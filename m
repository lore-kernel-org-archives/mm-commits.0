Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FA64CCA47F
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:12:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379745AbiFQCM4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379694AbiFQCMd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:12:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7811038F
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:12:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BAE7B82694
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:12:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F923C34114;
        Fri, 17 Jun 2022 02:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655431947;
        bh=pFvec5ZELI1XMxLPPzIV105rz20DH37lqrQcZYQxRUI=;
        h=Date:To:From:Subject:From;
        b=cb7iKqY+0LzTMuMXwCaMZRtQ5NyIwCoe3C6hw0oESpsOSsNgUQBY45sryeOj0GSff
         sQVf+FutPPG7eIewuZlAm2Bkvl78Om4sDfZ1tdF3VtJLCT3xh7CTvampufNOE4LO/U
         68HRcKWGRnvyzZ67DRX8dUfd3MTHDJhErWw9FMog=
Date:   Thu, 16 Jun 2022 19:12:27 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        songmuchun@bytedance.com, naoya.horiguchi@linux.dev,
        mhocko@suse.com, david@redhat.com, dave.hansen@intel.com,
        axelrasmussen@google.com, mike.kravetz@oracle.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] hugetlbfs-zero-partial-pages-during-fallocate-hole-punch.patch removed from -mm tree
Message-Id: <20220617021227.9F923C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: zero partial pages during fallocate hole punch
has been removed from the -mm tree.  Its filename was
     hugetlbfs-zero-partial-pages-during-fallocate-hole-punch.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: hugetlbfs: zero partial pages during fallocate hole punch
Date: Mon, 13 Jun 2022 13:36:48 -0700

hugetlbfs fallocate support was originally added with commit 70c3547e36f5
("hugetlbfs: add hugetlbfs_fallocate()").  Initial support only operated
on whole hugetlb pages.  This makes sense for populating files as other
interfaces such as mmap and truncate require hugetlb page size alignment. 
Only operating on whole hugetlb pages for the hole punch case was a
simplification and there was no compelling use case to zero partial pages.

In a recent discussion[1] it was assumed that hugetlbfs hole punch would
zero partial hugetlb pages as that is in line with the man page
description saying 'partial filesystem blocks are zeroed'.  However, the
hugetlbfs hole punch code actually does this:

        hole_start = round_up(offset, hpage_size);
        hole_end = round_down(offset + len, hpage_size);

Modify code to zero partial hugetlb pages in hole punch range.  It is
possible that application code could note a change in behavior.  However,
that would imply the code is passing in an unaligned range and expecting
only whole pages be removed.  This is unlikely as the fallocate
documentation states the opposite.

The current hugetlbfs fallocate hole punch behavior is tested with the
libhugetlbfs test fallocate_align[2].  This test will be updated to
validate partial page zeroing.

[1] https://lore.kernel.org/linux-mm/20571829-9d3d-0b48-817c-b6b15565f651@redhat.com/
[2] https://github.com/libhugetlbfs/libhugetlbfs/blob/master/tests/fallocate_align.c

Link: https://lkml.kernel.org/r/YqeiMlZDKI1Kabfe@monkey
Signed-off-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   68 +++++++++++++++++++++++++++++++----------
 1 file changed, 53 insertions(+), 15 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-zero-partial-pages-during-fallocate-hole-punch
+++ a/fs/hugetlbfs/inode.c
@@ -600,41 +600,79 @@ static void hugetlb_vmtruncate(struct in
 	remove_inode_hugepages(inode, offset, LLONG_MAX);
 }
 
+static void hugetlbfs_zero_partial_page(struct hstate *h,
+					struct address_space *mapping,
+					loff_t start,
+					loff_t end)
+{
+	pgoff_t idx = start >> huge_page_shift(h);
+	struct folio *folio;
+
+	folio = filemap_lock_folio(mapping, idx);
+	if (!folio)
+		return;
+
+	start = start & ~huge_page_mask(h);
+	end = end & ~huge_page_mask(h);
+	if (!end)
+		end = huge_page_size(h);
+
+	folio_zero_segment(folio, (size_t)start, (size_t)end);
+
+	folio_unlock(folio);
+	folio_put(folio);
+}
+
 static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 {
+	struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
+	struct address_space *mapping = inode->i_mapping;
 	struct hstate *h = hstate_inode(inode);
 	loff_t hpage_size = huge_page_size(h);
 	loff_t hole_start, hole_end;
 
 	/*
-	 * For hole punch round up the beginning offset of the hole and
-	 * round down the end.
+	 * hole_start and hole_end indicate the full pages within the hole.
 	 */
 	hole_start = round_up(offset, hpage_size);
 	hole_end = round_down(offset + len, hpage_size);
 
-	if (hole_end > hole_start) {
-		struct address_space *mapping = inode->i_mapping;
-		struct hugetlbfs_inode_info *info = HUGETLBFS_I(inode);
+	inode_lock(inode);
+
+	/* protected by i_rwsem */
+	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
+		inode_unlock(inode);
+		return -EPERM;
+	}
 
-		inode_lock(inode);
+	i_mmap_lock_write(mapping);
 
-		/* protected by i_rwsem */
-		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
-			inode_unlock(inode);
-			return -EPERM;
-		}
+	/* If range starts before first full page, zero partial page. */
+	if (offset < hole_start)
+		hugetlbfs_zero_partial_page(h, mapping,
+				offset, min(offset + len, hole_start));
 
-		i_mmap_lock_write(mapping);
+	/* Unmap users of full pages in the hole. */
+	if (hole_end > hole_start) {
 		if (!RB_EMPTY_ROOT(&mapping->i_mmap.rb_root))
 			hugetlb_vmdelete_list(&mapping->i_mmap,
 					      hole_start >> PAGE_SHIFT,
 					      hole_end >> PAGE_SHIFT, 0);
-		i_mmap_unlock_write(mapping);
-		remove_inode_hugepages(inode, hole_start, hole_end);
-		inode_unlock(inode);
 	}
 
+	/* If range extends beyond last full page, zero partial page. */
+	if ((offset + len) > hole_end && (offset + len) > hole_start)
+		hugetlbfs_zero_partial_page(h, mapping,
+				hole_end, offset + len);
+
+	i_mmap_unlock_write(mapping);
+
+	/* Remove full pages from the file. */
+	if (hole_end > hole_start)
+		remove_inode_hugepages(inode, hole_start, hole_end);
+
+	inode_unlock(inode);
+
 	return 0;
 }
 
_

Patches currently in -mm which might be from mike.kravetz@oracle.com are


