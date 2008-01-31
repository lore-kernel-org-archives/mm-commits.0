From: akpm@linux-foundation.org
Subject: + mm-fix-section-mismatch-warning-in-sparsec.patch added to -mm tree
Date: Thu, 31 Jan 2008 14:45:41 -0800
Message-ID: <200801312245.m0VMjffa015203@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51737 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762197AbYAaWqI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 31 Jan 2008 17:46:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sam@ravnborg.org, apw@shadowen.org, clameter@sgi.com, mel@csn.ul.ie


The patch titled
     mm: fix section mismatch warning in sparse.c
has been added to the -mm tree.  Its filename is
     mm-fix-section-mismatch-warning-in-sparsec.patch

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
Subject: mm: fix section mismatch warning in sparse.c
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: mm/built-in.o(.text+0x22069): Section mismatch in reference from the function sparse_early_usemap_alloc() to the function .init.text:__alloc_bootmem_node()

static sparse_early_usemap_alloc() were used only by sparse_init()
and with sparse_init() annotated _init it is safe to
annotate sparse_early_usemap_alloc with __init too.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/sparse.c~mm-fix-section-mismatch-warning-in-sparsec mm/sparse.c
--- a/mm/sparse.c~mm-fix-section-mismatch-warning-in-sparsec
+++ a/mm/sparse.c
@@ -237,7 +237,7 @@ static unsigned long *__kmalloc_section_
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
 
-static unsigned long *sparse_early_usemap_alloc(unsigned long pnum)
+static unsigned long *__init sparse_early_usemap_alloc(unsigned long pnum)
 {
 	unsigned long *usemap;
 	struct mem_section *ms = __nr_to_section(pnum);
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
sdio-fix-module-device-table-definition-for-m68k.patch
git-kbuild.patch
git-kbuild-fixup.patch
git-net.patch
hamradio-fix-dmascc-section-mismatch.patch
git-x86.patch
gpiolib-add-drivers-gpio-directory.patch
gpiolib-add-gpio-provider-infrastructure.patch
gpiolib-update-documentation-gpiotxt.patch
gpiolib-pxa-platform-support.patch
gpiolib-pcf857x-i2c-gpio-expander-support.patch
gpiolib-mcp23s08-spi-gpio-expander-support.patch
gpiolib-pca9539-i2c-gpio-expander-support.patch
gpiolib-deprecate-obsolete-pca9539-driver.patch
gpiolib-avr32-at32ap-platform-support.patch
m68k-use-cc-cross-prefix.patch
cris-avoid-using-arch-links-in-kconfig.patch
uml-remove-topdir.patch
remove-support-for-un-needed-_extratext-section.patch
remove-support-for-un-needed-_extratext-section-checkpatch-fixes.patch
kallsyms-should-prefer-non-weak-symbols.patch
kallsyms-should-prefer-non-weak-symbols-checkpatch-fixes.patch
tpm-infineon-section-mismatch.patch
create-arch-kconfig.patch
add-have_oprofile.patch
add-have_kprobes.patch
linux-kernel-markers-create-modpost-file.patch
linux-typesh-always-export-64bit-aligned-defines.patch
avoid-overflows-in-kernel-timec.patch
remove-__init_refok-and-__initdata_refok.patch
pci-fix-section-mismatch-warnings-referring-to-pci_do_scan_bus.patch
pci-fix-4x-section-mismatch-warnings.patch
cpu-fix-section-mismatch-warnings-for-enable_nonboot_cpus.patch
cpu-fix-section-mismatch-related-to-cpu_chain.patch
cpu-do-not-annotate-exported-register_cpu_notifier.patch
cpu-silence-section-mismatch-warnings-for-hotcpu-notifies.patch
mm-fix-section-mismatch-warning-in-sparsec.patch
