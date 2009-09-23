From: akpm@linux-foundation.org
Subject: [folded] exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:35:53 -0700
Message-ID: <200909232235.n8NMZrub029974@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990AbZIWWgD (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:36:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch

This patch was dropped because it was folded into exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

WARNING: suspect code indent for conditional statements (16, 25)
#48: FILE: fs/exec.c:1796:
+		if (core_limit == 0) {
+			 /*

WARNING: line over 80 characters
#57: FILE: fs/exec.c:1805:
+			  * but it runs as root, and can do lots of stupid things

WARNING: line over 80 characters
#58: FILE: fs/exec.c:1806:
+			  * Note that we use task_tgid_vnr here to grab the pid of the

WARNING: line over 80 characters
#59: FILE: fs/exec.c:1807:
+			  * process group leader.  That way we get the right pid if a thread

total: 0 errors, 4 warnings, 59 lines checked

./patches/exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |   32 +++++++++++++++++---------------
 1 file changed, 17 insertions(+), 15 deletions(-)

diff -puN fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes
+++ a/fs/exec.c
@@ -1794,21 +1794,23 @@ void do_coredump(long signr, int exit_co
 
  	if (ispipe) {
 		if (core_limit == 0) {
-			 /*
-			  * Normally core limits are irrelevant to pipes, since
-			  * we're not writing to the file system, but we use
-			  * core_limit of 0 here as a speacial value. Any
-			  * non-zero limit gets set to RLIM_INFINITY below, but
-			  * a limit of 0 skips the dump.  This is a consistent
-			  * way to catch recursive crashes.  We can still crash
-			  * if the core_pattern binary sets RLIM_CORE =  !0
-			  * but it runs as root, and can do lots of stupid things
-			  * Note that we use task_tgid_vnr here to grab the pid of the
-			  * process group leader.  That way we get the right pid if a thread
-			  * in a multi-threaded core_pattern process dies.
-			  */
-			printk(KERN_WARNING "Process %d(%s) has RLIMIT_CORE set to 0\n",
-			       task_tgid_vnr(current), current->comm);
+			/*
+			 * Normally core limits are irrelevant to pipes, since
+			 * we're not writing to the file system, but we use
+			 * core_limit of 0 here as a speacial value. Any
+			 * non-zero limit gets set to RLIM_INFINITY below, but
+			 * a limit of 0 skips the dump.  This is a consistent
+			 * way to catch recursive crashes.  We can still crash
+			 * if the core_pattern binary sets RLIM_CORE =  !0
+			 * but it runs as root, and can do lots of stupid things
+			 * Note that we use task_tgid_vnr here to grab the pid
+			 * of the process group leader.  That way we get the
+			 * right pid if a thread in a multi-threaded
+			 * core_pattern process dies.
+			 */
+			printk(KERN_WARNING
+				"Process %d(%s) has RLIMIT_CORE set to 0\n",
+				task_tgid_vnr(current), current->comm);
 			printk(KERN_WARNING "Aborting core\n");
 			goto fail_unlock;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9-checkpatch-fixes.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

