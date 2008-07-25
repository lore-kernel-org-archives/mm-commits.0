From: akpm@linux-foundation.org
Subject: - pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch removed from -mm tree
Date: Fri, 25 Jul 2008 13:54:26 -0700
Message-ID: <200807252054.m6PKsQWv030723@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55826 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750916AbYGYUyw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Jul 2008 16:54:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bjorn.helgaas@hp.com, mm-commits@vger.kernel.org


The patch titled
     pnpacpi: fix pnpacpi_parse_irq_option()'s test against PNP_IRQ_NR
has been removed from the -mm tree.  Its filename was
     pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnpacpi: fix pnpacpi_parse_irq_option()'s test against PNP_IRQ_NR
From: David Howells <dhowells@redhat.com>

Fix the test pnpacpi_parse_irq_option() makes against PNP_IRQ_NR by sticking
p->interrupt[i] into an unsigned int and then using it in the three places
that want it.  This gets rid of the warning:

drivers/pnp/pnpacpi/rsparser.c:500: warning: comparison is always true due to limited range of data type

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Bjorn Helgaas <bjorn.helgaas@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pnp/pnpacpi/rsparser.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr drivers/pnp/pnpacpi/rsparser.c
--- a/drivers/pnp/pnpacpi/rsparser.c~pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr
+++ a/drivers/pnp/pnpacpi/rsparser.c
@@ -517,12 +517,13 @@ static __init void pnpacpi_parse_ext_irq
 	bitmap_zero(map.bits, PNP_IRQ_NR);
 	for (i = 0; i < p->interrupt_count; i++) {
 		if (p->interrupts[i]) {
-			if (p->interrupts[i] < PNP_IRQ_NR)
-				__set_bit(p->interrupts[i], map.bits);
+			unsigned irq = p->interrupts[i];
+			if (irq < PNP_IRQ_NR)
+				__set_bit(irq, map.bits);
 			else
 				dev_err(&dev->dev, "ignoring IRQ %d option "
 					"(too large for %d entry bitmap)\n",
-					p->interrupts[i], PNP_IRQ_NR);
+					irq, PNP_IRQ_NR);
 		}
 	}
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
git-unionfs.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
inflate-refactor-inflate-malloc-code.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
coredump-elf_fdpic_core_dump-use-core_state-dumper-list.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mm-print-swapcache-page-count-in-show_swap_cache_info.patch
lib-generic-show_mem.patch
mn10300-use-generic-show_mem.patch
frv-use-generic-show_mem.patch
mutex-subsystem-synchro-test-module.patch

