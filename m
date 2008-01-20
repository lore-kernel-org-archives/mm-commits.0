From: akpm@linux-foundation.org
Subject: - mm-fix-section-mismatch-warning-in-page_allocc.patch removed from -mm tree
Date: Sat, 19 Jan 2008 23:04:47 -0800
Message-ID: <200801200704.m0K74RgM007805@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36892 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753692AbYATHEn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 20 Jan 2008 02:04:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     mm: fix section mismatch warning in page_alloc.c
has been removed from the -mm tree.  Its filename was
     mm-fix-section-mismatch-warning-in-page_allocc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
rcu-fix-section-mismatch.patch
hrtimer-fix-section-mismatch.patch
timer-fix-section-mismatch.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-kbuild.patch
git-net.patch
git-s390.patch
git-scsi-misc.patch
hostap-section-mismatch-warning.patch
git-x86.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
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
