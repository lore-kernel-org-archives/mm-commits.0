From: akpm@linux-foundation.org
Subject: + stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes.patch added to -mm tree
Date: Tue, 04 Oct 2011 14:06:24 -0700
Message-ID: <201110042106.p94L6Pea022601@wpaz21.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:25019 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab1JDVGn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Oct 2011 17:06:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, hpa@linux.intel.com, jeremy.fitzhardinge@citrix.com


The patch titled
     Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes

Cc: H. Peter Anvin <hpa@linux.intel.com>

ERROR: do not initialise statics to 0 or NULL
#39: FILE: kernel/stop_machine.c:44:
+static bool stop_machine_initialized = false;

ERROR: code indent should use tabs where possible
#61: FILE: kernel/stop_machine.c:496:
+ ^I^Iunsigned long flags;$

WARNING: please, no space before tabs
#61: FILE: kernel/stop_machine.c:496:
+ ^I^Iunsigned long flags;$

WARNING: please, no spaces at the start of a line
#61: FILE: kernel/stop_machine.c:496:
+ ^I^Iunsigned long flags;$

total: 2 errors, 2 warnings, 39 lines checked

NOTE: whitespace errors detected, you may wish to use scripts/cleanpatch or
      scripts/cleanfile

./patches/stop_machine-make-stop_machine-safe-and-efficient-to-call-early.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/stop_machine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes kernel/stop_machine.c
--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes
+++ a/kernel/stop_machine.c
@@ -493,7 +493,7 @@ int __stop_machine(int (*fn)(void *), vo
 		 * Handle the case where stop_machine() is called early in boot
 		 * before SMP startup.
 		 */
- 		unsigned long flags;
+		unsigned long flags;
 		int ret;
 
 		WARN_ON_ONCE(smdata.num_threads != 1);
_
Subject: Subject: stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
include-linux-dmarh-forward-declare-struct-acpi_dmar_header.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-driver.patch
mrst-battery-fixes-fix.patch
drivers-message-fusion-mptbasec-ensure-nul-termination-of-mptcallbacksname-elements.patch
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
stop_machine-make-stop_machine-safe-and-efficient-to-call-early-checkpatch-fixes.patch
dynamic_debug-consolidate-repetitive-struct-_ddebug-descriptor-definitions.patch
dynamic_debug-use-a-single-printk-to-emit-messages.patch
treewide-use-__printf-not-__attribute__formatprintf-checkpatch-fixes.patch
fs-nameic-remove-unused-getname_flags.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
leds-route-kbd-leds-through-the-generic-leds-layer-fix.patch
lib-bitmapc-quiet-sparse-noise-about-address-space-fix.patch
llist-return-whether-list-is-empty-before-adding-in-llist_add-fix.patch
lib-crc-add-slice-by-8-algorithm-to-crc32c-fix.patch
cgroups-create-a-workqueue-for-cgroup-fix.patch
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

