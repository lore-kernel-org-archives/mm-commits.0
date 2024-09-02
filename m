Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D5A14E2D6
	for <mm-commits@vger.kernel.org>; Mon,  2 Sep 2024 03:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725248828; cv=none; b=Rk9fZNSkRgYAVtpVv3sNjaPpAME7kSJlZPOQOjjpgRcyRvZ+UMFehfN5ezqkdOFLB3G5H9RrvvI+uNfA11hLk9tVDxhKuRXLrnLFWzFR0MpsQz6cFLlotkSSfVAdQ1+hSHFKe3xezwj3urBJKOa80KP/25Os+R5y6pvBNBCHmZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725248828; c=relaxed/simple;
	bh=ybvkVKkR0wtO4rMSFOuJvNh5wmz1xJ/KdtTpfDxDyAU=;
	h=Date:To:From:Subject:Message-Id; b=FIAgcvFOk2JimVgynQxa9+RuV6XfJnLluoMBfrNwCOotp2aiq0tVInXcoe+bUfR/Z8wm5BjLWAphWq/Ye43KT/HuPR/4ch79Jgq3XqWwIibp2KFu5ZM78pZPcWCjesjf2AxKUXKwiv1zmzEsXIWMU1WymBh+h3fy393ppirbYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FcnU1Fx8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FcnU1Fx8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC1C4CEC2;
	Mon,  2 Sep 2024 03:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725248828;
	bh=ybvkVKkR0wtO4rMSFOuJvNh5wmz1xJ/KdtTpfDxDyAU=;
	h=Date:To:From:Subject:From;
	b=FcnU1Fx8cbEQGvIo8tPzRj4nMD6GHmZs4ptIzrjM2JVpBRjIpQyXcz3IkpoW1BBSa
	 SB6KrmaYmG2xejFQqVb6SHnILDdhsqDwXj+o542+r7riL/Ec6+zYyx2hNcSlmgRxOD
	 YRflLOZ3aYgqnl5Mz/dqVAhhduoG13ypJWjmwNFY=
Date: Sun, 01 Sep 2024 20:47:08 -0700
To: mm-commits@vger.kernel.org,ptesarik@suse.com,petr@tesarici.cz,hbathini@linux.ibm.com,corbet@lwn.net,bhe@redhat.com,sourabhjain@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] document-kexec-generalize-crash-hotplug-description.patch removed from -mm tree
Message-Id: <20240902034708.88EC1C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Document/kexec: generalize crash hotplug description
has been removed from the -mm tree.  Its filename was
     document-kexec-generalize-crash-hotplug-description.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Sourabh Jain <sourabhjain@linux.ibm.com>
Subject: Document/kexec: generalize crash hotplug description
Date: Mon, 12 Aug 2024 09:46:51 +0530

Commit 79365026f869 ("crash: add a new kexec flag for hotplug support")
generalizes the crash hotplug support to allow architectures to update
multiple kexec segments on CPU/Memory hotplug and not just elfcorehdr. 
Therefore, update the relevant kernel documentation to reflect the same.

No functional change.

Link: https://lkml.kernel.org/r/20240812041651.703156-1-sourabhjain@linux.ibm.com
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Reviewed-by: Petr Tesarik <ptesarik@suse.com>
Acked-by: Baoquan He <bhe@redhat.com>
Cc: Hari Bathini <hbathini@linux.ibm.com>
Cc: Petr Tesarik <petr@tesarici.cz>
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ABI/testing/sysfs-devices-memory     |    6 +-
 Documentation/ABI/testing/sysfs-devices-system-cpu |    6 +-
 Documentation/admin-guide/mm/memory-hotplug.rst    |    5 +
 Documentation/core-api/cpu_hotplug.rst             |   10 ++-
 kernel/crash_core.c                                |   33 ++++++-----
 5 files changed, 35 insertions(+), 25 deletions(-)

--- a/Documentation/ABI/testing/sysfs-devices-memory~document-kexec-generalize-crash-hotplug-description
+++ a/Documentation/ABI/testing/sysfs-devices-memory
@@ -115,6 +115,6 @@ What:		/sys/devices/system/memory/crash_
 Date:		Aug 2023
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:
-		(RO) indicates whether or not the kernel directly supports
-		modifying the crash elfcorehdr for memory hot un/plug and/or
-		on/offline changes.
+		(RO) indicates whether or not the kernel updates relevant kexec
+		segments on memory hot un/plug and/or on/offline events, avoiding the
+		need to reload kdump kernel.
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu~document-kexec-generalize-crash-hotplug-description
+++ a/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -704,9 +704,9 @@ What:		/sys/devices/system/cpu/crash_hot
 Date:		Aug 2023
 Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
 Description:
-		(RO) indicates whether or not the kernel directly supports
-		modifying the crash elfcorehdr for CPU hot un/plug and/or
-		on/offline changes.
+		(RO) indicates whether or not the kernel updates relevant kexec
+		segments on memory hot un/plug and/or on/offline events, avoiding the
+		need to reload kdump kernel.
 
 What:		/sys/devices/system/cpu/enabled
 Date:		Nov 2022
--- a/Documentation/admin-guide/mm/memory-hotplug.rst~document-kexec-generalize-crash-hotplug-description
+++ a/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -294,8 +294,9 @@ The following files are currently define
 ``crash_hotplug``      read-only: when changes to the system memory map
 		       occur due to hot un/plug of memory, this file contains
 		       '1' if the kernel updates the kdump capture kernel memory
-		       map itself (via elfcorehdr), or '0' if userspace must update
-		       the kdump capture kernel memory map.
+		       map itself (via elfcorehdr and other relevant kexec
+		       segments), or '0' if userspace must update the kdump
+		       capture kernel memory map.
 
 		       Availability depends on the CONFIG_MEMORY_HOTPLUG kernel
 		       configuration option.
--- a/Documentation/core-api/cpu_hotplug.rst~document-kexec-generalize-crash-hotplug-description
+++ a/Documentation/core-api/cpu_hotplug.rst
@@ -737,8 +737,9 @@ can process the event further.
 
 When changes to the CPUs in the system occur, the sysfs file
 /sys/devices/system/cpu/crash_hotplug contains '1' if the kernel
-updates the kdump capture kernel list of CPUs itself (via elfcorehdr),
-or '0' if userspace must update the kdump capture kernel list of CPUs.
+updates the kdump capture kernel list of CPUs itself (via elfcorehdr and
+other relevant kexec segment), or '0' if userspace must update the kdump
+capture kernel list of CPUs.
 
 The availability depends on the CONFIG_HOTPLUG_CPU kernel configuration
 option.
@@ -750,8 +751,9 @@ file can be used in a udev rule as follo
  SUBSYSTEM=="cpu", ATTRS{crash_hotplug}=="1", GOTO="kdump_reload_end"
 
 For a CPU hot un/plug event, if the architecture supports kernel updates
-of the elfcorehdr (which contains the list of CPUs), then the rule skips
-the unload-then-reload of the kdump capture kernel.
+of the elfcorehdr (which contains the list of CPUs) and other relevant
+kexec segments, then the rule skips the unload-then-reload of the kdump
+capture kernel.
 
 Kernel Inline Documentations Reference
 ======================================
--- a/kernel/crash_core.c~document-kexec-generalize-crash-hotplug-description
+++ a/kernel/crash_core.c
@@ -505,7 +505,7 @@ int crash_check_hotplug_support(void)
 	crash_hotplug_lock();
 	/* Obtain lock while reading crash information */
 	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
+		pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
 		crash_hotplug_unlock();
 		return 0;
 	}
@@ -520,18 +520,25 @@ int crash_check_hotplug_support(void)
 }
 
 /*
- * To accurately reflect hot un/plug changes of cpu and memory resources
- * (including onling and offlining of those resources), the elfcorehdr
- * (which is passed to the crash kernel via the elfcorehdr= parameter)
- * must be updated with the new list of CPUs and memories.
+ * To accurately reflect hot un/plug changes of CPU and Memory resources
+ * (including onling and offlining of those resources), the relevant
+ * kexec segments must be updated with latest CPU and Memory resources.
  *
- * In order to make changes to elfcorehdr, two conditions are needed:
- * First, the segment containing the elfcorehdr must be large enough
- * to permit a growing number of resources; the elfcorehdr memory size
- * is based on NR_CPUS_DEFAULT and CRASH_MAX_MEMORY_RANGES.
- * Second, purgatory must explicitly exclude the elfcorehdr from the
- * list of segments it checks (since the elfcorehdr changes and thus
- * would require an update to purgatory itself to update the digest).
+ * Architectures must ensure two things for all segments that need
+ * updating during hotplug events:
+ *
+ * 1. Segments must be large enough to accommodate a growing number of
+ *    resources.
+ * 2. Exclude the segments from SHA verification.
+ *
+ * For example, on most architectures, the elfcorehdr (which is passed
+ * to the crash kernel via the elfcorehdr= parameter) must include the
+ * new list of CPUs and memory. To make changes to the elfcorehdr, it
+ * should be large enough to permit a growing number of CPU and Memory
+ * resources. One can estimate the elfcorehdr memory size based on
+ * NR_CPUS_DEFAULT and CRASH_MAX_MEMORY_RANGES. The elfcorehdr is
+ * excluded from SHA verification by default if the architecture
+ * supports crash hotplug.
  */
 static void crash_handle_hotplug_event(unsigned int hp_action, unsigned int cpu, void *arg)
 {
@@ -540,7 +547,7 @@ static void crash_handle_hotplug_event(u
 	crash_hotplug_lock();
 	/* Obtain lock while changing crash information */
 	if (!kexec_trylock()) {
-		pr_info("kexec_trylock() failed, elfcorehdr may be inaccurate\n");
+		pr_info("kexec_trylock() failed, kdump image may be inaccurate\n");
 		crash_hotplug_unlock();
 		return;
 	}
_

Patches currently in -mm which might be from sourabhjain@linux.ibm.com are


