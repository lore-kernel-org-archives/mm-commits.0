From: akpm@linux-foundation.org
Subject: [merged] headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:16 -0700
Message-ID: <200906171837.n5HIbG4k003313@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35000 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760586AbZFQSiH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:38:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, knikanth@novell.com, rusty@rustcorp.com.au, mm-commits@vger.kernel.org


The patch titled
     headers: move module_bug_finalize()/module_bug_cleanup() definitions into module.h
has been removed from the -mm tree.  Its filename was
     headers-move-module_bug_finalize-module_bug_cleanup-definitions-into-moduleh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -697,4 +697,21 @@ static inline void module_remove_modinfo
 
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

origin.patch
documentation-vm-makefile-dont-try-to-build-slqbinfo.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-x86-kernel-cpu-cpufreq-acpi-cpufreqc-avoid-cross-cpu-interrupts.patch
devres-warn-and-return-dont-crash-on-device_del-of-uninitialized-device.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
input-documentation-input-xpadtxt-update-for-new-driver-functionality.patch
3x59x-fix-pci-resource-management-checkpatch-fixes.patch
jsm-clean-up-serial-jsm-correctly-support-4-8-port-boards.patch
raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic.patch
libfs-make-simple_read_from_buffer-conventional.patch
maintainers-fbdev-is-orphaned.patch
drivers-rtc-rtc-cmosc-cmos_init-dont-ignore-pnp_register_driver-return-value.patch
readahead-add-blk_run_backing_dev-fix.patch
readahead-add-blk_run_backing_dev-fix-fix-2.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
m68k-count-can-reach-51-not-50.patch
arch-m68k-include-asm-motorola_pgalloch-fix-kunmap-arg.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes.patch
gpio-pca953x-get-platform_data-from-openfirmware-checkpatch-fixes-gpio-pca953x-get-platform_data-from-openfirmware-cleanups.patch
documentation-changes-perl-is-needed-to-build-the-kernel-fix.patch
cgroups-forbid-noprefix-if-mounting-more-than-just-cpuset-subsystem-fix.patch
drivers-char-memc-memory_open-cleanup-lookup-minor-device-number-from-devlist-checkpatch-fixes.patch
char-moxa-prevent-opening-unavailable-ports.patch
edac-add-cpc925-memory-controller-driver-cleanup.patch
edac-add-edac_device_alloc_index-cleanup.patch
edac-kconfig-fix-the-meaning-of-edac-abbreviation-fix.patch
kexec-sysrq-simplify-sysrq-c-handler.patch
gru-support-for-asynchronous-gru-instructions-fix.patch
lib-add-lib-gcdc-fix.patch
lib-add-lib-gcdc-fix-fix.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc-fix.patch
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

