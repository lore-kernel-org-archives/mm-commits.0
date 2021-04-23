Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3F6EC433B4
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA19961469
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244015AbhDWV3j (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:29:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244023AbhDWV3i (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Apr 2021 17:29:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC01661494;
        Fri, 23 Apr 2021 21:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213341;
        bh=R3+psPEHjS+f/1eA5d+m6Sr3gUYoybDcFxwQkDyVIwQ=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=U+Jb8DJIaE0DTkt+JBqHAEHzTo7DOV9Z5I7zx4DUysVJ56AHxl1WjzXfqm7jbPLYj
         rCZR8gIbkqbdYSv7n40tXfybnsSX7aYLCbOZkj83cQFrCzPCO0ohUorUQhmMabxJFH
         1ZLXFhJU2nlNzA38j/zCCDUoIv9MIjL1tgg+Zk5g=
Date:   Fri, 23 Apr 2021 14:29:00 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 4/5] mm/filemap: fix mapping_seek_hole_data on THP
 & 32-bit
Message-ID: <20210423212900.bdXHf5h31%akpm@linux-foundation.org>
In-Reply-To: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Hugh Dickins <hughd@google.com>
Subject: mm/filemap: fix mapping_seek_hole_data on THP & 32-bit

No problem on 64-bit without huge pages, but xfstests generic/285 and
other SEEK_HOLE/SEEK_DATA tests have regressed on huge tmpfs, and on
32-bit architectures, with the new mapping_seek_hole_data().  Several
different bugs turned out to need fixing.

u64 cast to stop losing bits when converting unsigned long to loff_t (and
let's use shifts throughout, rather than mixed with * and /).

Use round_up() when advancing pos, to stop assuming that pos was already
THP-aligned when advancing it by THP-size.  (This use of round_up()
assumes that any THP has THP-aligned index: true at present and true going
forward, but could be recoded to avoid the assumption.)

Use xas_set() when iterating away from a THP, so that xa_index stays in
synch with start, instead of drifting away to return bogus offset.

Check start against end to avoid wrapping 32-bit xa_index to 0 (and to
handle these additional cases, seek_data or not, it's easier to break the
loop than goto: so rearrange exit from the function).

[hughd@google.com: remove unneeded u64 casts, per Matthew]
  Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104221347240.1170@eggly.anvils
Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104211737410.3299@eggly.anvils
Fixes: 41139aa4c3a3 ("mm/filemap: add mapping_seek_hole_data")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit
+++ a/mm/filemap.c
@@ -2678,7 +2678,7 @@ loff_t mapping_seek_hole_data(struct add
 		loff_t end, int whence)
 {
 	XA_STATE(xas, &mapping->i_pages, start >> PAGE_SHIFT);
-	pgoff_t max = (end - 1) / PAGE_SIZE;
+	pgoff_t max = (end - 1) >> PAGE_SHIFT;
 	bool seek_data = (whence == SEEK_DATA);
 	struct page *page;
 
@@ -2687,7 +2687,8 @@ loff_t mapping_seek_hole_data(struct add
 
 	rcu_read_lock();
 	while ((page = find_get_entry(&xas, max, XA_PRESENT))) {
-		loff_t pos = xas.xa_index * PAGE_SIZE;
+		loff_t pos = (u64)xas.xa_index << PAGE_SHIFT;
+		unsigned int seek_size;
 
 		if (start < pos) {
 			if (!seek_data)
@@ -2695,25 +2696,25 @@ loff_t mapping_seek_hole_data(struct add
 			start = pos;
 		}
 
-		pos += seek_page_size(&xas, page);
+		seek_size = seek_page_size(&xas, page);
+		pos = round_up(pos + 1, seek_size);
 		start = page_seek_hole_data(&xas, mapping, page, start, pos,
 				seek_data);
 		if (start < pos)
 			goto unlock;
+		if (start >= end)
+			break;
+		if (seek_size > PAGE_SIZE)
+			xas_set(&xas, pos >> PAGE_SHIFT);
 		if (!xa_is_value(page))
 			put_page(page);
 	}
-	rcu_read_unlock();
-
 	if (seek_data)
-		return -ENXIO;
-	goto out;
-
+		start = -ENXIO;
 unlock:
 	rcu_read_unlock();
-	if (!xa_is_value(page))
+	if (page && !xa_is_value(page))
 		put_page(page);
-out:
 	if (start > end)
 		return end;
 	return start;
_
