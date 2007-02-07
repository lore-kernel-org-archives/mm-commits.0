From: akpm@linux-foundation.org
Subject: - kexec-fix-config_smp=n-compilation-v2-ia64.patch removed from -mm tree
Date: Wed, 07 Feb 2007 11:52:15 -0800
Message-ID: <200702071952.l17JqFIw025227@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:33777 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422909AbXBGTxs (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Feb 2007 14:53:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: magnus@valinux.co.jp, horms@verge.net.au, jlan@sgi.com, stable@kernel.org, tony.luck@intel.com, mm-commits@vger.kernel.org


The patch titled
     kexec: Fix CONFIG_SMP=n compilation V2 (ia64)
has been removed from the -mm tree.  Its filename was
     kexec-fix-config_smp=n-compilation-v2-ia64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kexec: Fix CONFIG_SMP=n compilation V2 (ia64)
From: Magnus Damm <magnus@valinux.co.jp>

Kexec support for 2.6.20 on ia64 does not build properly using a config
made up by CONFIG_SMP=n and CONFIG_HOTPLUG_CPU=n:

  CC      arch/ia64/kernel/machine_kexec.o
arch/ia64/kernel/machine_kexec.c: In function `machine_shutdown':
arch/ia64/kernel/machine_kexec.c:77: warning: implicit declaration of function `cpu_down'
  AS      arch/ia64/kernel/relocate_kernel.o
  CC      arch/ia64/kernel/crash.o
arch/ia64/kernel/crash.c: In function `kdump_cpu_freeze':
arch/ia64/kernel/crash.c:139: warning: implicit declaration of function `ia64_jump_to_sal'
arch/ia64/kernel/crash.c:139: error: `sal_boot_rendez_state' undeclared (first use in this function)
arch/ia64/kernel/crash.c:139: error: (Each undeclared identifier is reported only once
arch/ia64/kernel/crash.c:139: error: for each function it appears in.)
arch/ia64/kernel/crash.c: At top level:
arch/ia64/kernel/crash.c:84: warning: 'kdump_wait_cpu_freeze' defined but not used
make[1]: *** [arch/ia64/kernel/crash.o] Error 1
make: *** [arch/ia64/kernel] Error 2

Signed-off-by: Magnus Damm <magnus@valinux.co.jp>
Acked-by: Simon Horman <horms@verge.net.au>
Acked-by: Jay Lan <jlan@sgi.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/crash.c         |   11 +++++++----
 arch/ia64/kernel/machine_kexec.c |    2 ++
 2 files changed, 9 insertions(+), 4 deletions(-)

diff -puN arch/ia64/kernel/crash.c~kexec-fix-config_smp=n-compilation-v2-ia64 arch/ia64/kernel/crash.c
--- a/arch/ia64/kernel/crash.c~kexec-fix-config_smp=n-compilation-v2-ia64
+++ a/arch/ia64/kernel/crash.c
@@ -79,6 +79,7 @@ crash_save_this_cpu()
 	final_note(buf);
 }
 
+#ifdef CONFIG_SMP
 static int
 kdump_wait_cpu_freeze(void)
 {
@@ -91,6 +92,7 @@ kdump_wait_cpu_freeze(void)
 	}
 	return 1;
 }
+#endif
 
 void
 machine_crash_shutdown(struct pt_regs *pt)
@@ -132,11 +134,12 @@ kdump_cpu_freeze(struct unw_frame_info *
 	atomic_inc(&kdump_cpu_freezed);
 	kdump_status[cpuid] = 1;
 	mb();
-	if (cpuid == 0) {
-		for (;;)
-			cpu_relax();
-	} else
+#ifdef CONFIG_HOTPLUG_CPU
+	if (cpuid != 0)
 		ia64_jump_to_sal(&sal_boot_rendez_state[cpuid]);
+#endif
+	for (;;)
+		cpu_relax();
 }
 
 static int
diff -puN arch/ia64/kernel/machine_kexec.c~kexec-fix-config_smp=n-compilation-v2-ia64 arch/ia64/kernel/machine_kexec.c
--- a/arch/ia64/kernel/machine_kexec.c~kexec-fix-config_smp=n-compilation-v2-ia64
+++ a/arch/ia64/kernel/machine_kexec.c
@@ -70,12 +70,14 @@ void machine_kexec_cleanup(struct kimage
 
 void machine_shutdown(void)
 {
+#ifdef CONFIG_HOTPLUG_CPU
 	int cpu;
 
 	for_each_online_cpu(cpu) {
 		if (cpu != smp_processor_id())
 			cpu_down(cpu);
 	}
+#endif
 	kexec_disable_iosapic();
 }
 
_

Patches currently in -mm which might be from magnus@valinux.co.jp are

origin.patch
