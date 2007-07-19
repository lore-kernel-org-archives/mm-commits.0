From: akpm@linux-foundation.org
Subject: + x86_64-use-non-locked-version-for-local_cmpxchg.patch added to -mm tree
Date: Wed, 18 Jul 2007 22:31:59 -0700
Message-ID: <200707190531.l6J5Vx88015765@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32939 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751633AbXGSFcT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Jul 2007 01:32:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, andi@firstfloor.org, clameter@sgi.com


The patch titled
     x86_64: use non locked version for local_cmpxchg()
has been added to the -mm tree.  Its filename is
     x86_64-use-non-locked-version-for-local_cmpxchg.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
x86_64-use-non-locked-version-for-local_cmpxchg.patch
