Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71724C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiJCVQA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJCVOL (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D28213F4B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 236B1B815F8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC44AC433D7;
        Mon,  3 Oct 2022 21:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831381;
        bh=k/PyrCPN53aNnKRzQ6xTBa4arB8/z9P4AFCNX31XnkI=;
        h=Date:To:From:Subject:From;
        b=rp5HC3IdJQNGJbQsdkfU8FpP0LEBwNZVqorvftocGcGBo36Aa0pyo75iGaxZc5fUa
         FjilNumMSRMVBt1QVEdJJ1Q8SpNG1ann7IrdLMu3jOtTQBOnwC+ofTuTF5iJM5Debi
         WFURW03rOCX6taxVY9sZUVSloAdP6VHhF7WvctNI=
Date:   Mon, 03 Oct 2022 14:09:41 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch removed from -mm tree
Message-Id: <20221003210941.CC44AC433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: use costly_order in WARN_ON_ONCE_GFP()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: use costly_order in WARN_ON_ONCE_GFP()
Date: Fri, 16 Sep 2022 15:22:55 +0800

There's no need to check whether order > PAGE_ALLOC_COSTLY_ORDER again. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220916072257.9639-15-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-use-costly_order-in-warn_on_once_gfp
+++ a/mm/page_alloc.c
@@ -5280,7 +5280,7 @@ nopage:
 		 * so that we can identify them and convert them to something
 		 * else.
 		 */
-		WARN_ON_ONCE_GFP(order > PAGE_ALLOC_COSTLY_ORDER, gfp_mask);
+		WARN_ON_ONCE_GFP(costly_order, gfp_mask);
 
 		/*
 		 * Help non-failing allocations by giving them access to memory
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


