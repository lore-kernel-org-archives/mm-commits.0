From: akpm@linux-foundation.org
Subject: [merged] char-isicom-fix-build-warning.patch removed from -mm tree
Date: Thu, 18 Jun 2009 15:47:19 -0700
Message-ID: <200906182247.n5IMlJAr006436@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36529 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759220AbZFRWry (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Jun 2009 18:47:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk, mm-commits@vger.kernel.org


The patch titled
     Char: isicom: fix build warning
has been removed from the -mm tree.  Its filename was
     char-isicom-fix-build-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Char: isicom: fix build warning
From: Jiri Slaby <jirislaby@gmail.com>

Fix this:
isicom.c: In function `isicom_probe':
isicom.c:1587: warning: `signature' may be used uninitialized in this function
by uninitialized_var(), because if the signature is not initialized in
reset_card(), we won't use it.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/isicom.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/char/isicom.c~char-isicom-fix-build-warning drivers/char/isicom.c
--- a/drivers/char/isicom.c~char-isicom-fix-build-warning
+++ a/drivers/char/isicom.c
@@ -1593,7 +1593,7 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int signature, index;
+	unsigned int uninitialized_var(signature), index;
 	int retval = -EPERM;
 	struct isi_board *board = NULL;
 
_

Patches currently in -mm which might be from jirislaby@gmail.com are

origin.patch
char-moxa-prevent-opening-unavailable-ports.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated.patch
dma-mapping-mark-dma_nbits_mask-as-deprecated-fix.patch
linux-next.patch
icom-converting-space-to-tabs.patch
rapidio-fix-kerneldoc-for-rio_mem_ops.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

