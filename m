From: akpm@linux-foundation.org
Subject: + cleanup-include-asm-generic-atomich.patch added to -mm tree
Date: Mon, 21 Jul 2014 16:33:27 -0700
Message-ID: <53cda347.t9hBOqsjXDMe77JC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:57072 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750832AbaGUXd2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 21 Jul 2014 19:33:28 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so2016074pab.4
        for <mm-commits@vger.kernel.org>; Mon, 21 Jul 2014 16:33:27 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: maddy@linux.vnet.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Subject: include/asm-generic/atomic.h: fix comment
has been added to the -mm tree.  Its filename is
     cleanup-include-asm-generic-atomich.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleanup-include-asm-generic-atomich.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleanup-include-asm-generic-atomich.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

cleanup-include-asm-generic-atomich.patch

