From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:05 -0700
Message-ID: <200804300539.m3U5d5Tr028808@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34727 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753749AbYD3Fjp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch warnings in hotcpu_register
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-warnings-in-hotcpu_register.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warnings in hotcpu_register
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warnings:
WARNING: vmlinux.o(.data+0x5020): Section mismatch in reference from the variable cpu_vsyscall_notifier_nb.12876 to the function .cpuinit.text:cpu_vsyscall_notifier()
WARNING: vmlinux.o(.data+0x9ce0): Section mismatch in reference from the variable profile_cpu_callback_nb.17654 to the function .devinit.text:profile_cpu_callback()
WARNING: vmlinux.o(.data+0xd380): Section mismatch in reference from the variable workqueue_cpu_callback_nb.15004 to the function .devinit.text:workqueue_cpu_callback()
WARNING: vmlinux.o(.data+0x11d00): Section mismatch in reference from the variable relay_hotcpu_callback_nb.19626 to the function .cpuinit.text:relay_hotcpu_callback()
WARNING: vmlinux.o(.data+0x12970): Section mismatch in reference from the variable cpu_callback_nb.24694 to the function .devinit.text:cpu_callback()
WARNING: vmlinux.o(.data+0x3fee0): Section mismatch in reference from the variable percpu_counter_hotcpu_callback_nb.10903 to the function .cpuinit.text:percpu_counter_hotcpu_callback()
WARNING: vmlinux.o(.data+0x74ce0): Section mismatch in reference from the variable topology_cpu_callback_nb.12506 to the function .cpuinit.text:topology_cpu_callback()

Functions used as argument are by definition only used in HOTPLUG_CPU
situations so thay are annotated __cpuinit.  Annotate the static variable used
by hotcpu_register with __cpuinitdata to match this definition.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cpu.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/cpu.h~cpu-fix-section-mismatch-warnings-in-hotcpu_register include/linux/cpu.h
--- a/include/linux/cpu.h~cpu-fix-section-mismatch-warnings-in-hotcpu_register
+++ a/include/linux/cpu.h
@@ -108,7 +108,7 @@ static inline void cpuhotplug_mutex_unlo
 extern void get_online_cpus(void);
 extern void put_online_cpus(void);
 #define hotcpu_notifier(fn, pri) {				\
-	static struct notifier_block fn##_nb =			\
+	static struct notifier_block fn##_nb __cpuinitdata =	\
 		{ .notifier_call = fn, .priority = pri };	\
 	register_cpu_notifier(&fn##_nb);			\
 }
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

