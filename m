From: akpm@linux-foundation.org
Subject: + ocfs2-test-target-page-before-change-it.patch added to -mm tree
Date: Fri, 11 Sep 2015 15:32:30 -0700
Message-ID: <55f3567e.DKMt/22SXX6w/0hj%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbbIKWcb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 11 Sep 2015 18:32:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ryan.ding@oracle.com, jlbec@evilplan.org, joseph.qi@huawei.com, junxiao.bi@oracle.com, mfasheh@suse.de, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: test target page before change it
has been added to the -mm tree.  Its filename is
     ocfs2-test-target-page-before-change-it.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ocfs2-test-target-page-before-change-it.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ocfs2-test-target-page-before-change-it.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ryan Ding <ryan.ding@oracle.com>
Subject: ocfs2: test target page before change it

To support direct io in ocfs2_write_begin_nolock & ocfs2_write_end_nolock.

Direct io data will not appear in buffer.  The w_target_page member will
not be filled by direct io.  So avoid to use it when it's NULL.  Unlinke
buffer io and mmap, direct io will call write_begin with more than 1 page
a time.  So the target_index is not sufficient to describe the actual
data.  change it to a range start at target_index, end in end_index.

Signed-off-by: Ryan Ding <ryan.ding@oracle.com>
Reviewed-by: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Mark Fasheh <mfasheh@suse.de>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/aops.c |   32 ++++++++++++++++++++++++++------
 1 file changed, 26 insertions(+), 6 deletions(-)

diff -puN fs/ocfs2/aops.c~ocfs2-test-target-page-before-change-it fs/ocfs2/aops.c
--- a/fs/ocfs2/aops.c~ocfs2-test-target-page-before-change-it
+++ a/fs/ocfs2/aops.c
@@ -1399,12 +1399,13 @@ static void ocfs2_write_failure(struct i
 		to = user_pos + user_len;
 	struct page *tmppage;
 
-	ocfs2_zero_new_buffers(wc->w_target_page, from, to);
+	if (wc->w_target_page)
+		ocfs2_zero_new_buffers(wc->w_target_page, from, to);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
 
-		if (page_has_buffers(tmppage)) {
+		if (tmppage && page_has_buffers(tmppage)) {
 			if (ocfs2_should_order_data(inode))
 				ocfs2_jbd2_file_inode(wc->w_handle, inode);
 
@@ -1534,11 +1535,13 @@ static int ocfs2_grab_pages_for_write(st
 		wc->w_num_pages = 1;
 		start = target_index;
 	}
+	end_index = (user_pos + user_len - 1) >> PAGE_CACHE_SHIFT;
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		index = start + i;
 
-		if (index == target_index && mmap_page) {
+		if (index >= target_index && index <= end_index &&
+		    wc->w_type == OCFS2_WRITE_MMAP) {
 			/*
 			 * ocfs2_pagemkwrite() is a little different
 			 * and wants us to directly use the page
@@ -1557,6 +1560,11 @@ static int ocfs2_grab_pages_for_write(st
 			page_cache_get(mmap_page);
 			wc->w_pages[i] = mmap_page;
 			wc->w_target_locked = true;
+		} else if (index >= target_index && index <= end_index &&
+			   wc->w_type == OCFS2_WRITE_DIRECT) {
+			/* Direct write has no mapping page. */
+			wc->w_pages[i] = NULL;
+			continue;
 		} else {
 			wc->w_pages[i] = find_or_create_page(mapping, index,
 							     GFP_NOFS);
@@ -1658,6 +1666,12 @@ static int ocfs2_write_cluster(struct ad
 	for(i = 0; i < wc->w_num_pages; i++) {
 		int tmpret;
 
+		/* This is the direct io target page. */
+		if (wc->w_pages[i] == NULL) {
+			p_blkno++;
+			continue;
+		}
+
 		tmpret = ocfs2_prepare_page_for_write(inode, &p_blkno, wc,
 						      wc->w_pages[i], cpos,
 						      user_pos, user_len,
@@ -2259,7 +2273,8 @@ try_again:
 		ocfs2_free_alloc_context(meta_ac);
 
 success:
-	*pagep = wc->w_target_page;
+	if (pagep)
+		*pagep = wc->w_target_page;
 	*fsdata = wc;
 	return 0;
 out_quota:
@@ -2393,18 +2408,23 @@ int ocfs2_write_end_nolock(struct addres
 		goto out_write_size;
 	}
 
-	if (unlikely(copied < len)) {
+	if (unlikely(copied < len) && wc->w_target_page) {
 		if (!PageUptodate(wc->w_target_page))
 			copied = 0;
 
 		ocfs2_zero_new_buffers(wc->w_target_page, start+copied,
 				       start+len);
 	}
-	flush_dcache_page(wc->w_target_page);
+	if (wc->w_target_page)
+		flush_dcache_page(wc->w_target_page);
 
 	for(i = 0; i < wc->w_num_pages; i++) {
 		tmppage = wc->w_pages[i];
 
+		/* This is the direct io target page. */
+		if (tmppage == NULL)
+			continue;
+
 		if (tmppage == wc->w_target_page) {
 			from = wc->w_target_from;
 			to = wc->w_target_to;
_

Patches currently in -mm which might be from ryan.ding@oracle.com are

ocfs2-add-ocfs2_write_type_t-type-to-identify-the-caller-of-write.patch
ocfs2-use-c_new-to-indicate-newly-allocated-extents.patch
ocfs2-test-target-page-before-change-it.patch
ocfs2-do-not-change-i_size-in-write_end-for-direct-io.patch
ocfs2-return-the-physical-address-in-ocfs2_write_cluster.patch
ocfs2-record-unwritten-extents-when-populate-write-desc.patch
ocfs2-fix-sparse-file-data-ordering-issue-in-direct-io.patch
ocfs2-code-clean-up-for-direct-io.patch

