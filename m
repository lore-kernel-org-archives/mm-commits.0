From: akpm@linux-foundation.org
Subject: + unicode-diacritics-support-s390-fix.patch added to -mm tree
Date: Wed, 15 Aug 2007 12:46:12 -0700
Message-ID: <200708151946.l7FJkCcU011929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32803 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751877AbXHOTrF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 15 Aug 2007 15:47:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: samuel.thibault@ens-lyon.org, adaplas@pol.net, bunk@stusta.de, dwmw2@infradead.org, heiko.carstens@de.ibm.com, jengelh@gmx.de, schwidefsky@de.ibm.com


The patch titled
     unicode-diacritics-support s390 fix
has been added to the -mm tree.  Its filename is
     unicode-diacritics-support-s390-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: unicode-diacritics-support s390 fix
From: Samuel Thibault <samuel.thibault@ens-lyon.org>

Turn the kernel accent_table into unicode, and extend ioctls KDGKBDIACR and
KDSKBDIACR into their equivalents KDGKBDIACRUC and KDSKBDIACR.

New function int conv_uni_to_8bit(u32 uni) for converting unicode into 8bit
_input_.  No, we don't want to store the translation, as it is potentially
sparse and large.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
Cc: Jan Engelhardt <jengelh@gmx.de>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Adrian Bunk <bunk@stusta.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/char/keyboard.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/s390/char/keyboard.c~unicode-diacritics-support-s390-fix drivers/s390/char/keyboard.c
--- a/drivers/s390/char/keyboard.c~unicode-diacritics-support-s390-fix
+++ a/drivers/s390/char/keyboard.c
@@ -489,9 +489,9 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 		if (put_user(kbd->accent_table_size, &a->kb_cnt))
 			return -EFAULT;
 		for (i = 0; i < kbd->accent_table_size; i++) {
-			diacr.diacr = conv_uni_to_8bit(kbd->accent_table[i].diacr);
-			diacr.base = conv_uni_to_8bit(kbd->accent_table[i].base);
-			diacr.result = conv_uni_to_8bit(kbd->accent_table[i].result);
+			diacr.diacr = kbd->accent_table[i].diacr;
+			diacr.base = kbd->accent_table[i].base;
+			diacr.result = kbd->accent_table[i].result;
 			if (copy_to_user(a->kbdiacr + i, &diacr, sizeof(struct kbdiacr)))
 			return -EFAULT;
 		}
@@ -525,9 +525,9 @@ kbd_ioctl(struct kbd_data *kbd, struct f
 		for (i = 0; i < ct; i++) {
 			if (copy_from_user(&diacr, a->kbdiacr + i, sizeof(struct kbdiacr)))
 				return -EFAULT;
-			kbd->accent_table[i].diacr = conv_8bit_to_uni(diacr.diacr);
-			kbd->accent_table[i].base = conv_8bit_to_uni(diacr.base);
-			kbd->accent_table[i].result = conv_8bit_to_uni(diacr.result);
+			kbd->accent_table[i].diacr = diacr.diacr;
+			kbd->accent_table[i].base = diacr.base;
+			kbd->accent_table[i].result = diacr.result;
 		}
 		return 0;
 	}
_

Patches currently in -mm which might be from samuel.thibault@ens-lyon.org are

unicode-diacritics-support.patch
unicode-diacritics-support-s390-fix.patch
