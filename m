From: akpm@linux-foundation.org
Subject: [merged] generic-swap-dont-return-a-value-from-swap.patch removed from -mm tree
Date: Fri, 06 Feb 2009 11:37:33 -0800
Message-ID: <200902061937.n16JbXmd011013@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754343AbZBFTiM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 6 Feb 2009 14:38:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: peterz@infradead.org, a.p.zijlstra@chello.nl, wfg@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     generic swap(): don't return a value from swap()
has been removed from the -mm tree.  Its filename was
     generic-swap-dont-return-a-value-from-swap.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: generic swap(): don't return a value from swap()
From: Peter Zijlstra <peterz@infradead.org>

The swap() macro is accidentally retuning the value of its first argument.
Change it into a doesn't-return-anything macro before someone goes and
relies upon this behaviour.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Wu Fengguang <wfg@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN include/linux/kernel.h~generic-swap-dont-return-a-value-from-swap include/linux/kernel.h
--- a/include/linux/kernel.h~generic-swap-dont-return-a-value-from-swap
+++ a/include/linux/kernel.h
@@ -480,7 +480,8 @@ static inline char *pack_hex_byte(char *
 /*
  * swap - swap value of @a and @b
  */
-#define swap(a, b) ({ typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; })
+#define swap(a, b) \
+	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
 
 /**
  * container_of - cast a member of a structure out to the containing structure
_

Patches currently in -mm which might be from peterz@infradead.org are

origin.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches.patch
mm-fix-dirty_bytes-dirty_background_bytes-sysctls-on-64bit-arches-fix.patch
linux-next.patch

