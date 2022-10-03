Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 494A5C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiJCVPy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbiJCVOL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A79613E01
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED22DB8160E
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB8CC433C1;
        Mon,  3 Oct 2022 21:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831380;
        bh=1U4xtKbcP6qVvtiu/c9eHTzWSRvAPWHmVeyvON3l7mU=;
        h=Date:To:From:Subject:From;
        b=EKYvt+iJ1V05Ir7kPyqqK9p2trIda4e5zsCqkoj22JqrxOOHsZqe00ogK3dV6BV6W
         ykpVdsIKAljt1AtsaYRGxkTgUQXANTAvpcVmlCiYkXpQa/jglP9SnXiORFMYJbNwdD
         tsTSbNonfHt3upFl/DJtl3xREbGlTosulhaMxD5Q=
Date:   Mon, 03 Oct 2022 14:09:40 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-init-local-variable-buddy_pfn.patch removed from -mm tree
Message-Id: <20221003210940.AAB8CC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: init local variable buddy_pfn
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-init-local-variable-buddy_pfn.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: init local variable buddy_pfn
Date: Fri, 16 Sep 2022 15:22:54 +0800

The local variable buddy_pfn could be passed to buddy_merge_likely()
without initialization if the passed in order is MAX_ORDER - 1.  This
looks buggy but buddy_pfn won't be used in this case as there's a order >=
MAX_ORDER - 2 check.  Init buddy_pfn to 0 anyway to avoid possible future
misuse.

Link: https://lkml.kernel.org/r/20220916072257.9639-14-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-init-local-variable-buddy_pfn
+++ a/mm/page_alloc.c
@@ -1113,7 +1113,7 @@ static inline void __free_one_page(struc
 		int migratetype, fpi_t fpi_flags)
 {
 	struct capture_control *capc = task_capc(zone);
-	unsigned long buddy_pfn;
+	unsigned long buddy_pfn = 0;
 	unsigned long combined_pfn;
 	struct page *buddy;
 	bool to_tail;
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


