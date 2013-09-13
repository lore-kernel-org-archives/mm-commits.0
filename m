From: akpm@linux-foundation.org
Subject: [merged]
 arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch removed from -mm tree
Date: Fri, 13 Sep 2013 13:02:22 -0700
Message-ID: <52336f4e.mQbyGsPVWxemzMUf%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37945 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab3IMUCX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Sep 2013 16:02:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com, azurit@pobox.sk, hannes@cmpxchg.org

Subject: [merged] arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch removed from -mm tree
To: hannes@cmpxchg.org,azurit@pobox.sk,kamezawa.hiroyu@jp.fujitsu.com,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 13 Sep 2013 13:02:22 -0700


The patch titled
     Subject: arch: mm: do not invoke OOM killer on kernel fault OOM
has been removed from the -mm tree.  Its filename was
     arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: arch: mm: do not invoke OOM killer on kernel fault OOM

Kernel faults are expected to handle OOM conditions gracefully (gup,
uaccess etc.), so they should never invoke the OOM killer.  Reserve this
for faults triggered in user context when it is the only option.

Most architectures already do this, fix up the remaining few.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: azurIt <azurit@pobox.sk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/fault.c       |   14 +++++++-------
 arch/arm64/mm/fault.c     |   14 +++++++-------
 arch/avr32/mm/fault.c     |    2 +-
 arch/mips/mm/fault.c      |    2 ++
 arch/um/kernel/trap.c     |    2 ++
 arch/unicore32/mm/fault.c |   14 +++++++-------
 6 files changed, 26 insertions(+), 22 deletions(-)

diff -puN arch/arm/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/arm/mm/fault.c
--- a/arch/arm/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/arm/mm/fault.c
@@ -349,6 +349,13 @@ retry:
 	if (likely(!(fault & (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -359,13 +366,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to
diff -puN arch/arm64/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/arm64/mm/fault.c
--- a/arch/arm64/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/arm64/mm/fault.c
@@ -288,6 +288,13 @@ retry:
 			      VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we have no context to
+	 * handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -298,13 +305,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we have no context to
-	 * handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
-
 	if (fault & VM_FAULT_SIGBUS) {
 		/*
 		 * We had some memory, but were unable to successfully fix up
diff -puN arch/avr32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/avr32/mm/fault.c
--- a/arch/avr32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/avr32/mm/fault.c
@@ -228,9 +228,9 @@ no_context:
 	 */
 out_of_memory:
 	up_read(&mm->mmap_sem);
-	pagefault_out_of_memory();
 	if (!user_mode(regs))
 		goto no_context;
+	pagefault_out_of_memory();
 	return;
 
 do_sigbus:
diff -puN arch/mips/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/mips/mm/fault.c
--- a/arch/mips/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/mips/mm/fault.c
@@ -241,6 +241,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!user_mode(regs))
+		goto no_context;
 	pagefault_out_of_memory();
 	return;
 
diff -puN arch/um/kernel/trap.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/um/kernel/trap.c
--- a/arch/um/kernel/trap.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/um/kernel/trap.c
@@ -124,6 +124,8 @@ out_of_memory:
 	 * (which will retry the fault, or kill us if we got oom-killed).
 	 */
 	up_read(&mm->mmap_sem);
+	if (!is_user)
+		goto out_nosemaphore;
 	pagefault_out_of_memory();
 	return 0;
 }
diff -puN arch/unicore32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom arch/unicore32/mm/fault.c
--- a/arch/unicore32/mm/fault.c~arch-mm-do-not-invoke-oom-killer-on-kernel-fault-oom
+++ a/arch/unicore32/mm/fault.c
@@ -278,6 +278,13 @@ retry:
 	       (VM_FAULT_ERROR | VM_FAULT_BADMAP | VM_FAULT_BADACCESS))))
 		return 0;
 
+	/*
+	 * If we are in kernel mode at this point, we
+	 * have no context to handle this fault with.
+	 */
+	if (!user_mode(regs))
+		goto no_context;
+
 	if (fault & VM_FAULT_OOM) {
 		/*
 		 * We ran out of memory, call the OOM killer, and return to
@@ -288,13 +295,6 @@ retry:
 		return 0;
 	}
 
-	/*
-	 * If we are in kernel mode at this point, we
-	 * have no context to handle this fault with.
-	 */
-	if (!user_mode(regs))
-		goto no_context;
