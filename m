Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F10A9C001B0
	for <mm-commits@archiver.kernel.org>; Fri, 11 Aug 2023 23:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235319AbjHKXDW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 11 Aug 2023 19:03:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236335AbjHKXBp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 11 Aug 2023 19:01:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22C143C3F
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 16:00:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA85665772
        for <mm-commits@vger.kernel.org>; Fri, 11 Aug 2023 23:00:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08171C433C8;
        Fri, 11 Aug 2023 23:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1691794851;
        bh=qrYSdJGBuWJ1Nruk0aPGXnHWhQSu+8BYuU5wdNOT50Y=;
        h=Date:To:From:Subject:From;
        b=MF2Kk8DCs1yzopGuyXJ7JiaGxATDwd3DEZKJrrUkwo+fyQJXYBkuqU76Zb1wTwdyP
         FaKtoWefGWoZWaxYy5VPABZVhNnBrVnLHNL0jshZuexIUGKQX+FgdLW8Rur7LONPfL
         VzINQagdB/i1aOt9kiOAYO2VAL4kesrnChyRHehg=
Date:   Fri, 11 Aug 2023 16:00:50 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        shy828301@gmail.com, naoya.horiguchi@nec.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        jthoughton@google.com, jiaqiyan@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] hugetlbfs-improve-read-hwpoison-hugepage.patch removed from -mm tree
Message-Id: <20230811230051.08171C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: hugetlbfs: improve read HWPOISON hugepage
has been removed from the -mm tree.  Its filename was
     hugetlbfs-improve-read-hwpoison-hugepage.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jiaqi Yan <jiaqiyan@google.com>
Subject: hugetlbfs: improve read HWPOISON hugepage
Date: Thu, 13 Jul 2023 00:18:32 +0000

When a hugepage contains HWPOISON pages, read() fails to read any byte of
the hugepage and returns -EIO, although many bytes in the HWPOISON
hugepage are readable.

Improve this by allowing hugetlbfs_read_iter returns as many bytes as
possible.  For a requested range [offset, offset + len) that contains
HWPOISON page, return [offset, first HWPOISON page addr); the next read
attempt will fail and return -EIO.

Link: https://lkml.kernel.org/r/20230713001833.3778937-4-jiaqiyan@google.com
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hugetlbfs/inode.c |   57 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 51 insertions(+), 6 deletions(-)

--- a/fs/hugetlbfs/inode.c~hugetlbfs-improve-read-hwpoison-hugepage
+++ a/fs/hugetlbfs/inode.c
@@ -283,6 +283,41 @@ hugetlb_get_unmapped_area(struct file *f
 #endif
 
 /*
+ * Someone wants to read @bytes from a HWPOISON hugetlb @page from @offset.
+ * Returns the maximum number of bytes one can read without touching the 1st raw
+ * HWPOISON subpage.
+ *
+ * The implementation borrows the iteration logic from copy_page_to_iter*.
+ */
+static size_t adjust_range_hwpoison(struct page *page, size_t offset, size_t bytes)
+{
+	size_t n = 0;
+	size_t res = 0;
+
+	/* First subpage to start the loop. */
+	page += offset / PAGE_SIZE;
+	offset %= PAGE_SIZE;
+	while (1) {
+		if (is_raw_hwpoison_page_in_hugepage(page))
+			break;
+
+		/* Safe to read n bytes without touching HWPOISON subpage. */
+		n = min(bytes, (size_t)PAGE_SIZE - offset);
+		res += n;
+		bytes -= n;
+		if (!bytes || !n)
+			break;
+		offset += n;
+		if (offset == PAGE_SIZE) {
+			page++;
+			offset = 0;
+		}
+	}
+
+	return res;
+}
+
+/*
  * Support for read() - Find the page attached to f_mapping and copy out the
  * data. This provides functionality similar to filemap_read().
  */
@@ -300,7 +335,7 @@ static ssize_t hugetlbfs_read_iter(struc
 
 	while (iov_iter_count(to)) {
 		struct page *page;
-		size_t nr, copied;
+		size_t nr, copied, want;
 
 		/* nr is the maximum number of bytes to copy from this page */
 		nr = huge_page_size(h);
@@ -328,16 +363,26 @@ static ssize_t hugetlbfs_read_iter(struc
 		} else {
 			unlock_page(page);
 
-			if (PageHWPoison(page)) {
-				put_page(page);
-				retval = -EIO;
-				break;
+			if (!PageHWPoison(page))
+				want = nr;
+			else {
+				/*
+				 * Adjust how many bytes safe to read without
+				 * touching the 1st raw HWPOISON subpage after
+				 * offset.
+				 */
+				want = adjust_range_hwpoison(page, offset, nr);
+				if (want == 0) {
+					put_page(page);
+					retval = -EIO;
+					break;
+				}
 			}
 
 			/*
 			 * We have the page, copy it to user space buffer.
 			 */
-			copied = copy_page_to_iter(page, offset, nr, to);
+			copied = copy_page_to_iter(page, offset, want, to);
 			put_page(page);
 		}
 		offset += copied;
_

Patches currently in -mm which might be from jiaqiyan@google.com are

mm-hwpoison-rename-hwp_walk-to-hwpoison_walk.patch

