From: akpm@linux-foundation.org
Subject: + kernel-add-kcov-code-coverage-makefile-tweaks.patch added to
 -mm tree
Date: Fri, 04 Mar 2016 13:21:06 -0800
Message-ID: <56d9fc42.kKsrYd7jU3ZQI8Ma%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759080AbcCDVVH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Mar 2016 16:21:07 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dvyukov@google.com, hpa@zytor.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel-add-kcov-code-coverage-makefile-tweaks
has been added to the -mm tree.  Its filename is
     kernel-add-kcov-code-coverage-makefile-tweaks.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernel-add-kcov-code-coverage-makefile-tweaks.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernel-add-kcov-code-coverage-makefile-tweaks.patch

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
Subject: kernel-add-kcov-code-coverage-makefile-tweaks

follow x86 Makefile layout standards

Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/boot/Makefile            |    2 +-
 arch/x86/boot/compressed/Makefile |    2 +-
 arch/x86/entry/vdso/Makefile      |    2 +-
 arch/x86/kernel/Makefile          |    2 +-
 arch/x86/kernel/apic/Makefile     |    2 +-
 arch/x86/lib/Makefile             |    2 +-
 arch/x86/mm/Makefile              |    2 +-
 arch/x86/realmode/rm/Makefile     |    2 +-
 kernel/locking/Makefile           |    2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff -puN arch/x86/boot/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/boot/Makefile
--- a/arch/x86/boot/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/boot/Makefile
@@ -15,7 +15,7 @@ KASAN_SANITIZE := n
 # callback into middle of per-cpu data enabling code. Thus the callback observed
 # inconsistent state and crashed. We are interested mostly in syscall coverage,
 # so boot code is not interesting anyway.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 # If you want to preset the SVGA mode, uncomment the next line and
 # set SVGA_MODE to whatever number you want.
diff -puN arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/boot/compressed/Makefile
--- a/arch/x86/boot/compressed/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/boot/compressed/Makefile
@@ -18,7 +18,7 @@
 
 KASAN_SANITIZE := n
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 targets := vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma \
 	vmlinux.bin.xz vmlinux.bin.lzo vmlinux.bin.lz4
diff -puN arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/entry/vdso/Makefile
--- a/arch/x86/entry/vdso/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/entry/vdso/Makefile
@@ -6,7 +6,7 @@ KBUILD_CFLAGS += $(DISABLE_LTO)
 KASAN_SANITIZE := n
 UBSAN_SANITIZE := n
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 VDSO64-$(CONFIG_X86_64)		:= y
 VDSOX32-$(CONFIG_X86_X32_ABI)	:= y
diff -puN arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/kernel/Makefile
--- a/arch/x86/kernel/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/kernel/Makefile
@@ -23,7 +23,7 @@ KASAN_SANITIZE_dumpstack_$(BITS).o := n
 # Probably could be more selective here, but note that files related to irqs,
 # boot, dumpstack/stacktrace, etc are either non-interesting or can lead to
 # non-deterministic coverage.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 CFLAGS_irq.o := -I$(src)/../include/asm/trace
 
diff -puN arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/kernel/apic/Makefile
--- a/arch/x86/kernel/apic/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/kernel/apic/Makefile
@@ -4,7 +4,7 @@
 
 # Leads to non-deterministic coverage that is not a function of syscall inputs.
 # In particualr, smp_apic_timer_interrupt() is called in random places.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 obj-$(CONFIG_X86_LOCAL_APIC)	+= apic.o apic_noop.o ipi.o vector.o
 obj-y				+= hw_nmi.o
diff -puN arch/x86/lib/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/lib/Makefile
--- a/arch/x86/lib/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/lib/Makefile
@@ -3,7 +3,7 @@
 #
 
 # Produces uninteresting flaky coverage.
-KCOV_INSTRUMENT_delay.o := n
+KCOV_INSTRUMENT_delay.o	:= n
 
 inat_tables_script = $(srctree)/arch/x86/tools/gen-insn-attr-x86.awk
 inat_tables_maps = $(srctree)/arch/x86/lib/x86-opcode-map.txt
diff -puN arch/x86/mm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/mm/Makefile
--- a/arch/x86/mm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/mm/Makefile
@@ -1,5 +1,5 @@
 # Kernel does not boot with instrumentation of tlb.c.
-KCOV_INSTRUMENT_tlb.o := n
+KCOV_INSTRUMENT_tlb.o	:= n
 
 obj-y	:=  init.o init_$(BITS).o fault.o ioremap.o extable.o pageattr.o mmap.o \
 	    pat.o pgtable.o physaddr.o gup.o setup_nx.o
diff -puN arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks arch/x86/realmode/rm/Makefile
--- a/arch/x86/realmode/rm/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/arch/x86/realmode/rm/Makefile
@@ -8,7 +8,7 @@
 #
 KASAN_SANITIZE := n
 # Prevents link failures: __sanitizer_cov_trace_pc() is not linked in.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 always := realmode.bin realmode.relocs
 
diff -puN kernel/locking/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks kernel/locking/Makefile
--- a/kernel/locking/Makefile~kernel-add-kcov-code-coverage-makefile-tweaks
+++ a/kernel/locking/Makefile
@@ -1,6 +1,6 @@
 # Any varying coverage in these files is non-deterministic
 # and is generally not a function of system call inputs.
-KCOV_INSTRUMENT := n
+KCOV_INSTRUMENT		:= n
 
 obj-y += mutex.o semaphore.o rwsem.o percpu-rwsem.o
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
arm-arch-arm-include-asm-pageh-needs-personalityh.patch
ocfs2-code-clean-up-for-direct-io-fix.patch
ocfs2-fix-ip_unaligned_aio-deadlock-with-dio-work-queue-fix.patch
ocfs2-dlm-move-lock-to-the-tail-of-grant-queue-while-doing-in-place-convert-fix.patch
mm.patch
mm-slab-clean-up-debug_pagealloc-processing-code-fix.patch
mm-slab-put-the-freelist-at-the-end-of-slab-page-fix.patch
slub-drop-lock-at-the-end-of-free_debug_processing-fix.patch
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
mm-add-a-new-vector-based-madvise-syscall-fix.patch
mm-page_ref-add-tracepoint-to-track-down-page-reference-manipulation-fix-3-fix.patch
ksm-introduce-ksm_max_page_sharing-per-page-deduplication-limit-fix-2.patch
zram-export-the-number-of-available-comp-streams-fix.patch
mm-oom-rework-oom-detection-checkpatch-fixes.patch
mm-use-watermak-checks-for-__gfp_repeat-high-order-allocations-checkpatch-fixes.patch
mn10300-c6x-config_generic_bug-must-depend-on-config_bug.patch
arch-mn10300-kernel-fpu-nofpuc-needs-asm-elfh.patch
btrfs-use-radix_tree_iter_retry-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix.patch
sparc-compat-provide-an-accurate-in_compat_syscall-implementation-fix-fix.patch
rapidio-add-mport-char-device-driver-fix.patch
dma-rename-dma__writecombine-to-dma__wc-checkpatch-fixes.patch
kernel-add-kcov-code-coverage-fix.patch
kernel-add-kcov-code-coverage-fix-2.patch
kernel-add-kcov-code-coverage-makefile-tweaks.patch
linux-next-rejects.patch
drivers-net-wireless-intel-iwlwifi-dvm-calibc-fix-min-warning.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

