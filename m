From: akpm@linux-foundation.org
Subject: + char-isicom-fix-build-warning.patch added to -mm tree
Date: Tue, 07 Apr 2009 13:43:28 -0700
Message-ID: <200904072043.n37KhSrs019279@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52594 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753599AbZDGUpX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Apr 2009 16:45:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, alan@lxorguk.ukuu.org.uk


The patch titled
     Char: isicom: fix build warning
has been added to the -mm tree.  Its filename is
     char-isicom-fix-build-warning.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -1585,7 +1585,7 @@ static unsigned int card_count;
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
linux-next.patch
icom-converting-space-to-tabs.patch
char-isicom-prolong-tty-reference-holding.patch
char-isicom-fix-build-warning.patch
reiser4.patch
shrink_slab-handle-bad-shrinkers.patch

