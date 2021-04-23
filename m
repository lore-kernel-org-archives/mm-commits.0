Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C0AC43470
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 18F28613AB
	for <mm-commits@archiver.kernel.org>; Fri, 23 Apr 2021 21:29:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhDWV3g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 23 Apr 2021 17:29:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:36946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243960AbhDWV3e (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 23 Apr 2021 17:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 780C661469;
        Fri, 23 Apr 2021 21:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619213337;
        bh=50DcqW+qXHbwsuPF084kbHU9PE95xeexvEO5iqMPrIM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=svdMtvwkTn3eNYC4aJvpDAtxgh5Rvq12OJXwlalO/92KOkVH1ihiBkv1RVf1fyzUf
         ff0syY0NSnLZbF3mWKGiKE44ZjaQNiCqeYLQazOvdvsWRMlyXvr8aoXoBCVB4SHdFv
         RLWiqtSWM+maAqKZiX2Ie+OZlL20ASJZy2EmRLKY=
Date:   Fri, 23 Apr 2021 14:28:57 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dchinner@redhat.com, hannes@cmpxchg.org,
        hch@lst.de, hughd@google.com, jack@suse.cz,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        william.kucharski@oracle.com, willy@infradead.org,
        yang.shi@linux.alibaba.com
Subject:  [patch 3/5] mm/filemap: fix find_lock_entries hang on
 32-bit THP
Message-ID: <20210423212857.ZjNcexu9X%akpm@linux-foundation.org>
In-Reply-To: <20210423142805.fd6d718ec3296452108b3ee0@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
