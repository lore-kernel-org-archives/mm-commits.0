From: akpm@linux-foundation.org
Subject: [merged] cpufreq-powernow-k8-determine-exact-cpu-frequency-for-hw-pstates.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:45 -0700
Message-ID: <200905272055.n4RKtjfI025934@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43746 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758088AbZE0U43 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 16:56:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.herrmann3@amd.com, davej@codemonkey.org.uk, trenn@suse.de, mm-commits@vger.kernel.org


The patch titled
     cpufreq: powernow-k8: determine exact CPU frequency for HW Pstates
has been removed from the -mm tree.  Its filename was
     cpufreq-powernow-k8-determine-exact-cpu-frequency-for-hw-pstates.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpufreq: powernow-k8: determine exact CPU frequency for HW Pstates
From: Andreas Herrmann <andreas.herrmann3@amd.com>

Slightly modified by trenn@suse.de -> only do this on fam 10h and fam 11h.

Currently powernow-k8 determines CPU frequency from ACPI PSS objects, but
according to AMD family 11h BKDG this frequency is just a rounded value:

  "CoreFreq (MHz) = The CPU COF specified by MSRC001_00[6B:64][CpuFid]
  rounded to the nearest 100 Mhz."

As a consequnce powernow-k8 reports wrong CPU frequency on some systems,
e.g. on Turion X2 Ultra:

  powernow-k8: Found 1 AMD Turion(tm)X2 Ultra DualCore Mobile ZM-82
               processors (2 cpu cores) (version 2.20.00)
  powernow-k8:    0 : pstate 0 (2200 MHz)
  powernow-k8:    1 : pstate 1 (1100 MHz)
  powernow-k8:    2 : pstate 2 (600 MHz)

But this is wrong as frequency for Pstate2 is 550 MHz. x86info reports it
correctly:

  #x86info -a |grep Pstate
  ...
  Pstate-0: fid=e, did=0, vid=24 (2200MHz)
  Pstate-1: fid=e, did=1, vid=30 (1100MHz)
  Pstate-2: fid=e, did=2, vid=3c (550MHz) (current)

Solution is to determine the frequency directly from Pstate MSRs instead
of using rounded values from ACPI table.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
Signed-off-by: Thomas Renninger <trenn@suse.de>
Cc: Dave Jones <davej@codemonkey.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |   23 ++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff -puN arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-determine-exact-cpu-frequency-for-hw-pstates arch/x86/kernel/cpu/cpufreq/powernow-k8.c
--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c~cpufreq-powernow-k8-determine-exact-cpu-frequency-for-hw-pstates
+++ a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -639,6 +639,20 @@ static void print_basics(struct powernow
 				data->batps);
 }
 
+static u32 freq_from_fid_did(u32 fid, u32 did)
+{
+	u32 mhz = 0;
+
+	if (boot_cpu_data.x86 == 0x10)
+		mhz = (100 * (fid + 0x10)) >> did;
+	else if (boot_cpu_data.x86 == 0x11)
+		mhz = (100 * (fid + 8)) >> did;
+	else
+		BUG();
+
+	return mhz * 1000;
+}
+
 static int fill_powernow_table(struct powernow_k8_data *data,
 		struct pst_s *pst, u8 maxvid)
 {
@@ -913,8 +927,13 @@ static int fill_powernow_table_pstate(st
 
 		powernow_table[i].index = index;
 
-		powernow_table[i].frequency =
-			data->acpi_data.states[i].core_frequency * 1000;
+		/* Frequency may be rounded for these */
+		if (boot_cpu_data.x86 == 0x10 || boot_cpu_data.x86 == 0x11) {
+			powernow_table[i].frequency =
+				freq_from_fid_did(lo & 0x3f, (lo >> 6) & 7);
+		} else
+			powernow_table[i].frequency =
+				data->acpi_data.states[i].core_frequency * 1000;
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from andreas.herrmann3@amd.com are

origin.patch
linux-next.patch

