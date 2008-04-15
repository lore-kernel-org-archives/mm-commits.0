From: akpm@linux-foundation.org
Subject: + powerpc-fix-max_order-config-problem.patch added to -mm tree
Date: Mon, 14 Apr 2008 18:05:39 -0700
Message-ID: <200804150105.m3F15dE9003409@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752127AbYDOBFu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Apr 2008 21:05:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, benh@kernel.crashing.org, paulus@samba.org


The patch titled
     powerpc: fix MAX_ORDER config problem
has been added to the -mm tree.  Its filename is
     powerpc-fix-max_order-config-problem.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: powerpc: fix MAX_ORDER config problem
From: Stephen Rothwell <sfr@canb.auug.org.au>

The allyesconfig (among others) build was giving this:

In file included from include/linux/gfp.h:4,
                 from include/linux/slab.h:14,
                 from include/linux/percpu.h:5,
                 from include2/asm/time.h:18,
                 from include2/asm/cputime.h:26,
                 from include/linux/sched.h:67,
                 from
arch/powerpc/kernel/asm-offsets.c:17:
include/linux/mmzone.h:791:2: error: #error Allocator MAX_ORDER exceeds SECTION_SIZE

Kconfig options are order depenendent, so move the setting of
FORCE_MAX_ZONEORDER to after the setting of PPC_64K_PAGES.  Also add an
explicit !PPC_64K_PAGES.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/Kconfig |   40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff -puN arch/powerpc/Kconfig~powerpc-fix-max_order-config-problem arch/powerpc/Kconfig
--- a/arch/powerpc/Kconfig~powerpc-fix-max_order-config-problem
+++ a/arch/powerpc/Kconfig
@@ -211,26 +211,6 @@ source kernel/Kconfig.hz
 source kernel/Kconfig.preempt
 source "fs/Kconfig.binfmt"
 
-config FORCE_MAX_ZONEORDER
-	int "Maximum zone order"
-	default "9" if PPC_64K_PAGES
-	default "13" if PPC64
-	default "11"
-	help
-	  The kernel memory allocator divides physically contiguous memory
-	  blocks into "zones", where each zone is a power of two number of
-	  pages.  This option selects the largest power of two that the kernel
-	  keeps in the memory allocator.  If you need to allocate very large
-	  blocks of physically contiguous memory, then you may need to
-	  increase this value.
-
-	  This config option is actually maximum order plus one. For example,
-	  a value of 11 means that the largest free memory block is 2^10 pages.
-
-	  The page size is not necessarily 4KB.  For example, on 64-bit
-	  systems, 64KB pages can be enabled via CONFIG_PPC_64K_PAGES.  Keep
-	  this in mind when choosing a value for this option.
-
 config HUGETLB_PAGE_SIZE_VARIABLE
 	bool
 	depends on HUGETLB_PAGE
@@ -403,6 +383,26 @@ config PPC_64K_PAGES
 	  while on hardware with such support, it will be used to map
 	  normal application pages.
 
+config FORCE_MAX_ZONEORDER
+	int "Maximum zone order"
+	default "9" if PPC_64K_PAGES
+	default "13" if PPC64 && !PPC_64K_PAGES
+	default "11"
+	help
+	  The kernel memory allocator divides physically contiguous memory
+	  blocks into "zones", where each zone is a power of two number of
+	  pages.  This option selects the largest power of two that the kernel
+	  keeps in the memory allocator.  If you need to allocate very large
+	  blocks of physically contiguous memory, then you may need to
+	  increase this value.
+
+	  This config option is actually maximum order plus one. For example,
+	  a value of 11 means that the largest free memory block is 2^10 pages.
+
+	  The page size is not necessarily 4KB.  For example, on 64-bit
+	  systems, 64KB pages can be enabled via CONFIG_PPC_64K_PAGES.  Keep
+	  this in mind when choosing a value for this option.
+
 config PPC_SUBPAGE_PROT
 	bool "Support setting protections for 4k subpages"
 	depends on PPC_64K_PAGES
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

git-x86.patch
git-powerpc.patch
powerpc-fix-max_order-config-problem.patch
git-libata-all.patch
git-async-tx.patch
smsc-ircc2-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
nsc-ircc-wrap-pnp-probe-code-in-ifdef-config_pnp.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device.patch
git-scsi-misc-vs-gregkh-driver-driver-core-remove-no-longer-used-struct-class_device-fix.patch
drivers-video-imsttfbc-add-missing-curly-brackets.patch
viocons-bkl-locking.patch

