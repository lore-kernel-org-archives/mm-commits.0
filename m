From: akpm@linux-foundation.org
Subject: - powerpc-sysfs-fix-compiler-warning.patch removed from -mm tree
Date: Wed, 18 Jul 2007 17:11:15 -0700
Message-ID: <200707190011.l6J0BGQl004284@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50797 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754599AbXGSAL5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 20:11:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: krafft@de.ibm.com, arnd.bergmann@de.ibm.com, mm-commits@vger.kernel.org


The patch titled
     powerpc: sysfs fix compiler warning
has been removed from the -mm tree.  Its filename was
     powerpc-sysfs-fix-compiler-warning.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
Subject: powerpc: sysfs fix compiler warning
From: Christian Krafft <krafft@de.ibm.com>

This patch fixes the following compiler warning:
arch/powerpc/kernel/sysfs.c:385: warning: ignoring return value of
`sysfs_create_group',

Signed-off-by: Christian Krafft <krafft@de.ibm.com>
Signed-off-by: Arnd Bergmann <arnd.bergmann@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/kernel/sysfs.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff -puN arch/powerpc/kernel/sysfs.c~powerpc-sysfs-fix-compiler-warning arch/powerpc/kernel/sysfs.c
--- a/arch/powerpc/kernel/sysfs.c~powerpc-sysfs-fix-compiler-warning
+++ a/arch/powerpc/kernel/sysfs.c
@@ -380,16 +380,25 @@ int cpu_add_sysdev_attr_group(struct att
 {
 	int cpu;
 	struct sys_device *sysdev;
+	int error = 0;
 
 	mutex_lock(&cpu_mutex);
 
 	for_each_possible_cpu(cpu) {
 		sysdev = get_cpu_sysdev(cpu);
-		sysfs_create_group(&sysdev->kobj, attrs);
+		error = sysfs_create_group(&sysdev->kobj, attrs);
+
+		if (error) {
+			for_each_possible_cpu(cpu) {
+				sysdev = get_cpu_sysdev(cpu);
+				sysfs_remove_group(&sysdev->kobj, attrs);
+			}
+			break;
+		}
 	}
 
 	mutex_unlock(&cpu_mutex);
-	return 0;
+	return error;
 }
 EXPORT_SYMBOL_GPL(cpu_add_sysdev_attr_group);
 
_

Patches currently in -mm which might be from krafft@de.ibm.com are

cell-pmi-remove-support-for-mutiple-devices.patch
cell-cbe_cpufreq-fix-latency-measurement.patch
cell-cbe_cpufreq-fix-initialization.patch
cell-cbe_cpufreq-fix-minor-issues.patch
cell-cbe_cpufreq-reorganize-code.patch
cell-fix-cbe_cpufreq-for-legacy-slof-tree.patch
cell-fix-cbe_regc-for-legacy-slof-tree.patch
cell-fix-cbe_thermal-for-legacy-slof-tree.patch
cell-allow-linux-to-map-cell-regs-on-legacy-slof-tree.patch
powerpc-sysfs-fix-compiler-warning.patch
