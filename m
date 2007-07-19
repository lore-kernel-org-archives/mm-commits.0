From: akpm@linux-foundation.org
Subject: - x86_64-use-non-locked-version-for-local_cmpxchg.patch removed from -mm tree
Date: Thu, 19 Jul 2007 13:11:09 -0700
Message-ID: <200707192011.l6JKB96w020743@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:47619 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757380AbXGSUQQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 16:16:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, andi@firstfloor.org, clameter@sgi.com, mm-commits@vger.kernel.org


The patch titled
     x86_64: use non locked version for local_cmpxchg()
has been removed from the -mm tree.  Its filename was
     x86_64-use-non-locked-version-for-local_cmpxchg.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: x86_64: use non locked version for local_cmpxchg()
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

local_cmpxchg() should not use any LOCK prefix.  This change probably got
lost in the move to cmpxchg.h.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Acked-by: Christoph Lameter <clameter@sgi.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-x86_64/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-x86_64/cmpxchg.h~x86_64-use-non-locked-version-for-local_cmpxchg include/asm-x86_64/cmpxchg.h
--- a/include/asm-x86_64/cmpxchg.h~x86_64-use-non-locked-version-for-local_cmpxchg
+++ a/include/asm-x86_64/cmpxchg.h
@@ -128,7 +128,7 @@ static inline unsigned long __cmpxchg_lo
 	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 #define cmpxchg_local(ptr,o,n)\
-	((__typeof__(*(ptr)))__cmpxchg((ptr),(unsigned long)(o),\
+	((__typeof__(*(ptr)))__cmpxchg_local((ptr),(unsigned long)(o),\
 					(unsigned long)(n),sizeof(*(ptr))))
 
 #endif
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

origin.patch
powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
git-kbuild.patch
