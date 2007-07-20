From: akpm@linux-foundation.org
Subject: - m68knommu-reformat-show_cpuinfo.patch removed from -mm tree
Date: Fri, 20 Jul 2007 12:42:04 -0700
Message-ID: <200707201942.l6KJg49N013060@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46629 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763578AbXGTTmp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 20 Jul 2007 15:42:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: reformat show_cpuinfo()
has been removed from the -mm tree.  Its filename was
     m68knommu-reformat-show_cpuinfo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
git-mtd.patch
