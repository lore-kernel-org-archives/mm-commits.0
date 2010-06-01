From: akpm@linux-foundation.org
Subject: + input-remove-references-to-obsolete-config_spruce.patch added to -mm tree
Date: Tue, 01 Jun 2010 13:40:32 -0700
Message-ID: <201006012040.o51KeWuD017162@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46707 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753089Ab0FAUkt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 1 Jun 2010 16:40:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: siccegge@cs.fau.de, dtor@mail.ru


The patch titled
     input: remove references to obsolete CONFIG_SPRUCE
has been added to the -mm tree.  Its filename is
     input-remove-references-to-obsolete-config_spruce.patch

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
Subject: input: remove references to obsolete CONFIG_SPRUCE
From: Christoph Egger <siccegge@cs.fau.de>

CONFIG_SPRUCE was removed from kernel around 2.6.26. Last piece of
relevant code that is still in linux' source tree will be removed by
this patch.

Signed-off-by: Christoph Egger <siccegge@cs.fau.de>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/serio/i8042-ppcio.h |   75 ----------------------------
 1 file changed, 75 deletions(-)

diff -puN drivers/input/serio/i8042-ppcio.h~input-remove-references-to-obsolete-config_spruce drivers/input/serio/i8042-ppcio.h
--- a/drivers/input/serio/i8042-ppcio.h~input-remove-references-to-obsolete-config_spruce
+++ a/drivers/input/serio/i8042-ppcio.h
@@ -52,81 +52,6 @@ static inline void i8042_platform_exit(v
 {
 }
 
-#elif defined(CONFIG_SPRUCE)
-
-#define I8042_KBD_IRQ 22
-#define I8042_AUX_IRQ 21
-
-#define I8042_KBD_PHYS_DESC "spruceps2/serio0"
-#define I8042_AUX_PHYS_DESC "spruceps2/serio1"
-#define I8042_MUX_PHYS_DESC "spruceps2/serio%d"
-
-#define I8042_COMMAND_REG 0xff810000
-#define I8042_DATA_REG 0xff810001
-
-static inline int i8042_read_data(void)
-{
-	unsigned long kbd_data;
-
-	__raw_writel(0x00000088, 0xff500008);
-	eieio();
-
-	__raw_writel(0x03000000, 0xff50000c);
-	eieio();
-
-	asm volatile("lis     7,0xff88        \n\
-		      lswi    6,7,0x8         \n\
-		      mr      %0,6"
-	              : "=r" (kbd_data) :: "6", "7");
-
-	__raw_writel(0x00000000, 0xff50000c);
-	eieio();
-
-	return (unsigned char)(kbd_data >> 24);
-}
-
-static inline int i8042_read_status(void)
-{
-	unsigned long kbd_status;
-
-	__raw_writel(0x00000088, 0xff500008);
-	eieio();
-
-	__raw_writel(0x03000000, 0xff50000c);
-	eieio();
-
-	asm volatile("lis     7,0xff88        \n\
-		      ori     7,7,0x8         \n\
-		      lswi    6,7,0x8         \n\
-		      mr      %0,6"
-		      : "=r" (kbd_status) :: "6", "7");
-
-	__raw_writel(0x00000000, 0xff50000c);
-	eieio();
-
-	return (unsigned char)(kbd_status >> 24);
-}
-
-static inline void i8042_write_data(int val)
-{
-	*((unsigned char *)0xff810000) = (char)val;
-}
-
-static inline void i8042_write_command(int val)
-{
-	*((unsigned char *)0xff810001) = (char)val;
-}
-
-static inline int i8042_platform_init(void)
-{
-	i8042_reset = 1;
-	return 0;
-}
-
-static inline void i8042_platform_exit(void)
-{
-}
