From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 21 Jan 2014 12:36:17 -0800
Message-ID: <52deda41.3WuR+x3i2f55uU9a%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44380 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAUUgS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 21 Jan 2014 15:36:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 21 Jan 2014 12:36:17 -0800


The patch titled
     Subject: linux-next-git-rejects
has been added to the -mm tree.  Its filename is
     linux-next-git-rejects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-next-git-rejects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-next-git-rejects.patch

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
Subject: linux-next-git-rejects

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/configs/bcm_defconfig |    3 --
 arch/xtensa/Kconfig            |    3 --
 drivers/char/tpm/tpm_ppi.c     |   37 -------------------------------
 drivers/gpio/Kconfig           |    5 ----
 drivers/leds/leds-s3c24xx.c    |    3 --
 lib/kobject.c                  |    3 --
 6 files changed, 54 deletions(-)

diff -puN arch/arm/configs/bcm_defconfig~linux-next-git-rejects arch/arm/configs/bcm_defconfig
--- a/arch/arm/configs/bcm_defconfig~linux-next-git-rejects
+++ a/arch/arm/configs/bcm_defconfig
@@ -125,10 +125,7 @@ CONFIG_CRC_ITU_T=y
 CONFIG_CRC7=y
 CONFIG_XZ_DEC=y
 CONFIG_AVERAGE=y
-<<<<<<< HEAD
-=======
 CONFIG_WATCHDOG=y
 CONFIG_BCM_KONA_WDT=y
 CONFIG_BCM_KONA_WDT_DEBUG=y
->>>>>>> linux-next/akpm-base
 CONFIG_PINCTRL_CAPRI=y
diff -puN arch/xtensa/Kconfig~linux-next-git-rejects arch/xtensa/Kconfig
--- a/arch/xtensa/Kconfig~linux-next-git-rejects
+++ a/arch/xtensa/Kconfig
@@ -65,12 +65,9 @@ config MMU
 config VARIANT_IRQ_SWITCH
 	def_bool n
 
-<<<<<<< HEAD
-=======
 config MAY_HAVE_SMP
 	def_bool n
 
->>>>>>> linux-next/akpm-base
 config HAVE_XTENSA_GPIO32
 	def_bool n
 
diff -puN drivers/char/tpm/tpm_ppi.c~linux-next-git-rejects drivers/char/tpm/tpm_ppi.c
--- a/drivers/char/tpm/tpm_ppi.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm_ppi.c
@@ -109,30 +109,16 @@ static ssize_t tpm_store_ppi_request(str
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-<<<<<<< HEAD
-	if (strcmp(version, "1.1") < 0)
-		params[2].integer.value = TPM_PPI_FN_SUBREQ;
-	else
-		params[2].integer.value = TPM_PPI_FN_SUBREQ2;
-=======
 	if (acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
 			   1 << TPM_PPI_FN_SUBREQ2))
 		func = TPM_PPI_FN_SUBREQ2;
 
->>>>>>> linux-next/akpm-base
 	/*
 	 * PPI spec defines params[3].type as ACPI_TYPE_PACKAGE. Some BIOS
 	 * accept buffer/string/integer type, but some BIOS accept buffer/
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-<<<<<<< HEAD
-	if (strcmp(version, "1.2") < 0) {
-		params[3].type = ACPI_TYPE_BUFFER;
-		params[3].buffer.length = sizeof(req);
-		sscanf(buf, "%d", &req);
-		params[3].buffer.pointer = (char *)&req;
-=======
 	if (strcmp(tpm_ppi_version, "1.2") < 0) {
 		if (sscanf(buf, "%d", &req) != 1)
 			return -EINVAL;
@@ -148,7 +134,6 @@ static ssize_t tpm_store_ppi_request(str
 	obj = tpm_eval_dsm(func, ACPI_TYPE_INTEGER, &argv4);
 	if (!obj) {
 		return -ENXIO;
->>>>>>> linux-next/akpm-base
 	} else {
 		ret = obj->integer.value;
 		ACPI_FREE(obj);
@@ -186,12 +171,6 @@ static ssize_t tpm_show_ppi_transition_a
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-<<<<<<< HEAD
-	if (strcmp(version, "1.2") < 0) {
-		params[3].type = ACPI_TYPE_BUFFER;
-		params[3].buffer.length =  0;
-		params[3].buffer.pointer = NULL;
-=======
 	if (strcmp(tpm_ppi_version, "1.2") < 0)
 		obj = &tmp;
 	obj = tpm_eval_dsm(TPM_PPI_FN_GETACT, ACPI_TYPE_INTEGER, obj);
@@ -200,7 +179,6 @@ static ssize_t tpm_show_ppi_transition_a
 	} else {
 		ret = obj->integer.value;
 		ACPI_FREE(obj);
->>>>>>> linux-next/akpm-base
 	}
 
 	if (ret < ARRAY_SIZE(info) - 1)
@@ -286,23 +264,8 @@ static ssize_t show_ppi_operations(char
 		"User not required",
 	};
 
-<<<<<<< HEAD
-	status = acpi_evaluate_object_typed(handle, "_DSM", &input, &output,
-					 ACPI_TYPE_STRING);
-	if (ACPI_FAILURE(status))
-		return -ENOMEM;
-
-	strlcpy(version,
-		((union acpi_object *)output.pointer)->string.pointer,
-		PPI_VERSION_LEN + 1);
-	kfree(output.pointer);
-	output.length = ACPI_ALLOCATE_BUFFER;
-	output.pointer = NULL;
-	if (strcmp(version, "1.2") < 0)
-=======
 	if (!acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
 			    1 << TPM_PPI_FN_GETOPR))
->>>>>>> linux-next/akpm-base
 		return -EPERM;
 
 	tmp.integer.type = ACPI_TYPE_INTEGER;
diff -puN drivers/gpio/Kconfig~linux-next-git-rejects drivers/gpio/Kconfig
--- a/drivers/gpio/Kconfig~linux-next-git-rejects
+++ a/drivers/gpio/Kconfig
@@ -732,12 +732,7 @@ config GPIO_MAX7301
 
 config GPIO_MCP23S08
 	tristate "Microchip MCP23xxx I/O expander"
-<<<<<<< HEAD
-	depends on OF_GPIO
-	depends on (SPI_MASTER && !I2C) || I2C
-=======
 	depends on (SPI_MASTER && !I2C) || I2C && OF_GPIO
->>>>>>> linux-next/akpm-base
 	help
 	  SPI/I2C driver for Microchip MCP23S08/MCP23S17/MCP23008/MCP23017
 	  I/O expanders.
diff -puN drivers/leds/leds-s3c24xx.c~linux-next-git-rejects drivers/leds/leds-s3c24xx.c
--- a/drivers/leds/leds-s3c24xx.c~linux-next-git-rejects
+++ a/drivers/leds/leds-s3c24xx.c
@@ -22,10 +22,7 @@
 
 #include <mach/regs-gpio.h>
 #include <plat/gpio-cfg.h>
-<<<<<<< HEAD
 #include <linux/platform_data/leds-s3c24xx.h>
-=======
->>>>>>> linux-next/akpm-base
 
 /* our context */
 
diff -puN lib/kobject.c~linux-next-git-rejects lib/kobject.c
--- a/lib/kobject.c~linux-next-git-rejects
+++ a/lib/kobject.c
@@ -779,10 +779,7 @@ const struct sysfs_ops kobj_sysfs_ops =
 	.show	= kobj_attr_show,
 	.store	= kobj_attr_store,
 };
-<<<<<<< HEAD
-=======
 EXPORT_SYMBOL_GPL(kobj_sysfs_ops);
->>>>>>> linux-next/akpm-base
 
 /**
  * kset_register - initialize and add a kset.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer-fix.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-hugetlbfs-move-the-put-get_page-slab-and-hugetlbfs-optimization-in-a-faster-path-fix-2.patch
mm-hugetlbc-simplify-pageheadhuge-and-pagehuge.patch
mm-swapc-reorganize-put_compound_page.patch
mm-get-rid-of-unnecessary-pageblock-scanning-in-setup_zone_migrate_reserve-fix.patch
mm-memory-failure-fix-the-typo-in-me_pagecache_dirty-fix.patch
mm-show_mem-remove-show_mem_filter_page_count-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-checkpatch-fixes.patch
mm-add-overcommit_kbytes-sysctl-variable-fix.patch
mm-add-overcommit_kbytes-sysctl-variable-fix-2.patch
memblock-mem_hotplug-introduce-memblock_hotplug-flag-to-mark-hotpluggable-regions-checkpatch-fixes.patch
acpi-numa-mem_hotplug-mark-hotpluggable-memory-in-memblock-checkpatch-fixes.patch
memblock-mem_hotplug-make-memblock-skip-hotpluggable-regions-if-needed-checkpatch-fixes.patch
mm-memblock-add-memblock-memory-allocation-apis-fix.patch
sched-add-tracepoints-related-to-numa-task-migration-fix.patch
mm-page_alloc-warn-for-non-blockable-__gfp_nofail-allocation-failure.patch
mm-print-more-details-for-bad_page-fix.patch
mm-munlock-fix-potential-race-with-thp-page-split-fix.patch
mm-dump-page-when-hitting-a-vm_bug_on-using-vm_bug_on_page-fix-fix.patch
memcg-slab-kmem_cache_create_memcg-fix-memleak-on-fail-path-fix.patch
numa-add-a-sysctl-for-numa_balancing-fix.patch
mm-swap-fix-race-on-swap_info-reuse-between-swapoff-and-swapon-fix.patch
mm-nobootmem-free_all_bootmem-again-fix-fix.patch
mm-improve-documentation-of-page_order-v2-fix.patch
lib-parserc-put-export_symbols-in-the-conventional-place.patch
printk-flush-conflicting-continuation-line-fix.patch
drivers-rtc-rtc-cmosc-propagate-hpet_register_irq_handler-failure.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
fs-ext3-use-rbtree-postorder-iteration-helper-instead-of-opencoding-fix.patch
ipc-semc-avoid-overflow-of-semop-undo-semadj-value-fix.patch
ipcmsg-document-barriers-fix.patch
ipcmsg-document-barriers-fix-fix.patch
linux-next.patch
linux-next-git-rejects.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

