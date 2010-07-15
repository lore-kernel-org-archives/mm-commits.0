From: akpm@linux-foundation.org
Subject: + drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update.patch added to -mm tree
Date: Thu, 15 Jul 2010 13:34:19 -0700
Message-ID: <201007152034.o6FKYJlV017741@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44193 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934652Ab0GOUe5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Jul 2010 16:34:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: masa-korg@dsn.okisemi.com, arnd@arndb.de, greg@kroah.com


The patch titled
     drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update
has been added to the -mm tree.  Its filename is
     drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update.patch

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
Subject: drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update
From: Masayuki Ohtak <masa-korg@dsn.okisemi.com>

Signed-off-by: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pch_phub/pch_phub.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff -puN drivers/char/pch_phub/pch_phub.c~drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update drivers/char/pch_phub/pch_phub.c
--- a/drivers/char/pch_phub/pch_phub.c~drivers-char-add-packet-hub-driver-for-the-topcliff-pch-update
+++ a/drivers/char/pch_phub/pch_phub.c
@@ -470,6 +470,10 @@ static ssize_t pch_phub_write(struct fil
 	}
 
 	for (addr_offset = 0; addr_offset < size; addr_offset++) {
+		if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
+			*ppos += addr_offset;
+			goto return_ok;
+		}
 		ret_value1 = get_user(data, &buf[addr_offset]);
 		if (ret_value1) {
 			err = -EFAULT;
@@ -482,12 +486,6 @@ static ssize_t pch_phub_write(struct fil
 			err = ret_value2;
 			goto return_err;
 		}
-
-		if (PCH_PHUB_OROM_SIZE < pos + addr_offset) {
-			*ppos += addr_offset;
-			goto return_ok;
-		}
