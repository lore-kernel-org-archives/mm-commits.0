Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1AD3C433B4
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD25613EA
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:38:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbhEHWju (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:39:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:42438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhEHWjt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:39:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DFF613E8;
        Sat,  8 May 2021 22:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513527;
        bh=YZ7ZlhX0aeyudcFLR1zk/vEOpmT2R452wzUNdrag79A=;
        h=Date:From:To:Subject:From;
        b=yjOAtGcOun7K5nPu7GYHLpdd4scWlr/NGssSEF50lrznJYTiQSQp+t9J0Q6raIKRo
         bknEFQJW3CdBFtw2oDr3p4+29dEJzKa8c2SMfN/fgDnByRojbGD8KXF0jSwd3G6yUN
         x7fLUQZmyLPfGp8dJtlTBn0jzeH1ttmDRssCfzpk=
Date:   Sat, 08 May 2021 15:38:46 -0700
From:   akpm@linux-foundation.org
To:     dchinner@redhat.com, hannes@cmpxchg.org, hch@lst.de,
        hughd@google.com, jack@suse.cz, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, william.kucharski@oracle.com,
        willy@infradead.org, yang.shi@linux.alibaba.com
Subject:  [merged]
 mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch removed from -mm
 tree
Message-ID: <20210508223846.aI1KAWnbV%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/filemap: fix find_lock_entries hang on 32-bit THP
has been removed from the -mm tree.  Its filename was
     mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/filemap: fix find_lock_entries hang on 32-bit THP

No problem on 64-bit, or without huge pages, but xfstests generic/308 hung
uninterruptibly on 32-bit huge tmpfs.  Since 4.13's 0cc3b0ec23ce ("Clarify
(and fix) MAX_LFS_FILESIZE macros"), MAX_LFS_FILESIZE is only a PAGE_SIZE
away from wrapping 32-bit xa_index to 0, so the new find_lock_entries()
has to be extra careful when handling a THP.

Link: https://lkml.kernel.org/r/alpine.LSU.2.11.2104211735430.3299@eggly.anvils
Fixes: 5c211ba29deb ("mm: add and use find_lock_entries")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <dchinner@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Yang Shi <yang.shi@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/filemap.c~mm-filemap-fix-find_lock_entries-hang-on-32-bit-thp
+++ a/mm/filemap.c
@@ -1969,8 +1969,14 @@ unlock:
 put:
 		put_page(page);
 next:
-		if (!xa_is_value(page) && PageTransHuge(page))
-			xas_set(&xas, page->index + thp_nr_pages(page));
+		if (!xa_is_value(page) && PageTransHuge(page)) {
+			unsigned int nr_pages = thp_nr_pages(page);
+
+			/* Final THP may cross MAX_LFS_FILESIZE on 32-bit */
+			xas_set(&xas, page->index + nr_pages);
+			if (xas.xa_index < nr_pages)
+				break;
+		}
 	}
 	rcu_read_unlock();
 
_

Patches currently in -mm which might be from hughd@google.com are


