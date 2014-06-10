From: akpm@linux-foundation.org
Subject: +
 ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch
 added to -mm tree
Date: Tue, 10 Jun 2014 15:51:33 -0700
Message-ID: <53978bf5.5qNFNv3ApWnXmVVL%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998AbaFJWve (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jun 2014 18:51:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mfasheh@suse.com, joseph.qi@huawei.com, jlbec@evilplan.org, xieyingtai@huawei.com

Subject: + ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch added to -mm tree
To: xieyingtai@huawei.com,jlbec@evilplan.org,joseph.qi@huawei.com,mfasheh@suse.com
From: akpm@linux-foundation.org
Date: Tue, 10 Jun 2014 15:51:33 -0700


The patch titled
     Subject: ocfs2: correctly check the return value of ocfs2_search_extent_list
has been added to the -mm tree.  Its filename is
     ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

ocfs2-correctly-check-the-return-value-of-ocfs2_search_extent_list.patch

