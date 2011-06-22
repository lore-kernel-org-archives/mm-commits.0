From: akpm@linux-foundation.org
Subject: [withdrawn] blackfin-smp-punt-unused-atomic_test_mask-helper.patch removed from -mm tree
Date: Tue, 21 Jun 2011 21:59:33 -0700
Message-ID: <201106220459.p5M4xKWt014459@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751255Ab1FVE72 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 22 Jun 2011 00:59:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, arnd@arndb.de, asharma@fb.com, mm-commits@vger.kernel.org


The patch titled
     Blackfin: SMP: punt unused atomic_test_mask helper
has been removed from the -mm tree.  Its filename was
     blackfin-smp-punt-unused-atomic_test_mask-helper.patch

This patch was dropped because it was withdrawn

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
