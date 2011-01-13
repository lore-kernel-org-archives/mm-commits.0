From: akpm@linux-foundation.org
Subject: [merged] drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch removed from -mm tree
Date: Thu, 13 Jan 2011 12:07:31 -0800
Message-ID: <201101132010.p0DKACUn030042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33895 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933663Ab1AMUKo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Jan 2011 15:10:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dilinger@queued.net, greg@kroah.com, mm-commits@vger.kernel.org


The patch titled
     drivers/staging/olpc_dcon: convert to new cs5535 gpio API
has been removed from the -mm tree.  Its filename was
     drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/staging/olpc_dcon: convert to new cs5535 gpio API
From: Andres Salomon <dilinger@queued.net>

Drop the old geode_gpio crud, as well as the raw outl() calls; instead,
use the Linux GPIO API where possible, and the cs5535_gpio API in other
places.

Note that we don't actually clean up the driver properly yet (once loaded,
it always remains loaded).  That'll come later..

This patch is necessary for building the driver.

Signed-off-by: Andres Salomon <dilinger@queued.net>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/olpc.h                  |   10 -
 drivers/staging/olpc_dcon/TODO               |    1 
 drivers/staging/olpc_dcon/olpc_dcon.c        |    3 
 drivers/staging/olpc_dcon/olpc_dcon.h        |   20 --
 drivers/staging/olpc_dcon/olpc_dcon_xo_1.c   |  168 ++++++++++-------
 drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c |    4 
 include/linux/cs5535.h                       |    4 
 7 files changed, 114 insertions(+), 96 deletions(-)

diff -puN arch/x86/include/asm/olpc.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api arch/x86/include/asm/olpc.h
--- a/arch/x86/include/asm/olpc.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/arch/x86/include/asm/olpc.h
@@ -107,10 +107,14 @@ extern int olpc_ec_mask_unset(uint8_t bi
 /* GPIO assignments */
 
 #define OLPC_GPIO_MIC_AC	1
-#define OLPC_GPIO_DCON_IRQ	geode_gpio(7)
+#define OLPC_GPIO_DCON_STAT0	5
+#define OLPC_GPIO_DCON_STAT1	6
+#define OLPC_GPIO_DCON_IRQ	7
 #define OLPC_GPIO_THRM_ALRM	geode_gpio(10)
-#define OLPC_GPIO_SMB_CLK	geode_gpio(14)
-#define OLPC_GPIO_SMB_DATA	geode_gpio(15)
+#define OLPC_GPIO_DCON_LOAD    11
+#define OLPC_GPIO_DCON_BLANK   12
+#define OLPC_GPIO_SMB_CLK      14
+#define OLPC_GPIO_SMB_DATA     15
 #define OLPC_GPIO_WORKAUX	geode_gpio(24)
 #define OLPC_GPIO_LID		geode_gpio(26)
 #define OLPC_GPIO_ECSCI		geode_gpio(27)
diff -puN drivers/staging/olpc_dcon/TODO~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api drivers/staging/olpc_dcon/TODO
--- a/drivers/staging/olpc_dcon/TODO~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/drivers/staging/olpc_dcon/TODO
@@ -1,6 +1,5 @@
 TODO:
 	- checkpatch.pl cleanups
-	- port geode gpio calls to newer cs5535 API
 	- see if vx855 gpio API can be made similar enough to cs5535 so we can
 	  share more code
 	- allow simultaneous XO-1 and XO-1.5 support
diff -puN drivers/staging/olpc_dcon/olpc_dcon.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api drivers/staging/olpc_dcon/olpc_dcon.c
--- a/drivers/staging/olpc_dcon/olpc_dcon.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/drivers/staging/olpc_dcon/olpc_dcon.c
@@ -27,7 +27,6 @@
 #include <asm/uaccess.h>
 #include <linux/ctype.h>
 #include <linux/reboot.h>
-#include <linux/gpio.h>
 #include <asm/tsc.h>
 #include <asm/olpc.h>
 
@@ -49,7 +48,7 @@ struct dcon_platform_data {
 	int (*init)(void);
 	void (*bus_stabilize_wiggle)(void);
 	void (*set_dconload)(int);
-	int (*read_status)(void);
+	u8 (*read_status)(void);
 };
 
 static struct dcon_platform_data *pdata;
diff -puN drivers/staging/olpc_dcon/olpc_dcon.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api drivers/staging/olpc_dcon/olpc_dcon.h
--- a/drivers/staging/olpc_dcon/olpc_dcon.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/drivers/staging/olpc_dcon/olpc_dcon.h
@@ -29,26 +29,6 @@
 #define DCON_REG_SCAN_INT	9
 #define DCON_REG_BRIGHT		10
 
-/* GPIO registers (CS5536) */
-
-#define MSR_LBAR_GPIO		0x5140000C
-
-#define GPIOx_OUT_VAL     0x00
-#define GPIOx_OUT_EN      0x04
-#define GPIOx_IN_EN       0x20
-#define GPIOx_INV_EN      0x24
-#define GPIOx_IN_FLTR_EN  0x28
-#define GPIOx_EVNTCNT_EN  0x2C
-#define GPIOx_READ_BACK   0x30
-#define GPIOx_EVNT_EN     0x38
-#define GPIOx_NEGEDGE_EN  0x44
-#define GPIOx_NEGEDGE_STS 0x4C
-#define GPIO_FLT7_AMNT    0xD8
-#define GPIO_MAP_X        0xE0
-#define GPIO_MAP_Y        0xE4
-#define GPIO_FE7_SEL      0xF7
-
-
 /* Status values */
 
 #define DCONSTAT_SCANINT	0
diff -puN drivers/staging/olpc_dcon/olpc_dcon_xo_1.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/drivers/staging/olpc_dcon/olpc_dcon_xo_1.c
@@ -10,54 +10,70 @@
  * modify it under the terms of version 2 of the GNU General Public
  * License as published by the Free Software Foundation.
  */
-
+#include <linux/cs5535.h>
+#include <linux/gpio.h>
 #include <asm/olpc.h>
 
 #include "olpc_dcon.h"
 
-/* Base address of the GPIO registers */
-static unsigned long gpio_base;
-
-/*
- * List of GPIOs that we care about:
- * (in)  GPIO12   -- DCONBLANK
- * (in)  GPIO[56] -- DCONSTAT[01]
- * (out) GPIO11   -- DCONLOAD
- */
-
-#define IN_GPIOS ((1<<5) | (1<<6) | (1<<7) | (1<<12))
-#define OUT_GPIOS (1<<11)
-
 static int dcon_init_xo_1(void)
 {
-	unsigned long lo, hi;
 	unsigned char lob;
 
-	rdmsr(MSR_LBAR_GPIO, lo, hi);
-
-	/* Check the mask and whether GPIO is enabled (sanity check) */
-	if (hi != 0x0000f001) {
-		printk(KERN_ERR "GPIO not enabled -- cannot use DCON\n");
-		return -ENODEV;
+	if (gpio_request(OLPC_GPIO_DCON_STAT0, "OLPC-DCON")) {
+		printk(KERN_ERR "olpc-dcon: failed to request STAT0 GPIO\n");
+		return -EIO;
+	}
+	if (gpio_request(OLPC_GPIO_DCON_STAT1, "OLPC-DCON")) {
+		printk(KERN_ERR "olpc-dcon: failed to request STAT1 GPIO\n");
+		goto err_gp_stat1;
+	}
+	if (gpio_request(OLPC_GPIO_DCON_IRQ, "OLPC-DCON")) {
+		printk(KERN_ERR "olpc-dcon: failed to request IRQ GPIO\n");
+		goto err_gp_irq;
+	}
+	if (gpio_request(OLPC_GPIO_DCON_LOAD, "OLPC-DCON")) {
+		printk(KERN_ERR "olpc-dcon: failed to request LOAD GPIO\n");
+		goto err_gp_load;
+	}
+	if (gpio_request(OLPC_GPIO_DCON_BLANK, "OLPC-DCON")) {
+		printk(KERN_ERR "olpc-dcon: failed to request BLANK GPIO\n");
+		goto err_gp_blank;
 	}
-
-	/* Mask off the IO base address */
-	gpio_base = lo & 0x0000ff00;
 
 	/* Turn off the event enable for GPIO7 just to be safe */
-	outl(1 << (16+7), gpio_base + GPIOx_EVNT_EN);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_IRQ, GPIO_EVENTS_ENABLE);
+
+	/*
+	 * Determine the current state by reading the GPIO bit; earlier
+	 * stages of the boot process have established the state.
+	 *
+	 * Note that we read GPIO_OUPUT_VAL rather than GPIO_READ_BACK here;
+	 * this is because OFW will disable input for the pin and set a value..
+	 * READ_BACK will only contain a valid value if input is enabled and
+	 * then a value is set.  So, future readings of the pin can use
+	 * READ_BACK, but the first one cannot.  Awesome, huh?
+	 */
+	dcon_source = cs5535_gpio_isset(OLPC_GPIO_DCON_LOAD, GPIO_OUTPUT_VAL)
+		? DCON_SOURCE_CPU
+		: DCON_SOURCE_DCON;
+	dcon_pending = dcon_source;
 
 	/* Set the directions for the GPIO pins */
-	outl(OUT_GPIOS | (IN_GPIOS << 16), gpio_base + GPIOx_OUT_EN);
-	outl(IN_GPIOS | (OUT_GPIOS << 16), gpio_base + GPIOx_IN_EN);
+	gpio_direction_input(OLPC_GPIO_DCON_STAT0);
+	gpio_direction_input(OLPC_GPIO_DCON_STAT1);
+	gpio_direction_input(OLPC_GPIO_DCON_IRQ);
+	gpio_direction_input(OLPC_GPIO_DCON_BLANK);
+	gpio_direction_output(OLPC_GPIO_DCON_LOAD,
+			dcon_source == DCON_SOURCE_CPU);
 
 	/* Set up the interrupt mappings */
 
 	/* Set the IRQ to pair 2 */
-	geode_gpio_event_irq(OLPC_GPIO_DCON_IRQ, 2);
+	cs5535_gpio_setup_event(OLPC_GPIO_DCON_IRQ, 2, 0);
 
 	/* Enable group 2 to trigger the DCON interrupt */
-	geode_gpio_set_irq(2, DCON_IRQ);
+	cs5535_gpio_set_irq(2, DCON_IRQ);
 
 	/* Select edge level for interrupt (in PIC) */
 	lob = inb(0x4d0);
@@ -65,52 +81,61 @@ static int dcon_init_xo_1(void)
 	outb(lob, 0x4d0);
 
 	/* Register the interupt handler */
-	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", &dcon_driver))
-		return -EIO;
+	if (request_irq(DCON_IRQ, &dcon_interrupt, 0, "DCON", &dcon_driver)) {
+		printk(KERN_ERR "olpc-dcon: failed to request DCON's irq\n");
+		goto err_req_irq;
+	}
 
 	/* Clear INV_EN for GPIO7 (DCONIRQ) */
-	outl((1<<(16+7)), gpio_base + GPIOx_INV_EN);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_IRQ, GPIO_INPUT_INVERT);
 
 	/* Enable filter for GPIO12 (DCONBLANK) */
-	outl(1<<(12), gpio_base + GPIOx_IN_FLTR_EN);
+	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_INPUT_FILTER);
 
 	/* Disable filter for GPIO7 */
-	outl(1<<(16+7), gpio_base + GPIOx_IN_FLTR_EN);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_IRQ, GPIO_INPUT_FILTER);
 
 	/* Disable event counter for GPIO7 (DCONIRQ) and GPIO12 (DCONBLANK) */
-
-	outl(1<<(16+7), gpio_base + GPIOx_EVNTCNT_EN);
-	outl(1<<(16+12), gpio_base + GPIOx_EVNTCNT_EN);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_IRQ, GPIO_INPUT_EVENT_COUNT);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_BLANK, GPIO_INPUT_EVENT_COUNT);
 
 	/* Add GPIO12 to the Filter Event Pair #7 */
-	outb(12, gpio_base + GPIO_FE7_SEL);
+	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_FE7_SEL);
 
 	/* Turn off negative Edge Enable for GPIO12 */
-	outl(1<<(16+12), gpio_base + GPIOx_NEGEDGE_EN);
+	cs5535_gpio_clear(OLPC_GPIO_DCON_BLANK, GPIO_NEGATIVE_EDGE_EN);
 
 	/* Enable negative Edge Enable for GPIO7 */
-	outl(1<<7, gpio_base + GPIOx_NEGEDGE_EN);
+	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_NEGATIVE_EDGE_EN);
 
 	/* Zero the filter amount for Filter Event Pair #7 */
-	outw(0, gpio_base + GPIO_FLT7_AMNT);
+	cs5535_gpio_set(0, GPIO_FLTR7_AMOUNT);
 
 	/* Clear the negative edge status for GPIO7 and GPIO12 */
-	outl((1<<7) | (1<<12), gpio_base+0x4c);
+	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_NEGATIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_NEGATIVE_EDGE_STS);
 
 	/* FIXME:  Clear the posiitive status as well, just to be sure */
-	outl((1<<7) | (1<<12), gpio_base+0x48);
+	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_POSITIVE_EDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_POSITIVE_EDGE_STS);
 
 	/* Enable events for GPIO7 (DCONIRQ) and GPIO12 (DCONBLANK) */
-	outl((1<<(7))|(1<<12), gpio_base + GPIOx_EVNT_EN);
-
-	/* Determine the current state by reading the GPIO bit */
-	/* Earlier stages of the boot process have established the state */
-	dcon_source = inl(gpio_base + GPIOx_OUT_VAL) & (1<<11)
-		? DCON_SOURCE_CPU
-		: DCON_SOURCE_DCON;
-	dcon_pending = dcon_source;
+	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_EVENTS_ENABLE);
+	cs5535_gpio_set(OLPC_GPIO_DCON_BLANK, GPIO_EVENTS_ENABLE);
 
 	return 0;
+
+err_req_irq:
+	gpio_free(OLPC_GPIO_DCON_BLANK);
+err_gp_blank:
+	gpio_free(OLPC_GPIO_DCON_LOAD);
+err_gp_load:
+	gpio_free(OLPC_GPIO_DCON_IRQ);
+err_gp_irq:
+	gpio_free(OLPC_GPIO_DCON_STAT1);
+err_gp_stat1:
+	gpio_free(OLPC_GPIO_DCON_STAT0);
+	return -EIO;
 }
 
 static void dcon_wiggle_xo_1(void)
@@ -128,37 +153,44 @@ static void dcon_wiggle_xo_1(void)
 	 * simultaneously set AUX1 IN/OUT to GPIO14; ditto for SMB_DATA and
 	 * GPIO15.
  	 */
-	geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_VAL);
-	geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_ENABLE);
-	geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
-	geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX2);
-	geode_gpio_clear(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);
+	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
+	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_VAL);
+	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_ENABLE);
+	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_ENABLE);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_AUX1);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_AUX2);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX2);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_INPUT_AUX1);
+	cs5535_gpio_clear(OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);
 
 	for (x = 0; x < 16; x++) {
 		udelay(5);
-		geode_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
+		cs5535_gpio_clear(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
 		udelay(5);
-		geode_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
+		cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_VAL);
 	}
 	udelay(5);
-	geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
-	geode_gpio_set(OLPC_GPIO_SMB_CLK|OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);
+	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_OUTPUT_AUX1);
+	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_OUTPUT_AUX1);
+	cs5535_gpio_set(OLPC_GPIO_SMB_CLK, GPIO_INPUT_AUX1);
+	cs5535_gpio_set(OLPC_GPIO_SMB_DATA, GPIO_INPUT_AUX1);
 }
 
 static void dcon_set_dconload_1(int val)
 {
-	if (val)	
-		outl(1<<11, gpio_base + GPIOx_OUT_VAL);
-	else
-		outl(1<<(11 + 16), gpio_base + GPIOx_OUT_VAL);
+	gpio_set_value(OLPC_GPIO_DCON_LOAD, val);
 }
 
-static int dcon_read_status_xo_1(void)
+static u8 dcon_read_status_xo_1(void)
 {
-	int status = inl(gpio_base + GPIOx_READ_BACK) >> 5;
-	
+	u8 status;
+
+	status = gpio_get_value(OLPC_GPIO_DCON_STAT0);
+	status |= gpio_get_value(OLPC_GPIO_DCON_STAT1) << 1;
+
 	/* Clear the negative edge status for GPIO7 */
-	outl(1 << 7, gpio_base + GPIOx_NEGEDGE_STS);
+	cs5535_gpio_set(OLPC_GPIO_DCON_IRQ, GPIO_NEGATIVE_EDGE_STS);
 
 	return status;
 }
diff -puN drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
--- a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/drivers/staging/olpc_dcon/olpc_dcon_xo_1_5.c
@@ -195,9 +195,9 @@ static void dcon_set_dconload_xo_1_5(int
 	}
 }
 
-static int dcon_read_status_xo_1_5(void) 
+static u8 dcon_read_status_xo_1_5(void)
 {
-	int status;
+	u8 status;
 	
 	if (!dcon_was_irq())
 		return -1;
diff -puN include/linux/cs5535.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api include/linux/cs5535.h
--- a/include/linux/cs5535.h~drivers-staging-olpc_dcon-convert-to-new-cs5535-gpio-api
+++ a/include/linux/cs5535.h
@@ -103,11 +103,15 @@ static inline int cs5535_has_vsa2(void)
 #define GPIO_POSITIVE_EDGE_STS	0x48
 #define GPIO_NEGATIVE_EDGE_STS	0x4C
 
+#define GPIO_FLTR7_AMOUNT	0xD8
+
 #define GPIO_MAP_X		0xE0
 #define GPIO_MAP_Y		0xE4
 #define GPIO_MAP_Z		0xE8
 #define GPIO_MAP_W		0xEC
 
+#define GPIO_FE7_SEL		0xF7
+
 void cs5535_gpio_set(unsigned offset, unsigned int reg);
 void cs5535_gpio_clear(unsigned offset, unsigned int reg);
 int cs5535_gpio_isset(unsigned offset, unsigned int reg);
_

Patches currently in -mm which might be from dilinger@queued.net are

origin.patch
linux-next.patch

