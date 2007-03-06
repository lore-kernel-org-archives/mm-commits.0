From: akpm@linux-foundation.org
Subject: - reiser4-use-list_empty-instead-of-list_empty_careful-for.patch removed from -mm tree
Date: Mon, 05 Mar 2007 18:00:48 -0800
Message-ID: <200703060200.l2620mKQ008753@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:46658 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965703AbXCFCA7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 21:00:59 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: edward@namesys.com, mm-commits@vger.kernel.org


The patch titled
     reiser4: use list_empty instead of list_empty_careful for blocknr_set
has been removed from the -mm tree.  Its filename was
     reiser4-use-list_empty-instead-of-list_empty_careful-for.patch

This patch was dropped because it was folded into reiser4.patch

------------------------------------------------------
Subject: reiser4: use list_empty instead of list_empty_careful for blocknr_set
From: Edward Shishkin <edward@namesys.com>

this patch addresses the following todo item:

  > blocknr_set_add() modifies a list_head without any apparent
  > locking. Certainly without any _documented_ locking...
  > Ditto blocknr_set_destroy(). I'm sure there's locking, but
  > it's harder than it should be to work out what it is.
  > Given that proper locking is in place, the filesystem seems
  > to use list_*_careful() a lot more than is necessary?

Use list_empty() instead of list_empty_careful() for
reiser4 blocknr sets protected by atom lock.

Signed-off-by: Edward Shishkin <edward@namesys.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/reiser4/blocknrset.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff -puN fs/reiser4/blocknrset.c~reiser4-use-list_empty-instead-of-list_empty_careful-for fs/reiser4/blocknrset.c
--- a/fs/reiser4/blocknrset.c~reiser4-use-list_empty-instead-of-list_empty_careful-for
+++ a/fs/reiser4/blocknrset.c
@@ -28,6 +28,9 @@
  * extent; atom's wandered map is also stored as a blocknr set, blocknr pairs
  * there represent a (real block) -> (wandered block) mapping. */
 
+/* Protection: blocknr sets belong to reiser4 atom, and
+ * their modifications are performed with the atom lock held */
+
 typedef struct blocknr_pair blocknr_pair;
 
 /* The total size of a blocknr_set_entry. */
@@ -231,7 +234,7 @@ void blocknr_set_destroy(struct list_hea
 {
 	blocknr_set_entry *bse;
 
-	while (!list_empty_careful(bset)) {
+	while (!list_empty(bset)) {
 		bse = list_entry(bset->next, blocknr_set_entry, link);
 		list_del_init(&bse->link);
 		bse_free(bse);
@@ -253,10 +256,10 @@ void blocknr_set_merge(struct list_head 
 	blocknr_set_entry *bse_into = NULL;
 
 	/* If @from is empty, no work to perform. */
-	if (list_empty_careful(from))
+	if (list_empty(from))
 		return;
 	/* If @into is not empty, try merging partial-entries. */
-	if (!list_empty_careful(into)) {
+	if (!list_empty(into)) {
 
 		/* Neither set is empty, pop the front to members and try to combine them. */
 		blocknr_set_entry *bse_from;
_

Patches currently in -mm which might be from edward@namesys.com are

reiser4.patch
reiser4-use-list_empty-instead-of-list_empty_careful-for.patch
reiser4-update-comments-fix-write-and-truncate-cryptcompress.patch
reiser4-temp-fix.patch
reiser4-fix-write_extent-1.patch
fs-reiser4-possible-cleanups-2.patch
fs-reiser4-more-possible-cleanups.patch
reiser4-use-null-for-pointers.patch
reiser4-test_clear_page_dirty.patch
reiser4-fix-readpage_cryptcompress.patch
reiser4-improve-estimation-for-number-of-nodes-occupied.patch
reiser4-drop-check_cryptcompress.patch
reiser4-drop-unused-semaphores.patch
reiser4-use-dynamic-lattice-for-adaptive-compression.patch
reiser4-fix-freeze-and-corruption.patch
