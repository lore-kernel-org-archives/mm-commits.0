From: akpm@google.com
Subject: + arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh.patch added to -mm tree
Date: Tue, 27 Sep 2011 12:49:41 -0700
Message-ID: <201109272029.p8RKTQrp018842@hpaq14.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:25879 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752308Ab1I0U3f (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 27 Sep 2011 16:29:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, a.p.zijlstra@chello.nl, kjwinchester@gmail.com, mingo@redhat.com


The patch titled
     arch/x86/kernel/cpu/perf_event_amd.c needs asm/apicdef.h
has been added to the -mm tree.  Its filename is
     arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: arch/x86/kernel/cpu/perf_event_amd.c needs asm/apicdef.h
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

arch/x86/kernel/cpu/perf_event_amd.c: In function 'amd_pmu_cpu_starting':
arch/x86/kernel/cpu/perf_event_amd.c:350: error: 'BAD_APICID' undeclared (first use in this function)
arch/x86/kernel/cpu/perf_event_amd.c:350: error: (Each undeclared identifier is reported only once
arch/x86/kernel/cpu/perf_event_amd.c:350: error: for each function it appears in.)

Cc: Kevin Winchester <kjwinchester@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/perf_event_amd.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN arch/x86/kernel/cpu/perf_event_amd.c~arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh arch/x86/kernel/cpu/perf_event_amd.c
--- a/arch/x86/kernel/cpu/perf_event_amd.c~arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh
+++ a/arch/x86/kernel/cpu/perf_event_amd.c
@@ -3,6 +3,8 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 
+#include <asm/apicdef.h>
+
 #include "perf_event.h"
 
 static __initconst const u64 amd_hw_cache_event_ids
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
drivers-block-mtip32xx-mtip32xxc-fix-warning.patch
mm.patch
mm-add-comments-to-explain-mm_struct-fields-fix.patch
vmscan-use-atomic-long-for-shrinker-batching-fix.patch
mm-avoid-null-pointer-access-in-vm_struct-via-proc-vmallocinfo.patch
thp-mremap-support-and-tlb-optimization-fix.patch
thp-mremap-support-and-tlb-optimization-fix-fix.patch
mm-neaten-warn_alloc_failed-fix.patch
debug-pagealloc-add-support-for-highmem-pages-fix.patch
mm-compaction-compact-unevictable-pages-checkpatch-fixes.patch
mm-add-extra-free-kbytes-tunable-update-checkpatch-fixes.patch
mm-add-comment-explaining-task-state-setting-in-bdi_forker_thread-fix.patch
mm-mmapc-eliminate-the-ret-variable-from-mm_take_all_locks-fix.patch
include-linux-securityh-fix-security_inode_init_security-arg.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
sysctl-add-support-for-poll-fix.patch
pps-new-client-driver-using-gpio-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
memstick-add-support-for-legacy-memorysticks-fix.patch
kexec-remove-kmsg_dump_kexec.patch
dio-separate-fields-only-used-in-the-submission-path-from-struct-dio-checkpatch-fixes.patch
dio-inline-the-complete-submission-path-v2-checkpatch-fixes.patch
dio-merge-direct_io_walker-into-__blockdev_direct_io-checkpatch-fixes.patch
dio-optimize-cache-misses-in-the-submission-path-v2-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch
arch-x86-kernel-cpu-perf_event_amdc-needs-asm-apicdefh.patch

