From: akpm@linux-foundation.org
Subject: + v4l-drx397xdc-replace-__function__-occurrences.patch added to -mm tree
Date: Tue, 29 Jul 2008 14:54:08 -0700
Message-ID: <200807292154.m6TLs81P023535@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55912 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755288AbYG2VyU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 Jul 2008 17:54:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com


The patch titled
     v4l: drx397xD.c replace __FUNCTION__ occurrences
has been added to the -mm tree.  Its filename is
     v4l-drx397xdc-replace-__function__-occurrences.patch

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
Subject: v4l: drx397xD.c replace __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/media/dvb/frontends/drx397xD.c |   34 +++++++++++------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN drivers/media/dvb/frontends/drx397xD.c~v4l-drx397xdc-replace-__function__-occurrences drivers/media/dvb/frontends/drx397xD.c
--- a/drivers/media/dvb/frontends/drx397xD.c~v4l-drx397xdc-replace-__function__-occurrences
+++ a/drivers/media/dvb/frontends/drx397xD.c
@@ -96,7 +96,7 @@ static void drx_release_fw(struct drx397
 {
 	fw_ix_t ix = s->chip_rev;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	write_lock(&fw[ix].lock);
 	if (fw[ix].refcnt) {
@@ -113,7 +113,7 @@ static int drx_load_fw(struct drx397xD_s
 	size_t size, len;
 	int i = 0, j, rc = -EINVAL;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (ix < 0 || ix >= ARRAY_SIZE(fw))
 		return -EINVAL;
@@ -197,10 +197,10 @@ static int write_fw(struct drx397xD_stat
 	int len, rc = 0, i = 0;
 
 	if (ix < 0 || ix >= ARRAY_SIZE(blob_name)) {
-		pr_debug("%s drx_fw_ix_t out of range\n", __FUNCTION__);
+		pr_debug("%s drx_fw_ix_t out of range\n", __func__);
 		return -EINVAL;
 	}
-	pr_debug("%s %s\n", __FUNCTION__, blob_name[ix]);
+	pr_debug("%s %s\n", __func__, blob_name[ix]);
 
 	read_lock(&fw[s->chip_rev].lock);
 	data = fw[s->chip_rev].data[ix];
@@ -305,7 +305,7 @@ static int PLL_Set(struct drx397xD_state
 	u32 f_tuner, f = fep->frequency;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if ((f > s->frontend.ops.tuner_ops.info.frequency_max) ||
 	    (f < s->frontend.ops.tuner_ops.info.frequency_min))
@@ -325,7 +325,7 @@ static int PLL_Set(struct drx397xD_state
 		return rc;
 
 	*df_tuner = f_tuner - f;
-	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __FUNCTION__, f,
+	pr_debug("%s requested %d [Hz] tuner %d [Hz]\n", __func__, f,
 		 f_tuner);
 
 	return 0;
@@ -340,7 +340,7 @@ static int SC_WaitForReady(struct drx397
 	int cnt = 1000;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	while (cnt--) {
 		rc = RD16(s, 0x820043);
@@ -354,7 +354,7 @@ static int SC_SendCommand(struct drx397x
 {
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	WR16(s, 0x820043, cmd);
 	SC_WaitForReady(s);
@@ -368,7 +368,7 @@ static int HI_Command(struct drx397xD_st
 {
 	int rc, cnt = 1000;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	rc = WR16(s, 0x420032, cmd);
 	if (rc < 0)
@@ -389,7 +389,7 @@ static int HI_Command(struct drx397xD_st
 static int HI_CfgCommand(struct drx397xD_state *s)
 {
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	WR16(s, 0x420033, 0x3973);
 	WR16(s, 0x420034, s->config.w50);	// code 4, log 4
@@ -419,7 +419,7 @@ static int SetCfgIfAgc(struct drx397xD_s
 	u16 w0C = agc->w0C;
 	int quot, rem, i, rc = -EINVAL;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (agc->w04 > 0x3ff)
 		goto exit_rc;
@@ -478,7 +478,7 @@ static int SetCfgRfAgc(struct drx397xD_s
 	u16 w06 = agc->w06;
 	int rc = -1;
 
-	pr_debug("%s %d 0x%x 0x%x\n", __FUNCTION__, agc->d00, w04, w06);
+	pr_debug("%s %d 0x%x 0x%x\n", __func__, agc->d00, w04, w06);
 
 	if (w04 > 0x3ff)
 		goto exit_rc;
@@ -554,7 +554,7 @@ static int CorrectSysClockDeviation(stru
 	int lockstat;
 	u32 clk, clk_limit;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	if (s->config.d5C == 0) {
 		EXIT_RC(WR16(s, 0x08200e8, 0x010));
@@ -598,7 +598,7 @@ static int CorrectSysClockDeviation(stru
 
 	if (clk - s->config.f_osc * 1000 + clk_limit <= 2 * clk_limit) {
 		s->f_osc = clk;
-		pr_debug("%s: osc %d %d [Hz]\n", __FUNCTION__,
+		pr_debug("%s: osc %d %d [Hz]\n", __func__,
 			 s->config.f_osc * 1000, clk - s->config.f_osc * 1000);
 	}
 	rc = WR16(s, 0x08200e8, 0);
@@ -610,7 +610,7 @@ static int ConfigureMPEGOutput(struct dr
 {
 	int rc, si, bp;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	si = s->config.wA0;
 	if (s->config.w98 == 0) {
@@ -646,7 +646,7 @@ static int drx_tune(struct drx397xD_stat
 
 	int rc, df_tuner;
 	int a, b, c, d;
-	pr_debug("%s %d\n", __FUNCTION__, s->config.d60);
+	pr_debug("%s %d\n", __func__, s->config.d60);
 
 	if (s->config.d60 != 2)
 		goto set_tuner;
@@ -1082,7 +1082,7 @@ static int drx397x_init(struct dvb_front
 	struct drx397xD_state *s = fe->demodulator_priv;
 	int rc;
 
-	pr_debug("%s\n", __FUNCTION__);
+	pr_debug("%s\n", __func__);
 
 	s->config.rfagc.d00 = 2;	/* 0x7c */
 	s->config.rfagc.w04 = 0;
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

linux-next.patch
cifs-remove-global_extern-macro.patch
ppc-use-the-common-ascii-hex-helpers.patch
ppc-use-the-common-ascii-hex-helpers-fix.patch
v4l-drx397xdc-sparse-annotations.patch
v4l-drx397xdc-replace-__function__-occurrences.patch
input-ads7846c-sparse-lock-annotation.patch
mtd-diskonchipc-fix-sparse-endian-warnings.patch
net-use-the-common-ascii-hex-helpers.patch
isdn-use-the-common-ascii-hex-helpers.patch
scsi-replace-__inline-with-inline.patch
scsi-aic79xx_core-fix-shadowed-variables-add-statics.patch
scsi-aic79xx-aic79xx_pcic-fix-shadowed-variables.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-gdthc-use-unaligned-access-helpers-checkpatch-fixes.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
xfs-use-get_unaligned_-helpers.patch
xtensa-replace-remaining-__function__-occurences.patch
olpc-olpc_batteryc-sparse-endian-annotations.patch
befs-annotate-fs32-on-tests-for-superblock-endianness.patch
byteorder-add-a-new-include-linux-swabh-to-define-byteswapping-functions.patch
byteorder-add-include-linux-byteorderh-to-define-endian-helpers.patch

