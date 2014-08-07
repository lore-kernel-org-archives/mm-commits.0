From: akpm@linux-foundation.org
Subject: [merged]
 ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch
 removed from -mm tree
Date: Thu, 07 Aug 2014 13:02:39 -0700
Message-ID: <53e3db5f.NwLDx42o4GRU1wla%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:51960 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbaHGUCk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:02:40 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1175139pab.3
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: xieyingtai@huawei.com, jlbec@evilplan.org, joseph.qi@huawei.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: correctly check the return value of ocfs2_search_extent_list
has been removed from the -mm tree.  Its filename was
     ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yingtai Xie <xieyingtai@huawei.com>
Subject: ocfs2: correctly check the return value of ocfs2_search_extent_list

ocfs2_search_extent_list may return -1, so we should check the return
value in ocfs2_split_and_insert, otherwise it may cause array index out of
bound.

And ocfs2_search_extent_list can only return value less than
el->l_next_free_rec, so check if it is equal or larger than
le16_to_cpu(el->l_next_free_rec) is meaningless.

Signed-off-by: Yingtai Xie <xieyingtai@huawei.com>
Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/alloc.c        |   15 ++++++++++++---
 fs/ocfs2/move_extents.c |    2 +-
 fs/ocfs2/refcounttree.c |    2 +-
 3 files changed, 14 insertions(+), 5 deletions(-)

diff -puN fs/ocfs2/alloc.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list fs/ocfs2/alloc.c
--- a/fs/ocfs2/alloc.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list
+++ a/fs/ocfs2/alloc.c
@@ -4961,6 +4961,15 @@ leftright:
 
 		el = path_leaf_el(path);
 		split_index = ocfs2_search_extent_list(el, cpos);
+		if (split_index == -1) {
+			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
+					"Owner %llu has an extent at cpos %u "
+					"which can no longer be found.\n",
+					(unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
+					cpos);
+			ret = -EROFS;
+			goto out;
+		}
 		goto leftright;
 	}
 out:
@@ -5135,7 +5144,7 @@ int ocfs2_change_extent_flag(handle_t *h
 	el = path_leaf_el(left_path);
 
 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(sb,
 			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
@@ -5491,7 +5500,7 @@ int ocfs2_remove_extent(handle_t *handle
 
 	el = path_leaf_el(path);
 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 			    "Owner %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
@@ -5557,7 +5566,7 @@ int ocfs2_remove_extent(handle_t *handle
 
 		el = path_leaf_el(path);
 		index = ocfs2_search_extent_list(el, cpos);
-		if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+		if (index == -1) {
 			ocfs2_error(ocfs2_metadata_cache_get_super(et->et_ci),
 				    "Owner %llu: split at cpos %u lost record.",
 				    (unsigned long long)ocfs2_metadata_cache_owner(et->et_ci),
diff -puN fs/ocfs2/move_extents.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list fs/ocfs2/move_extents.c
--- a/fs/ocfs2/move_extents.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list
+++ a/fs/ocfs2/move_extents.c
@@ -98,7 +98,7 @@ static int __ocfs2_move_extent(handle_t
 	el = path_leaf_el(path);
 
 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(inode->i_sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
diff -puN fs/ocfs2/refcounttree.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list fs/ocfs2/refcounttree.c
--- a/fs/ocfs2/refcounttree.c~ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list
+++ a/fs/ocfs2/refcounttree.c
@@ -3109,7 +3109,7 @@ static int ocfs2_clear_ext_refcount(hand
 	el = path_leaf_el(path);
 
 	index = ocfs2_search_extent_list(el, cpos);
-	if (index == -1 || index >= le16_to_cpu(el->l_next_free_rec)) {
+	if (index == -1) {
 		ocfs2_error(sb,
 			    "Inode %llu has an extent at cpos %u which can no "
 			    "longer be found.\n",
_

Patches currently in -mm which might be from xieyingtai@huawei.com are

origin.patch

