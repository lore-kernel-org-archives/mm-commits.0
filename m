Return-Path: <SRS0=qjDH=DG=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A53DC2D0A8
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28EA22193E
	for <mm-commits@archiver.kernel.org>; Tue, 29 Sep 2020 00:43:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601340191;
	bh=lSrVAtDCfAzY/T3B/FkHtXGys2HsI3ropk1TY1YdMuk=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=k6w15F+LXGtxBoHKY/IY8lNoVLoALWPwLdo4obEsJ31rr6pyQUG53vF8FEaudTVAt
	 5XDRnD+ozwCBlDPSS1HFnN0qwNWprEnvwAfiGT+IddHmlj/86IQodZe3DDy4BwCe+M
	 SnxEHRa4khUelUJLttnFWmsCeL5oHxihK5Ym5nRk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbgI2AnK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Sep 2020 20:43:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:47726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725272AbgI2AnK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Sep 2020 20:43:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF5EC2184D;
        Tue, 29 Sep 2020 00:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601340189;
        bh=lSrVAtDCfAzY/T3B/FkHtXGys2HsI3ropk1TY1YdMuk=;
        h=Date:From:To:Subject:From;
        b=QoQ57xR6vl8zG1TU11qaspNvSoXPzFhtyeDwjNaq46yDkr1zo0rqMINn9VZJXdXHG
         NsCLpaB06WMUUGzglypN+hPgIsEWFcyB37Ycrf1aLdDWQRnBvcwSKAl9vOfIQsv5eQ
         McZZYKiYsiJd+Itgi5DJR/NMgKHygQK33DzhTO3g=
Date:   Mon, 28 Sep 2020 17:43:09 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, laoar.shao@gmail.com, mgorman@suse.de,
        mm-commits@vger.kernel.org
Subject:  +
 =?US-ASCII?Q?mm-fadvise-improve-the-expensive-remote-lru-cache-draining-a?=
 =?US-ASCII?Q?fter-fadv=5Fdontneed.patch?= added to -mm tree
Message-ID: <20200929004309.oGdL5g0zf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm, fadvise: improve the expensive remote LRU cache draining after FADV_DONTNEED
has been added to the -mm tree.  Its filename is
     mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
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
@@ -2591,6 +2591,10 @@ extern bool is_bad_inode(struct inode *)
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

Patches currently in -mm which might be from laoar.shao@gmail.com are

mm-fadvise-improve-the-expensive-remote-lru-cache-draining-after-fadv_dontneed.patch

