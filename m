From: akpm@linux-foundation.org
Subject: + pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch added to -mm tree
Date: Sat, 12 Jul 2008 22:16:33 -0700
Message-ID: <200807130516.m6D5GXfK005559@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbYGMFRg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 Jul 2008 01:17:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com, bjorn.helgaas@hp.com, kkeil@suse.de


The patch titled
     pnp: fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
has been added to the -mm tree.  Its filename is
     pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch

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
Subject: pnp: fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
From: David Howells <dhowells@redhat.com>

Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y as it's only
accessed in that case.

The PNP=n variant was added by patch 30d55e71a81b1f5a8136f191dc9f4c21f18e77e6.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Karsten Keil <kkeil@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/isdn/hisax/hisax_fcpcipnp.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN drivers/isdn/hisax/hisax_fcpcipnp.c~pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y drivers/isdn/hisax/hisax_fcpcipnp.c
--- a/drivers/isdn/hisax/hisax_fcpcipnp.c~pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y
+++ a/drivers/isdn/hisax/hisax_fcpcipnp.c
@@ -974,8 +974,6 @@ static struct pnp_driver fcpnp_driver = 
 	.remove		= __devexit_p(fcpnp_remove),
 	.id_table	= fcpnp_ids,
 };
-#else
-static struct pnp_driver fcpnp_driver;
 #endif
 
 static void __devexit fcpci_remove(struct pci_dev *pdev)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
frv-fix-irqs_disabled-to-return-an-int-not-an-unsigned-long.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

