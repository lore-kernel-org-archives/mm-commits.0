From: akpm@linux-foundation.org
Subject: + drivers-hwmon-coretempc-detect-the-thermal-sensors-by-cpuid.patch added to -mm tree
Date: Wed, 19 May 2010 14:57:12 -0700
Message-ID: <201005192157.o4JLvC0P008456@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42848 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751041Ab0ESV5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: C.Emde@osadl.org, hmh@hmh.eng.br, huaxu.wan@linux.intel.com, khali@linux-fr.org, r.marek@assembler.cz, valdis.kletnieks@vt.edu, yong.y.wang@linux.intel.com


The patch titled
     drivers/hwmon/coretemp.c: detect the thermal sensors by CPUID
has been added to the -mm tree.  Its filename is
     drivers-hwmon-coretempc-detect-the-thermal-sensors-by-cpuid.patch

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
Subject: drivers/hwmon/coretemp.c: detect the thermal sensors by CPUID
From: Carsten Emde <C.Emde@osadl.org>

The thermal sensors of Intel(R) CPUs can be detected by CPUID instruction,
indicated by CPUID.06H.EAX[0].

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Reviewed-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/hwmon/coretemp.c |   34 +++++++++++++---------------------
 1 file changed, 13 insertions(+), 21 deletions(-)

diff -puN drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-detect-the-thermal-sensors-by-cpuid drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-detect-the-thermal-sensors-by-cpuid
+++ a/drivers/hwmon/coretemp.c
@@ -451,28 +451,20 @@ static int __init coretemp_init(void)
 
 	for_each_online_cpu(i) {
 		struct cpuinfo_x86 *c = &cpu_data(i);
-
-		/* check if family 6, models 0xe (Pentium M DC),
-		  0xf (Core 2 DC 65nm), 0x16 (Core 2 SC 65nm),
-		  0x17 (Penryn 45nm), 0x1a (Nehalem), 0x1c (Atom),
-		  0x1e (Lynnfield) */
-		if ((c->cpuid_level < 0) || (c->x86 != 0x6) ||
-		    !((c->x86_model == 0xe) || (c->x86_model == 0xf) ||
-			(c->x86_model == 0x16) || (c->x86_model == 0x17) ||
-			(c->x86_model == 0x1a) || (c->x86_model == 0x1c) ||
-			(c->x86_model == 0x1e))) {
-
-			/* supported CPU not found, but report the unknown
-			   family 6 CPU */
-			if ((c->x86 == 0x6) && (c->x86_model > 0xf))
-				printk(KERN_WARNING DRVNAME ": Unknown CPU "
-					"model 0x%x\n", c->x86_model);
-			continue;
+		/*
+		 * CPUID.06H.EAX[0] indicates whether the CPU has thermal
+		 * sensors. We check this bit only, all the early CPUs
+		 * without thermal sensors will be filtered out.
+		 */
+		if (c->cpuid_level >= 6 && (cpuid_eax(0x06) & 0x01)) {
+			err = coretemp_device_add(i);
+			if (err)
+				goto exit_devices_unreg;
+
+		} else {
+			printk(KERN_INFO DRVNAME ": CPU (model=0x%x)"
+				" has no thermal sensor.\n", c->x86_model);
 		}
