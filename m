Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	URIBL_RED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09927C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED7D610D2
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229616AbhEHWjw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:42524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjw (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD752613EA;
        Sat,  8 May 2021 22:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513530;
        bh=bI2izRbDUbmrGj5ge5eMiFATHn9yS7+UXt7rqH2DEAI=;
        h=Date:From:To:Subject:From;
        b=TW7Sy0TbgNuCrMQdBAZDYg9t6aa4cz/u2pspIkMz16sspsWb6JU3poEaf2E1RuWml
         KU4pFxVrwYskBVfVKb3hKgzkHVPjxzNxxmy3ZbfdKc1GG/d5hzFVYxt4vEoi8IF/Ls
         T2yCkBckxja5TbjcMJnAWLdZrCzEZF7sJ8nNRgso=
Date:   Sat, 08 May 2021 15:38:49 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch removed from -mm
 tree
Message-ID: <20210508223849.6sFMYaBYt%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix mapping_seek_hole_data on THP & 32-bit
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hughd@google.com are


