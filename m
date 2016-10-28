From: akpm@linux-foundation.org
Subject: + mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
 added to -mm tree
Date: Fri, 28 Oct 2016 15:55:31 -0700
Message-ID: <5813d763.MTAIGX+Z3xhaPyQC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752824AbcJ1Wzc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2016 18:55:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, lstoakes@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-unexport-__get_user_pages_unlocked-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-unexport-__get_user_pages_unlocked-checkpatch-fixes

ERROR: Please use git commit description style 'commit <12+ chars of sha1> ("<title line>")' - ie: 'commit 0123456789ab ("commit description")'
#16: 
flag.  However, this flag was originally silently dropped by 1e9877902dc7e

WARNING: line over 80 characters
#89: FILE: mm/nommu.c:179:
+static long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,

WARNING: line over 80 characters
#90: FILE: mm/nommu.c:180:
+				      unsigned long start, unsigned long nr_pages,

WARNING: line over 80 characters
#91: FILE: mm/nommu.c:181:
+			              struct page **pages, unsigned int gup_flags)

ERROR: code indent should use tabs where possible
#91: FILE: mm/nommu.c:181:
+^I^I^I              struct page **pages, unsigned int gup_flags)$

total: 2 errors, 3 warnings, 116 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/mm-unexport-__get_user_pages_unlocked.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Lorenzo Stoakes <lstoakes@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/nommu.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN mm/nommu.c~mm-unexport-__get_user_pages_unlocked-checkpatch-fixes mm/nommu.c
--- a/mm/nommu.c~mm-unexport-__get_user_pages_unlocked-checkpatch-fixes
+++ a/mm/nommu.c
@@ -176,9 +176,10 @@ long get_user_pages_locked(unsigned long
 }
 EXPORT_SYMBOL(get_user_pages_locked);
 
-static long __get_user_pages_unlocked(struct task_struct *tsk, struct mm_struct *mm,
-				      unsigned long start, unsigned long nr_pages,
-			              struct page **pages, unsigned int gup_flags)
+static long __get_user_pages_unlocked(struct task_struct *tsk,
+			struct mm_struct *mm, unsigned long start,
+			unsigned long nr_pages, struct page **pages,
+			unsigned int gup_flags)
 {
 	long ret;
 	down_read(&mm->mmap_sem);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
prctl-remove-one-shot-limitation-for-changing-exe-link-fix.patch
mm.patch
mm-compaction-allow-compaction-for-gfp_nofs-requests-fix.patch
mm-mempolicy-clean-up-__gfp_thisnode-confusion-in-policy_zonelist-checkpatch-fixes.patch
mm-unexport-__get_user_pages_unlocked-checkpatch-fixes.patch
scripts-checkpatchpl-fix-spelling.patch
debug-more-properly-delay-for-secondary-cpus-fix.patch
ipc-sem-rework-task-wakeups-checkpatch-fixes.patch
ipc-sem-optimize-perform_atomic_semop-checkpatch-fixes.patch
linux-next-git-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

