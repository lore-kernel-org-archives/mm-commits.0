From: akpm@osdl.org
Subject: - fix-numaq-build-error.patch removed from -mm tree
Date: Wed, 06 Dec 2006 14:24:23 -0800
Message-ID: <200612062224.kB6MONaI018618@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:48348 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S937739AbWLFWY3 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 6 Dec 2006 17:24:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Fix numaq build error
has been removed from the -mm tree.  Its filename was
     fix-numaq-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix numaq build error
From: Randy Dunlap <randy.dunlap@oracle.com>

  CC      arch/i386/boot/compressed/misc.o
arch/i386/boot/compressed/misc.c:120: error: static declaration of 'xquad_portio' follows non-static declaration
include/asm/io.h:275: error: previous declaration of 'xquad_portio' was here
make[2]: *** [arch/i386/boot/compressed/misc.o] Error 1

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/boot/compressed/misc.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/i386/boot/compressed/misc.c~fix-numaq-build-error arch/i386/boot/compressed/misc.c
--- a/arch/i386/boot/compressed/misc.c~fix-numaq-build-error
+++ a/arch/i386/boot/compressed/misc.c
@@ -196,7 +196,7 @@ static int vidport;
 static int lines, cols;
 
 #ifdef CONFIG_X86_NUMAQ
-static void * xquad_portio = NULL;
+void *xquad_portio;
 #endif
 
 #include "../../../../lib/inflate.c"
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

