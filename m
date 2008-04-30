From: akpm@linux-foundation.org
Subject: - cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch removed from -mm tree
Date: Tue, 29 Apr 2008 22:39:08 -0700
Message-ID: <200804300539.m3U5d8Z4028811@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43468 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753787AbYD3Fjn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 30 Apr 2008 01:39:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sam@ravnborg.org, ego@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cpu: fix section mismatch warning in unregister_cpu_notifier
has been removed from the -mm tree.  Its filename was
     cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cpu: fix section mismatch warning in unregister_cpu_notifier
From: Sam Ravnborg <sam@ravnborg.org>

Fix following warning:
WARNING: vmlinux.o(.text+0x75f4e): Section mismatch in reference from the function unregister_cpu_notifier() to the variable .cpuinit.data:cpu_chain

We know that unregister_cpu_notifier is using HOTPLUG_CPU
stuff - so ignore these references.
Annotating unregister_cpu_notifier had been another option
but this caused far more warnings since not all callers were
annotated __cpuinit.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Gautham R Shenoy <ego@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/cpu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/cpu.c~cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier kernel/cpu.c
--- a/kernel/cpu.c~cpu-fix-section-mismatch-warning-in-unregister_cpu_notifier
+++ a/kernel/cpu.c
@@ -149,7 +149,7 @@ int __cpuinit register_cpu_notifier(stru
 
 EXPORT_SYMBOL(register_cpu_notifier);
 
-void unregister_cpu_notifier(struct notifier_block *nb)
+void __ref unregister_cpu_notifier(struct notifier_block *nb)
 {
 	cpu_maps_update_begin();
 	raw_notifier_chain_unregister(&cpu_chain, nb);
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

