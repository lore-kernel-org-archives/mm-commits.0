From: akpm@linux-foundation.org
Subject: - ia64-fix-unlock-ordering-in-smp_callin.patch removed from -mm tree
Date: Thu, 10 Apr 2008 13:01:30 -0700
Message-ID: <200804102001.m3AK1U7Q014979@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59688 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757475AbYDJUCG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Apr 2008 16:02:06 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Alan.Brunelle@hp.com, alan.brunelle@hp.com, mm-commits@vger.kernel.org


The patch titled
     ia64: fix unlock ordering in smp_callin
has been removed from the -mm tree.  Its filename was
     ia64-fix-unlock-ordering-in-smp_callin.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix unlock ordering in smp_callin
From: "Alan D. Brunelle" <Alan.Brunelle@hp.com>

One should normally unlock in the reverse order of the lock calls, and in this
case there certainly is no reason not to.

To better see the results (with locks included), here's the complete
section of corrected code:

        lock_ipi_calllock();
        spin_lock(&vector_lock);
        /* Setup the per cpu irq handling data structures */
        __setup_vector_irq(cpuid);
        cpu_set(cpuid, cpu_online_map);
        per_cpu(cpu_state, cpuid) = CPU_ONLINE;
        spin_unlock(&vector_lock);
        unlock_ipi_calllock();

Signed-off-by: Alan D. Brunelle <alan.brunelle@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/smpboot.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/smpboot.c~ia64-fix-unlock-ordering-in-smp_callin arch/ia64/kernel/smpboot.c
--- a/arch/ia64/kernel/smpboot.c~ia64-fix-unlock-ordering-in-smp_callin
+++ a/arch/ia64/kernel/smpboot.c
@@ -400,9 +400,9 @@ smp_callin (void)
 	/* Setup the per cpu irq handling data structures */
 	__setup_vector_irq(cpuid);
 	cpu_set(cpuid, cpu_online_map);
-	unlock_ipi_calllock();
 	per_cpu(cpu_state, cpuid) = CPU_ONLINE;
 	spin_unlock(&vector_lock);
+	unlock_ipi_calllock();
 
 	smp_setup_percpu_timer();
 
_

Patches currently in -mm which might be from Alan.Brunelle@hp.com are

git-ia64.patch

