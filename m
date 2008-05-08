From: akpm@linux-foundation.org
Subject: + atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer.patch added to -mm tree
Date: Thu, 08 May 2008 12:51:40 -0700
Message-ID: <200805081951.m48Jpe2Z002690@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46819 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762051AbYEHTwn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 8 May 2008 15:52:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: nicolas.ferre@atmel.com, hskinnemoen@atmel.com, linux@maxim.org.za


The patch titled
     atmel_lcdfb: fix initialization of a pre-allocated framebuffer
has been added to the -mm tree.  Its filename is
     atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer.patch

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
Subject: atmel_lcdfb: fix initialization of a pre-allocated framebuffer
From: Nicolas Ferre <nicolas.ferre@atmel.com>

Fix initialization of framebuffer not calling ioremap_writecombine() function
and not using internal SRAM for at91sam9rl.

This is a little rework of the "Don't initialize a pre-allocated framebuffer"
patch that corrects the call to ioremap_writecombine() function.

It also cuts the use of internal SRAM for at91sam9rl : it is a bit small
for a framebuffer.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Andrew Victor <linux@maxim.org.za>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9261_devices.c |    4 ++--
 arch/arm/mach-at91/at91sam9rl_devices.c  |   21 ---------------------
 2 files changed, 2 insertions(+), 23 deletions(-)

diff -puN arch/arm/mach-at91/at91sam9261_devices.c~atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer arch/arm/mach-at91/at91sam9261_devices.c
--- a/arch/arm/mach-at91/at91sam9261_devices.c~atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer
+++ a/arch/arm/mach-at91/at91sam9261_devices.c
@@ -544,10 +544,10 @@ void __init at91_add_device_lcdc(struct 
 		struct resource *fb_res = &lcdc_resources[2];
 		size_t fb_len = fb_res->end - fb_res->start + 1;
 
-		fb = ioremap_writecombine(fb_res->start, fb_len);
+		fb = ioremap(fb_res->start, fb_len);
 		if (fb) {
 			memset(fb, 0, fb_len);
-			iounmap(fb, fb_len);
+			iounmap(fb);
 		}
 	}
 	lcdc_data = *data;
diff -puN arch/arm/mach-at91/at91sam9rl_devices.c~atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer arch/arm/mach-at91/at91sam9rl_devices.c
--- a/arch/arm/mach-at91/at91sam9rl_devices.c~atmel_lcdfb-fix-initialization-of-a-pre-allocated-framebuffer
+++ a/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -332,13 +332,6 @@ static struct resource lcdc_resources[] 
 		.end	= AT91SAM9RL_ID_LCDC,
 		.flags	= IORESOURCE_IRQ,
 	},
-#if defined(CONFIG_FB_INTSRAM)
-	[2] = {
-		.start	= AT91SAM9RL_SRAM_BASE,
-		.end	= AT91SAM9RL_SRAM_BASE + AT91SAM9RL_SRAM_SIZE - 1,
-		.flags	= IORESOURCE_MEM,
-	},
-#endif
 };
 
 static struct platform_device at91_lcdc_device = {
@@ -381,20 +374,6 @@ void __init at91_add_device_lcdc(struct 
 	at91_set_B_periph(AT91_PIN_PC24, 0);	/* LCDD22 */
 	at91_set_B_periph(AT91_PIN_PC25, 0);	/* LCDD23 */
 
-#ifdef CONFIG_FB_INTSRAM
-	{
-		void __iomem *fb;
-		struct resource *fb_res = &lcdc_resources[2];
-		size_t fb_len = fb_res->end - fb_res->start + 1;
-
-		fb = ioremap_writecombine(fb_res->start, fb_len);
-		if (fb) {
-			memset(fb, 0, fb_len);
-			iounmap(fb, fb_len);
-		}
-	}
-#endif
