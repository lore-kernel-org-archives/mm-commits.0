From: akpm@linux-foundation.org
Subject: + headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch added to -mm tree
Date: Thu, 30 Apr 2009 22:13:26 -0700
Message-ID: <200905010513.n415DQt0027141@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54380 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750778AbZEAFPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 1 May 2009 01:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, knikanth@novell.com, rusty@rustcorp.com.au


The patch titled
     headers: move module_bug_finalize()/module_bug_cleanup() definitions into module.h
has been added to the -mm tree.  Its filename is
     headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch

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
Subject: headers: move module_bug_finalize()/module_bug_cleanup() definitions into module.h
From: Andrew Morton <akpm@linux-foundation.org>

They're in linux/bug.h at present, which causes include order tangles.  In
particular, linux/bug.h cannot be used by linux/atomic.h because,
according to Nikanth:

linux/bug.h pulls in linux/module.h => linux/spinlock.h => asm/spinlock.h
(which uses atomic_inc) => asm/atomic.h.

bug.h is a pretty low-level thing and module.h is a higher-level thing,
IMO.

Cc: Nikanth Karthikesan <knikanth@novell.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/bug.h    |   12 ------------
 include/linux/module.h |   17 +++++++++++++++++
 2 files changed, 17 insertions(+), 12 deletions(-)

diff -puN include/linux/bug.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh include/linux/bug.h
--- a/include/linux/bug.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh
+++ a/include/linux/bug.h
@@ -1,7 +1,6 @@
 #ifndef _LINUX_BUG_H
 #define _LINUX_BUG_H
 
-#include <linux/module.h>
 #include <asm/bug.h>
 
 enum bug_trap_type {
@@ -24,10 +23,6 @@ const struct bug_entry *find_bug(unsigne
 
 enum bug_trap_type report_bug(unsigned long bug_addr, struct pt_regs *regs);
 
-int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
-			 struct module *);
-void module_bug_cleanup(struct module *);
-
 /* These are defined by the architecture */
 int is_valid_bugaddr(unsigned long addr);
 
@@ -38,13 +33,6 @@ static inline enum bug_trap_type report_
 {
 	return BUG_TRAP_TYPE_BUG;
 }
-static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
-					const Elf_Shdr *sechdrs,
-					struct module *mod)
-{
-	return 0;
-}
-static inline void module_bug_cleanup(struct module *mod) {}
 
 #endif	/* CONFIG_GENERIC_BUG */
 #endif	/* _LINUX_BUG_H */
diff -puN include/linux/module.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh include/linux/module.h
--- a/include/linux/module.h~headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh
+++ a/include/linux/module.h
@@ -696,4 +696,21 @@ static inline void module_remove_modinfo
 
 #define __MODULE_STRING(x) __stringify(x)
 
+
+#ifdef CONFIG_GENERIC_BUG
+int  module_bug_finalize(const Elf_Ehdr *, const Elf_Shdr *,
+			 struct module *);
+void module_bug_cleanup(struct module *);
+
+#else	/* !CONFIG_GENERIC_BUG */
+
+static inline int  module_bug_finalize(const Elf_Ehdr *hdr,
+					const Elf_Shdr *sechdrs,
+					struct module *mod)
+{
+	return 0;
+}
+static inline void module_bug_cleanup(struct module *mod) {}
+#endif	/* CONFIG_GENERIC_BUG */
+
 #endif /* _LINUX_MODULE_H */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-close-page_mkwrite-races-try-3.patch
vmscan-avoid-multiplication-overflow-in-shrink_zone.patch
i2c-too-much-compiler-noise.patch
linux-next.patch
next-remove-localversion.patch
dmar-stupid-hack.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
arch-x86-kernel-apic-io_apicc-conditionally-compile-eoi_ioapic_irq.patch
drivers-gpu-drm-i915-intel_fbc-remove-sysrq-g-handler.patch
dvb-core-fix-potential-mutex_unlock-without-mutex_lock-in-dvb_dvr_read-fix.patch
input-keyboard-introduce-lm8323-driver.patch
drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-checkpatch-fixes.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality-checkpatch-fixes.patch
mtd-flex-onenand-support.patch
mtd-fix-timeout-in-m25p80-driver-fix.patch
misdn-l1oip-reduce-stack-memory-footprint.patch
drivers-net-82596c-suppress-warnings.patch
forcedeth-add-clock-gating-feature-checkpatch-fixes.patch
pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets-v2.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
eliminate-thousands-of-warnings-with-gcc-32-build-cleanup.patch
scsi-dpt_i2o-is-bust-on-ia64.patch
leds-of_register_platform_driver-doesnt-exist-on-sparc64.patch
squashfs-fix-breakage-when-pagesize-blocksize-checkpatch-fixes.patch
mm-consolidate-init_mm-definition-fix.patch
readahead-record-mmap-read-around-states-in-file_ra_state-checkpatch-fixes.patch
mm-clean-up-get_user_pages_fast-documentation-checkpatch-fixes.patch
ksm-add-get_pte-helper-function-fetching-pte-for-va-fix.patch
ksm-add-ksm-kernel-shared-memory-driver-checkpatch-fixes.patch
ksm-add-ksm-kernel-shared-memory-driver-borked-on-non-x86.patch
page-allocator-do-not-sanity-check-order-in-the-fast-path-fix.patch
page-allocator-calculate-the-preferred-zone-for-allocation-only-once-fix.patch
page-allocator-remove-a-branch-by-assuming-__gfp_high-==-alloc_high.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch
rb_tree-reorganize-code-in-rb_erase-for-additional-changes-checkpatch-fixes.patch
flat-fix-data-sections-alignment.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
mutex-add-atomic_dec_and_mutex_lock-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
shrink_slab-handle-bad-shrinkers.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

