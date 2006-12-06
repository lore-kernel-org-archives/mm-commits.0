From: akpm@osdl.org
Subject: - make-i386-default-to-highmem4g-instead-of-nohighmem.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:11 -0800
Message-ID: <200612062224.kB6MOBgK018594@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48319 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937737AbWLFWYS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     Make ix86 default to HIGHMEM4G instead of NOHIGHMEM
has been removed from the -mm tree.  Its filename was
     make-i386-default-to-highmem4g-instead-of-nohighmem.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Make ix86 default to HIGHMEM4G instead of NOHIGHMEM
From: Randy Dunlap <randy.dunlap@oracle.com>

Generally better for allmodconfig coverage.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/i386/Kconfig~make-i386-default-to-highmem4g-instead-of-nohighmem arch/i386/Kconfig
--- a/arch/i386/Kconfig~make-i386-default-to-highmem4g-instead-of-nohighmem
+++ a/arch/i386/Kconfig
@@ -454,7 +454,8 @@ source "drivers/firmware/Kconfig"
 
 choice
 	prompt "High Memory Support"
-	default NOHIGHMEM
+	default HIGHMEM4G if !X86_NUMAQ
+	default HIGHMEM64G if X86_NUMAQ
 
 config NOHIGHMEM
 	bool "off"
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-acpi.patch
git-alsa.patch
alsa-add-struct-forward-declaration.patch
cpufreq-select-consistently-re-2619-rc5-mm1.patch
git-gfs2-nmw.patch
git-ieee1394.patch
git-input.patch
git-mtd.patch
mtd-esb2rom-uses-pci.patch
parisc-fix-module_param-iommu-permission.patch
scsi-advansys-wrap-pci-table-inside-ifdef-config_pci.patch
fuse-fix-compile-without-config_block.patch
tifm-fix-null-ptr-and-style.patch
kconfig-printk_time-depends-on-printk.patch
hpfs-fix-printk-format-warnings.patch
declare-smp_call_function_single-in-generic-code.patch
i2o-handle-__copy_from_user.patch
i2o-fix-i2o_config-without-adaptec-extension.patch
parport-section-mismatches-with-hotplug=n.patch
agp-amd64-section-mismatches-with-hotplug=n.patch
ciss-require-same-scsi-module-support.patch
export-toshiba-smm-support-for-neofb-module.patch
kernel-doc-add-fusion-and-i2o-to-kernel-api-book.patch
kernel-doc-fix-fusion-and-i2o-docs.patch
kernel-api-book-remove-videodev-chapter.patch
kernel-doc-stricter-function-pointer-recognition.patch
reporting-bugs-request-config-file.patch
lib-functions-always-build-hweight-for-loadable-modules.patch
ipmi-fix-proc_fs=n-warnings.patch
generic-bug-implementation-handle-bug=n.patch
reiser4-use-null-for-pointers.patch
visws-sgivwfb-is-module-needs-exports.patch
linux-fbdev-devel-is-subscribers-only.patch
extend-notifier_call_chain-to-count-nr_calls-made-fixes.patch
kvm-fix-null-and-c99-init-sparse-warnings.patch
profile_likely-export-do_check_likely.patch

