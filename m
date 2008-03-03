From: akpm@linux-foundation.org
Subject: + blackfin-replace-remaining-__function__-occurences.patch added to -mm tree
Date: Mon, 03 Mar 2008 13:26:36 -0800
Message-ID: <200803032126.m23LQaTE007363@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49812 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754812AbYCCV0l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 3 Mar 2008 16:26:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, bryan.wu@analog.com, vapier.adi@gmail.com


The patch titled
     blackfin: replace remaining __FUNCTION__ occurences
has been added to the -mm tree.  Its filename is
     blackfin-replace-remaining-__function__-occurences.patch

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
Subject: blackfin: replace remaining __FUNCTION__ occurences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: "Mike Frysinger" <vapier.adi@gmail.com>
Cc: Bryan Wu <bryan.wu@analog.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/kernel/bfin_gpio.c                |    8 ++++----
 arch/blackfin/kernel/dma-mapping.c              |    4 ++--
 arch/blackfin/mach-bf527/boards/ezkit.c         |    4 ++--
 arch/blackfin/mach-bf533/boards/H8606.c         |    2 +-
 arch/blackfin/mach-bf533/boards/cm_bf533.c      |    2 +-
 arch/blackfin/mach-bf533/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf533/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf533/boards/stamp.c         |    2 +-
 arch/blackfin/mach-bf537/boards/cm_bf537.c      |    2 +-
 arch/blackfin/mach-bf537/boards/generic_board.c |    4 ++--
 arch/blackfin/mach-bf537/boards/minotaur.c      |    2 +-
 arch/blackfin/mach-bf537/boards/pnav10.c        |    2 +-
 arch/blackfin/mach-bf537/boards/stamp.c         |    4 ++--
 arch/blackfin/mach-bf548/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf561/boards/cm_bf561.c      |    2 +-
 arch/blackfin/mach-bf561/boards/ezkit.c         |    2 +-
 arch/blackfin/mach-bf561/boards/generic_board.c |    2 +-
 arch/blackfin/mach-bf561/boards/tepla.c         |    2 +-
 arch/blackfin/mach-common/ints-priority.c       |    2 +-
 arch/blackfin/oprofile/common.c                 |    2 +-
 arch/blackfin/oprofile/op_model_bf533.c         |    2 +-
 21 files changed, 28 insertions(+), 28 deletions(-)

diff -puN arch/blackfin/kernel/bfin_gpio.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/kernel/bfin_gpio.c
--- a/arch/blackfin/kernel/bfin_gpio.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/kernel/bfin_gpio.c
@@ -823,7 +823,7 @@ int peripheral_request(unsigned short pe
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
 		    "%s: Peripheral %d is already reserved as GPIO by %s !\n",
-		       __FUNCTION__, ident, get_label(ident));
+		       __func__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -850,7 +850,7 @@ int peripheral_request(unsigned short pe
 
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already reserved by %s !\n",
-			       __FUNCTION__, ident, P_FUNCT2MUX(per), get_label(ident));
+			       __func__, ident, P_FUNCT2MUX(per), get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
 			return -EBUSY;
@@ -893,7 +893,7 @@ int peripheral_request(unsigned short pe
 	if (unlikely(reserved_gpio_map[gpio_bank(ident)] & gpio_bit(ident))) {
 		printk(KERN_ERR
 		       "%s: Peripheral %d is already reserved as GPIO by %s !\n",
-		       __FUNCTION__, ident, get_label(ident));
+		       __func__, ident, get_label(ident));
 		dump_stack();
 		local_irq_restore(flags);
 		return -EBUSY;
@@ -921,7 +921,7 @@ int peripheral_request(unsigned short pe
 			printk(KERN_ERR
 			       "%s: Peripheral %d function %d is already"
 			       " reserved by %s !\n",
-			       __FUNCTION__, ident, P_FUNCT2MUX(per),
+			       __func__, ident, P_FUNCT2MUX(per),
 				get_label(ident));
 			dump_stack();
 			local_irq_restore(flags);
diff -puN arch/blackfin/kernel/dma-mapping.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/kernel/dma-mapping.c
--- a/arch/blackfin/kernel/dma-mapping.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/kernel/dma-mapping.c
@@ -59,7 +59,7 @@ void dma_alloc_init(unsigned long start,
 	memset((void *)dma_base, 0, DMA_UNCACHED_REGION);
 	dma_initialized = 1;
 
-	printk(KERN_INFO "%s: dma_page @ 0x%p - %d pages at 0x%08lx\n", __FUNCTION__,
+	printk(KERN_INFO "%s: dma_page @ 0x%p - %d pages at 0x%08lx\n", __func__,
 	       dma_page, dma_pages, dma_base);
 }
 
@@ -100,7 +100,7 @@ static void __free_dma_pages(unsigned lo
 	int i;
 
 	if ((page + pages) > dma_pages) {
-		printk(KERN_ERR "%s: freeing outside range.\n", __FUNCTION__);
+		printk(KERN_ERR "%s: freeing outside range.\n", __func__);
 		BUG();
 	}
 
diff -puN arch/blackfin/mach-bf527/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf527/boards/ezkit.c
--- a/arch/blackfin/mach-bf527/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf527/boards/ezkit.c
@@ -94,7 +94,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -896,7 +896,7 @@ static struct platform_device *stamp_dev
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff -puN arch/blackfin/mach-bf533/boards/H8606.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf533/boards/H8606.c
--- a/arch/blackfin/mach-bf533/boards/H8606.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf533/boards/H8606.c
@@ -411,7 +411,7 @@ static struct platform_device *h8606_dev
 static int __init H8606_init(void)
 {
 	printk(KERN_INFO "HV Sistemas H8606 board support by http://www.hvsistemas.com\n");
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(h8606_devices, ARRAY_SIZE(h8606_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff -puN arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf533/boards/cm_bf533.c
--- a/arch/blackfin/mach-bf533/boards/cm_bf533.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf533/boards/cm_bf533.c
@@ -355,7 +355,7 @@ static struct platform_device *cm_bf533_
 
 static int __init cm_bf533_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf533_devices, ARRAY_SIZE(cm_bf533_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff -puN arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf533/boards/ezkit.c
--- a/arch/blackfin/mach-bf533/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf533/boards/ezkit.c
@@ -369,7 +369,7 @@ static struct platform_device *ezkit_dev
 
 static int __init ezkit_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff -puN arch/blackfin/mach-bf533/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf533/boards/generic_board.c
--- a/arch/blackfin/mach-bf533/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf533/boards/generic_board.c
@@ -84,7 +84,7 @@ static struct platform_device *generic_b
 
 static int __init generic_board_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(generic_board_devices, ARRAY_SIZE(generic_board_devices));
 }
 
diff -puN arch/blackfin/mach-bf533/boards/stamp.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf533/boards/stamp.c
--- a/arch/blackfin/mach-bf533/boards/stamp.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf533/boards/stamp.c
@@ -522,7 +522,7 @@ static int __init stamp_init(void)
 {
 	int ret;
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	ret = platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 	if (ret < 0)
 		return ret;
diff -puN arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf537/boards/cm_bf537.c
--- a/arch/blackfin/mach-bf537/boards/cm_bf537.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf537/boards/cm_bf537.c
@@ -425,7 +425,7 @@ static struct platform_device *cm_bf537_
 
 static int __init cm_bf537_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf537_devices, ARRAY_SIZE(cm_bf537_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff -puN arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf537/boards/generic_board.c
--- a/arch/blackfin/mach-bf537/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf537/boards/generic_board.c
@@ -90,7 +90,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -690,7 +690,7 @@ static struct platform_device *stamp_dev
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff -puN arch/blackfin/mach-bf537/boards/minotaur.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf537/boards/minotaur.c
--- a/arch/blackfin/mach-bf537/boards/minotaur.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf537/boards/minotaur.c
@@ -297,7 +297,7 @@ static struct platform_device *minotaur_
 
 static int __init minotaur_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(minotaur_devices, ARRAY_SIZE(minotaur_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff -puN arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf537/boards/pnav10.c
--- a/arch/blackfin/mach-bf537/boards/pnav10.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf537/boards/pnav10.c
@@ -497,7 +497,7 @@ static struct platform_device *stamp_dev
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff -puN arch/blackfin/mach-bf537/boards/stamp.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf537/boards/stamp.c
--- a/arch/blackfin/mach-bf537/boards/stamp.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf537/boards/stamp.c
@@ -90,7 +90,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
@@ -823,7 +823,7 @@ static struct platform_device *stamp_dev
 
 static int __init stamp_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(stamp_devices, ARRAY_SIZE(stamp_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info,
diff -puN arch/blackfin/mach-bf548/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf548/boards/ezkit.c
--- a/arch/blackfin/mach-bf548/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf548/boards/ezkit.c
@@ -666,7 +666,7 @@ static struct platform_device *ezkit_dev
 
 static int __init ezkit_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(ezkit_devices, ARRAY_SIZE(ezkit_devices));
 
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
diff -puN arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf561/boards/cm_bf561.c
--- a/arch/blackfin/mach-bf561/boards/cm_bf561.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf561/boards/cm_bf561.c
@@ -349,7 +349,7 @@ static struct platform_device *cm_bf561_
 
 static int __init cm_bf561_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	platform_add_devices(cm_bf561_devices, ARRAY_SIZE(cm_bf561_devices));
 #if defined(CONFIG_SPI_BFIN) || defined(CONFIG_SPI_BFIN_MODULE)
 	spi_register_board_info(bfin_spi_board_info, ARRAY_SIZE(bfin_spi_board_info));
diff -puN arch/blackfin/mach-bf561/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf561/boards/ezkit.c
--- a/arch/blackfin/mach-bf561/boards/ezkit.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf561/boards/ezkit.c
@@ -78,7 +78,7 @@ int __init bfin_isp1761_init(void)
 {
 	unsigned int num_devices = ARRAY_SIZE(bfin_isp1761_devices);
 
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	set_irq_type(ISP1761_IRQ, IRQF_TRIGGER_FALLING);
 
 	return platform_add_devices(bfin_isp1761_devices, num_devices);
diff -puN arch/blackfin/mach-bf561/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf561/boards/generic_board.c
--- a/arch/blackfin/mach-bf561/boards/generic_board.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf561/boards/generic_board.c
@@ -70,7 +70,7 @@ static struct platform_device *generic_b
 
 static int __init generic_board_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(generic_board_devices,
 				    ARRAY_SIZE(generic_board_devices));
 }
diff -puN arch/blackfin/mach-bf561/boards/tepla.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-bf561/boards/tepla.c
--- a/arch/blackfin/mach-bf561/boards/tepla.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-bf561/boards/tepla.c
@@ -50,7 +50,7 @@ static struct platform_device *tepla_dev
 
 static int __init tepla_init(void)
 {
-	printk(KERN_INFO "%s(): registering device resources\n", __FUNCTION__);
+	printk(KERN_INFO "%s(): registering device resources\n", __func__);
 	return platform_add_devices(tepla_devices, ARRAY_SIZE(tepla_devices));
 }
 
diff -puN arch/blackfin/mach-common/ints-priority.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/mach-common/ints-priority.c
--- a/arch/blackfin/mach-common/ints-priority.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/mach-common/ints-priority.c
@@ -316,7 +316,7 @@ static void bfin_demux_error_irq(unsigne
 		printk(KERN_ERR
 		       "%s : %s : LINE %d :\nIRQ ?: PERIPHERAL ERROR"
 		       " INTERRUPT ASSERTED BUT NO SOURCE FOUND\n",
-		       __FUNCTION__, __FILE__, __LINE__);
+		       __func__, __FILE__, __LINE__);
 
 }
 #endif				/* BF537_GENERIC_ERROR_INT_DEMUX */
diff -puN arch/blackfin/oprofile/common.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/oprofile/common.c
--- a/arch/blackfin/oprofile/common.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/oprofile/common.c
@@ -75,7 +75,7 @@ static int op_bfin_start(void)
 {
 	int ret = -EBUSY;
 
-	printk(KERN_INFO "KSDBG:in %s\n", __FUNCTION__);
+	printk(KERN_INFO "KSDBG:in %s\n", __func__);
 	mutex_lock(&pfmon_lock);
 	if (!pfmon_enabled) {
 		ret = model->start(ctr);
diff -puN arch/blackfin/oprofile/op_model_bf533.c~blackfin-replace-remaining-__function__-occurences arch/blackfin/oprofile/op_model_bf533.c
--- a/arch/blackfin/oprofile/op_model_bf533.c~blackfin-replace-remaining-__function__-occurences
+++ a/arch/blackfin/oprofile/op_model_bf533.c
@@ -125,7 +125,7 @@ int pm_overflow_handler(int irq, struct 
 	unsigned int pc, pfctl;
 	unsigned int count[2];
 
-	pr_debug("get interrupt in %s\n", __FUNCTION__);
+	pr_debug("get interrupt in %s\n", __func__);
 	if (oprofile_running == 0) {
 		pr_debug("error: entering interrupt when oprofile is stopped.\n\r");
 		return -1;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
specialixc-fix-possible-double-unlock.patch
git-x86.patch
git-alsa.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
arm-replace-remaining-__function__-occurences.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
ia64-remove-remaining-__function__-occurences.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
blackfin-replace-remaining-__function__-occurences.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
kernel-add-clamp-and-clamp_t-macros.patch
kernel-add-clamp-and-clamp_t-macros-checkpatch-fixes.patch
kernel-add-clamp-and-clamp_t-macros-fix.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
alpha-remove-remaining-__function__-occurences.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-introduce-kprobe_handle_fault-ia64-fix.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
fbcon-replace-mono_col-macro-with-static-inline-fix.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
mm-remove-remaining-__function__-occurances.patch
block-remove-remaining-__function__-occurances.patch
kernel-replace-remaining-__function__-occurances.patch
lib-replace-remaining-__function__-occurances.patch

