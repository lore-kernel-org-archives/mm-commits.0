From: akpm@linux-foundation.org
Subject: [folded-merged] mm-support-madvisemadv_free-fix.patch removed
 from -mm tree
Date: Mon, 02 Nov 2015 14:49:28 -0800
Message-ID: <5637e878.EwjZoNDbs8l5S2Zb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55851 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbKBWt3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Nov 2015 17:49:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, chris@zankel.net, deller@gmx.de, fengguang.wu@intel.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, jejb@parisc-linux.org, mtk.manpages@gmail.com, ralf@linux-mips.org, rth@twiddle.net, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: define MADV_FREE for some arches
has been removed from the -mm tree.  Its filename was
     mm-support-madvisemadv_free-fix.patch

This patch was dropped because it was folded into mm-support-madvisemadv_free.patch

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: define MADV_FREE for some arches

Most architectures use asm-generic, but alpha, mips, parisc, xtensa
need their own definitions.

This patch defines MADV_FREE for them so it should fix build break
for their architectures.

Maybe, I should split and feed piecies to arch maintainers but
included here for mmotm convenience.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Reported-by: kbuild test robot <fengguang.wu@intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Chris Zankel <chris@zankel.net>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h  |    1 +
 arch/mips/include/uapi/asm/mman.h   |    1 +
 arch/parisc/include/uapi/asm/mman.h |    1 +
 arch/xtensa/include/uapi/asm/mman.h |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -47,6 +47,7 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
+#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,6 +73,7 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -43,6 +43,7 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-support-madvisemadv_free-fix
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -86,6 +86,7 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
_

Patches currently in -mm which might be from minchan@kernel.org are

x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_-for-thp.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix-5.patch
mm-support-madvisemadv_free-fix-6.patch
mm-mark-stable-page-dirty-in-ksm.patch
mm-dont-split-thp-page-when-syscall-is-called.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-5.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-6.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazy-free-pages-to-inactive-list.patch
mm-move-lazy-free-pages-to-inactive-list-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch

