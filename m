From: akpm@linux-foundation.org
Subject: [nacked] cleanup-include-asm-generic-atomich.patch removed from
 -mm tree
Date: Tue, 22 Jul 2014 13:08:40 -0700
Message-ID: <53cec4c8.J95YFwBeQopbgZ5D%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-oi0-f74.google.com ([209.85.218.74]:53060 "EHLO
	mail-oi0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634AbaGVUIl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 16:08:41 -0400
Received: by mail-oi0-f74.google.com with SMTP id a141so39310oig.1
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 13:08:41 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maddy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/atomic.h: fix comment
has been removed from the -mm tree.  Its filename was
     cleanup-include-asm-generic-atomich.patch

This patch was dropped because it was nacked

------------------------------------------------------
From: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Subject: include/asm-generic/atomic.h: fix comment

4b358e2206 ("cleanup include/asm-generic/atomic.h") added comments for
#else/#endif, but ended up adding same comment "BITS_PER_LONG == 64" on
both sides.  This patch fixes it.

Signed-off-by: Madhavan Srinivasan <maddy@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic-long.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/asm-generic/atomic-long.h~cleanup-include-asm-generic-atomich include/asm-generic/atomic-long.h
--- a/include/asm-generic/atomic-long.h~cleanup-include-asm-generic-atomich
+++ a/include/asm-generic/atomic-long.h
@@ -253,6 +253,6 @@ static inline long atomic_long_add_unles
 #define atomic_long_xchg(v, new) \
 	(atomic_xchg((atomic_t *)(v), (new)))
 
-#endif  /*  BITS_PER_LONG == 64  */
+#endif  /*  BITS_PER_LONG != 64  */
 
 #endif  /*  _ASM_GENERIC_ATOMIC_LONG_H  */
_

Patches currently in -mm which might be from maddy@linux.vnet.ibm.com are


