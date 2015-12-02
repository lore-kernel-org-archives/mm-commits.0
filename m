From: akpm@linux-foundation.org
Subject: +
 arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch added to -mm tree
Date: Wed, 02 Dec 2015 15:28:34 -0800
Message-ID: <565f7ea2.k03OB5oT8fCiAvas%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39439 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757400AbbLBX2g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Dec 2015 18:28:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gang.chen.5i5j@gmail.com, aarcange@redhat.com, arnd@arndb.de, benh@kernel.crashing.org, catalin.marinas@arm.com, chris@zankel.net, danielmicay@gmail.com, darrick.wong@oracle.com, davem@davemloft.net, deller@gmx.de, fengguang.wu@intel.com, hannes@cmpxchg.org, hughd@google.com, ink@jurassic.park.msu.ru, jcmvbkbc@gmail.com, je@fb.com, jejb@parisc-linux.org, kirill@shutemov.name, kosaki.motohiro@jp.fujitsu.com, luto@amacapital.net, mattst88@gmail.com, mgorman@suse.de, mhocko@suse.com, mika.penttila@nextfour.com, minchan@kernel.org, mtk.manpages@gmail.com, ralf@linux-mips.org, riel@redhat.com, rmk@arm.linux.org.uk, roland@kernel.org, rth@twiddle.net, shli@kernel.org, will.deacon@arm.com, yalin.wang2010@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: arch/*/include/uapi/asm/mman.h: : let MADV_FREE have same value for all architectures
has been added to the -mm tree.  Its filename is
     arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Chen Gang <gang.chen.5i5j@gmail.com>
Subject: arch/*/include/uapi/asm/mman.h: : let MADV_FREE have same value for all architectures

For uapi, need try to let all macros have same value, and MADV_FREE is
added into main branch recently, so need redefine MADV_FREE for it.

At present, '8' can be shared with all architectures, so redefine it to
'8'.

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Helge Deller <deller@gmx.de>
Cc: Chris Zankel <chris@zankel.net>
Cc: Max Filippov <jcmvbkbc@gmail.com>
Cc: Roland Dreier <roland@kernel.org>
Cc: Darrick J. Wong <darrick.wong@oracle.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: "Shaohua Li" <shli@kernel.org>
Cc: <yalin.wang2010@gmail.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: Jason Evans <je@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mika Penttil <mika.penttila@nextfour.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/uapi/asm/mman.h     |    1 +
 arch/mips/include/uapi/asm/mman.h      |    1 +
 arch/parisc/include/uapi/asm/mman.h    |    1 +
 arch/xtensa/include/uapi/asm/mman.h    |    1 +
 include/uapi/asm-generic/mman-common.h |    2 +-
 5 files changed, 5 insertions(+), 1 deletion(-)

diff -puN arch/alpha/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures arch/alpha/include/uapi/asm/mman.h
--- a/arch/alpha/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures
+++ a/arch/alpha/include/uapi/asm/mman.h
@@ -50,6 +50,7 @@
 #define MADV_FREE	7		/* free pages only if memory pressure */
 
 /* common/generic parameters */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff -puN arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures arch/mips/include/uapi/asm/mman.h
--- a/arch/mips/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures
+++ a/arch/mips/include/uapi/asm/mman.h
@@ -76,6 +76,7 @@
 #define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff -puN arch/parisc/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures arch/parisc/include/uapi/asm/mman.h
--- a/arch/parisc/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures
+++ a/arch/parisc/include/uapi/asm/mman.h
@@ -46,6 +46,7 @@
 #define MADV_FREE	8		/* free pages only if memory pressure */
 
 /* common/generic parameters */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff -puN arch/xtensa/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures arch/xtensa/include/uapi/asm/mman.h
--- a/arch/xtensa/include/uapi/asm/mman.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures
+++ a/arch/xtensa/include/uapi/asm/mman.h
@@ -89,6 +89,7 @@
 #define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
diff -puN include/uapi/asm-generic/mman-common.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures include/uapi/asm-generic/mman-common.h
--- a/include/uapi/asm-generic/mman-common.h~arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures
+++ a/include/uapi/asm-generic/mman-common.h
@@ -39,9 +39,9 @@
 #define MADV_SEQUENTIAL	2		/* expect sequential page references */
 #define MADV_WILLNEED	3		/* will need these pages */
 #define MADV_DONTNEED	4		/* don't need these pages */
-#define MADV_FREE	5		/* free pages only if memory pressure */
 
 /* common parameters: try to keep these consistent across architectures */
+#define MADV_FREE	8		/* free pages only if memory pressure */
 #define MADV_REMOVE	9		/* remove these pages & resources */
 #define MADV_DONTFORK	10		/* don't inherit across fork */
 #define MADV_DOFORK	11		/* do inherit across fork */
_

Patches currently in -mm which might be from gang.chen.5i5j@gmail.com are

mm-mmapc-remove-redundant-local-variables-for-may_expand_vm.patch
arch-uapi-asm-mmanh-let-madv_free-have-same-value-for-all-architectures.patch

