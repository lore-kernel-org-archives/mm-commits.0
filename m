Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDA57C433EF
	for <mm-commits@archiver.kernel.org>; Fri, 27 May 2022 16:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349268AbiE0Qfa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 27 May 2022 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349163AbiE0QfQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2022 12:35:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DF7D527EF
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 09:35:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95E43B825AF
        for <mm-commits@vger.kernel.org>; Fri, 27 May 2022 16:35:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 515DBC385B8;
        Fri, 27 May 2022 16:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653669313;
        bh=K7NXHJHAWhbvWmj8H0ehwqxH/Fqn7ge5VmuidWdDHkc=;
        h=Date:To:From:Subject:From;
        b=jLp9WP1CJWfsXQ4ubRtqfgIGt6urIhoxgWbELpT5MZzKQNDS6utdN1bKpl59uPEbx
         5HHPKxQ1IloGjyU2f0zCvJqgHVt3/t7uiQhCeAyPSJzAZ8kcmssC28l+IyMsxwwgld
         P22rrsTc7hDuYEG5RXxH7dogiEQtszwxwGSrLeKQ=
Date:   Fri, 27 May 2022 09:35:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, rcampbell@nvidia.com, peterx@redhat.com,
        neilb@suse.de, naoya.horiguchi@nec.com, hughd@google.com,
        dhowells@redhat.com, david@redhat.com, apopple@nvidia.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-filter-out-swapin-error-entry-in-shmem-mapping.patch removed from -mm tree
Message-Id: <20220527163513.515DBC385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: filter out swapin error entry in shmem mapping
has been removed from the -mm tree.  Its filename was
     mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: filter out swapin error entry in shmem mapping
Date: Thu, 19 May 2022 20:50:30 +0800

There might be swapin error entries in shmem mapping.  Filter them out to
avoid "Bad swap file entry" complaint.

Link: https://lkml.kernel.org/r/20220519125030.21486-6-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Hildenbrand <david@redhat.com>
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

 mm/madvise.c    |    5 ++++-
 mm/swap_state.c |    3 +++
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/mm/madvise.c~mm-filter-out-swapin-error-entry-in-shmem-mapping
+++ a/mm/madvise.c
@@ -248,10 +248,13 @@ static void force_shm_swapin_readahead(s
 
 		if (!xa_is_value(page))
 			continue;
+		swap = radix_to_swp_entry(page);
+		/* There might be swapin error entries in shmem mapping. */
+		if (non_swap_entry(swap))
+			continue;
 		xas_pause(&xas);
 		rcu_read_unlock();
 
-		swap = radix_to_swp_entry(page);
 		page = read_swap_cache_async(swap, GFP_HIGHUSER_MOVABLE,
 					     NULL, 0, false, &splug);
 		if (page)
--- a/mm/swap_state.c~mm-filter-out-swapin-error-entry-in-shmem-mapping
+++ a/mm/swap_state.c
@@ -410,6 +410,9 @@ struct page *find_get_incore_page(struct
 		return NULL;
 
 	swp = radix_to_swp_entry(page);
+	/* There might be swapin error entries in shmem mapping. */
+	if (non_swap_entry(swp))
+		return NULL;
 	/* Prevent swapoff from happening to us */
 	si = get_swap_device(swp);
 	if (!si)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are


