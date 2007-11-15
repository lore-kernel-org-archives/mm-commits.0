From: akpm@linux-foundation.org
Subject: - vmstat-fix-section-mismatch-warning.patch removed from -mm tree
Date: Thu, 15 Nov 2007 13:10:44 -0800
Message-ID: <200711152110.lAFLAiTx015685@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40682 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932259AbXKOVSS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Nov 2007 16:18:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     vmstat: fix section mismatch warning
has been removed from the -mm tree.  Its filename was
     vmstat-fix-section-mismatch-warning.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: vmstat: fix section mismatch warning
From: Randy Dunlap <randy.dunlap@oracle.com>

Mark start_cpu_timer() as __cpuinit instead of __devinit.
Fixes this section warning:

WARNING: vmlinux.o(.text+0x60e53): Section mismatch: reference to .init.text:start_cpu_timer (between 'vmstat_cpuup_callback' and 'vmstat_show')

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Christoph Lameter <clameter@sgi.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmstat.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/vmstat.c~vmstat-fix-section-mismatch-warning mm/vmstat.c
--- a/mm/vmstat.c~vmstat-fix-section-mismatch-warning
+++ a/mm/vmstat.c
@@ -803,7 +803,7 @@ static void vmstat_update(struct work_st
 		sysctl_stat_interval);
 }
 
-static void __devinit start_cpu_timer(int cpu)
+static void __cpuinit start_cpu_timer(int cpu)
 {
 	struct delayed_work *vmstat_work = &per_cpu(vmstat_work, cpu);
 
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
git-dvb.patch
git-kbuild.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
