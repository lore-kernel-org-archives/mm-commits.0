From: akpm@linux-foundation.org
Subject: - m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch removed from -mm tree
Date: Thu, 14 Feb 2008 19:16:16 -0500
Message-ID: <200802150719.m1F7Jctc025720@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57163 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763922AbYBOH35 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 15 Feb 2008 02:29:57 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gerg@snapgear.com, gerg@uclinux.org, mm-commits@vger.kernel.org


The patch titled
     m68knommu: avoid unneccessary use of xchg() in set_mb()
has been removed from the -mm tree.  Its filename was
     m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: m68knommu: avoid unneccessary use of xchg() in set_mb()
From: Greg Ungerer <gerg@snapgear.com>

Avoid unneccessary use of xchg() in set_mb().

Signed-off-by: Greg Ungerer <gerg@uclinux.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-m68knommu/system.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-m68knommu/system.h~m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb include/asm-m68knommu/system.h
--- a/include/asm-m68knommu/system.h~m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb
+++ a/include/asm-m68knommu/system.h
@@ -104,7 +104,7 @@ asmlinkage void resume(void);
 #define mb()   asm volatile (""   : : :"memory")
 #define rmb()  asm volatile (""   : : :"memory")
 #define wmb()  asm volatile (""   : : :"memory")
-#define set_mb(var, value) do { xchg(&var, value); } while (0)
+#define set_mb(var, value)	({ (var) = (value); wmb(); })
 
 #ifdef CONFIG_SMP
 #define smp_mb()	mb()
_

Patches currently in -mm which might be from gerg@snapgear.com are

origin.patch
