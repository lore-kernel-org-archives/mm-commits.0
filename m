From: akpm@linux-foundation.org
Subject: - pc8736x_gpio-add-support-for-pc87365-chips.patch removed from -mm tree
Date: Mon, 20 Oct 2008 13:37:20 -0700
Message-ID: <200810202037.m9KKbK2R011585@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33731 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657AbYJTUiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 20 Oct 2008 16:38:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andre@bitwigglers.org, jim.cromie@gmail.com, mm-commits@vger.kernel.org


The patch titled
     pc8736x_gpio: add support for PC87365 chips
has been removed from the -mm tree.  Its filename was
     pc8736x_gpio-add-support-for-pc87365-chips.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

