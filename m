From: akpm@linux-foundation.org
Subject: - softlockup-make-asm-irq_regsh-available-on-every-platform.patch removed from -mm tree
Date: Wed, 17 Oct 2007 23:52:42 -0700
Message-ID: <200710180652.l9I6qgZE030311@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43945 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932522AbXJRHrd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:47:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mingo@elte.hu, benh@kernel.crashing.org, galak@gate.crashing.org, paulus@samba.org, spyro@f2s.com, starvik@axis.com, uclinux-v850@lsi.nec.co.jp, mm-commits@vger.kernel.org


The patch titled
     softlockup: make asm/irq_regs.h available on every platform
has been removed from the -mm tree.  Its filename was
     softlockup-make-asm-irq_regsh-available-on-every-platform.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: softlockup: make asm/irq_regs.h available on every platform
From: Ingo Molnar <mingo@elte.hu>

The softlockup detector would like to use get_irq_regs(), so generalize the
availability on every Linux architecture.

(It is fine for an architecture to always return NULL to get_irq_regs(),
which it does by default.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Ian Molton <spyro@f2s.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Miles Bader <uclinux-v850@lsi.nec.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-arm26/irq_regs.h |    1 +
 include/asm-cris/irq_regs.h  |    1 +
 include/asm-ppc/irq_regs.h   |    1 +
 include/asm-v850/irq_regs.h  |    1 +
 4 files changed, 4 insertions(+)

diff -puN /dev/null include/asm-arm26/irq_regs.h
--- /dev/null
+++ a/include/asm-arm26/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-cris/irq_regs.h
--- /dev/null
+++ a/include/asm-cris/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-ppc/irq_regs.h
--- /dev/null
+++ a/include/asm-ppc/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
diff -puN /dev/null include/asm-v850/irq_regs.h
--- /dev/null
+++ a/include/asm-v850/irq_regs.h
@@ -0,0 +1 @@
+#include <asm-generic/irq_regs.h>
_

Patches currently in -mm which might be from mingo@elte.hu are

origin.patch
git-acpi.patch
git-kvm.patch
net-dccp-fix-link-error-with-config_sysctl.patch
git-netdev-all.patch
fix-build-breakage-if-sysfs-fix.patch
git-x86.patch
hpet-force-enable-on-vt8235-37-chipsets.patch
i386-paravirt-boot-sequence.patch
workqueue-debug-flushing-deadlocks-with-lockdep.patch
workqueue-debug-work-related-deadlocks-with-lockdep.patch
lockdep-fix-mismatched-lockdep_depth-curr_chain_hash-checkpatch-fixes.patch
whitespace-fixes-time-syscalls.patch
whitespace-fixes-interval-timers.patch
whitespace-fixes-system-timers.patch
uninline-find_task_by_xxx-set-of-functions.patch
cpuset-sched_load_balance-flag.patch
cpuset-sched_load_balance-flag-fix.patch
cpuset-sched_load_balance-kmalloc-fix.patch
cpusets-decrustify-cpuset-mask-update-code.patch
cpusets-decrustify-cpuset-mask-update-code-checkpatch-fixes.patch
hotplug-cpu-migrate-a-task-within-its-cpuset.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-whitespace-fix.patch
hotplug-cpu-migrate-a-task-within-its-cpuset-doc.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
uninline-forkc-exitc.patch
uninline-forkc-exitc-checkpatch-fixes.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
lockdep-show-held-locks-when-showing-a-stackdump.patch
kmap_atomic-debugging.patch
