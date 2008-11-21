From: akpm@linux-foundation.org
Subject: + epoll-introduce-resource-usage-limits.patch added to -mm tree
Date: Fri, 21 Nov 2008 14:26:57 -0800
Message-ID: <200811212226.mALMQvAB024362@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752843AbYKUW1l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 21 Nov 2008 17:27:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: davidel@xmailserver.org, gorcunov@gmail.com, mtk.manpages@gmail.com, stable@kernel.org, vegardno@ifi.uio.no


The patch titled
     epoll: introduce resource usage limits
has been added to the -mm tree.  Its filename is
     epoll-introduce-resource-usage-limits.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll: introduce resource usage limits
From: Davide Libenzi <davidel@xmailserver.org>

It has been thought that the per-user file descriptors limit would also
limit the resources that a normal user can request via the epoll
interface.  Vegard Nossum reported a very simple program (a modified
version attached) that can make a normal user to request a pretty large
amount of kernel memory, well within the its maximum number of fds.  To
solve such problem, default limits are now imposed, and /proc based
configuration has been introduced.  A new directory has been created,
named /proc/sys/fs/epoll/ and inside there, there are two configuration
points:

  max_user_instances = Maximum number of devices - per user

  max_user_watches   = Maximum number of "watched" fds - per user

The current default for "max_user_watches" limits the memory used by epoll
to store "watches", to 1/32 of the amount of the low RAM.  As example, a
256MB 32bit machine, will have "max_user_watches" set to roughly 90000. 
That should be enough to not break existing heavy epoll users.  The
default value for "max_user_instances" is set to 128, that should be
enough too.

This also changes the userspace, because a new error code can now come out
from EPOLL_CTL_ADD (-ENOSPC).  The EMFILE from epoll_create() was already
listed, so that should be ok.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: <stable@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Reported-by: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/proc.txt |   27 ++++++++
 fs/eventpoll.c                     |   89 ++++++++++++++++++++++++---
 include/linux/sched.h              |    4 +
 include/linux/sysctl.h             |    8 ++
 kernel/sysctl.c                    |   11 +++
 5 files changed, 131 insertions(+), 8 deletions(-)

diff -puN Documentation/filesystems/proc.txt~epoll-introduce-resource-usage-limits Documentation/filesystems/proc.txt
--- a/Documentation/filesystems/proc.txt~epoll-introduce-resource-usage-limits
+++ a/Documentation/filesystems/proc.txt
@@ -44,6 +44,7 @@ Table of Contents
   2.14	/proc/<pid>/io - Display the IO accounting fields
   2.15	/proc/<pid>/coredump_filter - Core dump filtering settings
   2.16	/proc/<pid>/mountinfo - Information about mounts
+  2.17	/proc/sys/fs/epoll - Configuration options for the epoll interface
 
 ------------------------------------------------------------------------------
 Preface
@@ -2486,4 +2487,30 @@ For more information on mount propagatio
 
   Documentation/filesystems/sharedsubtree.txt
 
+2.17	/proc/sys/fs/epoll - Configuration options for the epoll interface
+--------------------------------------------------------
+
+This directory contains configuration options for the epoll(7) interface.
+
+max_user_instances
+------------------
+
+This is the maximum number of epoll file descriptors that a single user can
+have open at a given time. The default value is 128, and should be enough
+for normal users.
+
+max_user_watches
+----------------
+
+Every epoll file descriptor can store a number of files to be monitored
+for event readiness. Each one of these monitored files constitutes a "watch".
+This configuration option sets the maximum number of "watches" that are
+allowed for each user.
+Each "watch" costs roughly 90 bytes on a 32bit kernel, and roughly 160 bytes
+on a 64bit one.
+The current default value for  max_user_watches  is the 1/32 of the available
+low memory, divided for the "watch" cost in bytes.
+
+
 ------------------------------------------------------------------------------
+
diff -puN fs/eventpoll.c~epoll-introduce-resource-usage-limits fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-introduce-resource-usage-limits
+++ a/fs/eventpoll.c
@@ -102,6 +102,8 @@
 
 #define EP_UNACTIVE_PTR ((void *) -1L)
 
+#define EP_ITEM_COST (sizeof(struct epitem) + sizeof(struct eppoll_entry))
+
 struct epoll_filefd {
 	struct file *file;
 	int fd;
@@ -200,6 +202,9 @@ struct eventpoll {
 	 * holding ->lock.
 	 */
 	struct epitem *ovflist;
+
+	/* The user that created the eventpoll descriptor */
+	struct user_struct *user;
 };
 
 /* Wait structure used by the poll hooks */
@@ -227,9 +232,17 @@ struct ep_pqueue {
 };
 
 /*
+ * Configuration options available inside /proc/sys/fs/epoll/
+ */
+/* Maximum number of epoll devices, per user */
+static int max_user_instances __read_mostly;
+/* Maximum number of epoll watched descriptors, per user */
+static int max_user_watches __read_mostly;
+
+/*
  * This mutex is used to serialize ep_free() and eventpoll_release_file().
  */
-static struct mutex epmutex;
+static DEFINE_MUTEX(epmutex);
 
 /* Safe wake up implementation */
 static struct poll_safewake psw;
@@ -240,6 +253,37 @@ static struct kmem_cache *epi_cache __re
 /* Slab cache used to allocate "struct eppoll_entry" */
 static struct kmem_cache *pwq_cache __read_mostly;
 
+#ifdef CONFIG_SYSCTL
+
+#include <linux/sysctl.h>
+
+static int zero;
+
+ctl_table epoll_table[] = {
+	{
+		.ctl_name	= EPOLL_MAX_USER_INSTANCES,
+		.procname	= "max_user_instances",
+		.data		= &max_user_instances,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{
+		.ctl_name	= EPOLL_MAX_USER_WATCHES,
+		.procname	= "max_user_watches",
+		.data		= &max_user_watches,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec_minmax,
+		.strategy	= &sysctl_intvec,
+		.extra1		= &zero,
+	},
+	{ .ctl_name = 0 }
+};
+#endif /* CONFIG_SYSCTL */
+
 
 /* Setup the structure that is used as key for the RB tree */
 static inline void ep_set_ffd(struct epoll_filefd *ffd,
@@ -402,6 +446,8 @@ static int ep_remove(struct eventpoll *e
 	/* At this point it is safe to free the eventpoll item */
 	kmem_cache_free(epi_cache, epi);
 
+	atomic_dec(&ep->user->epoll_watches);
+
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_remove(%p, %p)\n",
 		     current, ep, file));
 
@@ -449,6 +495,8 @@ static void ep_free(struct eventpoll *ep
 
 	mutex_unlock(&epmutex);
 	mutex_destroy(&ep->mtx);
+	atomic_dec(&ep->user->epoll_devs);
+	free_uid(ep->user);
 	kfree(ep);
 }
 
@@ -532,10 +580,19 @@ void eventpoll_release_file(struct file 
 
 static int ep_alloc(struct eventpoll **pep)
 {
-	struct eventpoll *ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	int error;
+	struct user_struct *user;
+	struct eventpoll *ep;
 
-	if (!ep)
-		return -ENOMEM;
+	user = get_uid(current->user);
+	error = -EMFILE;
+	if (unlikely(atomic_read(&user->epoll_devs) >=
+			max_user_instances))
+		goto free_uid;
+	error = -ENOMEM;
+	ep = kzalloc(sizeof(*ep), GFP_KERNEL);
+	if (unlikely(!ep))
+		goto free_uid;
 
 	spin_lock_init(&ep->lock);
 	mutex_init(&ep->mtx);
@@ -544,12 +601,17 @@ static int ep_alloc(struct eventpoll **p
 	INIT_LIST_HEAD(&ep->rdllist);
 	ep->rbr = RB_ROOT;
 	ep->ovflist = EP_UNACTIVE_PTR;
+	ep->user = user;
 
 	*pep = ep;
 
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: ep_alloc() ep=%p\n",
 		     current, ep));
 	return 0;
+
+free_uid:
+	free_uid(user);
+	return error;
 }
 
 /*
@@ -703,9 +765,11 @@ static int ep_insert(struct eventpoll *e
 	struct epitem *epi;
 	struct ep_pqueue epq;
 
-	error = -ENOMEM;
+	if (unlikely(atomic_read(&ep->user->epoll_watches) >=
+		     max_user_watches))
+		return -ENOSPC;
 	if (!(epi = kmem_cache_alloc(epi_cache, GFP_KERNEL)))
-		goto error_return;
+		return -ENOMEM;
 
 	/* Item initialization follow here ... */
 	INIT_LIST_HEAD(&epi->rdllink);
@@ -735,6 +799,7 @@ static int ep_insert(struct eventpoll *e
 	 * install process. Namely an allocation for a wait queue failed due
 	 * high memory pressure.
 	 */
+	error = -ENOMEM;
 	if (epi->nwait < 0)
 		goto error_unregister;
 
@@ -765,6 +830,8 @@ static int ep_insert(struct eventpoll *e
 
 	spin_unlock_irqrestore(&ep->lock, flags);
 
+	atomic_inc(&ep->user->epoll_watches);
+
 	/* We have to call this outside the lock */
 	if (pwake)
 		ep_poll_safewake(&psw, &ep->poll_wait);
@@ -789,7 +856,7 @@ error_unregister:
 	spin_unlock_irqrestore(&ep->lock, flags);
 
 	kmem_cache_free(epi_cache, epi);
-error_return:
+
 	return error;
 }
 
@@ -1078,6 +1145,7 @@ asmlinkage long sys_epoll_create1(int fl
 			      flags & O_CLOEXEC);
 	if (fd < 0)
 		ep_free(ep);
+	atomic_inc(&ep->user->epoll_devs);
 
 error_return:
 	DNPRINTK(3, (KERN_INFO "[%p] eventpoll: sys_epoll_create(%d) = %d\n",
@@ -1299,7 +1367,12 @@ asmlinkage long sys_epoll_pwait(int epfd
 
 static int __init eventpoll_init(void)
 {
-	mutex_init(&epmutex);
+	struct sysinfo si;
+
+	si_meminfo(&si);
+	max_user_instances = 128;
+	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
+		EP_ITEM_COST;
 
 	/* Initialize the structure used to perform safe poll wait head wake ups */
 	ep_poll_safewake_init(&psw);
diff -puN include/linux/sched.h~epoll-introduce-resource-usage-limits include/linux/sched.h
--- a/include/linux/sched.h~epoll-introduce-resource-usage-limits
+++ a/include/linux/sched.h
@@ -621,6 +621,10 @@ struct user_struct {
 	atomic_t inotify_watches; /* How many inotify watches does this user have? */
 	atomic_t inotify_devs;	/* How many inotify devs does this user have opened? */
 #endif
+#ifdef CONFIG_EPOLL
+	atomic_t epoll_devs;	/* The number of epoll descriptors currently open */
+	atomic_t epoll_watches;	/* The number of file descriptors currently watched */
+#endif
 #ifdef CONFIG_POSIX_MQUEUE
 	/* protected by mq_lock	*/
 	unsigned long mq_bytes;	/* How many bytes can be allocated to mqueue? */
diff -puN include/linux/sysctl.h~epoll-introduce-resource-usage-limits include/linux/sysctl.h
--- a/include/linux/sysctl.h~epoll-introduce-resource-usage-limits
+++ a/include/linux/sysctl.h
@@ -90,6 +90,13 @@ enum
 	INOTIFY_MAX_QUEUED_EVENTS=3	/* max queued events per instance */
 };
 
+/* /proc/sys/fs/epoll/ */
+enum
+{
+	EPOLL_MAX_USER_INSTANCES = 1,	/* max instances per user */
+	EPOLL_MAX_USER_WATCHES = 2,	/* max watches per user */
+};
+
 /* CTL_KERN names: */
 enum
 {
@@ -831,6 +838,7 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
+	FS_EPOLL = 21,	/* epoll configuration directory */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff -puN kernel/sysctl.c~epoll-introduce-resource-usage-limits kernel/sysctl.c
--- a/kernel/sysctl.c~epoll-introduce-resource-usage-limits
+++ a/kernel/sysctl.c
@@ -177,6 +177,9 @@ extern struct ctl_table random_table[];
 #ifdef CONFIG_INOTIFY_USER
 extern struct ctl_table inotify_table[];
 #endif
+#ifdef CONFIG_EPOLL
+extern struct ctl_table epoll_table[];
+#endif
 
 #ifdef HAVE_ARCH_PICK_MMAP_LAYOUT
 int sysctl_legacy_va_layout;
@@ -1366,6 +1369,14 @@ static struct ctl_table fs_table[] = {
 		.child		= inotify_table,
 	},
 #endif	
+#ifdef CONFIG_EPOLL
+	{
+		.ctl_name	= FS_EPOLL,
+		.procname	= "epoll",
+		.mode		= 0555,
+		.child		= epoll_table,
+	},
+#endif
 #endif
 	{
 		.ctl_name	= KERN_SETUID_DUMPABLE,
_

Patches currently in -mm which might be from davidel@xmailserver.org are

linux-next.patch
epoll-introduce-resource-usage-limits.patch

