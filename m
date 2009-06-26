From: akpm@linux-foundation.org
Subject: + mm-make-swap-token-dummies-static-inlines-fix-2.patch added to -mm tree
Date: Fri, 26 Jun 2009 00:34:15 -0700
Message-ID: <200906260734.n5Q7YFfh028410@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51788 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbZFZHfH (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 26 Jun 2009 03:35:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, randy.dunlap@oracle.com, riel@redhat.com


The patch titled
     mm-make-swap-token-dummies-static-inlines-fix-2.txt
has been added to the -mm tree.  Its filename is
     mm-make-swap-token-dummies-static-inlines-fix-2.patch

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
Subject: mm-make-swap-token-dummies-static-inlines-fix-2.txt
From: Johannes Weiner <hannes@cmpxchg.org>

disable_swap_token() doesn't take an argument.  This fixes the
!CONFIG_SWAP dummy.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/swap.h~mm-make-swap-token-dummies-static-inlines-fix-2 include/linux/swap.h
--- a/include/linux/swap.h~mm-make-swap-token-dummies-static-inlines-fix-2
+++ a/include/linux/swap.h
@@ -432,7 +432,7 @@ static inline int has_swap_token(struct 
 	return 0;
 }
 
-static inline void disable_swap_token(struct mm_struct *mm)
+static inline void disable_swap_token(void)
 {
 }
 
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-make-swap-token-dummies-static-inlines.patch
mm-make-swap-token-dummies-static-inlines-fix.patch
mm-make-swap-token-dummies-static-inlines-fix-2.patch

