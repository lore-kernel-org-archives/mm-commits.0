From: akpm@linux-foundation.org
Subject: [merged]
 powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch removed from -mm tree
Date: Fri, 13 Feb 2015 12:21:55 -0800
Message-ID: <54de5ce3.0R1dZmf7bPw+AbuP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:49071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111AbbBMUV4 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 15:21:56 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, atomlin@redhat.com, benzh@chromium.org, chaiw.fnst@cn.fujitsu.com, drjones@redhat.com, dzickus@redhat.com, fabf@skynet.be, john.stultz@linaro.org, mingo@kernel.org, mpe@ellerman.id.au, schwidefsky@de.ibm.com, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add running_clock for powerpc to prevent spurious softlockup warnings
has been removed from the -mm tree.  Its filename was
     powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyril Bur <cyrilbur@gmail.com>
Subject: powerpc: add running_clock for powerpc to prevent spurious softlockup warnings

On POWER8 virtualised kernels the VTB register can be read to have a view
of time that only increases while the guest is running.  This will prevent
guests from seeing time jump if a guest is paused for significant amounts
of time.

On POWER7 and below virtualised kernels stolen time is subtracted from
local_clock as a best effort approximation.  This will not eliminate
spurious warnings in the case of a suspended guest but may reduce the
occurance in the case of softlockups due to host over commit.

Bare metal kernels should avoid reading the VTB as KVM does not restore
sane values when not executing, the approxmation is fine as host kernels
won't observe any stolen time.

[akpm@linux-foundation.org: coding-style fixes]
Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andrew Jones <drjones@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ben Zhang <benzh@chromium.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |   32 ++++++++++++++++++++++++++++++++
 1 file changed, 32 insertions(+)

diff -puN arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings
+++ a/arch/powerpc/kernel/time.c
@@ -621,6 +621,38 @@ unsigned long long sched_clock(void)
 	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
 }
 
+
+#ifdef CONFIG_PPC_PSERIES
+
+/*
+ * Running clock - attempts to give a view of time passing for a virtualised
+ * kernels.
+ * Uses the VTB register if available otherwise a next best guess.
+ */
+unsigned long long running_clock(void)
+{
+	/*
+	 * Don't read the VTB as a host since KVM does not switch in host
+	 * timebase into the VTB when it takes a guest off the CPU, reading the
+	 * VTB would result in reading 'last switched out' guest VTB.
+	 *
+	 * Host kernels are often compiled with CONFIG_PPC_PSERIES checked, it
+	 * would be unsafe to rely only on the #ifdef above.
+	 */
+	if (firmware_has_feature(FW_FEATURE_LPAR) &&
+	    cpu_has_feature(CPU_FTR_ARCH_207S))
+		return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+
+	/*
+	 * This is a next best approximation without a VTB.
+	 * On a host which is running bare metal there should never be any stolen
+	 * time and on a host which doesn't do any virtualisation TB *should* equal
+	 * VTB so it makes no difference anyway.
+	 */
+	return local_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);
+}
+#endif
+
 static int __init get_freq(char *name, int cells, unsigned long *val)
 {
 	struct device_node *cpu;
_

Patches currently in -mm which might be from cyrilbur@gmail.com are

origin.patch

