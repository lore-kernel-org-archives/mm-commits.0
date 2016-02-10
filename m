From: akpm@linux-foundation.org
Subject: +
 arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch added to
 -mm tree
Date: Wed, 10 Feb 2016 12:13:43 -0800
Message-ID: <56bb99f7.gH6o1nOdVneUALE7%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45686 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbcBJUNo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 10 Feb 2016 15:13:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@intel.com, hpa@zytor.com, matt@codeblueprint.co.uk, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/x86/Kconfig: CONFIG_X86_UV should depend on CONFIG_EFI
has been added to the -mm tree.  Its filename is
     arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch

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
Subject: arch/x86/Kconfig: CONFIG_X86_UV should depend on CONFIG_EFI

arch/x86/built-in.o: In function `uv_bios_call':
(.text+0xeba00): undefined reference to `efi_call'

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Suggested-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/Kconfig~arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi arch/x86/Kconfig
--- a/arch/x86/Kconfig~arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi
+++ a/arch/x86/Kconfig
@@ -477,6 +477,7 @@ config X86_UV
 	depends on X86_64
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
+	depends on EFI
 	depends on X86_X2APIC
 	depends on PCI
 	---help---
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
vsprintf-kptr_restrict-is-okay-in-irq-when-2-checkpatch-fixes.patch
kernel-locking-lockdepc-convert-hash-tables-to-hlists.patch
arch-x86-kconfig-config_x86_uv-should-depend-on-config_efi.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
fs-mpagec-mpage_readpages-use-lru_to_page-helper.patch
mm-page_allocc-introduce-kernelcore=mirror-option-fix.patch
mm-page_allocc-rework-code-layout-in-memmap_init_zone.patch
mm-debug-pageallocc-split-out-page-poisoning-from-debug-page_alloc-checkpatch-fixes.patch
mm-page_poisonc-enable-page_poisoning-as-a-separate-option-fix.patch
mm-page_poisoningc-allow-for-zero-poisoning-checkpatch-fixes.patch
mm-madvise-update-comment-on-sys_madvise-fix.patch
mm-migrate-do-not-touch-page-mem_cgroup-of-live-pages-fix.patch
mm-simplify-lock_page_memcg-fix.patch
sched-add-schedule_timeout_idle.patch
mm-oom_reaper-report-success-failure-fix.patch
mm-compaction-speed-up-pageblock_pfn_to_page-when-zone-is-contiguous-fix.patch
proc-kpageflags-return-kpf_buddy-for-tail-buddy-pages-fix-fix.patch
mm-vmalloc-query-dynamic-debug_pagealloc-setting-fix.patch
mm-slub-query-dynamic-debug_pagealloc-setting-fix.patch
sound-query-dynamic-debug_pagealloc-setting-fix.patch
mm-config_nr_zones_extended-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-memremapc-add-new-arg-to-dev_warn.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

