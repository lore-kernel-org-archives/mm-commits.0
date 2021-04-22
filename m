Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AFEFC433ED
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44E6261404
	for <mm-commits@archiver.kernel.org>; Thu, 22 Apr 2021 23:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236949AbhDVXDj (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Apr 2021 19:03:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:53210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235977AbhDVXDi (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Apr 2021 19:03:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E492C61417;
        Thu, 22 Apr 2021 23:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619132583;
        bh=S3NfI5YRiUQ1OfBqf0hQMt2zavWbp2EVLdv6dpp07xk=;
        h=Date:From:To:Subject:From;
        b=eGSrrosLK9mIzUKMd9ML/qW2T8NHiF37r0pKJLPFtDrCHv5OtDwaeVMPrhRkqrrKo
         nHrZ1Y+iiUCe6k0MQWxwxw/HwreGqQepw1m7SnvVQyjR6bGk8f2r/lo/g9pFvfu0fc
         qZJ9l7BTDGpzAcNZtEo4kp5S3Lq7kX0nLBDs3ObI=
Date:   Thu, 22 Apr 2021 16:03:02 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  +
 mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2.patch added to -mm
 tree
Message-ID: <20210422230302.C6iYqA-Pn%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2
has been added to the -mm tree.  Its filename is
     mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2.patch

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
Subject: mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2

remove unneeded u64 casts

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104221347240.1170@eggly.anvils
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

 mm/filemap.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2
+++ a/mm/filemap.c
@@ -2677,8 +2677,8 @@ unsigned int seek_page_size(struct xa_st
 loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
 		loff_t end, int whence)
 {
-	XA_STATE(xas, &mapping->i_pages, (u64)start >> PAGE_SHIFT);
-	pgoff_t max = (u64)(end - 1) >> PAGE_SHIFT;
+	XA_STATE(xas, &mapping->i_pages, start >> PAGE_SHIFT);
+	pgoff_t max = (end - 1) >> PAGE_SHIFT;
 	bool seek_data = (whence == SEEK_DATA);
 	struct page *page;
 
@@ -2697,7 +2697,7 @@ loff_t mapping_seek_hole_data(struct add
 		}
 
 		seek_size = seek_page_size(&xas, page);
-		pos = round_up((u64)pos + 1, seek_size);
+		pos = round_up(pos + 1, seek_size);
 		start = page_seek_hole_data(&xas, mapping, page, start, pos,
 				seek_data);
 		if (start < pos)
@@ -2705,7 +2705,7 @@ loff_t mapping_seek_hole_data(struct add
 		if (start >= end)
 			break;
 		if (seek_size > PAGE_SIZE)
-			xas_set(&xas, (u64)pos >> PAGE_SHIFT);
+			xas_set(&xas, pos >> PAGE_SHIFT);
 		if (!xa_is_value(page))
 			put_page(page);
 	}
_

Patches currently in -mm which might be from hughd@google.com are

mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch
mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit.patch
mm-filemap-fix-mapping_seek_hole_data-on-thp-32-bit-v2.patch
mm-restore-node-stat-checking-in-proc-sys-vm-stat_refresh.patch
mm-no-more-einval-from-proc-sys-vm-stat_refresh.patch
mm-proc-sys-vm-stat_refresh-skip-checking-known-negative-stats.patch
mm-proc-sys-vm-stat_refresh-stop-checking-monotonic-numa-stats.patch

