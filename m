Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC34FC38159
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 01:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbjASBTW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 20:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbjASBRn (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 20:17:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFA369219
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 17:15:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ACB161B18
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 01:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A1AC433F2;
        Thu, 19 Jan 2023 01:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674090934;
        bh=j2QfvnHhTHziNKJU1yf428SUIa+8074vWErTNHcc1dQ=;
        h=Date:To:From:Subject:From;
        b=1eVDDUerV3GOSOdxkugq9In/yLMoiT58Xri0PzOtsrznc7ZUjbuz4qfpGnh7u5/B3
         GJADU9Y61KfrxEoybhwjXCY1uIB95OAZNIW/RxweWKe7rFa9o38/Kg37Wn5sWvJzVc
         dvmohiKGvaqEvYMbjJN1zS2qrinWAalkZYHt/F0A=
Date:   Wed, 18 Jan 2023 17:15:33 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com, willy@infradead.org,
        vbabka@suse.cz, peterx@redhat.com, pasha.tatashin@soleen.com,
        liam.howlett@oracle.com, hughd@google.com, david@redhat.com,
        ccross@google.com, arnd@arndb.de, kele.huang@columbia.edu,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-fix-comment-of-page-table-counter.patch removed from -mm tree
Message-Id: <20230119011534.64A1AC433F2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix comment of page table counter
has been removed from the -mm tree.  Its filename was
     mm-fix-comment-of-page-table-counter.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kele Huang <kele.huang@columbia.edu>
Subject: mm: fix comment of page table counter
Date: Sat, 24 Dec 2022 01:02:33 -0500

Commit af5b0f6a09e42 ("mm: consolidate page table accounting")
consolidates page table accounting to a single counter in struct mm_struct
{} as mm->pgtables_bytes.  So the meanning of this counter should be the
size of all page tables now.

Link: https://lkml.kernel.org/r/20221224060233.417827-1-kele.huang@columbia.edu
Signed-off-by: Kele Huang <kele.huang@columbia.edu>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Colin Cross <ccross@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm_types.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mm_types.h~mm-fix-comment-of-page-table-counter
+++ a/include/linux/mm_types.h
@@ -647,7 +647,7 @@ struct mm_struct {
 		atomic_t mm_count;
 
 #ifdef CONFIG_MMU
-		atomic_long_t pgtables_bytes;	/* PTE page table pages */
+		atomic_long_t pgtables_bytes;	/* size of all page tables */
 #endif
 		int map_count;			/* number of VMAs */
 
_

Patches currently in -mm which might be from kele.huang@columbia.edu are


