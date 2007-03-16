From: akpm@linux-foundation.org
Subject: + i386-fix-typo-in-sync_constant_test_bits-name.patch added to -mm tree
Date: Fri, 16 Mar 2007 12:50:57 -0800
Message-ID: <200703162050.l2GKovPe021281@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:35450 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753673AbXCPUvv (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 Mar 2007 16:51:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeremy@goop.org, chrisw@sous-sol.org, jeremy@xensource.com, mingo@elte.hu


The patch titled
     i386: fix typo in sync_constant_test_bit()'s name
has been added to the -mm tree.  Its filename is
     i386-fix-typo-in-sync_constant_test_bits-name.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: i386: fix typo in sync_constant_test_bit()'s name
From: Jeremy Fitzhardinge <jeremy@goop.org>

Fix typo in sync_constant_test_bit()'s name, so sync_bitops.h is consistent
with bitops.h

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Acked-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/sync_bitops.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-i386/sync_bitops.h~i386-fix-typo-in-sync_constant_test_bits-name include/asm-i386/sync_bitops.h
--- a/include/asm-i386/sync_bitops.h~i386-fix-typo-in-sync_constant_test_bits-name
+++ a/include/asm-i386/sync_bitops.h
@@ -130,7 +130,7 @@ static inline int sync_test_and_change_b
 	return oldbit;
 }
 
-static __always_inline int sync_const_test_bit(int nr, const volatile unsigned long *addr)
+static __always_inline int sync_constant_test_bit(int nr, const volatile unsigned long *addr)
 {
 	return ((1UL << (nr & 31)) &
 		(((const volatile unsigned int *)addr)[nr >> 5])) != 0;
_

Patches currently in -mm which might be from jeremy@goop.org are

i386-fix-typo-in-sync_constant_test_bits-name.patch
