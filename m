Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DA84C433B4
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:36:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C6B06144A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 04:36:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230119AbhDVEgh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 00:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229468AbhDVEgg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 00:36:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CE9861437;
        Thu, 22 Apr 2021 04:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619066162;
        bh=fAk3LIn9zIR7iTi06FFtNDheQtLtLc8pj6HsJlVU1Ak=;
        h=Date:From:To:Subject:From;
        b=z9P4+DDG2NYLCNK/e01QrvTHYhBd16EK++rxCWoBM63vs/X8NZAav3ANHTf6tyNlG
         2m4oWn4ygtdkOob312P30YiYF4Hrk0t/raSdvzITNVi3f4d3utpLFFFSYOT3oZCv7V
         +Vk8RBJUBruct7nxXYyuvnxu4jaH0NPQ7VMXHmNw=
Date:   Wed, 21 Apr 2021 21:36:01 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch added to -mm tree
Message-ID: <20210422043601._ozQ0-vjO%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix mapping_seek_hole_data on THP & 32-bit
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/filemap: fix mapping_seek_hole_data on THP & 32-bit

No problem on 64-bit without huge pages, but xfstests generic/285 and
other SEEK_HOLE/SEEK_DATA tests have regressed on huge tmpfs, and on
32-bit architectures, with the new mapping_seek_hole_data().  Several
different bugs turned out to need fixing.

u64 casts added to stop unfortunate sign-extension when shifting (and
let's use shifts throughout, rather than mixed with * and /).

Use round_up() when advancing pos, to stop assuming that pos was already
THP-aligned when advancing it by THP-size.  (But I believe this use of
round_up() assumes that any THP must be THP-aligned: true while tmpfs
enforces that alignment, and is the only fs with FS_THP_SUPPORT; but might
need to be generalized in the future?  If I try to generalize it right
now, I'm sure to get it wrong!)

Use xas_set() when iterating away from a THP, so that xa_index stays in
synch with start, instead of drifting away to return bogus offset.

Check start against end to avoid wrapping 32-bit xa_index to 0 (and to
handle these additional cases, seek_data or not, it's easier to break the
loop than goto: so rearrange exit from the function).

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

 mm/filemap.c |   23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit
+++ a/mm/filemap.c
@@ -2677,8 +2677,8 @@ unsigned int seek_page_size(struct xa_st
 loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 		loff_t end, int whence)
 {
-	XA_STATE(xas, &mapping->i_pages, start >> PAGE_SHIFT);
-	pgoff_t max = (end - 1) / PAGE_SIZE;
+	XA_STATE(xas, &mapping->i_pages, (u64)start >> PAGE_SHIFT);
+	pgoff_t max = (u64)(end - 1) >> PAGE_SHIFT;
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
+		pos = round_up((u64)pos + 1, seek_size);
 		start = page_seek_hole_data(&xas, mapping, page, start, pos,
 				seek_data);
 		if (start < pos)
 			goto unlock;
+		if (start >= end)
+			break;
+		if (seek_size > PAGE_SIZE)
+			xas_set(&xas, (u64)pos >> PAGE_SHIFT);
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

mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch
mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch
mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

