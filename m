From: akpm@linux-foundation.org
Subject: [merged] crash_dump-fix-compilation-error-on-mips-at-least.patch
 removed from -mm tree
Date: Wed, 15 Jan 2014 12:28:48 -0800
Message-ID: <52d6ef80.wPWaXGv4R4FuSiYL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43099 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbaAOU2t (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Jan 2014 15:28:49 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, vgoyal@redhat.com, stable@vger.kernel.org, james.hogan@imgtec.com, holzheu@linux.vnet.ibm.com, qais.yousef@imgtec.com

Subject: [merged] crash_dump-fix-compilation-error-on-mips-at-least.patch removed from -mm tree
To: qais.yousef@imgtec.com,holzheu@linux.vnet.ibm.com,james.hogan@imgtec.com,stable@vger.kernel.org,vgoyal@redhat.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 15 Jan 2014 12:28:48 -0800


The patch titled
     Subject: crash_dump: fix compilation error (on MIPS at least)
has been removed from the -mm tree.  Its filename was
     crash_dump-fix-compilation-error-on-mips-at-least.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qais Yousef <qais.yousef@imgtec.com>
Subject: crash_dump: fix compilation error (on MIPS at least)

  In file included from kernel/crash_dump.c:2:0:
  include/linux/crash_dump.h:22:27: error: unknown type name `pgprot_t'

when CONFIG_CRASH_DUMP=y

The error was traced back to this commit:

  9cb218131de1 vmcore: introduce remap_oldmem_pfn_range()

include <asm/pgtable.h> to get the missing definition

Signed-off-by: Qais Yousef <qais.yousef@imgtec.com>
Reviewed-by: James Hogan <james.hogan@imgtec.com>
Cc: Michael Holzheu <holzheu@linux.vnet.ibm.com>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Cc: <stable@vger.kernel.org>	[3.12+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/crash_dump.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/crash_dump.h~crash_dump-fix-compilation-error-on-mips-at-least include/linux/crash_dump.h
--- a/include/linux/crash_dump.h~crash_dump-fix-compilation-error-on-mips-at-least
+++ a/include/linux/crash_dump.h
@@ -6,6 +6,8 @@
 #include <linux/proc_fs.h>
 #include <linux/elf.h>
 
+#include <asm/pgtable.h> /* for pgprot_t */
+
 #define ELFCORE_ADDR_MAX	(-1ULL)
 #define ELFCORE_ADDR_ERR	(-2ULL)
 
_

Patches currently in -mm which might be from qais.yousef@imgtec.com are

origin.patch
linux-next.patch

