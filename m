From: akpm@linux-foundation.org
Subject: + mm-define-madv_free-for-some-arches.patch added to -mm tree
Date: Wed, 02 Dec 2015 15:28:31 -0800
Message-ID: <565f7e9f.HBsq/2+GQ4HCya7N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39410 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757498AbbLBX2c (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 18:28:32 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: minchan@kernel.org, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, danielmicay@gmail.com, darrick.wong@oracle.com, davem@davemloft.net, deller@gmx.de, fengguang.wu@intel.com, gang.chen.5i5j@gmail.com, hannes@cmpxchg.org, hughd@google.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, je@fb.com, jejb@parisc-linux.org, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, luto@amacapital.net, mattst88@gmail.com, mgorman@suse.de, mhocko@suse.com, mika.penttila@nextfour.com, mtk.manpages@gmail.com, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, roland@kernel.org, rth@twiddle.net, shli@kernel.org, will.deacon@arm.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: define MADV_FREE for some arches
has been added to the -mm tree.  Its filename is
     mm-define-madv_free-for-some-arches.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-define-madv_free-for-some-arches.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-define-madv_free-for-some-arches.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Minchan Kim <minchan@kernel.org>
Subject: mm: define MADV_FREE for some arches

Most architectures use asm-generic, but alpha, mips, parisc, xtensa
need their own definitions.

This patch defines MADV_FREE for them so it should fix build break
for their architectures.

Maybe, I should split and feed pieces to arch maintainers but
included here for mmotm convenience.

Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Max Filippov <jcmvbkbc@gmail.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Chris Zankel <chris@zankel.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Shaohua Li" <shli@kernel.org>
Cc: <yalin.wang2010@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Evans <je@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h  |    1 +
 arch/mips/include/uapi/asm/mman.h   |    1 +
 arch/parisc/include/uapi/asm/mman.h |    1 +
 arch/xtensa/include/uapi/asm/mman.h |    1 +
 4 files changed, 4 insertions(+)

diff -puN arch/alpha/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -47,6 +47,7 @@
 #define MADV_WILLNEED	3		/* will need these pages */
 #define	MADV_SPACEAVAIL	5		/* ensure resources are available */
 #define MADV_DONTNEED	6		/* don't need these pages */
+#define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/mips/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -73,6 +73,7 @@
 #define MADV_SEQUENTIAL 2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
+#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/parisc/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -43,6 +43,7 @@
 #define MADV_SPACEAVAIL 5               /* insure that resources are reserved */
 #define MADV_VPS_PURGE  6               /* Purge pages from VM page cache */
 #define MADV_VPS_INHERIT 7              /* Inherit parents page size */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
 #define MADV_REMOVE	9		/* remove these pages & resources */
diff -puN arch/xtensa/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~mm-define-madv_free-for-some-arches
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

zram-pass-gfp-from-zcomp-frontend-to-backend.patch
mm-support-madvisemadv_free.patch
mm-support-madvisemadv_free-fix.patch
mm-define-madv_free-for-some-arches.patch
mm-free-swp_entry-in-madvise_free.patch
mm-move-lazily-freed-pages-to-inactive-list.patch
mm-mark-stable-page-dirty-in-ksm.patch
x86-add-pmd_-for-thp.patch
sparc-add-pmd_-for-thp.patch
powerpc-add-pmd_-for-thp.patch
arm-add-pmd_mkclean-for-thp.patch
arm64-add-pmd_mkclean-for-thp.patch
mm-dont-split-thp-page-when-syscall-is-called.patch

