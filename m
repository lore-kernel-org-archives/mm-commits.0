Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A7CC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:16:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbiJCVQT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:16:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiJCVO1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:14:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28636167F5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:09:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6A4D61207
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:09:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ACAC433C1;
        Mon,  3 Oct 2022 21:09:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831384;
        bh=PfPWLUziEtRcwbi0cxYEHfVk93EyuC7BJZqqnsZ3duE=;
        h=Date:To:From:Subject:From;
        b=bW5WsBceSUhRhWleL2MHJPRidKMU+YbYWgvkSHldvmCruvvNRKxhtCiMB9IzdjNN4
         grxDgNlVhfOMR4mZLqUiBjWFVmXW1HbXUtNrEzQqjapQR+JCAlD7jEmWZ5Jn++zkZJ
         VCz2yy5V6/5TP50rJIAoMIzXvLjJB1cl9vSsyJQE=
Date:   Mon, 03 Oct 2022 14:09:43 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, osalvador@suse.de,
        david@redhat.com, anshuman.khandual@arm.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch removed from -mm tree
Message-Id: <20221003210944.17ACAC433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/page_alloc: fix obsolete comment in deferred_pfn_valid()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/page_alloc: fix obsolete comment in deferred_pfn_valid()
Date: Fri, 16 Sep 2022 15:22:57 +0800

There are no architectures that can have holes in the memory map within a
pageblock since commit 859a85ddf90e ("mm: remove pfn_valid_within() and
CONFIG_HOLES_IN_ZONE").  Update the corresponding comment.

Link: https://lkml.kernel.org/r/20220916072257.9639-17-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid
+++ a/mm/page_alloc.c
@@ -1929,11 +1929,7 @@ static inline void __init pgdat_init_rep
 /*
  * Returns true if page needs to be initialized or freed to buddy allocator.
  *
- * First we check if pfn is valid on architectures where it is possible to have
- * holes within pageblock_nr_pages. On systems where it is not possible, this
- * function is optimized out.
- *
- * Then, we check if a current large page is valid by only checking the validity
+ * We check if a current large page is valid by only checking the validity
  * of the head pfn.
  */
 static inline bool __init deferred_pfn_valid(unsigned long pfn)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


