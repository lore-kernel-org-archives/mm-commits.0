From: akpm@linux-foundation.org
Subject: + sparc64-ng4-memset-32-bits-overflow.patch added to -mm tree
Date: Fri, 03 Mar 2017 15:36:04 -0800
Message-ID: <58b9fde4.Dn0hfEl7ZyCSbbyJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57524 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752105AbdCCXpy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Mar 2017 18:45:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pasha.tatashin@oracle.com, babu.moger@oracle.com, davem@davemloft.net, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: sparc64: NG4 memset 32 bits overflow
has been added to the -mm tree.  Its filename is
     sparc64-ng4-memset-32-bits-overflow.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparc64-ng4-memset-32-bits-overflow.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparc64-ng4-memset-32-bits-overflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Pavel Tatashin <pasha.tatashin@oracle.com>
Subject: sparc64: NG4 memset 32 bits overflow

Early in boot Linux patches memset and memcpy to branch to platform
optimized versions of these routines.  The NG4 (Niagra 4) versions are
currently used on all platforms starting from T4.  Recently, there were M7
optimized routines added into UEK4 but not into mainline yet.  So, even
with M7 optimized routines NG4 are still going to be used on T4, T5, M5,
and M6 processors.

While investigating how to improve initialization time of dentry_hashtable
which is 8G long on M6 ldom with 7T of main memory, I noticed that
memset() does not reset all the memory in this array, after studying the
code, I realized that NG4memset() branches use %icc register instead of
%xcc to check compare, so if value of length is over 32-bit long, which is
true for 8G array, these routines fail to work properly.

The fix is to replace all %icc with %xcc in these routines.  (Alternative
is to use %ncc, but this is misleading, as the code already has sparcv9
only instructions, and cannot be compiled on 32-bit).

This is important to fix this bug, because even older T4-4 can have 2T of
memory, and there are large memory proportional data structures in kernel
which can be larger than 4G in size.  The failing of memset() is silent
and corruption is hard to detect.

Link: http://lkml.kernel.org/r/1488432825-92126-2-git-send-email-pasha.tatashin@oracle.com
Signed-off-by: Pavel Tatashin <pasha.tatashin@oracle.com>
Reviewed-by: Babu Moger <babu.moger@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/sparc/lib/NG4memset.S |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN arch/sparc/lib/NG4memset.S~sparc64-ng4-memset-32-bits-overflow arch/sparc/lib/NG4memset.S
--- a/arch/sparc/lib/NG4memset.S~sparc64-ng4-memset-32-bits-overflow
+++ a/arch/sparc/lib/NG4memset.S
@@ -13,14 +13,14 @@
 	.globl		NG4memset
 NG4memset:
 	andcc		%o1, 0xff, %o4
-	be,pt		%icc, 1f
+	be,pt		%xcc, 1f
 	 mov		%o2, %o1
 	sllx		%o4, 8, %g1
 	or		%g1, %o4, %o2
 	sllx		%o2, 16, %g1
 	or		%g1, %o2, %o2
 	sllx		%o2, 32, %g1
-	ba,pt		%icc, 1f
+	ba,pt		%xcc, 1f
 	 or		%g1, %o2, %o4
 	.size		NG4memset,.-NG4memset
 
@@ -29,7 +29,7 @@ NG4memset:
 NG4bzero:
 	clr		%o4
 1:	cmp		%o1, 16
-	ble		%icc, .Ltiny
+	ble		%xcc, .Ltiny
 	 mov		%o0, %o3
 	sub		%g0, %o0, %g1
 	and		%g1, 0x7, %g1
@@ -37,7 +37,7 @@ NG4bzero:
 	 sub		%o1, %g1, %o1
 1:	stb		%o4, [%o0 + 0x00]
 	subcc		%g1, 1, %g1
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 1, %o0
 .Laligned8:
 	cmp		%o1, 64 + (64 - 8)
@@ -48,7 +48,7 @@ NG4bzero:
 	 sub		%o1, %g1, %o1
 1:	stx		%o4, [%o0 + 0x00]
 	subcc		%g1, 8, %g1
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 0x8, %o0
 .Laligned64:
 	andn		%o1, 64 - 1, %g1
@@ -58,30 +58,30 @@ NG4bzero:
 1:	stxa		%o4, [%o0 + %g0] ASI_BLK_INIT_QUAD_LDD_P
 	subcc		%g1, 0x40, %g1
 	stxa		%o4, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 0x40, %o0
 .Lpostloop:
 	cmp		%o1, 8
-	bl,pn		%icc, .Ltiny
+	bl,pn		%xcc, .Ltiny
 	 membar		#StoreStore|#StoreLoad
 .Lmedium:
 	andn		%o1, 0x7, %g1
 	sub		%o1, %g1, %o1
 1:	stx		%o4, [%o0 + 0x00]
 	subcc		%g1, 0x8, %g1
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 0x08, %o0
 	andcc		%o1, 0x4, %g1
-	be,pt		%icc, .Ltiny
+	be,pt		%xcc, .Ltiny
 	 sub		%o1, %g1, %o1
 	stw		%o4, [%o0 + 0x00]
 	add		%o0, 0x4, %o0
 .Ltiny:
 	cmp		%o1, 0
-	be,pn		%icc, .Lexit
+	be,pn		%xcc, .Lexit
 1:	 subcc		%o1, 1, %o1
 	stb		%o4, [%o0 + 0x00]
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 1, %o0
 .Lexit:
 	retl
@@ -99,7 +99,7 @@ NG4bzero:
 	stxa		%o4, [%o0 + %g2] ASI_BLK_INIT_QUAD_LDD_P
 	stxa		%o4, [%o0 + %g3] ASI_BLK_INIT_QUAD_LDD_P
 	stxa		%o4, [%o0 + %o5] ASI_BLK_INIT_QUAD_LDD_P
-	bne,pt		%icc, 1b
+	bne,pt		%xcc, 1b
 	 add		%o0, 0x30, %o0
-	ba,a,pt		%icc, .Lpostloop
+	ba,a,pt		%xcc, .Lpostloop
 	.size		NG4bzero,.-NG4bzero
_

Patches currently in -mm which might be from pasha.tatashin@oracle.com are

sparc64-ng4-memset-32-bits-overflow.patch
mm-zeroing-hash-tables-in-allocator.patch
mm-updated-callers-to-use-hash_zero-flag.patch
mm-adaptive-hash-table-scaling.patch

