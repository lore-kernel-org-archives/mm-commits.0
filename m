From: akpm@linux-foundation.org
Subject: +
 audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch added to -mm tree
Date: Fri, 28 Feb 2014 15:34:44 -0800
Message-ID: <53111d14.J+Mb6rJ+QdyMU/W7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:52426 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaB1Xep (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 28 Feb 2014 18:34:45 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rgb@redhat.com, eparis@redhat.com, ebiederm@xmission.com

Subject: + audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch added to -mm tree
To: ebiederm@xmission.com,eparis@redhat.com,rgb@redhat.com
From: akpm@linux-foundation.org
Date: Fri, 28 Feb 2014 15:34:44 -0800


The patch titled
     Subject: audit: use struct net not pid_t to remember the network namespce to reply in
has been added to the -mm tree.  Its filename is
     audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: audit: use struct net not pid_t to remember the network namespce to reply in

While reading through 3.14-rc1 I found a pretty siginficant mishandling of
network namespaces in the recent audit changes.

In struct audit_netlink_list and audit_reply add a reference to the
network namespace of the caller and remove the userspace pid of the
caller.  This cleanly remembers the callers network namespace, and removes
a huge class of races and nasty failure modes that can occur when
attempting to relook up the callers network namespace from a pid_t
(including the caller's network namespace changing, pid wraparound, and
the pid simply not being present).

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>
Cc: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/audit.c       |   10 ++++++----
 kernel/audit.h       |    2 +-
 kernel/auditfilter.c |    3 ++-
 3 files changed, 9 insertions(+), 6 deletions(-)

diff -puN kernel/audit.c~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in kernel/audit.c
--- a/kernel/audit.c~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in
+++ a/kernel/audit.c
@@ -182,7 +182,7 @@ struct audit_buffer {
 
 struct audit_reply {
 	__u32 portid;
-	pid_t pid;
+	struct net *net;
 	struct sk_buff *skb;
 };
 
@@ -500,7 +500,7 @@ int audit_send_list(void *_dest)
 {
 	struct audit_netlink_list *dest = _dest;
 	struct sk_buff *skb;
-	struct net *net = get_net_ns_by_pid(dest->pid);
+	struct net *net = dest->net;
 	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	/* wait for parent to finish and send an ACK */
@@ -510,6 +510,7 @@ int audit_send_list(void *_dest)
 	while ((skb = __skb_dequeue(&dest->q)) != NULL)
 		netlink_unicast(aunet->nlsk, skb, dest->portid, 0);
 
+	put_net(net);
 	kfree(dest);
 
 	return 0;
@@ -543,7 +544,7 @@ out_kfree_skb:
 static int audit_send_reply_thread(void *arg)
 {
 	struct audit_reply *reply = (struct audit_reply *)arg;
-	struct net *net = get_net_ns_by_pid(reply->pid);
+	struct net *net = reply->net;
 	struct audit_net *aunet = net_generic(net, audit_net_id);
 
 	mutex_lock(&audit_cmd_mutex);
@@ -552,6 +553,7 @@ static int audit_send_reply_thread(void
 	/* Ignore failure. It'll only happen if the sender goes away,
 	   because our timeout is set to infinite. */
 	netlink_unicast(aunet->nlsk , reply->skb, reply->portid, 0);
+	put_net(net);
 	kfree(reply);
 	return 0;
 }
@@ -583,8 +585,8 @@ static void audit_send_reply(__u32 porti
 	if (!skb)
 		goto out;
 
+	reply->net = get_net(current->nsproxy->net_ns);
 	reply->portid = portid;
-	reply->pid = task_pid_vnr(current);
 	reply->skb = skb;
 
 	tsk = kthread_run(audit_send_reply_thread, reply, "audit_send_reply");
diff -puN kernel/audit.h~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in kernel/audit.h
--- a/kernel/audit.h~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in
+++ a/kernel/audit.h
@@ -247,7 +247,7 @@ extern void		    audit_panic(const char
 
 struct audit_netlink_list {
 	__u32 portid;
-	pid_t pid;
+	struct net *net;
 	struct sk_buff_head q;
 };
 
diff -puN kernel/auditfilter.c~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in kernel/auditfilter.c
--- a/kernel/auditfilter.c~audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in
+++ a/kernel/auditfilter.c
@@ -29,6 +29,7 @@
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/security.h>
+#include <net/net_namespace.h>
 #include "audit.h"
 
 /*
@@ -1083,8 +1084,8 @@ int audit_list_rules_send(__u32 portid,
 	dest = kmalloc(sizeof(struct audit_netlink_list), GFP_KERNEL);
 	if (!dest)
 		return -ENOMEM;
+	dest->net = get_net(current->nsproxy->net_ns);
 	dest->portid = portid;
-	dest->pid = task_pid_vnr(current);
 	skb_queue_head_init(&dest->q);
 
 	mutex_lock(&audit_filter_mutex);
_

Patches currently in -mm which might be from ebiederm@xmission.com are

audit-use-struct-net-not-pid_t-to-remember-the-network-namespce-to-reply-in.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags.patch
mm-revert-thp-make-madv_hugepage-check-for-mm-def_flags-ignore-madv_hugepage-on-s390-to-prevent-sigsegv-in-qemu.patch
mm-thp-add-vm_init_def_mask-and-prctl_thp_disable.patch
exec-kill-the-unnecessary-mm-def_flags-setting-in-load_elf_binary.patch
kernel-groupsc-remove-return-value-of-set_groups.patch
kernel-groupsc-remove-return-value-of-set_groups-fix.patch
kernel-audit-fix-non-modular-users-of-module_init-in-core-code.patch
linux-next.patch

