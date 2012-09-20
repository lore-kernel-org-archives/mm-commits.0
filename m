From: akpm@linux-foundation.org
Subject: + drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix.patch added to -mm tree
Date: Thu, 20 Sep 2012 15:25:35 -0700
Message-ID: <20120920231355.B2A815C0060@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:38307 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab2ITXN6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Sep 2012 19:13:58 -0400
Received: by bkcjc3 with SMTP id jc3so174193bkc.1
        for <mm-commits@vger.kernel.org>; Thu, 20 Sep 2012 16:13:57 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, anilkumar@ti.com, arnd@arndb.de, broonie@opensource.wolfsonmicro.com, eric.piel@tremplin-utc.net, tony@atomide.com


The patch titled
     Subject: drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix
has been added to the -mm tree.  Its filename is
     drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix.patch

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
Subject: drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix

config CONFIG_OF=n build

drivers/misc/lis3lv02d/lis3lv02d_spi.c: In function 'lis302dl_spi_probe':
drivers/misc/lis3lv02d/lis3lv02d_spi.c:89: error: implicit declaration of function 'of_match_device'
drivers/misc/lis3lv02d/lis3lv02d_spi.c:89: error: 'lis302dl_spi_dt_ids' undeclared (first use in this function)
drivers/misc/lis3lv02d/lis3lv02d_spi.c:89: error: (Each undeclared identifier is reported only once
drivers/misc/lis3lv02d/lis3lv02d_spi.c:89: error: for each function it appears in.)
drivers/misc/lis3lv02d/lis3lv02d_spi.c:90: error: 'struct lis3lv02d' has no member named 'of_node'

Cc: AnilKumar Ch <anilkumar@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Piel <eric.piel@tremplin-utc.net>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Tony Lindgren <tony@atomide.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/misc/lis3lv02d/lis3lv02d_spi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -puN drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix drivers/misc/lis3lv02d/lis3lv02d_spi.c
--- a/drivers/misc/lis3lv02d/lis3lv02d_spi.c~drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix
+++ a/drivers/misc/lis3lv02d/lis3lv02d_spi.c
@@ -19,6 +19,7 @@
 #include <linux/pm.h>
 #include <linux/of.h>
 #include <linux/of_platform.h>
+#include <linux/of_device.h>
 
 #include "lis3lv02d.h"
 
@@ -86,13 +87,14 @@ static int __devinit lis302dl_spi_probe(
 	lis3_dev.ac		= lis3lv02d_axis_normal;
 	lis3_dev.pdata		= spi->dev.platform_data;
 
+#ifdef CONFIG_OF
 	if (of_match_device(lis302dl_spi_dt_ids, &spi->dev)) {
 		lis3_dev.of_node = spi->dev.of_node;
 		ret = lis3lv02d_init_dt(&lis3_dev);
 		if (ret)
 			return ret;
 	}
-
+#endif
 	spi_set_drvdata(spi, &lis3_dev);
 
 	return lis3lv02d_init_device(&lis3_dev);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
idr-rename-max_level-to-max_idr_level-fix-3.patch
cpu_hotplug-unmap-cpu2node-when-the-cpu-is-hotremoved-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
audith-replace-defines-with-c-stubs.patch
mm.patch
x86-pat-separate-the-pfn-attribute-tracking-for-remap_pfn_range-and-vm_insert_pfn-fix.patch
mm-kill-vma-flag-vm_reserved-and-mm-reserved_vm-counter-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix.patch
mm-fix-nonuniform-page-status-when-writing-new-file-with-small-buffer-fix-fix.patch
mm-vmscan-scale-number-of-pages-reclaimed-by-reclaim-compaction-based-on-failures-fix.patch
mm-mmu_notifier-fix-inconsistent-memory-between-secondary-mmu-and-host-fix.patch
rbtree-performance-and-correctness-test-fix.patch
mm-cma-discard-clean-pages-during-contiguous-allocation-instead-of-migration-fix-fix.patch
mm-fix-tracing-in-free_pcppages_bulk-fix.patch
cma-count-free-cma-pages-fix.patch
memory-hotplug-fix-pages-missed-by-race-rather-than-failng-fix.patch
atomic-implement-generic-atomic_dec_if_positive-fix.patch
swap-add-a-simple-detector-for-inappropriate-swapin-readahead-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch
mm-page_alloc-refactor-out-__alloc_contig_migrate_alloc-checkpatch-fixes.patch
mm-fix-invalidate_complete_page2-lock-ordering.patch
mm-numa-reclaim-from-all-nodes-within-reclaim-distance-fix.patch
mm-move-all-mmu-notifier-invocations-to-be-done-outside-the-pt-lock.patch
sections-fix-section-conflicts-in-arch-h8300-checkpatch-fixes.patch
sections-fix-section-conflicts-in-drivers-macintosh-checkpatch-fixes.patch
sectons-fix-const-sections-for-crc32-table-checkpatch-fixes.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-dt-matching-table-passthru-code-fix-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_spic-add-lis3lv02d-device-tree-init-fix.patch
drivers-misc-lis3lv02d-lis3lv02d_i2cc-add-lis3lv02d-device-tree-init-fix.patch
backlight-add-backlight-driver-for-lm3630-chip-fix.patch
backlight-add-new-lm3639-backlight-driver-fix.patch
idr-rename-max_level-to-max_idr_level-fix.patch
idr-rename-max_level-to-max_idr_level-fix-fix-2.patch
lib-parserc-avoid-overflow-in-match_number-fix.patch
lib-spinlock_debug-avoid-livelock-in-do_raw_spin_lock-fix.patch
compat-fs-generic-compat_sys_sendfile-implementation.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid-fix.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists-checkpatch-fixes.patch
rtc-add-dallas-ds2404-driver-fix.patch
rtc-snvs-add-freescale-rtc-snvs-driver-fix.patch
fs-fat-fix-all-other-checkpatch-issues-in-dirc-fix.patch
fat-simplify-writeback_inode-checkpatch-fixes.patch
fat-simplify-writeback_inode-checkpatch-fixes-fix.patch
coredump-make-core-dump-functionality-optional-fix-fix.patch
coredump-use-suid_dumpable_enabled-rather-than-hardcoded-1-checkpatch-fixes.patch
coredump-extend-core-dump-note-section-to-contain-file-names-of-mapped-files-checkpatch-fixes.patch
proc-use-kzalloc-instead-of-kmalloc-and-memset-fix.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

