From: akpm@linux-foundation.org
Subject: + blackfin-smp-punt-unused-atomic_test_mask-helper.patch added to -mm tree
Date: Tue, 21 Jun 2011 16:06:05 -0700
Message-ID: <201106212306.p5LN65BF030242@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757015Ab1FUXGK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 19:06:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com


The patch titled
     Blackfin: SMP: punt unused atomic_test_mask helper
has been added to the -mm tree.  Its filename is
     blackfin-smp-punt-unused-atomic_test_mask-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Blackfin: SMP: punt unused atomic_test_mask helper
From: Mike Frysinger <vapier@gentoo.org>

No one uses this func, so just punt it.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/blackfin/include/asm/atomic.h |    5 -----
 1 file changed, 5 deletions(-)

diff -puN arch/blackfin/include/asm/atomic.h~blackfin-smp-punt-unused-atomic_test_mask-helper arch/blackfin/include/asm/atomic.h
--- a/arch/blackfin/include/asm/atomic.h~blackfin-smp-punt-unused-atomic_test_mask-helper
+++ a/arch/blackfin/include/asm/atomic.h
@@ -76,11 +76,6 @@ static inline void atomic_set_mask(int m
 	__raw_atomic_set_asm(&v->counter, mask);
 }
 
-static inline int atomic_test_mask(int mask, atomic_t *v)
-{
-	return __raw_atomic_test_asm(&v->counter, mask);
-}
