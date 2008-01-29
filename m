From: akpm@linux-foundation.org
Subject: + sis190-silence-section-type-conflict.patch added to -mm tree
Date: Tue, 29 Jan 2008 14:59:14 -0800
Message-ID: <200801292259.m0TMxE56008750@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51536 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753819AbYA2W7c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jan 2008 17:59:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: romieu@fr.zoreil.com, max@stro.at


The patch titled
     sis190: silence section type conflict
has been added to the -mm tree.  Its filename is
     sis190-silence-section-type-conflict.patch

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

git-net.patch
sis190-silence-section-type-conflict.patch
