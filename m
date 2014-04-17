From: akpm@linux-foundation.org
Subject: +
 hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch added to -mm tree
Date: Thu, 17 Apr 2014 16:02:08 -0700
Message-ID: <53505d70.8H1xzAxHY2Iko44A%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33329 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDQXCJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 17 Apr 2014 19:02:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, lcapitulino@redhat.com, akpm@linux-foundation.org

Subject: + hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,lcapitulino@redhat.com
From: akpm@linux-foundation.org
Date: Thu, 17 Apr 2014 16:02:08 -0700


The patch titled
     Subject: hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch

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
Subject: hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes

WARNING: braces {} are not necessary for any arm of this statement
#282: FILE: mm/hugetlb.c:1650:
+		if (hstate_is_gigantic(h)) {
[...]
+		} else {
[...]

total: 0 errors, 1 warnings, 219 lines checked

./patches/hugetlb-add-support-for-gigantic-page-allocation-at-runtime.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Luiz Capitulino <lcapitulino@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes mm/hugetlb.c
--- a/mm/hugetlb.c~hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes
+++ a/mm/hugetlb.c
@@ -1647,11 +1647,10 @@ static unsigned long set_max_huge_pages(
 		 * and reducing the surplus.
 		 */
 		spin_unlock(&hugetlb_lock);
-		if (hstate_is_gigantic(h)) {
+		if (hstate_is_gigantic(h))
 			ret = alloc_fresh_gigantic_page(h, nodes_allowed);
-		} else {
+		else
 			ret = alloc_fresh_huge_page(h, nodes_allowed);
-		}
 		spin_lock(&hugetlb_lock);
 		if (!ret)
 			goto out;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-watchdogc-touch_softlockup_watchdog-use-raw_cpu_write.patch
wait-explain-the-shadowing-and-type-inconsistencies.patch
mips-export-flush_icache_range-fix.patch
drm-nouveau-bios-fix-a-bit-shift-error-introduced-by-457e77b-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
mm.patch
mm-hugetlbfs-fix-rmapping-for-anonymous-hugepages-with-page_pgoff-v3-fix.patch
pagewalk-update-page-table-walker-core-fix-end-address-calculation-in-walk_page_range-fix.patch
pagemap-redefine-callback-functions-for-page-table-walker-fix.patch
pagewalk-remove-argument-hmask-from-hugetlb_entry-fix-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
mm-huge_memoryc-complete-conversion-to-pr_foo.patch
include-linux-mmdebugh-add-vm_warn_on-and-vm_warn_on_once.patch
mm-mempool-warn-about-__gfp_zero-usage-fix.patch
mm-pass-vm_bug_on-reason-to-dump_page-fix.patch
hugetlb-add-support-for-gigantic-page-allocation-at-runtime-checkpatch-fixes.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

