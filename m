From: akpm@linux-foundation.org
Subject: + msi-fix-arm-compile.patch added to -mm tree
Date: Fri, 27 Apr 2007 00:37:24 -0700
Message-ID: <200704270737.l3R7bO6C022365@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58237 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755453AbXD0Hiw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 27 Apr 2007 03:38:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dan.j.williams@intel.com, ebiederm@xmission.com, greg@kroah.com, rmk@arm.linux.org.uk, stable@kernel.org


The patch titled
     msi: fix ARM compile
has been added to the -mm tree.  Its filename is
     msi-fix-arm-compile.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

dev_dbg-check-dev_dbg-arguments.patch
git-md-accel.patch
git-ioat-vs-git-md-accel.patch
msi-fix-arm-compile.patch
