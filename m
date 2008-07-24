From: akpm@linux-foundation.org
Subject: - cgroups-traffic-control-cgroups-subsystem.patch removed from -mm tree
Date: Wed, 23 Jul 2008 17:22:20 -0700
Message-ID: <200807240022.m6O0MKBw020074@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754625AbYGXAXR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jul 2008 20:23:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ranjitm@google.com, balbir@in.ibm.com, clg@fr.ibm.com, davem@davemloft.net, ebiederm@xmission.com, kaber@trash.net, kamezawa.hiroyu@jp.fujitsu.com, lizf@cn.fujitsu.com, menage@google.


The patch titled
     cgroups: traffic control cgroups subsystem
has been removed from the -mm tree.  Its filename was
     cgroups-traffic-control-cgroups-subsystem.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cgroups: traffic control cgroups subsystem
From: Ranjit Manomohan <ranjitm@google.com>

This patch provides a simple resource controller (cgroup_tc) based on the
cgroups infrastructure to manage network traffic.  The cgroup_tc resource
controller can be used to schedule and shape traffic belonging to the
task(s) in a particular cgroup.

The implementation consists of two parts:

1) A resource controller (cgroup_tc) that is used to associate packets
   from a particular task belonging to a cgroup with a traffic control
   class id ( tc_classid).  This tc_classid is propagated to all sockets
   created by tasks in the cgroup and will be used for classifying packets
   at the link layer.

2) A modified traffic control classifier (cls_flow) that can classify
   packets based on the tc_classid field in the socket to specific
   destination classes.

An example of the use of this resource controller would be to limit the
traffic from all tasks from a file_server cgroup to 100Mbps.  We could
achieve this by doing:

# make a cgroup of file transfer processes and assign it a uniqe classid
# of 0x10 - this will be used lated to direct packets.
mkdir -p /dev/cgroup
mount -t cgroup tc -otc /dev/cgroup
mkdir /dev/cgroup/file_transfer
echo 0x10 > /dev/cgroup/file_transfer/tc.classid
echo $PID_OF_FILE_XFER_PROCESS > /dev/cgroup/file_transfer/tasks

# Now create a HTB class that rate limits traffic to 100mbits and attach
# a filter to direct all traffic from cgroup file_transfer to this new class.
tc qdisc add dev eth0 root handle 1: htb
tc class add dev eth0 parent 1: classid 1:10 htb rate 100mbit ceil 100mbit
tc filter add dev eth0 parent 1: handle 800 protocol ip prio 1 flow map key cgroup-classid baseclass 1:10

Signed-off-by: Ranjit Manomohan <ranjitm@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Patrick McHardy <kaber@trash.net>
Cc: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@in.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@fr.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Paul Menage <menage@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Rohit Seth <rohitseth@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cgroup_subsys.h |    6 +
 include/linux/cgroup_tc.h     |   20 +++++
 include/linux/pkt_cls.h       |    1 
 include/net/sock.h            |    3 
 init/Kconfig                  |   11 +++
 kernel/Makefile               |    1 
 kernel/tc_cgroup.c            |  108 ++++++++++++++++++++++++++++++++
 net/sched/cls_flow.c          |   18 +++++
 net/socket.c                  |    5 +
 9 files changed, 172 insertions(+), 1 deletion(-)

diff -puN include/linux/cgroup_subsys.h~cgroups-traffic-control-cgroups-subsystem include/linux/cgroup_subsys.h
--- a/include/linux/cgroup_subsys.h~cgroups-traffic-control-cgroups-subsystem
+++ a/include/linux/cgroup_subsys.h
@@ -48,3 +48,9 @@ SUBSYS(devices)
 #endif
 
 /* */
+
+#ifdef CONFIG_CGROUP_TC
+SUBSYS(tc)
+#endif
+
+/* */
diff -puN /dev/null include/linux/cgroup_tc.h
--- /dev/null
+++ a/include/linux/cgroup_tc.h
@@ -0,0 +1,20 @@
+#ifndef __LINUX_CGROUP_TC_H
+#define __LINUX_CGROUP_TC_H
+
+/* Interface to obtain tasks cgroup identifier. */
+
+#include <linux/cgroup.h>
+#include <linux/skbuff.h>
+#include <net/sock.h>
+
+#ifdef CONFIG_CGROUP_TC
+
+void cgroup_tc_set_sock_classid(struct sock *sk);
+
+#else
+
+#define cgroup_tc_set_sock_classid(sk)
+
+#endif /* CONFIG_CGROUP_TC */
+
+#endif /* __LINUX_CGROUP_TC_H */
diff -puN include/linux/pkt_cls.h~cgroups-traffic-control-cgroups-subsystem include/linux/pkt_cls.h
--- a/include/linux/pkt_cls.h~cgroups-traffic-control-cgroups-subsystem
+++ a/include/linux/pkt_cls.h
@@ -349,6 +349,7 @@ enum
 	FLOW_KEY_SKUID,
 	FLOW_KEY_SKGID,
 	FLOW_KEY_VLAN_TAG,
+	FLOW_KEY_CGROUP_CLASSID,
 	__FLOW_KEY_MAX,
 };
 
diff -puN include/net/sock.h~cgroups-traffic-control-cgroups-subsystem include/net/sock.h
--- a/include/net/sock.h~cgroups-traffic-control-cgroups-subsystem
+++ a/include/net/sock.h
@@ -271,6 +271,9 @@ struct sock {
 	int			sk_write_pending;
 	void			*sk_security;
 	__u32			sk_mark;
+#ifdef CONFIG_CGROUP_TC
+	__u32			sk_cgroup_classid;
+#endif
 	/* XXX 4 bytes hole on 64 bit */
 	void			(*sk_state_change)(struct sock *sk);
 	void			(*sk_data_ready)(struct sock *sk, int bytes);
diff -puN init/Kconfig~cgroups-traffic-control-cgroups-subsystem init/Kconfig
--- a/init/Kconfig~cgroups-traffic-control-cgroups-subsystem
+++ a/init/Kconfig
@@ -290,6 +290,17 @@ config CGROUP_DEBUG
 
 	  Say N if unsure
 
+config CGROUP_TC
+	bool "Traffic control cgroup subsystem"
+	depends on CGROUPS
+	default n
+	help
+	  This option enables a simple cgroup subsystem that
+	  allows network traffic to be classified based on the
+	  cgroup of the task originating the traffic.
+
+	  Say N if unsure
+
 config CGROUP_NS
         bool "Namespace cgroup subsystem"
         depends on CGROUPS
diff -puN kernel/Makefile~cgroups-traffic-control-cgroups-subsystem kernel/Makefile
--- a/kernel/Makefile~cgroups-traffic-control-cgroups-subsystem
+++ a/kernel/Makefile
@@ -54,6 +54,7 @@ obj-$(CONFIG_CGROUPS) += cgroup.o
 obj-$(CONFIG_CGROUP_DEBUG) += cgroup_debug.o
 obj-$(CONFIG_CPUSETS) += cpuset.o
 obj-$(CONFIG_CGROUP_NS) += ns_cgroup.o
+obj-$(CONFIG_CGROUP_TC) += tc_cgroup.o
 obj-$(CONFIG_UTS_NS) += utsname.o
 obj-$(CONFIG_USER_NS) += user_namespace.o
 obj-$(CONFIG_PID_NS) += pid_namespace.o
diff -puN /dev/null kernel/tc_cgroup.c
--- /dev/null
+++ a/kernel/tc_cgroup.c
@@ -0,0 +1,108 @@
+/*
+ * tc_cgroup.c - traffic control cgroup subsystem
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/cgroup.h>
+#include <linux/fs.h>
+#include <linux/slab.h>
+#include <linux/cgroup_tc.h>
+
+struct tc_cgroup {
+	struct cgroup_subsys_state css;
+	unsigned int classid;
+};
+
+struct cgroup_subsys tc_subsys;
+
+static inline struct tc_cgroup *cgroup_to_tc(
+		struct cgroup *cgroup)
+{
+	return container_of(cgroup_subsys_state(cgroup, tc_subsys_id),
+			    struct tc_cgroup, css);
+}
+
+static int cgroup_tc_classid(struct task_struct *tsk)
+{
+	int tc_classid;
+
+	rcu_read_lock();
+	tc_classid =  container_of(task_subsys_state(tsk, tc_subsys_id),
+					 struct tc_cgroup, css)->classid;
+	rcu_read_unlock();
+	return tc_classid;
+}
+
+void cgroup_tc_set_sock_classid(struct sock *sk)
+{
+	if (sk)
+		sk->sk_cgroup_classid = cgroup_tc_classid(current);
+}
+
+static struct cgroup_subsys_state *tc_create(struct cgroup_subsys *ss,
+						struct cgroup *cgroup)
+{
+	struct tc_cgroup *tc_cgroup;
+
+	tc_cgroup = kzalloc(sizeof(*tc_cgroup), GFP_KERNEL);
+
+	if (!tc_cgroup)
+		return ERR_PTR(-ENOMEM);
+
+	/* Copy parent's class id if present */
+	if (cgroup->parent)
+		tc_cgroup->classid = cgroup_to_tc(cgroup->parent)->classid;
+
+	return &tc_cgroup->css;
+}
+
+static void tc_destroy(struct cgroup_subsys *ss,
+			struct cgroup *cgroup)
+{
+	kfree(cgroup_to_tc(cgroup));
+}
+
+static int tc_write_u64(struct cgroup *cgrp, struct cftype *cft, u64 val)
+{
+	struct tc_cgroup *tc = cgroup_to_tc(cgrp);
+
+	cgroup_lock();
+	if (cgroup_is_removed(cgrp)) {
+		cgroup_unlock();
+		return -ENODEV;
+	}
+
+	tc->classid = (unsigned int) (val & 0xffffffff);
+	cgroup_unlock();
+	return 0;
+}
+
+static u64 tc_read_u64(struct cgroup *cont, struct cftype *cft)
+{
+	struct tc_cgroup *tc = cgroup_to_tc(cont);
+	return tc->classid;
+}
+
+static struct cftype tc_files[] = {
+	{
+		.name = "classid",
+		.read_u64 = tc_read_u64,
+		.write_u64 = tc_write_u64,
+	}
+};
+
+static int tc_populate(struct cgroup_subsys *ss, struct cgroup *cont)
+{
+	int err;
+	err = cgroup_add_files(cont, ss, tc_files, ARRAY_SIZE(tc_files));
+	return err;
+}
+
+struct cgroup_subsys tc_subsys = {
+	.name = "tc",
+	.create = tc_create,
+	.destroy  = tc_destroy,
+	.populate = tc_populate,
+	.subsys_id = tc_subsys_id,
+};
diff -puN net/sched/cls_flow.c~cgroups-traffic-control-cgroups-subsystem net/sched/cls_flow.c
--- a/net/sched/cls_flow.c~cgroups-traffic-control-cgroups-subsystem
+++ a/net/sched/cls_flow.c
@@ -280,6 +280,15 @@ static u32 flow_get_vlan_tag(const struc
 	return tag & VLAN_VID_MASK;
 }
 
+static u32 flow_get_cgroup_classid(const struct sk_buff *skb)
+{
+#ifdef CONFIG_CGROUP_TC
+	if (skb->sk)
+		return skb->sk->sk_cgroup_classid;
+#endif
+	return 0;
+}
+
 static u32 flow_key_get(const struct sk_buff *skb, int key)
 {
 	switch (key) {
@@ -317,6 +326,8 @@ static u32 flow_key_get(const struct sk_
 		return flow_get_skgid(skb);
 	case FLOW_KEY_VLAN_TAG:
 		return flow_get_vlan_tag(skb);
+	case FLOW_KEY_CGROUP_CLASSID:
+		return flow_get_cgroup_classid(skb);
 	default:
 		WARN_ON(1);
 		return 0;
@@ -359,7 +370,12 @@ static int flow_classify(struct sk_buff 
 			classid %= f->divisor;
 
 		res->class   = 0;
-		res->classid = TC_H_MAKE(f->baseclass, f->baseclass + classid);
+
+		if (key == FLOW_KEY_CGROUP_CLASSID)
+			res->classid = TC_H_MAKE(f->baseclass, classid);
+		else
+			res->classid = TC_H_MAKE(f->baseclass,
+						 f->baseclass + classid);
 
 		r = tcf_exts_exec(skb, &f->exts, res);
 		if (r < 0)
diff -puN net/socket.c~cgroups-traffic-control-cgroups-subsystem net/socket.c
--- a/net/socket.c~cgroups-traffic-control-cgroups-subsystem
+++ a/net/socket.c
@@ -94,6 +94,7 @@
 
 #include <net/sock.h>
 #include <linux/netfilter.h>
+#include <linux/cgroup_tc.h>
 
 static int sock_no_open(struct inode *irrelevant, struct file *dontcare);
 static ssize_t sock_aio_read(struct kiocb *iocb, const struct iovec *iov,
@@ -1171,6 +1172,8 @@ static int __sock_create(struct net *net
 	if (err < 0)
 		goto out_module_put;
 
+	cgroup_tc_set_sock_classid(sock->sk);
+
 	/*
 	 * Now to bump the refcnt of the [loadable] module that owns this
 	 * socket at sock_release time we decrement its refcnt.
@@ -1445,6 +1448,8 @@ asmlinkage long sys_accept(int fd, struc
 	if (err < 0)
 		goto out_fd;
 
+	cgroup_tc_set_sock_classid(newsock->sk);
+
 	if (upeer_sockaddr) {
 		if (newsock->ops->getname(newsock, (struct sockaddr *)&address,
 					  &len, 2) < 0) {
_

Patches currently in -mm which might be from ranjitm@google.com are

cgroups-traffic-control-cgroups-subsystem.patch

