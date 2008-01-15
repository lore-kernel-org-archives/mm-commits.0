From: akpm@linux-foundation.org
Subject: + mm-fix-section-mismatch-warning-in-page_allocc.patch added to -mm tree
Date: Tue, 15 Jan 2008 14:38:15 -0800
Message-ID: <200801152238.m0FMcFrS007017@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751469AbYAOWir (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 15 Jan 2008 17:38:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, mingo@elte.hu


The patch titled
     mm: fix section mismatch warning in page_alloc.c
has been added to the -mm tree.  Its filename is
     mm-fix-section-mismatch-warning-in-page_allocc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: fix section mismatch warning in page_alloc.c
From: Sam Ravnborg <sam@ravnborg.org>

With CONFIG_HOTPLUG=n and CONFIG_HOTPLUG_CPU=y we saw
following warning:
WARNING: mm/built-in.o(.text+0x6864): Section mismatch: reference to .init.text: (between 'process_zones' and 'pageset_cpuup_callback')

The culprit was zone_batchsize() which were annotated __devinit but used
from process_zones() which is annotated __cpuinit.  zone_batchsize() are
used from another function annotated __meminit so the only valid option is
to drop the annotation of zone_batchsize() so we know it is always valid to
use it.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/page_alloc.c~mm-fix-section-mismatch-warning-in-page_allocc mm/page_alloc.c
--- a/mm/page_alloc.c~mm-fix-section-mismatch-warning-in-page_allocc
+++ a/mm/page_alloc.c
@@ -2566,7 +2566,7 @@ static void __meminit zone_init_free_lis
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __devinit zone_batchsize(struct zone *zone)
+static int zone_batchsize(struct zone *zone)
 {
 	int batch;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

scsi-qla2xxx-qla_osc-section-fix.patch
cciss-section-mismatch.patch
cris-v10-vmlinuxldss-fix-kernel-oops-on-boot-and-use-common-defines.patch
mm-fix-section-mismatch-warning-in-page_allocc.patch
sdio-fix-module-device-table-definition-for-m68k.patch
driver-core-build-with-sysfs=n.patch
sysfs-make-sysfs_deprecated-depend-on-sysfs.patch
git-kbuild.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
megaraid-fix-section-mismatch.patch
hostap-section-mismatch-warning.patch
git-x86.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
avoid-overflows-in-kernel-timec.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
move-kconfiginstrumentation-to-arch-kconfig-and-init-kconfig.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
linux-kernel-markers-create-modpost-file.patch
