From: akpm@linux-foundation.org
Subject: - msi-fix-arm-compile.patch removed from -mm tree
Date: Thu, 03 May 2007 12:31:24 -0700
Message-ID: <200705031931.l43JVO81018265@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:40155 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S376310AbXECTem (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 15:34:42 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, ebiederm@xmission.com, greg@kroah.com, rmk@arm.linux.org.uk, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     msi: fix ARM compile
has been removed from the -mm tree.  Its filename was
     msi-fix-arm-compile.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: msi: fix ARM compile
From: Dan Williams <dan.j.williams@intel.com>

In file included from drivers/pci/msi.c:22:
include/asm/smp.h:17:26: asm/arch/smp.h: No such file or directory
include/asm/smp.h:20:3: #error "<asm-arm/smp.h> included in non-SMP build"
include/asm/smp.h:23:1: warning: "raw_smp_processor_id" redefined
In file included from include/linux/sched.h:65,
                 from include/linux/mm.h:4,
                 from drivers/pci/msi.c:10:
include/linux/smp.h:85:1: warning: this is the location of the previous
definition

Tested on powerpc, i386, and x86_64.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Eric W. Biederman <ebiederm@xmission.com>
Cc: Greg KH <greg@kroah.com>
Cc: <stable@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/pci/msi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/pci/msi.c~msi-fix-arm-compile drivers/pci/msi.c
--- a/drivers/pci/msi.c~msi-fix-arm-compile
+++ a/drivers/pci/msi.c
@@ -16,10 +16,10 @@
 #include <linux/pci.h>
 #include <linux/proc_fs.h>
 #include <linux/msi.h>
+#include <linux/smp.h>
 
 #include <asm/errno.h>
 #include <asm/io.h>
-#include <asm/smp.h>
 
 #include "pci.h"
 #include "msi.h"
_

Patches currently in -mm which might be from dan.j.williams@intel.com are

origin.patch
iop13xx-msi-support-rev6.patch
git-md-accel.patch
git-ioat-vs-git-md-accel.patch
