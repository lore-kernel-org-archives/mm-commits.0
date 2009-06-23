From: akpm@linux-foundation.org
Subject: + mm-make-swap-token-dummies-static-inlines.patch added to -mm tree
Date: Tue, 23 Jun 2009 14:00:49 -0700
Message-ID: <200906232100.n5NL0nSA032509@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751819AbZFWVBI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 23 Jun 2009 17:01:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: hannes@cmpxchg.org, riel@redhat.com


The patch titled
     mm: make swap token dummies static inlines
has been added to the -mm tree.  Its filename is
     mm-make-swap-token-dummies-static-inlines.patch

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
Subject: mm: make swap token dummies static inlines
From: Johannes Weiner <hannes@cmpxchg.org>

Make use of the compiler's typechecking on !CONFIG_SWAP as well.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swap.h |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff -puN include/linux/swap.h~mm-make-swap-token-dummies-static-inlines include/linux/swap.h
--- a/include/linux/swap.h~mm-make-swap-token-dummies-static-inlines
+++ a/include/linux/swap.h
@@ -419,10 +419,22 @@ static inline swp_entry_t get_swap_page(
 }
 
 /* linux/mm/thrash.c */
-#define put_swap_token(mm)	do { } while (0)
-#define grab_swap_token(mm)	do { } while (0)
-#define has_swap_token(mm)	0
-#define disable_swap_token()	do { } while (0)
+static inline void put_swap_token(struct mm_struct *mm)
+{
+}
+
+static inline void grab_swap_token(void)
+{
+}
+
+static inline int has_swap_token(struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void disable_swap_token(struct mm_struct *mm)
+{
+}
 
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
mm-pass-mm-to-grab_swap_token.patch
mm-make-swap-token-dummies-static-inlines.patch

