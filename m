From: akpm@linux-foundation.org
Subject: [folded] exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch removed from -mm tree
Date: Wed, 23 Sep 2009 15:36:10 -0700
Message-ID: <200909232236.n8NMaB3U030599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51581 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752249AbZIWWgR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 18:36:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, nhorman@tuxdriver.com, mm-commits@vger.kernel.org


The patch titled
     exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch

This patch was dropped because it was folded into exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#115: FILE: fs/exec.c:1838:
+ ^I^Iif (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,$

ERROR: code indent should use tabs where possible
#120: FILE: fs/exec.c:1842:
+ ^I^I^Igoto fail_dropcount;$

WARNING: externs should be avoided in .c files
#149: FILE: kernel/sysctl.c:80:
+extern unsigned int core_pipe_limit;

total: 2 errors, 1 warnings, 120 lines checked

./patches/exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Neil Horman <nhorman@tuxdriver.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/exec.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/exec.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes fs/exec.c
--- a/fs/exec.c~exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes
+++ a/fs/exec.c
@@ -1835,11 +1835,11 @@ void do_coredump(long signr, int exit_co
 		core_limit = RLIM_INFINITY;
 
 		/* SIGPIPE can happen, but it's just never processed */
- 		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
+		if (call_usermodehelper_pipe(helper_argv[0], helper_argv, NULL,
 				&file)) {
  			printk(KERN_INFO "Core dump to %s pipe failed\n",
 			       corename);
- 			goto fail_dropcount;
+			goto fail_dropcount;
  		}
  	} else
  		file = filp_open(corename,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
page-types-add-feature-for-walking-process-address-space.patch
memcg-remove-the-overhead-associated-with-the-root-cgroup.patch
memcg-add-comments-explaining-memory-barriers.patch
memory-controller-soft-limit-reclaim-on-contention-v9.patch
memcg-improve-resource-counter-scalability.patch
exec-make-do_coredump-more-resilient-to-recursive-crashes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9.patch
exec-let-do_coredump-limit-the-number-of-concurrent-dumps-to-pipes-v9-checkpatch-fixes.patch
elf-clean-up-fill_note_info-fix.patch

