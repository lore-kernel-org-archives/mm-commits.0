From: akpm@linux-foundation.org
Subject: - atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer.patch removed from -mm tree
Date: Mon, 28 Apr 2008 14:58:35 -0700
Message-ID: <200804282158.m3SLwZ9S018504@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45517 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965372AbYD1V6z (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 28 Apr 2008 17:58:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hskinnemoen@atmel.com, adaplas@pol.net, andrew@sanpeople.com, nicolas.ferre@rfo.atmel.com, mm-commits@vger.kernel.org


The patch titled
     atmel_lcdfb: don't initialize a pre-allocated framebuffer
has been removed from the -mm tree.  Its filename was
     atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atmel_lcdfb: don't initialize a pre-allocated framebuffer
From: Haavard Skinnemoen <hskinnemoen@atmel.com>

If the user specified a fixed framebuffer address on the command line, it may
have been initialized already with a splash image or something, so we
shouldn't clear it.

Therefore, we should only initialize the framebuffer if we allocated it
ourselves.  This patch also updates the AVR32 setup code to clear the
framebuffer if it allocated it itself, i.e.  the user didn't provide a fixed
address or the reservation failed.

I've updated the at91 platform code as well so that it initializes the
framebuffer if it is located in SRAM, but I haven't tested that it actually
works.

Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: "Antonino A. Daplas" <adaplas@pol.net>
Cc: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>
Cc: Andrew Victor <andrew@sanpeople.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mach-at91/at91sam9261_devices.c |   11 +++++++++++
 arch/arm/mach-at91/at91sam9rl_devices.c  |   14 ++++++++++++++
 arch/avr32/kernel/setup.c                |    2 ++
 drivers/video/atmel_lcdfb.c              |    8 +++++++-
 4 files changed, 34 insertions(+), 1 deletion(-)

diff -puN arch/arm/mach-at91/at91sam9261_devices.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer arch/arm/mach-at91/at91sam9261_devices.c
--- a/arch/arm/mach-at91/at91sam9261_devices.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer
+++ a/arch/arm/mach-at91/at91sam9261_devices.c
@@ -539,6 +539,17 @@ void __init at91_add_device_lcdc(struct 
 	at91_set_B_periph(AT91_PIN_PB28, 0);	/* LCDD23 */
 #endif
 
+	if (ARRAY_SIZE(lcdc_resources) > 2) {
+		void __iomem *fb;
+		struct resource *fb_res = &lcdc_resources[2];
+		size_t fb_len = fb_res->end - fb_res->start + 1;
+
+		fb = ioremap_writecombine(fb_res->start, fb_len);
+		if (fb) {
+			memset(fb, 0, fb_len);
+			iounmap(fb, fb_len);
+		}
+	}
 	lcdc_data = *data;
 	platform_device_register(&at91_lcdc_device);
 }
diff -puN arch/arm/mach-at91/at91sam9rl_devices.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer arch/arm/mach-at91/at91sam9rl_devices.c
--- a/arch/arm/mach-at91/at91sam9rl_devices.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer
+++ a/arch/arm/mach-at91/at91sam9rl_devices.c
@@ -381,6 +381,20 @@ void __init at91_add_device_lcdc(struct 
 	at91_set_B_periph(AT91_PIN_PC24, 0);	/* LCDD22 */
 	at91_set_B_periph(AT91_PIN_PC25, 0);	/* LCDD23 */
 
+#ifdef CONFIG_FB_INTSRAM
+	{
+		void __iomem *fb;
+		struct resource *fb_res = &lcdc_resources[2];
+		size_t fb_len = fb_res->end - fb_res->start + 1;
+
+		fb = ioremap_writecombine(fb_res->start, fb_len);
+		if (fb) {
+			memset(fb, 0, fb_len);
+			iounmap(fb, fb_len);
+		}
+	}
+#endif
+
 	lcdc_data = *data;
 	platform_device_register(&at91_lcdc_device);
 }
diff -puN arch/avr32/kernel/setup.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer arch/avr32/kernel/setup.c
--- a/arch/avr32/kernel/setup.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer
+++ a/arch/avr32/kernel/setup.c
@@ -274,6 +274,8 @@ static int __init early_parse_fbmem(char
 			printk(KERN_WARNING
 			       "Failed to allocate framebuffer memory\n");
 			fbmem_size = 0;
+		} else {
+			memset(__va(fbmem_start), 0, fbmem_size);
 		}
 	}
 
diff -puN drivers/video/atmel_lcdfb.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer drivers/video/atmel_lcdfb.c
--- a/drivers/video/atmel_lcdfb.c~atmel_lcdfb-dont-initialize-a-pre-allocated-framebuffer
+++ a/drivers/video/atmel_lcdfb.c
@@ -250,6 +250,8 @@ static int atmel_lcdfb_alloc_video_memor
 		return -ENOMEM;
 	}
 
+	memset(info->screen_base, 0, info->fix.smem_len);
+
 	return 0;
 }
 
@@ -634,7 +636,6 @@ static int __init atmel_lcdfb_init_fbinf
 	struct fb_info *info = sinfo->info;
 	int ret = 0;
 
-	memset_io(info->screen_base, 0, info->fix.smem_len);
 	info->var.activate |= FB_ACTIVATE_FORCE | FB_ACTIVATE_NOW;
 
 	dev_info(info->device,
@@ -764,6 +765,11 @@ static int __init atmel_lcdfb_probe(stru
 		info->screen_base = ioremap(info->fix.smem_start, info->fix.smem_len);
 		if (!info->screen_base)
 			goto release_intmem;
+
+		/*
+		 * Don't clear the framebuffer -- someone may have set
+		 * up a splash image.
+		 */
 	} else {
 		/* alocate memory buffer */
 		ret = atmel_lcdfb_alloc_video_memory(sinfo);
_

Patches currently in -mm which might be from hskinnemoen@atmel.com are

origin.patch
taint-kernel-after-warn_oncondition.patch
proc-introduce-proc_create_data-to-setup-de-data.patch
avr32-proc-use-non-racy-method-for-proc-tlb-creation.patch
add-kbuildh-that-contains-common-definitions-for-kbuild-users.patch
avr32-use-kbuildh-macros-instead-of-defining-macros-in-asm-offsetsc.patch

