From: akpm@linux-foundation.org
Subject: + gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
 added to -mm tree
Date: Wed, 18 Sep 2013 14:26:34 -0700
Message-ID: <523a1a8a.D2hIgwhXSPLWcVnd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556Ab3IRV0f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Sep 2013 17:26:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, fhrbata@redhat.com, akpm@linux-foundation.org

Subject: + gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,fhrbata@redhat.com
From: akpm@linux-foundation.org
Date: Wed, 18 Sep 2013 14:26:34 -0700


The patch titled
     Subject: gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch

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
Subject: gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes

ERROR: that open brace { should be on the previous line
#227: FILE: kernel/gcov/gcc_4_7.c:179:
+	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++)
+	{

ERROR: that open brace { should be on the previous line
#269: FILE: kernel/gcov/gcc_4_7.c:221:
+	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++)
+	{

total: 2 errors, 0 warnings, 574 lines checked

./patches/gcov-add-support-for-gcc-47-gcov-format.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Frantisek Hrbata <fhrbata@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/gcov/gcc_4_7.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes kernel/gcov/gcc_4_7.c
--- a/kernel/gcov/gcc_4_7.c~gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes
+++ a/kernel/gcov/gcc_4_7.c
@@ -176,8 +176,7 @@ void gcov_info_reset(struct gcov_info *i
 	unsigned int fi_idx;
 	unsigned int ct_idx;
 
-	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++)
-	{
+	for (fi_idx = 0; fi_idx < info->n_functions; fi_idx++) {
 		ci_ptr = info->functions[fi_idx]->ctrs;
 
 		for (ct_idx = 0; ct_idx < GCOV_COUNTERS; ct_idx++) {
@@ -218,8 +217,7 @@ void gcov_info_add(struct gcov_info *dst
 	unsigned int ct_idx;
 	unsigned int val_idx;
 
-	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++)
-	{
+	for (fi_idx = 0; fi_idx < src->n_functions; fi_idx++) {
 		dci_ptr = dst->functions[fi_idx]->ctrs;
 		sci_ptr = src->functions[fi_idx]->ctrs;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
revert-memcg-vmscan-do-not-fall-into-reclaim-all-pass-too-quickly.patch
revert-memcg-track-all-children-over-limit-in-the-root.patch
revert-memcg-vmscan-do-not-attempt-soft-limit-reclaim-if-it-would-not-scan-anything.patch
revert-memcg-track-children-in-soft-limit-excess-to-improve-soft-limit.patch
revert-memcg-enhance-memcg-iterator-to-support-predicates.patch
revert-vmscan-memcg-do-softlimit-reclaim-also-for-targeted-reclaim.patch
revert-memcg-get-rid-of-soft-limit-tree-infrastructure.patch
revert-memcg-vmscan-integrate-soft-reclaim-tighter-with-zone-shrinking-code.patch
fs-binfmt_elfc-prevent-a-coredump-with-a-large-vm_map_count-from-oopsing-fix.patch
makefile-enable-werror=implicit-int-and-werror=strict-prototypes-by-default.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm.patch
mm-vmalloc-revert-mm-vmallocc-emit-the-failure-message-before-return-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
fat-additions-to-support-fat_fallocate-fix.patch
fat-additions-to-support-fat_fallocate-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

