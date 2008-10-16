From: akpm@linux-foundation.org
Subject: + pc8736x_gpio-add-support-for-pc87365-chips.patch added to -mm tree
Date: Thu, 16 Oct 2008 12:07:20 -0700
Message-ID: <200810161907.m9GJ7Ktx004536@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45189 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755931AbYJPTH1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 16 Oct 2008 15:07:27 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: andre@bitwigglers.org, jim.cromie@gmail.com


The patch titled
     pc8736x_gpio: add support for PC87365 chips
has been added to the -mm tree.  Its filename is
     pc8736x_gpio-add-support-for-pc87365-chips.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: pc8736x_gpio: add support for PC87365 chips
From: Andre Haupt <andre@bitwigglers.org>

This is only compile tested, because I do not own appropriate hardware.

Signed-off-by: Andre Haupt <andre@bitwigglers.org>
Cc: Jim Cromie <jim.cromie@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/pc8736x_gpio.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff -puN drivers/char/pc8736x_gpio.c~pc8736x_gpio-add-support-for-pc87365-chips drivers/char/pc8736x_gpio.c
--- a/drivers/char/pc8736x_gpio.c~pc8736x_gpio-add-support-for-pc87365-chips
+++ a/drivers/char/pc8736x_gpio.c
@@ -41,7 +41,8 @@ static u8 pc8736x_gpio_shadow[4];
 #define SIO_BASE2       0x4E	/* alt command-reg to check */
 
 #define SIO_SID		0x20	/* SuperI/O ID Register */
-#define SIO_SID_VALUE	0xe9	/* Expected value in SuperI/O ID Register */
+#define SIO_SID_PC87365	0xe5	/* Expected value in ID Register for PC87365 */
+#define SIO_SID_PC87366	0xe9	/* Expected value in ID Register for PC87366 */
 
 #define SIO_CF1		0x21	/* chip config, bit0 is chip enable */
 
@@ -91,13 +92,17 @@ static inline int superio_inb(int addr)
 
 static int pc8736x_superio_present(void)
 {
+	int id;
+
 	/* try the 2 possible values, read a hardware reg to verify */
 	superio_cmd = SIO_BASE1;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
+	id = superio_inb(SIO_SID);
+	if (id == SIO_SID_PC87365 || id == SIO_SID_PC87366)
 		return superio_cmd;
 
 	superio_cmd = SIO_BASE2;
-	if (superio_inb(SIO_SID) == SIO_SID_VALUE)
+	id = superio_inb(SIO_SID);
+	if (id == SIO_SID_PC87365 || id == SIO_SID_PC87366)
 		return superio_cmd;
 
 	return 0;
_

Patches currently in -mm which might be from andre@bitwigglers.org are

pc8736x_gpio-add-support-for-pc87365-chips.patch

