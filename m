From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-arch-sh.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:12:36 -0700
Message-ID: <20121005201237.123B320004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-we0-f202.google.com ([74.125.82.202]:57713 "EHLO
	mail-we0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUMi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:12:38 -0400
Received: by mail-we0-f202.google.com with SMTP id x43so139507wey.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:12:38 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, lethal@linux-sh.org, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in arch/sh
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-arch-sh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in arch/sh

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sh/include/asm/io.h |    2 +-
 arch/sh/kernel/ioport.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/sh/include/asm/io.h~sections-fix-section-conflicts-in-arch-sh arch/sh/include/asm/io.h
--- a/arch/sh/include/asm/io.h~sections-fix-section-conflicts-in-arch-sh
+++ a/arch/sh/include/asm/io.h
@@ -134,7 +134,7 @@ __BUILD_MEMORY_STRING(__raw_, q, u64)
  * load/store instructions. sh_io_port_base is the virtual address to
  * which all ports are being mapped.
  */
-extern const unsigned long sh_io_port_base;
+extern unsigned long sh_io_port_base;
 
 static inline void __set_io_port_base(unsigned long pbase)
 {
diff -puN arch/sh/kernel/ioport.c~sections-fix-section-conflicts-in-arch-sh arch/sh/kernel/ioport.c
--- a/arch/sh/kernel/ioport.c~sections-fix-section-conflicts-in-arch-sh
+++ a/arch/sh/kernel/ioport.c
@@ -11,7 +11,7 @@
 #include <linux/module.h>
 #include <linux/io.h>
 
-const unsigned long sh_io_port_base __read_mostly = -1;
+unsigned long sh_io_port_base __read_mostly = -1;
 EXPORT_SYMBOL(sh_io_port_base);
 
 void __iomem *__ioport_map(unsigned long addr, unsigned int size)
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

