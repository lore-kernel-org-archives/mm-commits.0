Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 746E8C43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33AA522228
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633144;
	bh=9lblYUDQuQXIc+Em531EfZY5r75mryVz2Z/rPy6WIlI=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=u8RzM6/XhRwyuxHnYK0geZgFqEfrlBeDQ8jqxbj2SsAhZbuHrkisb/2Yml1CRZ6LM
	 SdHOByJFtlGxCl0C2XCa3Oej33eZ8NB0M/wJGtoufG6mliLQQLSvE+Q1sj34gNDRz0
	 ljCvSb5IN+FNucZ8k/3LVPpti2lp+meDJRBhdoGM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgJMXwX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:36674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728674AbgJMXvt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:51:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F5C121D81;
        Tue, 13 Oct 2020 23:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633108;
        bh=9lblYUDQuQXIc+Em531EfZY5r75mryVz2Z/rPy6WIlI=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JsmTlH1m0mUSZzyZpMEJyGVzb71wtIV/vsrugiV3xZeIKLaj7qPw8DVxBKgd/9duB
         WhcJlZvWQ6X8BwlgbG5StAo6POJePNGqftqBzb0rw3SDKMC4dk745F+jSpA/cAYQ2I
         jfMnmIAFcBVJYbYiOKrOTlZF32NzthmOMS9LCCF4=
Date:   Tue, 13 Oct 2020 16:51:47 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hannes@cmpxchg.org,
        laoar.shao@gmail.com, linux-mm@kvack.org, mgorman@suse.de,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 063/181] mm, fadvise: improve the expensive remote
 LRU cache draining after FADV_DONTNEED
Message-ID: <20201013235147.a4WzEhOpP%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Yafang Shao <laoar.shao@gmail.com>
Subject: mm, fadvise: improve the expensive remote LRU cache draining after FADV_DONTNEED

Our users reported that there're some random latency spikes when their RT
process is running.  Finally we found that latency spike is caused by
FADV_DONTNEED.  Which may call lru_add_drain_all() to drain LRU cache on
remote CPUs, and then waits the per-cpu work to complete.  The wait time
is uncertain, which may be tens millisecond.

That behavior is unreasonable, because this process is bound to a specific
CPU and the file is only accessed by itself, IOW, there should be no
pagecache pages on a per-cpu pagevec of a remote CPU.  That unreasonable
behavior is partially caused by the wrong comparation of the number of
invalidated pages and the number of the target.  For example,

        if (count < (end_index - start_index + 1))

The count above is how many pages were invalidated in the local CPU, and
(end_index - start_index + 1) is how many pages should be invalidated. 
The usage of (end_index - start_index + 1) is incorrect, because they are
virtual addresses, which may not mapped to pages.  Besides that, there may
be holes between start and end.  So we'd better check whether there are
still pages on per-cpu pagevec after drain the local cpu, and then decide
whether or not to call lru_add_drain_all().

After I applied it with a hotfix to our production environment, most of
the lru_add_drain_all() can be avoided.

Link: https://lkml.kernel.org/r/20200923133318.14373-1-laoar.shao@gmail.com
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
Suggested-by: Mel Gorman <mgorman@suse.de>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++
 mm/fadvise.c       |    9 +++---
 mm/truncate.c      |   58 +++++++++++++++++++++++++++++--------------
 3 files changed, 49 insertions(+), 22 deletions(-)

--- a/include/linux/fs.h~mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed
+++ a/include/linux/fs.h
@@ -2581,6 +2581,10 @@ extern bool is_bad_inode(struct inode *)
 unsigned long invalidate_mapping_pages(struct address_space *mapping,
 					pgoff_t start, pgoff_t end);
 
+void invalidate_mapping_pagevec(struct address_space *mapping,
+				pgoff_t start, pgoff_t end,
+				unsigned long *nr_pagevec);
+
 static inline void invalidate_remote_inode(struct inode *inode)
 {
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
--- a/mm/fadvise.c~mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed
+++ a/mm/fadvise.c
@@ -141,7 +141,7 @@ int generic_fadvise(struct file *file, l
 		}
 
 		if (end_index >= start_index) {
-			unsigned long count;
+			unsigned long nr_pagevec = 0;
 
 			/*
 			 * It's common to FADV_DONTNEED right after
@@ -154,8 +154,9 @@ int generic_fadvise(struct file *file, l
 			 */
 			lru_add_drain();
 
-			count = invalidate_mapping_pages(mapping,
-						start_index, end_index);
+			invalidate_mapping_pagevec(mapping,
+						start_index, end_index,
+						&nr_pagevec);
 
 			/*
 			 * If fewer pages were invalidated than expected then
@@ -163,7 +164,7 @@ int generic_fadvise(struct file *file, l
 			 * a per-cpu pagevec for a remote CPU. Drain all
 			 * pagevecs and try again.
 			 */
-			if (count < (end_index - start_index + 1)) {
+			if (nr_pagevec) {
 				lru_add_drain_all();
 				invalidate_mapping_pages(mapping, start_index,
 						end_index);
--- a/mm/truncate.c~mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed
+++ a/mm/truncate.c
@@ -528,23 +528,8 @@ void truncate_inode_pages_final(struct a
 }
 EXPORT_SYMBOL(truncate_inode_pages_final);
 
-/**
- * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
- * @mapping: the address_space which holds the pages to invalidate
- * @start: the offset 'from' which to invalidate
- * @end: the offset 'to' which to invalidate (inclusive)
- *
- * This function only removes the unlocked pages, if you want to
- * remove all the pages of one inode, you must call truncate_inode_pages.
- *
- * invalidate_mapping_pages() will not block on IO activity. It will not
- * invalidate pages which are dirty, locked, under writeback or mapped into
- * pagetables.
- *
- * Return: the number of the pages that were invalidated
- */
-unsigned long invalidate_mapping_pages(struct address_space *mapping,
-		pgoff_t start, pgoff_t end)
+unsigned long __invalidate_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
 {
 	pgoff_t indices[PAGEVEC_SIZE];
 	struct pagevec pvec;
@@ -610,8 +595,13 @@ unsigned long invalidate_mapping_pages(s
 			 * Invalidation is a hint that the page is no longer
 			 * of interest and try to speed up its reclaim.
 			 */
-			if (!ret)
+			if (!ret) {
 				deactivate_file_page(page);
+				/* It is likely on the pagevec of a remote CPU */
+				if (nr_pagevec)
+					(*nr_pagevec)++;
+			}
+
 			if (PageTransHuge(page))
 				put_page(page);
 			count += ret;
@@ -623,8 +613,40 @@ unsigned long invalidate_mapping_pages(s
 	}
 	return count;
 }
+
+/**
+ * invalidate_mapping_pages - Invalidate all the unlocked pages of one inode
+ * @mapping: the address_space which holds the pages to invalidate
+ * @start: the offset 'from' which to invalidate
+ * @end: the offset 'to' which to invalidate (inclusive)
+ *
+ * This function only removes the unlocked pages, if you want to
+ * remove all the pages of one inode, you must call truncate_inode_pages.
+ *
+ * invalidate_mapping_pages() will not block on IO activity. It will not
+ * invalidate pages which are dirty, locked, under writeback or mapped into
+ * pagetables.
+ *
+ * Return: the number of the pages that were invalidated
+ */
+unsigned long invalidate_mapping_pages(struct address_space *mapping,
+		pgoff_t start, pgoff_t end)
+{
+	return __invalidate_mapping_pages(mapping, start, end, NULL);
+}
 EXPORT_SYMBOL(invalidate_mapping_pages);
 
+/**
+ * This helper is similar with the above one, except that it accounts for pages
+ * that are likely on a pagevec and count them in @nr_pagevec, which will used by
+ * the caller.
+ */
+void invalidate_mapping_pagevec(struct address_space *mapping,
+		pgoff_t start, pgoff_t end, unsigned long *nr_pagevec)
+{
+	__invalidate_mapping_pages(mapping, start, end, nr_pagevec);
+}
+
 /*
  * This is like invalidate_complete_page(), except it ignores the page's
  * refcount.  We do this because invalidate_inode_pages2() needs stronger
_
