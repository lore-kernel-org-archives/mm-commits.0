From: akpm@linux-foundation.org
Subject: + dvb-use-array_size-macro-when-appropriate.patch added to -mm tree
Date: Tue, 06 Feb 2007 16:04:52 -0800
Message-ID: <200702070004.l1704rBv001138@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:56092 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030238AbXBGAFr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Tue, 6 Feb 2007 19:05:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: darwish.07@gmail.com, mchehab@infradead.org


The patch titled
     DVB: Use ARRAY_SIZE macro when appropriate
has been added to the -mm tree.  Its filename is
     dvb-use-array_size-macro-when-appropriate.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: DVB: Use ARRAY_SIZE macro when appropriate
From: "Ahmed S. Darwish" <darwish.07@gmail.com>

Use ARRAY_SIZE macro already defined in kernel.h

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/bt8xx/dst.c         |    2 +-
 drivers/media/dvb/bt8xx/dvb-bt8xx.c   |    3 ++-
 drivers/media/dvb/frontends/cx24110.c |    4 ++--
 drivers/media/dvb/frontends/cx24123.c |    6 +++---
 drivers/media/dvb/ttpci/av7110_ir.c   |    3 ++-
 5 files changed, 10 insertions(+), 8 deletions(-)

diff -puN drivers/media/dvb/bt8xx/dst.c~dvb-use-array_size-macro-when-appropriate drivers/media/dvb/bt8xx/dst.c
--- a/drivers/media/dvb/bt8xx/dst.c~dvb-use-array_size-macro-when-appropriate
+++ a/drivers/media/dvb/bt8xx/dst.c
@@ -1161,7 +1161,7 @@ static int dst_get_device_id(struct dst_
 		}
 	}
 
-	if (i >= sizeof (dst_tlist) / sizeof (dst_tlist [0])) {
+	if (i >= ARRAY_SIZE(dst_tlist)) {
 		dprintk(verbose, DST_ERROR, 1, "Unable to recognize %s or %s", &state->rxbuffer[0], &state->rxbuffer[1]);
 		dprintk(verbose, DST_ERROR, 1, "please email linux-dvb@linuxtv.org with this type in");
 		use_dst_type = DST_TYPE_IS_SAT;
diff -puN drivers/media/dvb/bt8xx/dvb-bt8xx.c~dvb-use-array_size-macro-when-appropriate drivers/media/dvb/bt8xx/dvb-bt8xx.c
--- a/drivers/media/dvb/bt8xx/dvb-bt8xx.c~dvb-use-array_size-macro-when-appropriate
+++ a/drivers/media/dvb/bt8xx/dvb-bt8xx.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/init.h>
+#include <linux/kernel.h>
 #include <linux/device.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
@@ -213,7 +214,7 @@ static int cx24108_tuner_set_params(stru
 		freq = 2150000; /* satellite IF is 950..2150MHz */
 
 	/* decide which VCO to use for the input frequency */
-	for(i=1;(i<sizeof(osci)/sizeof(osci[0]))&&(osci[i]<freq);i++);
+	for(i=1;(i<ARRAY_SIZE(osci))&&(osci[i]<freq);i++);
 	printk("cx24108 debug: select vco #%d (f=%d)\n",i,freq);
 	band=bandsel[i];
 	/* the gain values must be set by SetSymbolrate */
diff -puN drivers/media/dvb/frontends/cx24110.c~dvb-use-array_size-macro-when-appropriate drivers/media/dvb/frontends/cx24110.c
--- a/drivers/media/dvb/frontends/cx24110.c~dvb-use-array_size-macro-when-appropriate
+++ a/drivers/media/dvb/frontends/cx24110.c
@@ -254,7 +254,7 @@ static int cx24110_set_symbolrate (struc
 	if (srate<500000)
 		srate=500000;
 
-	for(i=0;(i<sizeof(bands)/sizeof(bands[0]))&&(srate>bands[i]);i++)
+	for(i=0;(i<ARRAY_SIZE(bands))&&(srate>bands[i]);i++)
 		;
 	/* first, check which sample rate is appropriate: 45, 60 80 or 90 MHz,
 	   and set the PLL accordingly (R07[1:0] Fclk, R06[7:4] PLLmult,
@@ -361,7 +361,7 @@ static int cx24110_initfe(struct dvb_fro
 
 	dprintk("%s: init chip\n", __FUNCTION__);
 
-	for(i=0;i<sizeof(cx24110_regdata)/sizeof(cx24110_regdata[0]);i++) {
+	for(i=0;i<ARRAY_SIZE(cx24110_regdata);i++) {
 		cx24110_writereg(state, cx24110_regdata[i].reg, cx24110_regdata[i].data);
 	};
 
diff -puN drivers/media/dvb/frontends/cx24123.c~dvb-use-array_size-macro-when-appropriate drivers/media/dvb/frontends/cx24123.c
--- a/drivers/media/dvb/frontends/cx24123.c~dvb-use-array_size-macro-when-appropriate
+++ a/drivers/media/dvb/frontends/cx24123.c
@@ -507,7 +507,7 @@ static int cx24123_pll_calculate(struct 
 	int i = 0;
 	int pump = 2;
 	int band = 0;
-	int num_bands = sizeof(cx24123_bandselect_vals) / sizeof(cx24123_bandselect_vals[0]);
+	int num_bands = ARRAY_SIZE(cx24123_bandselect_vals);
 
 	/* Defaults for low freq, low rate */
 	state->VCAarg = cx24123_AGC_vals[0].VCAprogdata;
@@ -516,7 +516,7 @@ static int cx24123_pll_calculate(struct 
 	vco_div = cx24123_bandselect_vals[0].VCOdivider;
 
 	/* For the given symbol rate, determine the VCA, VGA and FILTUNE programming bits */
-	for (i = 0; i < sizeof(cx24123_AGC_vals) / sizeof(cx24123_AGC_vals[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(cx24123_AGC_vals); i++)
 	{
 		if ((cx24123_AGC_vals[i].symbolrate_low <= p->u.qpsk.symbol_rate) &&
 		    (cx24123_AGC_vals[i].symbolrate_high >= p->u.qpsk.symbol_rate) ) {
@@ -658,7 +658,7 @@ static int cx24123_initfe(struct dvb_fro
 	dprintk("%s:  init frontend\n",__FUNCTION__);
 
 	/* Configure the demod to a good set of defaults */
-	for (i = 0; i < sizeof(cx24123_regdata) / sizeof(cx24123_regdata[0]); i++)
+	for (i = 0; i < ARRAY_SIZE(cx24123_regdata); i++)
 		cx24123_writereg(state, cx24123_regdata[i].reg, cx24123_regdata[i].data);
 
 	/* Set the LNB polarity */
diff -puN drivers/media/dvb/ttpci/av7110_ir.c~dvb-use-array_size-macro-when-appropriate drivers/media/dvb/ttpci/av7110_ir.c
--- a/drivers/media/dvb/ttpci/av7110_ir.c~dvb-use-array_size-macro-when-appropriate
+++ a/drivers/media/dvb/ttpci/av7110_ir.c
@@ -4,6 +4,7 @@
 #include <linux/moduleparam.h>
 #include <linux/input.h>
 #include <linux/proc_fs.h>
+#include <linux/kernel.h>
 #include <asm/bitops.h>
 
 #include "av7110.h"
@@ -217,7 +218,7 @@ int __devinit av7110_ir_init(struct av71
 	static struct proc_dir_entry *e;
 	int err;
 
-	if (av_cnt >= sizeof av_list/sizeof av_list[0])
+	if (av_cnt >= ARRAY_SIZE(av_list))
 		return -ENOSPC;
 
 	av7110_setup_irc_config(av7110, 0x0001);
_

Patches currently in -mm which might be from darwish.07@gmail.com are

arch-arm-use-array_size-macro-when-appropriate.patch
arch-avr32-use-array_size-macro-when-appropriate.patch
arch-powerpc-user-array_size-macro-when-appropriate.patch
arch-ppc-user-array_size-macro-when-appropriate.patch
git-dvb.patch
git-netdev-all.patch
s390-kmalloc-kzalloc-casting-cleanups.patch
dac960-kmalloc-kzalloc-casting-cleanups.patch
arch-arm26-use-array_size-macro-when-appropriate.patch
arch-m68knommu-user-array_size-macro-when-appropriate.patch
arch-m68k-user-array_size-macro-when-appropriate.patch
arch-cris-user-array_size-macro-when-appropriate.patch
arch-v850-user-array_size-macro-when-appropriate.patch
w1-use-array_size-macro-when-appropriate.patch
isdn-capi-use-array_size-when-appropriate.patch
dvb-use-array_size-macro-when-appropriate.patch
isdn-eicon-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate.patch
oss-use-array_size-macro-when-appropriate-2.patch
atm-use-array_size-macro-when-appropriate.patch
drivers-mdc-use-array_size-macro-when-appropriate.patch
s390-drivers-use-array_size-macro-when-appropriate.patch
rcutorture-use-array_size-macro-when-appropriate.patch
intel-agp-use-array_size-macro-when-appropriate.patch
reiserfs-use-array_size-macro-when-appropriate.patch
toshiba-acpi-use-array_size-macro-when-appropriate.patch
drm-use-array_size-macro-when-appropriate.patch
