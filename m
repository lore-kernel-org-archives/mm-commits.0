From: akpm@linux-foundation.org
Subject: + platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch added to -mm tree
Date: Mon, 06 Feb 2012 13:01:08 -0800
Message-ID: <20120206210109.1E190A016E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yw0-f74.google.com ([209.85.213.74]:36590 "EHLO
	mail-yw0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab2BFVBK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2012 16:01:10 -0500
Received: by yhgm50 with SMTP id m50so686673yhg.1
        for <mm-commits@vger.kernel.org>; Mon, 06 Feb 2012 13:01:09 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mika.westerberg@linux.intel.com, alan@linux.intel.com, durgadoss.r@intel.com, hpa@zytor.com, kirill.shutemov@linux.intel.com, mingo@elte.hu, mjg@redhat.com, tglx@linutronix.de


The patch titled
     Subject: platform-x86: intel_mid_thermal: convert to use Intel MSIC API
has been added to the -mm tree.  Its filename is
     platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: platform-x86: intel_mid_thermal: convert to use Intel MSIC API

Intel MSIC MFD driver provides common register access interface to the
devices in the MSIC die so we use that instead of SCU IPC.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Acked-by: Durgadoss R <durgadoss.r@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/platform/x86/Kconfig             |    2 -
 drivers/platform/x86/intel_mid_thermal.c |   39 +++++++++------------
 2 files changed, 19 insertions(+), 22 deletions(-)

diff -puN drivers/platform/x86/Kconfig~platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api drivers/platform/x86/Kconfig
--- a/drivers/platform/x86/Kconfig~platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api
+++ a/drivers/platform/x86/Kconfig
@@ -672,7 +672,7 @@ config INTEL_MID_POWER_BUTTON
 
 config INTEL_MFLD_THERMAL
        tristate "Thermal driver for Intel Medfield platform"
-       depends on INTEL_SCU_IPC && THERMAL
+       depends on MFD_INTEL_MSIC && THERMAL
        help
          Say Y here to enable thermal driver support for the  Intel Medfield
          platform.
diff -puN drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api drivers/platform/x86/intel_mid_thermal.c
--- a/drivers/platform/x86/intel_mid_thermal.c~platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api
+++ a/drivers/platform/x86/intel_mid_thermal.c
@@ -33,18 +33,15 @@
 #include <linux/slab.h>
 #include <linux/pm.h>
 #include <linux/thermal.h>
-
-#include <asm/intel_scu_ipc.h>
+#include <linux/mfd/intel_msic.h>
 
 /* Number of thermal sensors */
 #define MSIC_THERMAL_SENSORS	4
 
 /* ADC1 - thermal registers */
-#define MSIC_THERM_ADC1CNTL1	0x1C0
 #define MSIC_ADC_ENBL		0x10
 #define MSIC_ADC_START		0x08
 
-#define MSIC_THERM_ADC1CNTL3	0x1C2
 #define MSIC_ADCTHERM_ENBL	0x04
 #define MSIC_ADCRRDATA_ENBL	0x05
 #define MSIC_CHANL_MASK_VAL	0x0F
@@ -75,8 +72,8 @@
 #define ADC_VAL60C		315
 
 /* ADC base addresses */
-#define ADC_CHNL_START_ADDR	0x1C5	/* increments by 1 */
-#define ADC_DATA_START_ADDR	0x1D4	/* increments by 2 */
+#define ADC_CHNL_START_ADDR	INTEL_MSIC_ADC1ADDR0	/* increments by 1 */
+#define ADC_DATA_START_ADDR	INTEL_MSIC_ADC1SNS0H	/* increments by 2 */
 
 /* MSIC die attributes */
 #define MSIC_DIE_ADC_MIN	488
@@ -189,17 +186,17 @@ static int mid_read_temp(struct thermal_
 	addr = td_info->chnl_addr;
 
 	/* Enable the msic for conversion before reading */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCRRDATA_ENBL);
 	if (ret)
 		return ret;
 
 	/* Re-toggle the RRDATARD bit (temporary workaround) */
-	ret = intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
+	ret = intel_msic_reg_write(INTEL_MSIC_ADC1CNTL3, MSIC_ADCTHERM_ENBL);
 	if (ret)
 		return ret;
 
 	/* Read the higher bits of data */
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 
@@ -207,7 +204,7 @@ static int mid_read_temp(struct thermal_
 	adc_val = (data << 2);
 	addr++;
 
-	ret = intel_scu_ipc_ioread8(addr, &data);/* Read lower bits */
+	ret = intel_msic_reg_read(addr, &data);/* Read lower bits */
 	if (ret)
 		return ret;
 
@@ -235,7 +232,7 @@ static int configure_adc(int val)
 	int ret;
 	uint8_t data;
 
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -246,7 +243,7 @@ static int configure_adc(int val)
 		/* Just stop the ADC */
 		data &= (~MSIC_ADC_START);
 	}
-	return intel_scu_ipc_iowrite8(MSIC_THERM_ADC1CNTL1, data);
+	return intel_msic_reg_write(INTEL_MSIC_ADC1CNTL1, data);
 }
 
 /**
@@ -262,21 +259,21 @@ static int set_up_therm_channel(u16 base
 	int ret;
 
 	/* Enable all the sensor channels */
-	ret = intel_scu_ipc_iowrite8(base_addr, SKIN_SENSOR0_CODE);
+	ret = intel_msic_reg_write(base_addr, SKIN_SENSOR0_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 1, SKIN_SENSOR1_CODE);
+	ret = intel_msic_reg_write(base_addr + 1, SKIN_SENSOR1_CODE);
 	if (ret)
 		return ret;
 
-	ret = intel_scu_ipc_iowrite8(base_addr + 2, SYS_SENSOR_CODE);
+	ret = intel_msic_reg_write(base_addr + 2, SYS_SENSOR_CODE);
 	if (ret)
 		return ret;
 
 	/* Since this is the last channel, set the stop bit
 	 * to 1 by ORing the DIE_SENSOR_CODE with 0x10 */
-	ret = intel_scu_ipc_iowrite8(base_addr + 3,
+	ret = intel_msic_reg_write(base_addr + 3,
 			(MSIC_DIE_SENSOR_CODE | 0x10));
 	if (ret)
 		return ret;
@@ -295,11 +292,11 @@ static int reset_stopbit(uint16_t addr)
 {
 	int ret;
 	uint8_t data;
-	ret = intel_scu_ipc_ioread8(addr, &data);
+	ret = intel_msic_reg_read(addr, &data);
 	if (ret)
 		return ret;
 	/* Set the stop bit to zero */
-	return intel_scu_ipc_iowrite8(addr, (data & 0xEF));
+	return intel_msic_reg_write(addr, (data & 0xEF));
 }
 
 /**
@@ -322,7 +319,7 @@ static int find_free_channel(void)
 	uint8_t data;
 
 	/* check whether ADC is enabled */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL1, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL1, &data);
 	if (ret)
 		return ret;
 
@@ -331,7 +328,7 @@ static int find_free_channel(void)
 
 	/* ADC is already enabled; Looking for an empty channel */
 	for (i = 0; i < ADC_CHANLS_MAX; i++) {
-		ret = intel_scu_ipc_ioread8(ADC_CHNL_START_ADDR + i, &data);
+		ret = intel_msic_reg_read(ADC_CHNL_START_ADDR + i, &data);
 		if (ret)
 			return ret;
 
@@ -359,7 +356,7 @@ static int mid_initialize_adc(struct dev
 	 * Ensure that adctherm is disabled before we
 	 * initialize the ADC
 	 */
-	ret = intel_scu_ipc_ioread8(MSIC_THERM_ADC1CNTL3, &data);
+	ret = intel_msic_reg_read(INTEL_MSIC_ADC1CNTL3, &data);
 	if (ret)
 		return ret;
 
_
Subject: Subject: platform-x86: intel_mid_thermal: convert to use Intel MSIC API

Patches currently in -mm which might be from mika.westerberg@linux.intel.com are

linux-next.patch
platform-x86-intel_mid_thermal-add-msic_thermal-alias.patch
platform-x86-intel_mid_thermal-convert-to-use-intel-msic-api.patch
platform-x86-intel_mid_thermal-turn-off-thermistor-voltage-by-default.patch
intel_mid_powerbtn-use-msic-read-write-instead-of-ipc_scu.patch

