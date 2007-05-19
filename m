From: akpm@linux-foundation.org
Subject: - fix-roundup_pow_of_two1.patch removed from -mm tree
Date: Sat, 19 May 2007 10:18:30 -0700
Message-ID: <200705191718.l4JHITER007018@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36905 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754078AbXESRUb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 19 May 2007 13:20:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: eike-kernel@sf-tec.de, dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Fix roundup_pow_of_two(1)
has been removed from the -mm tree.  Its filename was
     fix-roundup_pow_of_two1.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Fix roundup_pow_of_two(1)
From: Rolf Eike Beer <eike-kernel@sf-tec.de>

Fix roundup_pow_of_two(1)

1 is a power of two, therefore roundup_pow_of_two(1) should return 1.  It
does in case the argument is a variable but in case it's a constant it
behaves wrong and returns 0.  Probably nobody ever did it so this was never
noticed.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/log2.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/log2.h~fix-roundup_pow_of_two1 include/linux/log2.h
--- a/include/linux/log2.h~fix-roundup_pow_of_two1
+++ a/include/linux/log2.h
@@ -159,7 +159,7 @@ unsigned long __roundup_pow_of_two(unsig
 #define roundup_pow_of_two(n)			\
 (						\
 	__builtin_constant_p(n) ? (		\
-		(n == 1) ? 0 :			\
+		(n == 1) ? 1 :			\
 		(1UL << (ilog2((n) - 1) + 1))	\
 				   ) :		\
 	__roundup_pow_of_two(n)			\
_

Patches currently in -mm which might be from eike-kernel@sf-tec.de are

mm-use-div_round_up-in-mm-memoryc.patch
