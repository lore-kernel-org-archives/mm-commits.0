From: akpm@linux-foundation.org
Subject: + drivers-hwmon-coretempc-get-tjmax-value-from-msr.patch added to -mm tree
Date: Wed, 19 May 2010 14:57:16 -0700
Message-ID: <201005192157.o4JLvHSe008459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751069Ab0ESV5p (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 19 May 2010 17:57:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: C.Emde@osadl.org, hmh@hmh.eng.br, huaxu.wan@linux.intel.com, khali@linux-fr.org, r.marek@assembler.cz, valdis.kletnieks@vt.edu, yong.y.wang@linux.intel.com


The patch titled
     drivers/hwmon/coretemp.c: get TjMax value from MSR
has been added to the -mm tree.  Its filename is
     drivers-hwmon-coretempc-get-tjmax-value-from-msr.patch

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
Subject: drivers/hwmon/coretemp.c: get TjMax value from MSR
From: Carsten Emde <C.Emde@osadl.org>

The MSR IA32_TEMPERATURE_TARGET contains the TjMax value in the newer
Intel processors.

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Carsten Emde <C.Emde@osadl.org>
Cc: Jean Delvare <khali@linux-fr.org>
Cc: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Yong Wang <yong.y.wang@linux.intel.com>
Cc: Rudolf Marek <r.marek@assembler.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/msr-index.h |    2 
 drivers/hwmon/coretemp.c         |   61 +++++++++++++++++++++++++++--
 2 files changed, 59 insertions(+), 4 deletions(-)

diff -puN arch/x86/include/asm/msr-index.h~drivers-hwmon-coretempc-get-tjmax-value-from-msr arch/x86/include/asm/msr-index.h
--- a/arch/x86/include/asm/msr-index.h~drivers-hwmon-coretempc-get-tjmax-value-from-msr
+++ a/arch/x86/include/asm/msr-index.h
@@ -236,6 +236,8 @@
 
 #define MSR_IA32_MISC_ENABLE		0x000001a0
 
+#define MSR_IA32_TEMPERATURE_TARGET	0x000001a2
+
 /* MISC_ENABLE bits: architectural */
 #define MSR_IA32_MISC_ENABLE_FAST_STRING	(1ULL << 0)
 #define MSR_IA32_MISC_ENABLE_TCC		(1ULL << 1)
diff -puN drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-get-tjmax-value-from-msr drivers/hwmon/coretemp.c
--- a/drivers/hwmon/coretemp.c~drivers-hwmon-coretempc-get-tjmax-value-from-msr
+++ a/drivers/hwmon/coretemp.c
@@ -241,6 +241,55 @@ static int __devinit adjust_tjmax(struct
 	return tjmax;
 }
 
+static int __devinit get_tjmax(struct cpuinfo_x86 *c, u32 id,
+			       struct device *dev)
+{
+	/* The 100C is default for both mobile and non mobile CPUs */
+	int err;
+	u32 eax, edx;
+	u32 val;
+
+	/* A new feature of current Intel(R) processors, the
+	   IA32_TEMPERATURE_TARGET contains the TjMax value */
+	err = rdmsr_safe_on_cpu(id, MSR_IA32_TEMPERATURE_TARGET, &eax, &edx);
+	if (err) {
+		dev_warn(dev, "Unable to read TjMax from CPU.\n");
+	} else {
+		val = (eax >> 16) & 0xff;
+		/*
+		 * If the TjMax is not plausible, an assumption
+		 * will be used
+		 */
+		if ((val > 80) && (val < 120)) {
+			dev_info(dev, "TjMax is %d C.\n", val);
+			return val * 1000;
+		}
+	}
+
+	/*
+	 * An assumption is made for early CPUs and unreadable MSR.
+	 * NOTE: the given value may not be correct.
+	 */
+
+	switch (c->x86_model) {
+	case 0xe:
+	case 0xf:
+	case 0x16:
+	case 0x1a:
+		dev_warn(dev, "TjMax is assumed as 100 C!\n");
+		return 100000;
+		break;
+	case 0x17:
+	case 0x1c:		/* Atom CPUs */
+		return adjust_tjmax(c, id, dev);
+		break;
+	default:
+		dev_warn(dev, "CPU (model=0x%x) is not supported yet,"
+			" using default TjMax of 100C.\n", c->x86_model);
+		return 100000;
+	}
+}
+
 static int __devinit coretemp_probe(struct platform_device *pdev)
 {
 	struct coretemp_data *data;
@@ -283,14 +332,18 @@ static int __devinit coretemp_probe(stru
 		}
 	}
 
-	data->tjmax = adjust_tjmax(c, data->id, &pdev->dev);
+	data->tjmax = get_tjmax(c, data->id, &pdev->dev);
 	platform_set_drvdata(pdev, data);
 
-	/* read the still undocumented IA32_TEMPERATURE_TARGET it exists
-	   on older CPUs but not in this register, Atoms don't have it either */
+	/*
+	 * read the still undocumented IA32_TEMPERATURE_TARGET. It exists
+	 * on older CPUs but not in this register,
+	 * Atoms don't have it either.
+	 */
 
 	if ((c->x86_model > 0xe) && (c->x86_model != 0x1c)) {
-		err = rdmsr_safe_on_cpu(data->id, 0x1a2, &eax, &edx);
+		err = rdmsr_safe_on_cpu(data->id, MSR_IA32_TEMPERATURE_TARGET,
+		    &eax, &edx);
 		if (err) {
 			dev_warn(&pdev->dev, "Unable to read"
 					" IA32_TEMPERATURE_TARGET MSR\n");
_

Patches currently in -mm which might be from C.Emde@osadl.org are

linux-next.patch
drivers-hwmon-coretempc-detect-the-thermal-sensors-by-cpuid.patch
drivers-hwmon-coretempc-get-tjmax-value-from-msr.patch

