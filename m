From: akpm@linux-foundation.org
Subject: + m68knommu-reformat-show_cpuinfo.patch added to -mm tree
Date: Thu, 19 Jul 2007 23:25:50 -0700
Message-ID: <200707200625.l6K6PoY8011375@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:56911 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754072AbXGTG0x (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 02:26:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: reformat show_cpuinfo()
has been added to the -mm tree.  Its filename is
     m68knommu-reformat-show_cpuinfo.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: m68knommu: reformat show_cpuinfo()
From: Greg Ungerer <gerg@snapgear.com>

Reformat show_cpuinfo() to be consistent with normal coding style
(and rest of this file).

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/m68knommu/kernel/setup.c |   37 ++++++++++++++++----------------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff -puN arch/m68knommu/kernel/setup.c~m68knommu-reformat-show_cpuinfo arch/m68knommu/kernel/setup.c
--- a/arch/m68knommu/kernel/setup.c~m68knommu-reformat-show_cpuinfo
+++ a/arch/m68knommu/kernel/setup.c
@@ -231,32 +231,33 @@ void setup_arch(char **cmdline_p)
 /*
  *	Get CPU information for use by the procfs.
  */
-
 static int show_cpuinfo(struct seq_file *m, void *v)
 {
-    char *cpu, *mmu, *fpu;
-    u_long clockfreq;
+	char *cpu, *mmu, *fpu;
+	u_long clockfreq;
 
-    cpu = CPU;
-    mmu = "none";
-    fpu = "none";
+	cpu = CPU;
+	mmu = "none";
+	fpu = "none";
 
 #ifdef CONFIG_COLDFIRE
-    clockfreq = (loops_per_jiffy*HZ)*3;
+	clockfreq = (loops_per_jiffy * HZ) * 3;
 #else
-    clockfreq = (loops_per_jiffy*HZ)*16;
+	clockfreq = (loops_per_jiffy * HZ) * 16;
 #endif
 
-    seq_printf(m, "CPU:\t\t%s\n"
-		   "MMU:\t\t%s\n"
-		   "FPU:\t\t%s\n"
-		   "Clocking:\t%lu.%1luMHz\n"
-		   "BogoMips:\t%lu.%02lu\n"
-		   "Calibration:\t%lu loops\n",
-		   cpu, mmu, fpu,
-		   clockfreq/1000000,(clockfreq/100000)%10,
-		   (loops_per_jiffy*HZ)/500000,((loops_per_jiffy*HZ)/5000)%100,
-		   (loops_per_jiffy*HZ));
+	seq_printf(m, "CPU:\t\t%s\n"
+		      "MMU:\t\t%s\n"
+		      "FPU:\t\t%s\n"
+		      "Clocking:\t%lu.%1luMHz\n"
+		      "BogoMips:\t%lu.%02lu\n"
+		      "Calibration:\t%lu loops\n",
+		      cpu, mmu, fpu,
+		      clockfreq / 1000000,
+		      (clockfreq / 100000) % 10,
+		      (loops_per_jiffy * HZ) / 500000,
+		      ((loops_per_jiffy * HZ) / 5000) % 100,
+		      (loops_per_jiffy * HZ));
 
 	return 0;
 }
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
m68knommu-reformat-show_cpuinfo.patch
git-mtd.patch
