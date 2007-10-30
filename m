From: akpm@linux-foundation.org
Subject: + vmstat-fix-section-mismatch-warning.patch added to -mm tree
Date: Tue, 30 Oct 2007 13:36:36 -0700
Message-ID: <200710302036.l9UKaaTk026943@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59751 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754528AbXJ3UhI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Oct 2007 16:37:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, clameter@sgi.com


The patch titled
     vmstat: fix section mismatch warning
has been added to the -mm tree.  Its filename is
     vmstat-fix-section-mismatch-warning.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
voyager-use-struct-instead-of-param.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
