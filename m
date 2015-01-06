From: akpm@linux-foundation.org
Subject: [to-be-updated]
 powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch removed from -mm tree
Date: Tue, 06 Jan 2015 13:02:50 -0800
Message-ID: <54ac4d7a.6XcZqhWD0/a6Kw9i%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42587 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAFVCz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 6 Jan 2015 16:02:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cyrilbur@gmail.com, atomlin@redhat.com, benh@kernel.crashing.org, benzh@chromium.org, chaiw.fnst@cn.fujitsu.com, drjones@redhat.com, dzickus@redhat.com, fabf@skynet.be, mingo@kernel.org, mpe@ellerman.id.au, tglx@linutronix.de, uobergfe@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: powerpc: add running_clock for powerpc to prevent spurious softlockup warnings
has been removed from the -mm tree.  Its filename was
     powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Cyril Bur <cyrilbur@gmail.com>
Subject: powerpc: add running_clock for powerpc to prevent spurious softlockup warnings

On POWER8 virtualised kernels the VTB register can be read to have a view
of time that only increases while the guest is running.  This will prevent
guests from seeing time jump if a guest is paused for significant amounts
of time.

On POWER7 and below virtualised kernels stolen time is subtracted from
sched_clock as a best effort approximation.  This will not eliminate
spurious warnings in the case of a suspended guest but may reduce the
occurrence in the case of softlockups due to host over commit.

Bare metal kernels should avoid reading the VTB as KVM does not restore
sane values when not executing.  sched_clock is returned in this case.

Signed-off-by: Cyril Bur <cyrilbur@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Jones <drjones@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Ulrich Obergfell <uobergfe@redhat.com>
Cc: chai wen <chaiw.fnst@cn.fujitsu.com>
Cc: Fabian Frederick <fabf@skynet.be>
Cc: Aaron Tomlin <atomlin@redhat.com>
Cc: Ben Zhang <benzh@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/time.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff -puN arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings arch/powerpc/kernel/time.c
--- a/arch/powerpc/kernel/time.c~powerpc-add-running_clock-for-powerpc-to-prevent-spurious-softlockup-warnings
+++ a/arch/powerpc/kernel/time.c
@@ -621,6 +621,30 @@ unsigned long long sched_clock(void)
 	return mulhdu(get_tb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
 }
 
+unsigned long long running_clock(void)
+{
+	/*
+	 * Don't read the VTB as a host since KVM does not switch in host timebase
+	 * into the VTB when it takes a guest off the CPU, reading the VTB would
+	 * result in reading 'last switched out' guest VTB.
+	 */
+
+	if (firmware_has_feature(FW_FEATURE_LPAR)) {
+		if (cpu_has_feature(CPU_FTR_ARCH_207S))
+			return mulhdu(get_vtb() - boot_tb, tb_to_ns_scale) << tb_to_ns_shift;
+
+		/* This is a next best approximation without a VTB. */
+		return sched_clock() - cputime_to_nsecs(kcpustat_this_cpu->cpustat[CPUTIME_STEAL]);
+	}
+
+	/*
+	 * On a host which doesn't do any virtualisation TB *should* equal VTB so
+	 * it makes no difference anyway.
+	 */
+
+	return sched_clock();
+}
+
 static int __init get_freq(char *name, int cells, unsigned long *val)
 {
 	struct device_node *cpu;
_

Patches currently in -mm which might be from cyrilbur@gmail.com are


