From: akpm@linux-foundation.org
Subject: + round_up-macro-cleanup-in-drivers-char-lpc.patch added to -mm tree
Date: Fri, 06 Apr 2007 15:51:11 -0700
Message-ID: <200704062251.l36MpBjx021344@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:36565 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933045AbXDFWvN (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 6 Apr 2007 18:51:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: milindchoudhary@gmail.com


The patch titled
     ROUND_UP macro cleanup in drivers/char/lp.c
has been added to the -mm tree.  Its filename is
     round_up-macro-cleanup-in-drivers-char-lpc.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ROUND_UP macro cleanup in drivers/char/lp.c
From: Milind Arun Choudhary <milindchoudhary@gmail.com>

ROUND_UP macro cleanup use DIV_ROUND_UP

Signed-off-by: Milind Arun Choudhary <milindchoudhary@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/lp.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/char/lp.c~round_up-macro-cleanup-in-drivers-char-lpc drivers/char/lp.c
--- a/drivers/char/lp.c~round_up-macro-cleanup-in-drivers-char-lpc
+++ a/drivers/char/lp.c
@@ -139,9 +139,6 @@
 /* if you have more than 8 printers, remember to increase LP_NO */
 #define LP_NO 8
 
-/* ROUND_UP macro from fs/select.c */
-#define ROUND_UP(x,y) (((x)+(y)-1)/(y))
-
 static struct lp_struct lp_table[LP_NO];
 
 static unsigned int lp_count = 0;
@@ -652,7 +649,7 @@ static int lp_ioctl(struct inode *inode,
 			    (par_timeout.tv_usec < 0)) {
 				return -EINVAL;
 			}
-			to_jiffies = ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
+			to_jiffies = DIV_ROUND_UP(par_timeout.tv_usec, 1000000/HZ);
 			to_jiffies += par_timeout.tv_sec * (long) HZ;
 			if (to_jiffies <= 0) {
 				return -EINVAL;
_

Patches currently in -mm which might be from milindchoudhary@gmail.com are

unused-round_up-name_offset-macro-in-arch-powerpc.patch
round_up-macro-cleanup-in-drivers-parisc.patch
round_up-macro-cleanup-in-drivers-pci.patch
round_up-macro-cleanup-in-drivers-char-lpc.patch
