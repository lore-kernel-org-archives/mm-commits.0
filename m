From: akpm@linux-foundation.org
Subject: + rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch added to -mm tree
Date: Mon, 23 Mar 2015 15:34:10 -0700
Message-ID: <551094e2.DLwzMClzCAVUrWGN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:48131 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbbCWWeL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Mar 2015 18:34:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.zummo@towertech.it, baruch@tkos.co.il, mm-commits@vger.kernel.org


The patch titled
     Subject: rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix
has been added to the -mm tree.  Its filename is
     rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch

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
Subject: rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix

build command arrays at compile-time

Cc: Alessandro Zummo <a.zummo@towertech.it>
Cc: Baruch Siach <baruch@tkos.co.il>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-digicolor.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-digicolor.c~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix drivers/rtc/rtc-digicolor.c
--- a/drivers/rtc/rtc-digicolor.c~rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix
+++ a/drivers/rtc/rtc-digicolor.c
@@ -42,7 +42,7 @@ struct dc_rtc {
 	void __iomem		*regs;
 };
 
-static int dc_rtc_cmds(struct dc_rtc *rtc, u8 *cmds, int len)
+static int dc_rtc_cmds(struct dc_rtc *rtc, const u8 *cmds, int len)
 {
 	u8 val;
 	int i, ret;
@@ -62,7 +62,7 @@ static int dc_rtc_cmds(struct dc_rtc *rt
 
 static int dc_rtc_read(struct dc_rtc *rtc, unsigned long *val)
 {
-	u8 read_cmds[] = {CMD_READ, CMD_NOP};
+	static const u8 read_cmds[] = {CMD_READ, CMD_NOP};
 	u32 reference, time1, time2;
 	int ret;
 
@@ -86,7 +86,7 @@ static int dc_rtc_read(struct dc_rtc *rt
 
 static int dc_rtc_write(struct dc_rtc *rtc, u32 val)
 {
-	u8 write_cmds[] = {CMD_WRITE, CMD_NOP, CMD_RESET, CMD_NOP};
+	static const u8 write_cmds[] = {CMD_WRITE, CMD_NOP, CMD_RESET, CMD_NOP};
 
 	writel_relaxed(val, rtc->regs + DC_RTC_REFERENCE);
 	return dc_rtc_cmds(rtc, write_cmds, ARRAY_SIZE(write_cmds));
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
drivers-rtc-rtc-mrst-fix-suspend-resume-fix.patch
mm-fix-anon_vma-degree-underflow-in-anon_vma-endless-growing-prevention.patch
mm.patch
mm-cma-release-trigger-checkpatch-fixes.patch
mm-cma-allocation-trigger-fix.patch
mm-compaction-enhance-compaction-finish-condition-fix.patch
page_writeback-cleanup-mess-around-cancel_dirty_page-checkpatch-fixes.patch
mm-hide-per-cpu-lists-in-output-of-show_mem-fix.patch
mm-clarify-__gfp_nofail-deprecation-status-checkpatch-fixes.patch
mm-change-vunmap-to-tear-down-huge-kva-mappings-fix.patch
mm-mempool-do-not-allow-atomic-resizing-checkpatch-fixes.patch
hugetlbfs-add-minimum-size-tracking-fields-to-subpool-structure-fix.patch
hugetlbfs-add-minimum-size-accounting-to-subpools-fix.patch
mm-memory-failurec-define-page-types-for-action_result-in-one-place-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-memcg-sync-allocation-and-memcg-charge-gfp-flags-for-thp-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
mm-support-madvisemadv_free-fix-2.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
zram-add-dynamic-device-add-remove-functionality-fix.patch
zram-introduce-automatic-device_id-generation-fix.patch
zsmalloc-support-compaction-fix.patch
kernel-conditionally-support-non-root-users-groups-and-capabilities-checkpatch-fixes.patch
lib-vsprintf-add-%pcnr-format-specifiers-for-clocks-fix.patch
lib-find__bit-reimplementation-fix.patch
checkpatch-match-more-world-writable-permissions-fix.patch
binfmt_misc-simplify-entry_status-fix.patch
rtc-add-abracon-abx80x-driver-fix.patch
rtc-driver-for-conexant-digicolor-cx92755-on-chip-rtc-fix.patch
fs-fat-remove-unnecessary-includes-fix.patch
kconfig-use-macros-which-are-already-defined-fix.patch
linux-next.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
lib-kconfig-fix-up-have_arch_bitreverse-help-text.patch
oprofile-reduce-mmap_sem-hold-for-mm-exe_file-fix.patch
tomoyo-reduce-mmap_sem-hold-for-mm-exe_file-checkpatch-fixes.patch
documentation-spi-spidev_testc-fix-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

