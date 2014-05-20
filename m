From: akpm@linux-foundation.org
Subject: + linux-next-git-rejects.patch added to -mm tree
Date: Tue, 20 May 2014 11:15:24 -0700
Message-ID: <537b9bbc.pOUtREaz4L+3m7wE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:32970 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaETSPY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 20 May 2014 14:15:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, akpm@linux-foundation.org

Subject: + linux-next-git-rejects.patch added to -mm tree
To: akpm@linux-foundation.org
From: akpm@linux-foundation.org
Date: Tue, 20 May 2014 11:15:24 -0700


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

 arch/mips/include/uapi/asm/inst.h    |   21 ---------------------
 arch/mips/loongson/lemote-2f/clock.c |   15 ---------------
 arch/x86/kernel/ldt.c                |    9 ---------
 arch/x86/vdso/vdso32-setup.c         |    9 ---------
 sound/soc/intel/sst-baytrail-dsp.c   |   10 ----------
 5 files changed, 64 deletions(-)

diff -puN arch/mips/include/uapi/asm/inst.h~linux-next-git-rejects arch/mips/include/uapi/asm/inst.h
--- a/arch/mips/include/uapi/asm/inst.h~linux-next-git-rejects
+++ a/arch/mips/include/uapi/asm/inst.h
@@ -482,27 +482,6 @@ enum MIPS6e_i8_func {
  */
 #define MM_NOP16	0x0c00
 
-<<<<<<< HEAD
-/*
- * Damn ...  bitfields depend from byteorder :-(
- */
-#ifdef __MIPSEB__
-#define __BITFIELD_FIELD(field, more)					\
-	field;								\
-	more
-
-#elif defined(__MIPSEL__)
-
-#define __BITFIELD_FIELD(field, more)					\
-	more								\
-	field;
-
-#else /* !defined (__MIPSEB__) && !defined (__MIPSEL__) */
-#error "MIPS but neither __MIPSEL__ nor __MIPSEB__?"
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 struct j_format {
 	__BITFIELD_FIELD(unsigned int opcode : 6, /* Jump format */
 	__BITFIELD_FIELD(unsigned int target : 26,
diff -puN arch/mips/loongson/lemote-2f/clock.c~linux-next-git-rejects arch/mips/loongson/lemote-2f/clock.c
--- a/arch/mips/loongson/lemote-2f/clock.c~linux-next-git-rejects
+++ a/arch/mips/loongson/lemote-2f/clock.c
@@ -92,10 +92,7 @@ EXPORT_SYMBOL(clk_put);
 int clk_set_rate(struct clk *clk, unsigned long rate)
 {
 	unsigned int rate_khz = rate / 1000;
-<<<<<<< HEAD
-=======
 	struct cpufreq_frequency_table *pos;
->>>>>>> linux-next/akpm-base
 	int ret = 0;
 	int regval;
 
@@ -110,22 +107,10 @@ int clk_set_rate(struct clk *clk, unsign
 	if (unlikely(clk->flags & CLK_RATE_PROPAGATES))
 		propagate_rate(clk);
 
-<<<<<<< HEAD
-	for (i = 0; loongson2_clockmod_table[i].frequency != CPUFREQ_TABLE_END;
-	     i++) {
-		if (loongson2_clockmod_table[i].frequency ==
-		    CPUFREQ_ENTRY_INVALID)
-			continue;
-		if (rate_khz == loongson2_clockmod_table[i].frequency)
-			break;
-	}
-	if (rate_khz != loongson2_clockmod_table[i].frequency)
-=======
 	cpufreq_for_each_valid_entry(pos, loongson2_clockmod_table)
 		if (rate_khz == pos->frequency)
 			break;
 	if (rate_khz != pos->frequency)
->>>>>>> linux-next/akpm-base
 		return -ENOTSUPP;
 
 	clk->rate = rate;
diff -puN arch/x86/kernel/ldt.c~linux-next-git-rejects arch/x86/kernel/ldt.c
--- a/arch/x86/kernel/ldt.c~linux-next-git-rejects
+++ a/arch/x86/kernel/ldt.c
@@ -231,16 +231,7 @@ static int write_ldt(void __user *ptr, u
 		}
 	}
 
-<<<<<<< HEAD
-	/*
-	 * On x86-64 we do not support 16-bit segments due to
-	 * IRET leaking the high bits of the kernel stack address.
-	 */
-#ifdef CONFIG_X86_64
-	if (!ldt_info.seg_32bit && !sysctl_ldt16) {
-=======
 	if (!IS_ENABLED(CONFIG_X86_16BIT) && !ldt_info.seg_32bit) {
->>>>>>> linux-next/akpm-base
 		error = -EINVAL;
 		goto out_unlock;
 	}
diff -puN arch/x86/vdso/vdso32-setup.c~linux-next-git-rejects arch/x86/vdso/vdso32-setup.c
--- a/arch/x86/vdso/vdso32-setup.c~linux-next-git-rejects
+++ a/arch/x86/vdso/vdso32-setup.c
@@ -21,15 +21,6 @@
 #define VDSO_DEFAULT	1
 #endif
 
-<<<<<<< HEAD
-#ifdef CONFIG_X86_64
-#define vdso_enabled			sysctl_vsyscall32
-#define arch_setup_additional_pages	syscall32_setup_pages
-extern int sysctl_ldt16;
-#endif
-
-=======
->>>>>>> linux-next/akpm-base
 /*
  * Should the kernel map a VDSO page into processes and pass its
  * address down to glibc upon exec()?
diff -puN sound/soc/intel/sst-baytrail-dsp.c~linux-next-git-rejects sound/soc/intel/sst-baytrail-dsp.c
--- a/sound/soc/intel/sst-baytrail-dsp.c~linux-next-git-rejects
+++ a/sound/soc/intel/sst-baytrail-dsp.c
@@ -324,16 +324,6 @@ static int sst_byt_init(struct sst_dsp *
 		return ret;
 	}
 
-<<<<<<< HEAD
-	/*
-	 * save the physical address of extended firmware block in the first
-	 * 4 bytes of the mailbox
-	 */
-	memcpy_toio(sst->addr.lpe + SST_BYT_MAILBOX_OFFSET,
-	       &pdata->fw_base, sizeof(u32));
-
-=======
->>>>>>> linux-next/akpm-base
 	ret = dma_coerce_mask_and_coherent(sst->dma_dev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
maintainers-akpm-maintenance.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
arch-unicore32-mm-ioremapc-convert-printk-warn_on-to-warn1-fix.patch
arch-unicore32-mm-ioremapc-return-null-on-invalid-pfn.patch
ocfs2-limit-printk-when-journal-is-aborted-fix.patch
ocfs2-do-not-return-dlm_migrate_response_mastery_ref-to-avoid-endlessloop-during-umount.patch
fs-add-generic-data-flush-to-fsync-fix.patch
fs-add-generic-data-flush-to-fsync-fix-fix.patch
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
mm-page_alloc-do-not-cache-reclaim-distances-fix.patch
fs-hugetlbfs-inodec-complete-conversion-to-pr_foo.patch
mm-compaction-cleanup-isolate_freepages-fix.patch
arc-call-find_vma-with-the-mmap_sem-held-fix.patch
mm-vmscan-do-not-throttle-based-on-pfmemalloc-reserves-if-node-has-no-zone_normal-checkpatch-fixes.patch
swap-use-bdev_read_page-bdev_write_page-fix.patch
mm-update-comment-for-default_max_map_count-fix.patch
memcg-fold-mem_cgroup_stolen-fix.patch
mm-compaction-embed-migration-mode-in-compact_control-fix.patch
mm-add-comment-for-__mod_zone_page_stat.patch
mm-add-comment-for-__mod_zone_page_stat-checkpatch-fixes.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site.patch
mm-fold-mlocked_vma_newpage-into-its-only-call-site-checkpatch-fixes.patch
fs-buffer-do-not-use-unnecessary-atomic-operations-when-discarding-buffers-fix.patch
mm-compaction-properly-signal-and-act-upon-lock-and-need_sched-contention-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-res_counterc-replace-simple_strtoull-by-kstrtoull-fix.patch
printk-release-lockbuf_lock-before-calling-console_trylock_for_printk-fix.patch
lib-btreec-fix-leak-of-whole-btree-nodes-fix.patch
init-mainc-dont-use-pr_debug.patch
init-mainc-add-initcall_blacklist-kernel-parameter-fix.patch
init-mainc-remove-an-ifdef.patch
rtc-rtc-cmos-drivers-char-rtcc-features-for-decstation-support-fix.patch
rtc-da9063-rtc-driver-fix.patch
hfsplus-fixes-worst-case-unicode-to-char-conversion-of-file-names-and-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix.patch
hfsplus-correct-usage-of-hfsplus_attr_max_strlen-for-non-english-attributes-fix-2.patch
smp-print-more-useful-debug-info-upon-receiving-ipi-on-an-offline-cpu-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-2.patch
sysctl-allow-for-strict-write-position-handling-fix.patch
sysctl-allow-for-strict-write-position-handling-fix-3.patch
fs-pstore-logging-clean-up-fix.patch
fs-devpts-inodec-convert-printk-to-pr_foo-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-page_ioc-work-around-gcc-bug.patch
lib-test_bpfc-dont-use-gcc-union-shortcut.patch
kernel-watchdogc-print-traces-for-all-cpus-on-lockup-detection-fix.patch
rwsem-support-optimistic-spinning-checkpatch-fixes.patch
mm-mark-remap_file_pages-syscall-as-deprecated-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
memcg-deprecate-memoryforce_empty-knob-fix.patch
ufs-sb-mutex-merge-mutex_destroy.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
linux-next-git-rejects.patch

