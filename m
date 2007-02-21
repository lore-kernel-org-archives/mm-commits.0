From: akpm@linux-foundation.org
Subject: - mwave-interesting-flags-savings.patch removed from -mm tree
Date: Wed, 21 Feb 2007 02:45:37 -0800
Message-ID: <200702211045.l1LAjbBc006384@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46868 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932446AbXBUKpn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 05:45:43 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: adobriyan@gmail.com, mm-commits@vger.kernel.org


The patch titled
     mwave: interesting flags savings
has been removed from the -mm tree.  Its filename was
     mwave-interesting-flags-savings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: mwave: interesting flags savings
From: Alexey Dobriyan <adobriyan@gmail.com>

Flags from spin_lock_irqsave() are saved into global variable and restored
from it.  My gut feeling this is very racy.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mwave/3780i.c |   14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff -puN drivers/char/mwave/3780i.c~mwave-interesting-flags-savings drivers/char/mwave/3780i.c
--- a/drivers/char/mwave/3780i.c~mwave-interesting-flags-savings
+++ a/drivers/char/mwave/3780i.c
@@ -63,8 +63,6 @@
 #include "3780i.h"
 
 static DEFINE_SPINLOCK(dsp_lock);
-static unsigned long flags;
-
 
 static void PaceMsaAccess(unsigned short usDspBaseIO)
 {
@@ -76,6 +74,7 @@ static void PaceMsaAccess(unsigned short
 unsigned short dsp3780I_ReadMsaCfg(unsigned short usDspBaseIO,
                                    unsigned long ulMsaAddr)
 {
+	unsigned long flags;
 	unsigned short val;
 
 	PRINTK_3(TRACE_3780I,
@@ -96,6 +95,7 @@ unsigned short dsp3780I_ReadMsaCfg(unsig
 void dsp3780I_WriteMsaCfg(unsigned short usDspBaseIO,
                           unsigned long ulMsaAddr, unsigned short usValue)
 {
+	unsigned long flags;
 
 	PRINTK_4(TRACE_3780I,
 		"3780i::dsp3780i_WriteMsaCfg entry usDspBaseIO %x ulMsaAddr %lx usValue %x\n",
@@ -175,6 +175,7 @@ int dsp3780I_EnableDSP(DSP_3780I_CONFIG_
                        unsigned short *pIrqMap,
                        unsigned short *pDmaMap)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	int i;
 	DSP_UART_CFG_1 rUartCfg1;
@@ -354,6 +355,7 @@ int dsp3780I_EnableDSP(DSP_3780I_CONFIG_
 
 int dsp3780I_DisableDSP(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_ISA_SLAVE_CONTROL rSlaveControl;
 
@@ -383,6 +385,7 @@ int dsp3780I_DisableDSP(DSP_3780I_CONFIG
 
 int dsp3780I_Reset(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_BOOT_DOMAIN rBootDomain;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
@@ -427,6 +430,7 @@ int dsp3780I_Reset(DSP_3780I_CONFIG_SETT
 
 int dsp3780I_Run(DSP_3780I_CONFIG_SETTINGS * pSettings)
 {
+	unsigned long flags;
 	unsigned short usDspBaseIO = pSettings->usDspBaseIO;
 	DSP_BOOT_DOMAIN rBootDomain;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
@@ -473,6 +477,7 @@ int dsp3780I_Run(DSP_3780I_CONFIG_SETTIN
 int dsp3780I_ReadDStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                         unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 	unsigned short val;
 
@@ -514,6 +519,7 @@ int dsp3780I_ReadAndClearDStore(unsigned
                                 void __user *pvBuffer, unsigned uCount,
                                 unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 	unsigned short val;
 
@@ -555,6 +561,7 @@ int dsp3780I_ReadAndClearDStore(unsigned
 int dsp3780I_WriteDStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                          unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 
@@ -596,6 +603,7 @@ int dsp3780I_WriteDStore(unsigned short 
 int dsp3780I_ReadIStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                         unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 	PRINTK_5(TRACE_3780I,
@@ -643,6 +651,7 @@ int dsp3780I_ReadIStore(unsigned short u
 int dsp3780I_WriteIStore(unsigned short usDspBaseIO, void __user *pvBuffer,
                          unsigned uCount, unsigned long ulDSPAddr)
 {
+	unsigned long flags;
 	unsigned short __user *pusBuffer = pvBuffer;
 
 	PRINTK_5(TRACE_3780I,
@@ -691,6 +700,7 @@ int dsp3780I_WriteIStore(unsigned short 
 int dsp3780I_GetIPCSource(unsigned short usDspBaseIO,
                           unsigned short *pusIPCSource)
 {
+	unsigned long flags;
 	DSP_HBRIDGE_CONTROL rHBridgeControl;
 	unsigned short temp;
 
_

Patches currently in -mm which might be from adobriyan@gmail.com are

git-dvb.patch
megaraid-fix-warnings-when-config_proc_fs=n.patch
fix-rmmod-read-write-races-in-proc-entries.patch
fix-rmmod-read-write-races-in-proc-entries-fix.patch
