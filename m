From: akpm@linux-foundation.org
Subject: - sis190-silence-section-type-conflict.patch removed from -mm tree
Date: Sun, 03 Feb 2008 12:22:24 -0800
Message-ID: <200802032022.m13KM5rs029985@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58573 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752076AbYBCUWQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 3 Feb 2008 15:22:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: romieu@fr.zoreil.com, max@stro.at, mm-commits@vger.kernel.org


The patch titled
     sis190: silence section type conflict
has been removed from the -mm tree.  Its filename was
     sis190-silence-section-type-conflict.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: sis190: silence section type conflict
From: Francois Romieu <romieu@fr.zoreil.com>

CC [M]  drivers/net/sis190.o
drivers/net/sis190.c:329: error: sis190_pci_tbl causes a section type conflict
make[5]: *** [drivers/net/sis190.o] Error 1

Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Reported-by: Maximilian Attems <max@stro.at>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/sis190.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/sis190.c~sis190-silence-section-type-conflict drivers/net/sis190.c
--- a/drivers/net/sis190.c~sis190-silence-section-type-conflict
+++ a/drivers/net/sis190.c
@@ -326,7 +326,7 @@ static const struct {
 	{ "SiS 191 PCI Gigabit Ethernet adapter" },
 };
 
-static struct pci_device_id sis190_pci_tbl[] __devinitdata = {
+static struct pci_device_id sis190_pci_tbl[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0190), 0, 0, 0 },
 	{ PCI_DEVICE(PCI_VENDOR_ID_SI, 0x0191), 0, 0, 1 },
 	{ 0, },
_

Patches currently in -mm which might be from romieu@fr.zoreil.com are

origin.patch
