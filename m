From: akpm@linux-foundation.org
Subject: + drivers-char-memc-clean-up-the-code.patch added to -mm tree
Date: Wed, 23 Feb 2011 15:49:31 -0800
Message-ID: <201102232349.p1NNnViX030937@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab1BXANR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Feb 2011 19:13:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: xiaosuo@gmail.com


The patch titled
     drivers/char/mem.c: clean up the code
has been added to the -mm tree.  Its filename is
     drivers-char-memc-clean-up-the-code.patch

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
