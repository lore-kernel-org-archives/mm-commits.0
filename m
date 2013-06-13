From: akpm@linux-foundation.org
Subject: [withdrawn] drivers-base-cpuc-fix-maxcpus-boot-option.patch
 removed from -mm tree
Date: Thu, 13 Jun 2013 11:16:05 -0700
Message-ID: <51ba0c65.DhUYG2rhdGH9I/EN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab3FMSQH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 13 Jun 2013 14:16:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, stable@vger.kernel.org, greg@kroah.com, youquan.song@intel.com

Subject: [withdrawn] drivers-base-cpuc-fix-maxcpus-boot-option.patch removed from -mm tree
To: youquan.song@intel.com,greg@kroah.com,stable@vger.kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 13 Jun 2013 11:16:05 -0700


The patch titled
     Subject: drivers/base/cpu.c: fix maxcpus boot option
has been removed from the -mm tree.  Its filename was
     drivers-base-cpuc-fix-maxcpus-boot-option.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Youquan Song <youquan.song@intel.com>
Subject: drivers/base/cpu.c: fix maxcpus boot option

The maxcpus boot option limits the maximum number of CPUs in the system,
but this option is broken in recent kernels.  Though we use maxcpus to
limit CPUs number, the current kernel will register all of the present
CPUs in sysfs.  udev will enumerate all registered cpu in sysfs, and it
will bring up the CPU if the CPU is offline.  So the maxcpus option is
broken.

This patch will only register a CPU which is not over the limit of the
maxcpus option in sysfs.  So it will keep the maxcpus limitation during
udev enumeration or other bringup of CPUs over the limitation by methods
such as echo 1 > /sys/devices/system/cpu/online

[akpm@linux-foundation.org: fix CONFIG_SMP=n build]
Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option
+++ a/drivers/base/cpu.c
@@ -272,6 +272,12 @@ int __cpuinit register_cpu(struct cpu *c
 {
 	int error;
 
+#ifdef CONFIG_SMP
+	/* return when cpu number greater than maximum number of CPUs */
+	if (num >= setup_max_cpus)
+		return 0;
+#endif
+
 	cpu->node_id = cpu_to_node(num);
 	memset(&cpu->dev, 0x00, sizeof(struct device));
 	cpu->dev.id = num;
_

Patches currently in -mm which might be from youquan.song@intel.com are


