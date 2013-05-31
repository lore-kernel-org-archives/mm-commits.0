From: akpm@linux-foundation.org
Subject: + drivers-base-cpuc-fix-maxcpus-boot-option.patch added to -mm
 tree
Date: Fri, 31 May 2013 14:54:49 -0700
Message-ID: <51a91c29.MdilbnYVjcp5+mJO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40870 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab3EaVyu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 31 May 2013 17:54:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, greg@kroah.com, youquan.song@intel.com

Subject: + drivers-base-cpuc-fix-maxcpus-boot-option.patch added to -mm tree
To: youquan.song@intel.com,greg@kroah.com
From: akpm@linux-foundation.org
Date: Fri, 31 May 2013 14:54:49 -0700


The patch titled
     Subject: drivers/base/cpu.c: fix maxcpus boot option
has been added to the -mm tree.  Its filename is
     drivers-base-cpuc-fix-maxcpus-boot-option.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: Greg KH <greg@kroah.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/cpu.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option drivers/base/cpu.c
--- a/drivers/base/cpu.c~drivers-base-cpuc-fix-maxcpus-boot-option
+++ a/drivers/base/cpu.c
@@ -275,6 +275,10 @@ int __cpuinit register_cpu(struct cpu *c
 {
 	int error;
 
+	/* return when cpu number greater than maximum number of CPUs */
+	if (num >= setup_max_cpus)
+		return 0;
+
 	cpu->node_id = cpu_to_node(num);
 	memset(&cpu->dev, 0x00, sizeof(struct device));
 	cpu->dev.id = num;
_

Patches currently in -mm which might be from youquan.song@intel.com are

drivers-base-cpuc-fix-maxcpus-boot-option.patch

