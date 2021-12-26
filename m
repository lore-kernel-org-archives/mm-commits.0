Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF3BCC433EF
	for <mm-commits@archiver.kernel.org>; Sun, 26 Dec 2021 22:20:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234712AbhLZWUJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 26 Dec 2021 17:20:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhLZWUJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 26 Dec 2021 17:20:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 024B9C06173E
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 14:20:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D5E660F17
        for <mm-commits@vger.kernel.org>; Sun, 26 Dec 2021 22:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B27C1C36AE8;
        Sun, 26 Dec 2021 22:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1640557208;
        bh=QLTL0ynWWIZWm0nGDmzu1/CVkpQeMoEJqr/UfxBz554=;
        h=Date:From:To:Subject:From;
        b=BMgVhQy+BUjbR7dcWlRddhGKhb4I9iMoc7wR8O+GVPb0KCi1UUfNHoo5TTSYy1Vo6
         DMeI9Plv8XYMABIabjdFhejDCl78Qw9CfAFKnvyU9gqdufi3B2B5ctjmW8Z0wBZG7/
         EexgvFbCYSmRIDuREuaQUDwo9m464fgzd5xneers=
Date:   Sun, 26 Dec 2021 14:20:07 -0800
From:   akpm@linux-foundation.org
To:     hch@lst.de, hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  [merged]
 mm-delete-unsafe-bug-from-page_cache_add_speculative.patch removed from -mm
 tree
Message-ID: <20211226222007.rQboY32hU%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: delete unsafe BUG from page_cache_add_speculative()
has been removed from the -mm tree.  Its filename was
     mm-delete-unsafe-bug-from-page_cache_add_speculative.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm: delete unsafe BUG from page_cache_add_speculative()

It is not easily reproducible, but on 5.16-rc I have several times hit the
VM_BUG_ON_PAGE(PageTail(page), page) in page_cache_add_speculative():
usually from filemap_get_read_batch() for an ext4 read, yesterday from
next_uptodate_page() from filemap_map_pages() for a shmem fault.

That BUG used to be placed where page_ref_add_unless() had succeeded, but
now it is placed before folio_ref_add_unless() is attempted: that is not
safe, since it is only the acquired reference which makes the page safe
from racing THP collapse or split.

We could keep the BUG, checking PageTail only when folio_ref_try_add_rcu()
has succeeded; but I don't think it adds much value - just delete it.

Link: https://lkml.kernel.org/r/8b98fc6f-3439-8614-c3f3-945c659a1aba@google.com
Fixes: 020853b6f5ea ("mm: Add folio_try_get_rcu()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagemap.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/pagemap.h~mm-delete-unsafe-bug-from-page_cache_add_speculative
+++ a/include/linux/pagemap.h
@@ -285,7 +285,6 @@ static inline struct inode *folio_inode(
 
 static inline bool page_cache_add_speculative(struct page *page, int count)
 {
-	VM_BUG_ON_PAGE(PageTail(page), page);
 	return folio_ref_try_add_rcu((struct folio *)page, count);
 }
 
_

Patches currently in -mm which might be from hughd@google.com are


