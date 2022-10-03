Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05936C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:15:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiJCVPh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiJCVOC (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC0B654CA1
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0AAE61200
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8E7C433D6;
        Mon,  3 Oct 2022 21:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831370;
        bh=2ecThA4JYPyL7z3weSBLCOzptdLCb5a+UGYHjgBWlpg=;
        h=Date:To:From:Subject:From;
        b=W2JwPkNkFY8WBf90ZT1C5W6XTIprz15YzXmfhlyv6QD/d/Y1fKiFkowBgS8HThTIS
         RtR0ZgTnLTdueuAboZH337mfyyHMp1k60ICC/ceBfkThG92dB5PFuYhr8R7w7XkkDX
         H+UJGJ+I02zMYcLF6QyONythcoRd6o4lgs2zOQeE=
Date:   Mon, 03 Oct 2022 14:09:29 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch removed from -mm tree
Message-Id: <20221003210930.3C8E7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: remove obsolete comment in zone_statistics()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: remove obsolete comment in zone_statistics()
Date: Fri, 16 Sep 2022 15:22:45 +0800

Since commit 43c95bcc51e4 ("mm/page_alloc: reduce duration that IRQs are
disabled for VM counters"), zone_statistics() is not called with
interrupts disabled.  Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220916072257.9639-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-remove-obsolete-comment-in-zone_statistics
+++ a/mm/page_alloc.c
@@ -3671,8 +3671,6 @@ void __putback_isolated_page(struct page
 
 /*
  * Update NUMA hit/miss statistics
- *
- * Must be called with interrupts disabled.
  */
 static inline void zone_statistics(struct zone *preferred_zone, struct zone *z,
 				   long nr_account)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


