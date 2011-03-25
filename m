From: akpm@linux-foundation.org
Subject: [merged] drivers-char-memc-clean-up-the-code.patch removed from -mm tree
Date: Fri, 25 Mar 2011 00:25:59 -0700
Message-ID: <201103250725.p2P7Prq9026082@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933724Ab1CYHZz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 25 Mar 2011 03:25:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xiaosuo@gmail.com, mm-commits@vger.kernel.org


The patch titled
     drivers/char/mem.c: clean up the code
has been removed from the -mm tree.  Its filename was
     drivers-char-memc-clean-up-the-code.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: drivers/char/mem.c: clean up the code
From: Changli Gao <xiaosuo@gmail.com>

Reduce the lines of code and simplify the logic.

Signed-off-by: Changli Gao <xiaosuo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/mem.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff -puN drivers/char/mem.c~drivers-char-memc-clean-up-the-code drivers/char/mem.c
--- a/drivers/char/mem.c~drivers-char-memc-clean-up-the-code
+++ a/drivers/char/mem.c
@@ -47,10 +47,7 @@ static inline unsigned long size_inside_
 #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
 static inline int valid_phys_addr_range(unsigned long addr, size_t count)
 {
-	if (addr + count > __pa(high_memory))
-		return 0;
