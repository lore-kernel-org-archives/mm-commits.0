From: akpm@linux-foundation.org
Subject: - epoll-introduce-resource-usage-limits-update.patch removed from -mm tree
Date: Mon, 01 Dec 2008 13:09:46 -0800
Message-ID: <200812012125.mB1LPMfI014139@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58908 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750980AbYLAVZk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Dec 2008 16:25:40 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davidel@xmailserver.org, gorcunov@gmail.com, mtk.manpages@gmail.com, stable@kernel.org, vegardno@ifi.uio.no, mm-commits@vger.kernel.org


The patch titled
     epoll-introduce-resource-usage-limits update
has been removed from the -mm tree.  Its filename was
     epoll-introduce-resource-usage-limits-update.patch

This patch was dropped because it was folded into epoll-introduce-resource-usage-limits.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: epoll-introduce-resource-usage-limits update
From: Davide Libenzi <davidel@xmailserver.org>

> > On Sat, 22 Nov 2008, Alexey Dobriyan wrote:
> >
> > > Don't add new CTL_ numbers, just drop ->strategy and ->ctl_name and defines
> > > and world will become a better place.
> >
> > How do users of the sysctl(2) interface access those variables w/out
> > ->ctl_name?
>
> They don't :-) CONFIG_SYSCTL_SYSCALL_CHECK will warn you about it.
>
> > Do we not care about that interface?
>
> For already existing stuff, yes. For new stuff, no.

Ok, let's drop them then.
Andrew, the attached is the same as before, with dropped sysctl(2)
support.

Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: <stable@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Vegard Nossum <vegardno@ifi.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/eventpoll.c         |    6 +-----
 include/linux/sysctl.h |    8 --------
 kernel/sysctl.c        |    1 -
 3 files changed, 1 insertion(+), 14 deletions(-)

diff -puN fs/eventpoll.c~epoll-introduce-resource-usage-limits-update fs/eventpoll.c
--- a/fs/eventpoll.c~epoll-introduce-resource-usage-limits-update
+++ a/fs/eventpoll.c
@@ -261,23 +261,19 @@ static int zero;
 
 ctl_table epoll_table[] = {
 	{
-		.ctl_name	= EPOLL_MAX_USER_INSTANCES,
 		.procname	= "max_user_instances",
 		.data		= &max_user_instances,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{
-		.ctl_name	= EPOLL_MAX_USER_WATCHES,
 		.procname	= "max_user_watches",
 		.data		= &max_user_watches,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
 		.proc_handler	= &proc_dointvec_minmax,
-		.strategy	= &sysctl_intvec,
 		.extra1		= &zero,
 	},
 	{ .ctl_name = 0 }
@@ -584,7 +580,7 @@ static int ep_alloc(struct eventpoll **p
 	struct user_struct *user;
 	struct eventpoll *ep;
 
-	user = get_current_user();
+	user = get_uid(current->user);
 	error = -EMFILE;
 	if (unlikely(atomic_read(&user->epoll_devs) >=
 			max_user_instances))
diff -puN include/linux/sysctl.h~epoll-introduce-resource-usage-limits-update include/linux/sysctl.h
--- a/include/linux/sysctl.h~epoll-introduce-resource-usage-limits-update
+++ a/include/linux/sysctl.h
@@ -90,13 +90,6 @@ enum
 	INOTIFY_MAX_QUEUED_EVENTS=3	/* max queued events per instance */
 };
 
-/* /proc/sys/fs/epoll/ */
-enum
-{
-	EPOLL_MAX_USER_INSTANCES = 1,	/* max instances per user */
-	EPOLL_MAX_USER_WATCHES = 2,	/* max watches per user */
-};
-
 /* CTL_KERN names: */
 enum
 {
@@ -838,7 +831,6 @@ enum
 	FS_AIO_NR=18,	/* current system-wide number of aio requests */
 	FS_AIO_MAX_NR=19,	/* system-wide maximum number of aio requests */
 	FS_INOTIFY=20,	/* inotify submenu */
-	FS_EPOLL = 21,	/* epoll configuration directory */
 	FS_OCFS2=988,	/* ocfs2 */
 };
 
diff -puN kernel/sysctl.c~epoll-introduce-resource-usage-limits-update kernel/sysctl.c
--- a/kernel/sysctl.c~epoll-introduce-resource-usage-limits-update
+++ a/kernel/sysctl.c
@@ -1330,7 +1330,6 @@ static struct ctl_table fs_table[] = {
 #endif	
 #ifdef CONFIG_EPOLL
 	{
-		.ctl_name	= FS_EPOLL,
 		.procname	= "epoll",
 		.mode		= 0555,
 		.child		= epoll_table,
_

Patches currently in -mm which might be from davidel@xmailserver.org are

epoll-introduce-resource-usage-limits.patch
epoll-introduce-resource-usage-limits-update.patch
epoll-introduce-resource-usage-limits-update-refix.patch
linux-next.patch
poll-allow-f_op-poll-to-sleep-take6.patch

