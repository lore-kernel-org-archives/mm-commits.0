Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367E7C433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiJCVQB (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbiJCVOY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7559915A07
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 96F98611E0
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7ADAC433D6;
        Mon,  3 Oct 2022 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831383;
        bh=vhfKedU6BGy/o8N/w83BQkeWMQ9K4i+GWvOiPIn6T5s=;
        h=Date:To:From:Subject:From;
        b=L8AhKLp0J6jCce4C5pJZc7mQn8WEdELkFFiLJaQUnr3gTDV9tnQMIS7UIjtZtXu/H
         nrviQ1n5arMbcslUN2xvDO25FFoI+SZddrty6MVdNigaHOho+jvx0QddHZ7pI2moDg
         L270WdtHtiEtn5/pBdWkCwYRUjKX3yMcvRBUl/Lg=
Date:   Mon, 03 Oct 2022 14:09:42 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch removed from -mm tree
Message-Id: <20221003210942.E7ADAC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove obsolete gfpflags_normal_context()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: remove obsolete gfpflags_normal_context()
Date: Fri, 16 Sep 2022 15:22:56 +0800

Since commit dacb5d8875cc ("tcp: fix page frag corruption on page fault"),
there's no caller of gfpflags_normal_context().  Remove it as this helper
is strictly tied to the sk page frag usage and there won't be other user
in the future.

[linmiaohe@huawei.com: fix htmldocs]
  Link: https://lkml.kernel.org/r/1bc55727-9b66-0e9e-c306-f10c4716ea89@huawei.com
Link: https://lkml.kernel.org/r/20220916072257.9639-16-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/core-api/mm-api.rst |    3 ---
 include/linux/gfp.h               |   23 -----------------------
 2 files changed, 26 deletions(-)

--- a/Documentation/core-api/mm-api.rst~mm-page_alloc-remove-obsolete-gfpflags_normal_context
+++ a/Documentation/core-api/mm-api.rst
@@ -19,9 +19,6 @@ User Space Memory Access
 Memory Allocation Controls
 ==========================
 
-.. kernel-doc:: include/linux/gfp.h
-   :internal:
-
 .. kernel-doc:: include/linux/gfp_types.h
    :doc: Page mobility and placement hints
 
--- a/include/linux/gfp.h~mm-page_alloc-remove-obsolete-gfpflags_normal_context
+++ a/include/linux/gfp.h
@@ -36,29 +36,6 @@ static inline bool gfpflags_allow_blocki
 	return !!(gfp_flags & __GFP_DIRECT_RECLAIM);
 }
 
-/**
- * gfpflags_normal_context - is gfp_flags a normal sleepable context?
- * @gfp_flags: gfp_flags to test
- *
- * Test whether @gfp_flags indicates that the allocation is from the
- * %current context and allowed to sleep.
- *
- * An allocation being allowed to block doesn't mean it owns the %current
- * context.  When direct reclaim path tries to allocate memory, the
- * allocation context is nested inside whatever %current was doing at the
- * time of the original allocation.  The nested allocation may be allowed
- * to block but modifying anything %current owns can corrupt the outer
- * context's expectations.
- *
- * %true result from this function indicates that the allocation context
- * can sleep and use anything that's associated with %current.
- */
-static inline bool gfpflags_normal_context(const gfp_t gfp_flags)
-{
-	return (gfp_flags & (__GFP_DIRECT_RECLAIM | __GFP_MEMALLOC)) ==
-		__GFP_DIRECT_RECLAIM;
-}
-
 #ifdef CONFIG_HIGHMEM
 #define OPT_ZONE_HIGHMEM ZONE_HIGHMEM
 #else
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


