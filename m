From: akpm@linux-foundation.org
Subject: + add-ctl_proc-back.patch added to -mm tree
Date: Mon, 30 Jul 2007 18:20:24 -0700
Message-ID: <200707310120.l6V1KOJx008124@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38428 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753580AbXGaBVI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 30 Jul 2007 21:21:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: adobriyan@sw.ru, shemminger@linux-foundation.org


The patch titled
     Add CTL_PROC back
has been added to the -mm tree.  Its filename is
     add-ctl_proc-back.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add CTL_PROC back
From: Alexey Dobriyan <adobriyan@sw.ru>

commit eab03ac7bd3e0da99eb9dc068772a85a5e3f3577 aka
"[PATCH] Get rid of /proc/sys/proc" was good commit except strace(1) compile
breakage it introduced:

	system.c:1581: error: 'CTL_PROC' undeclared here (not in a function)

So, add dummy enum back.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
Cc: Stephen Hemminger <shemminger@osdl.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sysctl.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/sysctl.h~add-ctl_proc-back include/linux/sysctl.h
--- a/include/linux/sysctl.h~add-ctl_proc-back
+++ a/include/linux/sysctl.h
@@ -62,7 +62,7 @@ enum
 	CTL_KERN=1,		/* General kernel info and control */
 	CTL_VM=2,		/* VM management */
 	CTL_NET=3,		/* Networking */
-	/* was CTL_PROC */
+	CTL_PROC=4,		/* removal breaks strace(1) compilation */
 	CTL_FS=5,		/* Filesystems */
 	CTL_DEBUG=6,		/* Debugging */
 	CTL_DEV=7,		/* Devices */
_

Patches currently in -mm which might be from adobriyan@sw.ru are

origin.patch
gitignore-update.patch
add-ctl_proc-back.patch
consolidate-ptrace_detach.patch
use-list_head-in-binfmt-handling-update.patch
make-unregister_binfmt-return-void.patch
fix-leaks-on-proc-schedsched_debugtimer_listtimer_stats.patch
fix-leak-on-proc-lockdep_stats.patch
slab_panic-more-proc-posix-timers-shmem.patch
add-kernel-notifierc.patch
add-kernel-notifierc-fix.patch
add-kernel-notifierc-fix-2.patch
