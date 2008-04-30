From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-warnings-in-cpu_down.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:10 -0700
Message-ID: <200804300539.m3U5dAUa028814@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48677 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753849AbYD3Fjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch warnings in *cpu_down
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-warnings-in-cpu_down.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warnings in *cpu_down
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.text+0x75c8d): Section mismatch in reference from the function take_cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d2a): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75d4d): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75de4): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain
WARNING: vmlinux.o(.text+0x75e33): Section mismatch in reference from the function _cpu_down() to the variable .cpuinit.data:cpu_chain

cpu_down is only used from code surrounded by HOTPLUG_CPU so any references to
__cpuinit is OK.

Add a few __ref to tech modpost to ignore the references.

This is just papering over the fact that the cpu hotplug code is fragile with
respect to use of HOTPLUG_CPU and in many cases rely on __cpuinit to get rid
of code when HOTPLUG_CPU is not enabled.  For now this is the least invasive
change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warnings-in-cpu_down kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warnings-in-cpu_down
+++ a/kernel/cpu.c
@@ -180,7 +180,7 @@ struct take_cpu_down_param {
 };
 
 /* Take this CPU down. */
-static int take_cpu_down(void *_param)
+static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
 	int err;
@@ -199,7 +199,7 @@ static int take_cpu_down(void *_param)
 }
 
 /* Requires cpu_add_remove_lock to be held */
-static int _cpu_down(unsigned int cpu, int tasks_frozen)
+static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
 	struct task_struct *p;
@@ -274,7 +274,7 @@ out_release:
 	return err;
 }
 
-int cpu_down(unsigned int cpu)
+int __ref cpu_down(unsigned int cpu)
 {
 	int err = 0;
 
_

Patches currently in -mm which might be from sam@ravnborg.org are

origin.patch
git-x86.patch
git-m32r.patch
pcmcia-silence-section-mismatch-warnings-from-class_interface-variables.patch
pcmcia-silence-section-mismatch-warnings-from-pci_driver-variables.patch
pcmcia-annotate-cb_alloc-with-__ref.patch
git-pci.patch
git-s390.patch
git-sh.patch
scsi-fix-section-mismatch-in-aic94xx.patch
git-watchdog.patch
documentation-build-source-files-in-documentation-sub-dir.patch
remove-ifdef-__kernel__-checks-from-unexported-headers.patch

