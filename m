From: akpm@linux-foundation.org
Subject: + m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch added to -mm tree
Date: Thu, 14 Feb 2008 13:07:54 -0800
Message-ID: <200802142107.m1EL7sf3002881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43211 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933869AbYBNVIg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Feb 2008 16:08:36 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gerg@snapgear.com, gerg@uclinux.org


The patch titled
     m68knommu: avoid unneccessary use of xchg() in set_mb()
has been added to the -mm tree.  Its filename is
     m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch

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

m68knommu-avoid-unneccessary-use-of-xchg-in-set_mb.patch
m68knommu-use-asflags-instead-of-extra_aflags.patch
m68knommu-use-tabs-not-spaces-in-cacheflushh.patch
