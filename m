Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5130FC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349798AbiE0QfT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354192AbiE0QfN (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27EC752534
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B098261D68
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1679AC385A9;
        Fri, 27 May 2022 16:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669311;
        bh=jGbGZI4Ji6o22TG0wLWGD/ruiMuOXW3GqC8zK8qPRIM=;
        h=Date:To:From:Subject:From;
        b=neZQ15tc50jtvGArLhMKLl+85PgSyyDANJV0oiwL28VPdg1/+tRehNm8aaAV7pdy0
         g1QfDoR1xXzkk+YuSdxZAf4hCIho2S7r17x0WIXKnKVr84hg2/e0+KfmwZZwmsPLCI
         7XTAgljGY3l4KN+roSdjqWBQ/XgWrsYXgeJgjtv4=
Date:   Fri, 27 May 2022 09:35:10 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch removed from -mm tree
Message-Id: <20220527163511.1679AC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/madvise: free hwpoison and swapin error entry in madvise_free_pte_range
has been removed from the -mm tree.  Its filename was
     mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/madvise: free hwpoison and swapin error entry in madvise_free_pte_range
Date: Thu, 19 May 2022 20:50:28 +0800

Once the MADV_FREE operation has succeeded, callers can expect they might
get zero-fill pages if accessing the memory again.  Therefore it should be
safe to delete the hwpoison entry and swapin error entry.  There is no
reason to kill the process if it has called MADV_FREE on the range.

Link: https://lkml.kernel.org/r/20220519125030.21486-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ralph Campbell <rcampbell@nvidia.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/madvise.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/mm/madvise.c~mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range
+++ a/mm/madvise.c
@@ -624,11 +624,14 @@ static int madvise_free_pte_range(pmd_t
 			swp_entry_t entry;
 
 			entry = pte_to_swp_entry(ptent);
-			if (non_swap_entry(entry))
-				continue;
-			nr_swap--;
-			free_swap_and_cache(entry);
-			pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			if (!non_swap_entry(entry)) {
+				nr_swap--;
+				free_swap_and_cache(entry);
+				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			} else if (is_hwpoison_entry(entry) ||
+				   is_swapin_error_entry(entry)) {
+				pte_clear_not_present_full(mm, addr, pte, tlb->fullmm);
+			}
 			continue;
 		}
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


