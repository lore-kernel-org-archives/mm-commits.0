From: akpm@linux-foundation.org
Subject: - pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch removed from -mm tree
Date: Sat, 26 Jul 2008 14:13:28 -0700
Message-ID: <200807262113.m6QLDSGZ019599@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39960 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757520AbYGZVOK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 26 Jul 2008 17:14:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, bjorn.helgaas@hp.com, kkeil@suse.de, mm-commits@vger.kernel.org


The patch titled
     pnp: fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
has been removed from the -mm tree.  Its filename was
     pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pnp: fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y
From: David Howells <dhowells@redhat.com>

Fix the fcpnp_driver declaration to only exist if CONFIG_PNP=y as it's only
accessed in that case.

The PNP=n variant was added by patch 30d55e71a81b1f5a8136f191dc9f4c21f18e77e6.

Fixes an unused variable warning.

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
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
mutex-subsystem-synchro-test-module.patch

