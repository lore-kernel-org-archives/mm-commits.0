From: akpm@linux-foundation.org
Subject: + cpufreq-powernow-k8-support-family-0xf-with-2-low-p-states.patch added to -mm tree
Date: Thu, 02 Jul 2009 16:00:21 -0700
Message-ID: <200907022300.n62N0LTT031605@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756588AbZGBXAn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 2 Jul 2009 19:00:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mark.langsdorf@amd.com, davej@codemonkey.org.uk


The patch titled
     cpufreq: powernow-k8: support family 0xf with 2 low p-states
has been added to the -mm tree.  Its filename is
     cpufreq-powernow-k8-support-family-0xf-with-2-low-p-states.patch

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
Subject: cpufreq: powernow-k8: support family 0xf with 2 low p-states
From: Mark Langsdorf <mark.langsdorf@amd.com>

Provide support for family 0xf processors with 2 P-states below the
elevator voltage.  Remove the checks that prevent this configuration from
being supported and increase the transition voltage to prevent errors
during the transition.

Signed-off-by: Mark Langsdorf <mark.langsdorf@amd.com>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   30 +++++++-------------
 arch/x86/kernel/cpu/cpufreq/powernow-k8.h |    3 +-
 2 files changed, 13 insertions(+), 20 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-support-family-0xf-with-2-low-p-states arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-support-family-0xf-with-2-low-p-states
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -299,7 +299,7 @@ static int transition_pstate(struct powe
 static int transition_fid_vid(struct powernow_k8_data *data,
 		u32 reqfid, u32 reqvid)
 {
-	if (core_voltage_pre_transition(data, reqvid))
+	if (core_voltage_pre_transition(data, reqvid, reqfid))
 		return 1;
 
 	if (core_frequency_transition(data, reqfid))
@@ -327,17 +327,20 @@ static int transition_fid_vid(struct pow
 
 /* Phase 1 - core voltage transition ... setup voltage */
 static int core_voltage_pre_transition(struct powernow_k8_data *data,
-		u32 reqvid)
+		u32 reqvid, u32 reqfid)
 {
 	u32 rvosteps = data->rvo;
 	u32 savefid = data->currfid;
-	u32 maxvid, lo;
+	u32 maxvid, lo, rvomult = 1;
 
 	dprintk("ph1 (cpu%d): start, currfid 0x%x, currvid 0x%x, "
 		"reqvid 0x%x, rvo 0x%x\n",
 		smp_processor_id(),
 		data->currfid, data->currvid, reqvid, data->rvo);
 
+	if ((savefid < LO_FID_TABLE_TOP) && (reqfid < LO_FID_TABLE_TOP))
+		rvomult = 2;
+	rvosteps *= rvomult;
 	rdmsr(MSR_FIDVID_STATUS, lo, maxvid);
 	maxvid = 0x1f & (maxvid >> 16);
 	dprintk("ph1 maxvid=0x%x\n", maxvid);
@@ -351,7 +354,8 @@ static int core_voltage_pre_transition(s
 			return 1;
 	}
 
-	while ((rvosteps > 0) && ((data->rvo + data->currvid) > reqvid)) {
+	while ((rvosteps > 0) &&
+			((rvomult * data->rvo + data->currvid) > reqvid)) {
 		if (data->currvid == maxvid) {
 			rvosteps = 0;
 		} else {
@@ -384,13 +388,6 @@ static int core_frequency_transition(str
 	u32 vcoreqfid, vcocurrfid, vcofiddiff;
 	u32 fid_interval, savevid = data->currvid;
 
-	if ((reqfid < HI_FID_TABLE_BOTTOM) &&
-	    (data->currfid < HI_FID_TABLE_BOTTOM)) {
-		printk(KERN_ERR PFX "ph2: illegal lo-lo transition "
-				"0x%x 0x%x\n", reqfid, data->currfid);
-		return 1;
-	}
-
 	if (data->currfid == reqfid) {
 		printk(KERN_ERR PFX "ph2 null fid transition 0x%x\n",
 				data->currfid);
@@ -407,6 +404,9 @@ static int core_frequency_transition(str
 	vcofiddiff = vcocurrfid > vcoreqfid ? vcocurrfid - vcoreqfid
 	    : vcoreqfid - vcocurrfid;
 
+	if ((reqfid <= LO_FID_TABLE_TOP) && (data->currfid <= LO_FID_TABLE_TOP))
+		vcofiddiff = 0;
+
 	while (vcofiddiff > 2) {
 		(data->currfid & 1) ? (fid_interval = 1) : (fid_interval = 2);
 
@@ -1081,14 +1081,6 @@ static int transition_frequency_fidvid(s
 		return 0;
 	}
 
-	if ((fid < HI_FID_TABLE_BOTTOM) &&
-	    (data->currfid < HI_FID_TABLE_BOTTOM)) {
-		printk(KERN_ERR PFX
-		       "ignoring illegal change in lo freq table-%x to 0x%x\n",
-		       data->currfid, fid);
-		return 1;
-	}
