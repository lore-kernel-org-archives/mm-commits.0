From: akpm@linux-foundation.org
Subject: +
 rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
 added to -mm tree
Date: Mon, 21 Apr 2014 14:25:45 -0700
Message-ID: <53558cd9.whPh6gO5KWa71Qjb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754588AbaDUVZq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Apr 2014 17:25:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ralf@linux-mips.org, macro@linux-mips.org, a.zummo@towertech.it, akpm@linux-foundation.org

Subject: + rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch added to -mm tree
To: akpm@linux-foundation.org,a.zummo@towertech.it,macro@linux-mips.org,ralf@linux-mips.org
From: akpm@linux-foundation.org
Date: Mon, 21 Apr 2014 14:25:45 -0700


The patch titled
     Subject: rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix
has been added to the -mm tree.  Its filename is
     rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch

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
Subject: rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix

fix weird code layout

Cc: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-cmos.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix drivers/rtc/rtc-cmos.c
--- a/drivers/rtc/rtc-cmos.c~rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix
+++ a/drivers/rtc/rtc-cmos.c
@@ -662,11 +662,11 @@ cmos_do_probe(struct device *dev, struct
 	 * (needing ioremap etc), not i/o space resources like this ...
 	 */
 	if (RTC_IOMAPPED)
-		ports = request_region
-			(ports->start, resource_size(ports), driver_name);
+		ports = request_region(ports->start, resource_size(ports),
+				       driver_name);
 	else
-		ports = request_mem_region
-			(ports->start, resource_size(ports), driver_name);
+		ports = request_mem_region(ports->start, resource_size(ports),
+					   driver_name);
 	if (!ports) {
 		dev_dbg(dev, "i/o registers already in use\n");
 		return -EBUSY;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
hugetlb-ensure-hugepage-access-is-denied-if-hugepages-are-not-supported-fix.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
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
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-gupc-tweaks.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

