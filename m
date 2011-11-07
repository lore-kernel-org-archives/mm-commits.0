From: akpm@linux-foundation.org
Subject: [merged] sysctl-add-support-for-poll.patch removed from -mm tree
Date: Mon, 07 Nov 2011 12:28:50 -0800
Message-ID: <201111072028.pA7KSoJP030540@hpaq2.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:5845 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab1KGU26 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Nov 2011 15:28:58 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lucas.demarchi@profusion.mobi, adobriyan@gmail.com, ebiederm@xmission.com, gregkh@suse.de, kay.sievers@vrfy.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sysctl: add support for poll()
has been removed from the -mm tree.  Its filename was
     sysctl-add-support-for-poll.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: sysctl: add support for poll()

Adding support for poll() in sysctl fs allows userspace to receive
notifications of changes in sysctl entries.  This adds a infrastructure to
allow files in sysctl fs to be pollable and implements it for hostname and
domainname.

[akpm@linux-foundation.org: s/declare/define/ for definitions]
Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: Greg KH <gregkh@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_sysctl.c   |   45 ++++++++++++++++++++++++++++++++++++++
 include/linux/sysctl.h  |   22 ++++++++++++++++++
 include/linux/utsname.h |   16 +++++++++++++
 kernel/sys.c            |    2 +
 kernel/utsname_sysctl.c |   23 +++++++++++++++++++
 5 files changed, 108 insertions(+)

diff -puN fs/proc/proc_sysctl.c~sysctl-add-support-for-poll fs/proc/proc_sysctl.c
--- a/fs/proc/proc_sysctl.c~sysctl-add-support-for-poll
+++ a/fs/proc/proc_sysctl.c
@@ -3,6 +3,7 @@
  */
 #include <linux/init.h>
 #include <linux/sysctl.h>
+#include <linux/poll.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/namei.h>
@@ -14,6 +15,15 @@ static const struct inode_operations pro
 static const struct file_operations proc_sys_dir_file_operations;
 static const struct inode_operations proc_sys_dir_operations;
 
+void proc_sys_poll_notify(struct ctl_table_poll *poll)
+{
+	if (!poll)
+		return;
+
+	atomic_inc(&poll->event);
+	wake_up_interruptible(&poll->wait);
+}
+
 static struct inode *proc_sys_make_inode(struct super_block *sb,
 		struct ctl_table_header *head, struct ctl_table *table)
 {
@@ -176,6 +186,39 @@ static ssize_t proc_sys_write(struct fil
 	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
 }
 
+static int proc_sys_open(struct inode *inode, struct file *filp)
+{
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+
+	if (table->poll)
+		filp->private_data = proc_sys_poll_event(table->poll);
+
+	return 0;
+}
+
+static unsigned int proc_sys_poll(struct file *filp, poll_table *wait)
+{
+	struct inode *inode = filp->f_path.dentry->d_inode;
+	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
+	unsigned long event = (unsigned long)filp->private_data;
+	unsigned int ret = DEFAULT_POLLMASK;
+
+	if (!table->proc_handler)
+		goto out;
+
+	if (!table->poll)
+		goto out;
+
+	poll_wait(filp, &table->poll->wait, wait);
+
+	if (event != atomic_read(&table->poll->event)) {
+		filp->private_data = proc_sys_poll_event(table->poll);
+		ret = POLLIN | POLLRDNORM | POLLERR | POLLPRI;
+	}
+
+out:
+	return ret;
+}
 
 static int proc_sys_fill_cache(struct file *filp, void *dirent,
 				filldir_t filldir,
@@ -364,6 +407,8 @@ static int proc_sys_getattr(struct vfsmo
 }
 
 static const struct file_operations proc_sys_file_operations = {
+	.open		= proc_sys_open,
+	.poll		= proc_sys_poll,
 	.read		= proc_sys_read,
 	.write		= proc_sys_write,
 	.llseek		= default_llseek,
diff -puN include/linux/sysctl.h~sysctl-add-support-for-poll include/linux/sysctl.h
--- a/include/linux/sysctl.h~sysctl-add-support-for-poll
+++ a/include/linux/sysctl.h
@@ -931,6 +931,7 @@ enum
 #ifdef __KERNEL__
 #include <linux/list.h>
 #include <linux/rcupdate.h>
+#include <linux/wait.h>
 
 /* For the /proc/sys support */
 struct ctl_table;
@@ -1011,6 +1012,26 @@ extern int proc_do_large_bitmap(struct c
  * cover common cases.
  */
 
+/* Support for userspace poll() to watch for changes */
+struct ctl_table_poll {
+	atomic_t event;
+	wait_queue_head_t wait;
+};
+
+static inline void *proc_sys_poll_event(struct ctl_table_poll *poll)
+{
+	return (void *)(unsigned long)atomic_read(&poll->event);
+}
+
+void proc_sys_poll_notify(struct ctl_table_poll *poll);
+
+#define __CTL_TABLE_POLL_INITIALIZER(name) {				\
+	.event = ATOMIC_INIT(0),					\
+	.wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.wait) }
+
+#define DEFINE_CTL_TABLE_POLL(name)					\
+	struct ctl_table_poll name = __CTL_TABLE_POLL_INITIALIZER(name)
+
 /* A sysctl table is an array of struct ctl_table: */
 struct ctl_table 
 {
@@ -1021,6 +1042,7 @@ struct ctl_table 
 	struct ctl_table *child;
 	struct ctl_table *parent;	/* Automatically set */
 	proc_handler *proc_handler;	/* Callback for text formatting */
+	struct ctl_table_poll *poll;
 	void *extra1;
 	void *extra2;
 };
diff -puN include/linux/utsname.h~sysctl-add-support-for-poll include/linux/utsname.h
--- a/include/linux/utsname.h~sysctl-add-support-for-poll
+++ a/include/linux/utsname.h
@@ -37,6 +37,14 @@ struct new_utsname {
 #include <linux/nsproxy.h>
 #include <linux/err.h>
 
+enum uts_proc {
+	UTS_PROC_OSTYPE,
+	UTS_PROC_OSRELEASE,
+	UTS_PROC_VERSION,
+	UTS_PROC_HOSTNAME,
+	UTS_PROC_DOMAINNAME,
+};
+
 struct user_namespace;
 extern struct user_namespace init_user_ns;
 
@@ -80,6 +88,14 @@ static inline struct uts_namespace *copy
 }
 #endif
 
+#ifdef CONFIG_PROC_SYSCTL
+extern void uts_proc_notify(enum uts_proc proc);
+#else
+static inline void uts_proc_notify(enum uts_proc proc)
+{
+}
+#endif
+
 static inline struct new_utsname *utsname(void)
 {
 	return &current->nsproxy->uts_ns->name;
diff -puN kernel/sys.c~sysctl-add-support-for-poll kernel/sys.c
--- a/kernel/sys.c~sysctl-add-support-for-poll
+++ a/kernel/sys.c
@@ -1286,6 +1286,7 @@ SYSCALL_DEFINE2(sethostname, char __user
 		memset(u->nodename + len, 0, sizeof(u->nodename) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_HOSTNAME);
 	up_write(&uts_sem);
 	return errno;
 }
@@ -1336,6 +1337,7 @@ SYSCALL_DEFINE2(setdomainname, char __us
 		memset(u->domainname + len, 0, sizeof(u->domainname) - len);
 		errno = 0;
 	}
+	uts_proc_notify(UTS_PROC_DOMAINNAME);
 	up_write(&uts_sem);
 	return errno;
 }
diff -puN kernel/utsname_sysctl.c~sysctl-add-support-for-poll kernel/utsname_sysctl.c
--- a/kernel/utsname_sysctl.c~sysctl-add-support-for-poll
+++ a/kernel/utsname_sysctl.c
@@ -13,6 +13,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/sysctl.h>
+#include <linux/wait.h>
 
 static void *get_uts(ctl_table *table, int write)
 {
@@ -51,12 +52,19 @@ static int proc_do_uts_string(ctl_table 
 	uts_table.data = get_uts(table, write);
 	r = proc_dostring(&uts_table,write,buffer,lenp, ppos);
 	put_uts(table, write, uts_table.data);
+
+	if (write)
+		proc_sys_poll_notify(table->poll);
+
 	return r;
 }
 #else
 #define proc_do_uts_string NULL
 #endif
 
+static DEFINE_CTL_TABLE_POLL(hostname_poll);
+static DEFINE_CTL_TABLE_POLL(domainname_poll);
+
 static struct ctl_table uts_kern_table[] = {
 	{
 		.procname	= "ostype",
@@ -85,6 +93,7 @@ static struct ctl_table uts_kern_table[]
 		.maxlen		= sizeof(init_uts_ns.name.nodename),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &hostname_poll,
 	},
 	{
 		.procname	= "domainname",
@@ -92,6 +101,7 @@ static struct ctl_table uts_kern_table[]
 		.maxlen		= sizeof(init_uts_ns.name.domainname),
 		.mode		= 0644,
 		.proc_handler	= proc_do_uts_string,
+		.poll		= &domainname_poll,
 	},
 	{}
 };
@@ -105,6 +115,19 @@ static struct ctl_table uts_root_table[]
 	{}
 };
 
+#ifdef CONFIG_PROC_SYSCTL
+/*
+ * Notify userspace about a change in a certain entry of uts_kern_table,
+ * identified by the parameter proc.
+ */
+void uts_proc_notify(enum uts_proc proc)
+{
+	struct ctl_table *table = &uts_kern_table[proc];
+
+	proc_sys_poll_notify(table->poll);
+}
+#endif
+
 static int __init utsname_sysctl_init(void)
 {
 	register_sysctl_table(uts_root_table);
_

Patches currently in -mm which might be from lucas.demarchi@profusion.mobi are

origin.patch
linux-next.patch

