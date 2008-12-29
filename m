From: akpm@linux-foundation.org
Subject: - x86-remove-init_mm-export-as-planned-for-2626.patch removed from -mm tree
Date: Mon, 29 Dec 2008 11:18:36 -0800
Message-ID: <200812291918.mBTJIaR8030971@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33022 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751989AbYL2T0N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 29 Dec 2008 14:26:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, hch@lst.de, mingo@elte.hu, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     x86: remove init_mm export as planned for 2.6.26
has been removed from the -mm tree.  Its filename was
     x86-remove-init_mm-export-as-planned-for-2626.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: x86: remove init_mm export as planned for 2.6.26
From: Dave Jones <davej@redhat.com>

Signed-off-by: Dave Jones <davej@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/feature-removal-schedule.txt |   12 ------------
 arch/x86/kernel/init_task.c                |    1 -
 2 files changed, 13 deletions(-)

diff -puN Documentation/feature-removal-schedule.txt~x86-remove-init_mm-export-as-planned-for-2626 Documentation/feature-removal-schedule.txt
--- a/Documentation/feature-removal-schedule.txt~x86-remove-init_mm-export-as-planned-for-2626
+++ a/Documentation/feature-removal-schedule.txt
@@ -237,18 +237,6 @@ Who:	Michael Buesch <mb@bu3sch.de>
 
 ---------------------------
 
-What:	init_mm export
-When:	2.6.26
-Why:	Not used in-tree. The current out-of-tree users used it to
-	work around problems in the CPA code which should be resolved
-	by now. One usecase was described to provide verification code
-	of the CPA operation. That's a good idea in general, but such
-	code / infrastructure should be in the kernel and not in some
-	out-of-tree driver.
-Who:	Thomas Gleixner <tglx@linutronix.de>
-
-----------------------------
-
 What:	usedac i386 kernel parameter
 When:	2.6.27
 Why:	replaced by allowdac and no dac combination
diff -puN arch/x86/kernel/init_task.c~x86-remove-init_mm-export-as-planned-for-2626 arch/x86/kernel/init_task.c
--- a/arch/x86/kernel/init_task.c~x86-remove-init_mm-export-as-planned-for-2626
+++ a/arch/x86/kernel/init_task.c
@@ -14,7 +14,6 @@ static struct fs_struct init_fs = INIT_F
 static struct signal_struct init_signals = INIT_SIGNALS(init_signals);
 static struct sighand_struct init_sighand = INIT_SIGHAND(init_sighand);
 struct mm_struct init_mm = INIT_MM(init_mm);
-EXPORT_UNUSED_SYMBOL(init_mm); /* will be removed in 2.6.26 */
 
 /*
  * Initial thread structure.
_

Patches currently in -mm which might be from davej@redhat.com are

origin.patch
linux-next.patch
linuxpps-core-support.patch
pps-userland-header-file-for-pps-api.patch
pps-documentation-programs-and-examples.patch
pps-linuxpps-clients-support.patch
ldisc-new-dcd_change-method-for-line-disciplines.patch
pps-parallel-port-clients-support.patch

