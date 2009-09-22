From: akpm@linux-foundation.org
Subject: [merged] mm-make-swap-token-dummies-static-inlines.patch removed from -mm tree
Date: Tue, 22 Sep 2009 13:37:19 -0700
Message-ID: <200909222037.n8MKbJ7V031601@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752787AbZIVUmT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 22 Sep 2009 16:42:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: hannes@cmpxchg.org, randy.dunlap@oracle.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     mm: make swap token dummies static inlines
has been removed from the -mm tree.  Its filename was
     mm-make-swap-token-dummies-static-inlines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: mm: make swap token dummies static inlines
From: Johannes Weiner <hannes@cmpxchg.org>

Make use of the compiler's typechecking on !CONFIG_SWAP as well.

[akpm@linux-foundation.org: build fix]
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Rik van Riel <riel@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>
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
+static inline void grab_swap_token(struct mm_struct *mm)
+{
+}
+
+static inline int has_swap_token(struct mm_struct *mm)
+{
+	return 0;
+}
+
+static inline void disable_swap_token(void)
+{
+}
 
 static inline void
 mem_cgroup_uncharge_swapcache(struct page *page, swp_entry_t ent)
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

origin.patch
linux-next.patch
vfs-explicitly-cast-s_maxbytes-in-fiemap_check_ranges.patch
vfs-change-sb-s_maxbytes-to-a-loff_t.patch
vfs-remove-redundant-position-check-in-do_sendfile.patch
mm-warn-once-when-a-page-is-freed-with-pg_mlocked-set.patch

