From: akpm@osdl.org
Subject: - x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code.patch removed from -mm tree
Date: Sat, 09 Dec 2006 17:52:44 -0800
Message-ID: <200612100152.kBA1qi1J010600@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40598 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759223AbWLJBxx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sat, 9 Dec 2006 20:53:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: kiran@scalex86.org, ak@muc.de, shai@scalex86.org, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     x86_64: fix boot hang due to nmi watchdog init code
has been removed from the -mm tree.  Its filename was
     x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: fix boot hang due to nmi watchdog init code
From: Ravikiran G Thirumalai <kiran@scalex86.org>

2.6.19 stopped booting (or booted based on build/config) on our x86_64
systems due to a bug introduced in 2.6.19.  check_nmi_watchdog schedules an
IPI on all cpus to busy wait on a flag, but fails to set the busywait flag
if NMI functionality is disabled.

This causes the secondary cpus to spin in an endless loop, causing the
kernel bootup to hang.

Depending upon the build, the busywait flag got overwritten (stack
variable) and caused the kernel to bootup on certain builds.  Following
patch fixes the bug by setting the busywait flag before returning from
check_nmi_watchdog.

I guess using a stack variable is not good here as the calling function
could potentially return while the busy wait loop is still spinning on the
flag.  I would think this is a good candidate for 2.6.19 stable as well.

[akpm@osdl.org: cleanups]
Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
Signed-off-by: Shai Fultheim <shai@scalex86.org>
Cc: Andi Kleen <ak@muc.de>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/x86_64/kernel/nmi.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN arch/x86_64/kernel/nmi.c~x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code arch/x86_64/kernel/nmi.c
--- a/arch/x86_64/kernel/nmi.c~x86_64-fix-boot-hang-due-to-nmi-watchdog-init-code
+++ a/arch/x86_64/kernel/nmi.c
@@ -215,7 +215,7 @@ static __init void nmi_cpu_busy(void *da
 
 int __init check_nmi_watchdog (void)
 {
-	volatile int endflag = 0;
+	static int __initdata endflag;
 	int *counts;
 	int cpu;
 
@@ -256,6 +256,7 @@ int __init check_nmi_watchdog (void)
 	if (!atomic_read(&nmi_active)) {
 		kfree(counts);
 		atomic_set(&nmi_active, -1);
+		endflag = 1;
 		return -1;
 	}
 	endflag = 1;
_

Patches currently in -mm which might be from kiran@scalex86.org are

origin.patch
slab-leaks3-default-y.patch

