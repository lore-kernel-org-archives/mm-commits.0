From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Wed, 05 Jul 2017 12:38:56 -0700
Message-ID: <20170705193856.84dk9lZUV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47694 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751868AbdGETi5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jul 2017 15:38:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, mm-commits@vger.kernel.org


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


diff -puN drivers/char/tpm/tpm-interface.c~linux-next-git-rejects drivers/char/tpm/tpm-interface.c
--- a/drivers/char/tpm/tpm-interface.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm-interface.c
@@ -539,8 +539,6 @@ ssize_t tpm_transmit_cmd(struct tpm_chip
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tpm_transmit_cmd);
-<<<<<<< HEAD
-=======
 
 #define TPM_ORD_STARTUP 153
 #define TPM_ST_CLEAR 1
@@ -582,7 +580,6 @@ int tpm_startup(struct tpm_chip *chip)
 	tpm_buf_destroy(&buf);
 	return rc;
 }
->>>>>>> linux-next/akpm-base
 
 #define TPM_DIGEST_SIZE 20
 #define TPM_RET_CODE_IDX 6
@@ -630,30 +627,6 @@ ssize_t tpm_getcap(struct tpm_chip *chip
 }
 EXPORT_SYMBOL_GPL(tpm_getcap);
 
-<<<<<<< HEAD
-#define TPM_ORD_STARTUP 153
-#define TPM_ST_CLEAR cpu_to_be16(1)
-#define TPM_ST_STATE cpu_to_be16(2)
-#define TPM_ST_DEACTIVATED cpu_to_be16(3)
-static const struct tpm_input_header tpm_startup_header = {
-	.tag = cpu_to_be16(TPM_TAG_RQU_COMMAND),
-	.length = cpu_to_be32(12),
-	.ordinal = cpu_to_be32(TPM_ORD_STARTUP)
-};
-
-static int tpm_startup(struct tpm_chip *chip, __be16 startup_type)
-{
-	struct tpm_cmd_t start_cmd;
-	start_cmd.header.in = tpm_startup_header;
-
-	start_cmd.params.startup_in.startup_type = startup_type;
-	return tpm_transmit_cmd(chip, NULL, &start_cmd,
-				TPM_INTERNAL_RESULT_SIZE, 0,
-				0, "attempting to start the TPM");
-}
-
-=======
->>>>>>> linux-next/akpm-base
 int tpm_get_timeouts(struct tpm_chip *chip)
 {
 	cap_t cap;
diff -puN drivers/char/tpm/tpm_tis.c~linux-next-git-rejects drivers/char/tpm/tpm_tis.c
--- a/drivers/char/tpm/tpm_tis.c~linux-next-git-rejects
+++ a/drivers/char/tpm/tpm_tis.c
@@ -132,8 +132,6 @@ static int check_acpi_tpm2(struct device
 }
 #endif
 
-<<<<<<< HEAD
-=======
 #ifdef CONFIG_X86
 #define INTEL_LEGACY_BLK_BASE_ADDR      0xFED08000
 #define ILB_REMAP_SIZE			0x100
@@ -209,7 +207,6 @@ static void tpm_platform_end_xfer(void)
 }
 #endif
 
->>>>>>> linux-next/akpm-base
 static int tpm_tcg_read_bytes(struct tpm_tis_data *data, u32 addr, u16 len,
 			      u8 *result)
 {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-old-mle-put-and-release-after-the-function-dlm_add_migration_mle-called-fix.patch
ocfs2-dlm-optimization-of-code-while-free-dead-node-locks-checkpatch-fixes.patch
mm.patch
mm-slub-wrap-cpu_slab-partial-in-config_slub_cpu_partial-fix.patch
mm-memory_hotplug-do-not-associate-hotadded-memory-to-zones-until-online-fix-2-fix.patch
swap-add-block-io-poll-in-swapin-path-checkpatch-fixes.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix.patch
mm-oom_kill-count-global-and-memory-cgroup-oom-kills-fix-fix.patch
mm-swap-sort-swap-entries-before-free-fix.patch
mm-vmscan-avoid-thrashing-anon-lru-when-free-file-is-low-fix.patch
mm-hwpoison-dissolve-in-use-hugepage-in-unrecoverable-memory-error-fix.patch
mm-hugetlb-warn-the-user-when-issues-arise-on-boot-due-to-hugepages-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix.patch
mm-improve-readability-of-transparent_hugepage_enabled-fix-fix.patch
hugetlb-memory_hotplug-prefer-to-use-reserved-pages-for-migration-fix.patch
mm-page_allocc-eliminate-unsigned-confusion-in-__rmqueue_fallback-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix.patch
mm-memory_hotplug-just-build-zonelist-for-new-added-node-fix-fix.patch
signal-avoid-undefined-behaviour-in-kill_something_info-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
fault-inject-support-systematic-fault-injection-fix.patch
linux-next-rejects.patch
powerpc-64s-implement-arch-specific-hardlockup-watchdog-checkpatch-fixes.patch
mm-tree-wide-replace-__gfp_repeat-by-__gfp_retry_mayfail-with-more-useful-semantic-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch
linux-next-git-rejects.patch

