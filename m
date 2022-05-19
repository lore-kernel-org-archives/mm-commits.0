Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B760C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 22:25:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245444AbiESWZn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 18:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245443AbiESWZj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 18:25:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D29B663C8
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 15:25:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28D8D6169B
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 22:25:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDDFC385AA;
        Thu, 19 May 2022 22:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652999136;
        bh=UZkqAQaxhQWJ6jZsxCcHjlpR3keszVLP3e+PUGb9kwI=;
        h=Date:To:From:Subject:From;
        b=ppFiBq1LTlWHBMGl0FkYOUBWMVpFNkxMibCsL0ZLyHPGavV4nfkIGVei26GXQgE5Y
         YUkfDKNJY1TFxPVsNSdSKprv3gqyYJaYIJMQT6VsrZhN29G6sI6U/EebM3Bubo3CbR
         jR0hfZ9149yHKOzEhdjkUNb2joTxAQz3tUGTwM3c=
Date:   Thu, 19 May 2022 15:25:35 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        surenb@google.com, peterx@redhat.com, osalvador@suse.de,
        neilb@suse.de, naoya.horiguchi@nec.com, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-fold-__swap_info_get-into-its-sole-caller.patch removed from -mm tree
Message-Id: <20220519222536.7FDDFC385AA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: fold __swap_info_get() into its sole caller
has been removed from the -mm tree.  Its filename was
     mm-swap-fold-__swap_info_get-into-its-sole-caller.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/swap: fold __swap_info_get() into its sole caller

Fold __swap_info_get() into its sole caller to make code more clear. 
Minor readability improvement.

Link: https://lkml.kernel.org/r/20220509131416.17553-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: NeilBrown <neilb@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |   24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

--- a/mm/swapfile.c~mm-swap-fold-__swap_info_get-into-its-sole-caller
+++ a/mm/swapfile.c
@@ -1122,7 +1122,7 @@ noswap:
 	return n_ret;
 }
 
-static struct swap_info_struct *__swap_info_get(swp_entry_t entry)
+static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
 {
 	struct swap_info_struct *p;
 	unsigned long offset;
@@ -1137,8 +1137,13 @@ static struct swap_info_struct *__swap_i
 	offset = swp_offset(entry);
 	if (offset >= p->max)
 		goto bad_offset;
+	if (data_race(!p->swap_map[swp_offset(entry)]))
+		goto bad_free;
 	return p;
 
+bad_free:
+	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
+	goto out;
 bad_offset:
 	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	goto out;
@@ -1150,23 +1155,6 @@ bad_nofile:
 out:
 	return NULL;
 }
-
-static struct swap_info_struct *_swap_info_get(swp_entry_t entry)
-{
-	struct swap_info_struct *p;
-
-	p = __swap_info_get(entry);
-	if (!p)
-		goto out;
-	if (data_race(!p->swap_map[swp_offset(entry)]))
-		goto bad_free;
-	return p;
-
-bad_free:
-	pr_err("%s: %s%08lx\n", __func__, Unused_offset, entry.val);
-out:
-	return NULL;
-}
 
 static struct swap_info_struct *swap_info_get_cont(swp_entry_t entry,
 					struct swap_info_struct *q)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-z3fold-fix-sheduling-while-atomic.patch
mm-z3fold-fix-possible-null-pointer-dereferencing.patch
mm-z3fold-remove-buggy-use-of-stale-list-for-allocation.patch
mm-z3fold-throw-warning-on-failure-of-trylock_page-in-z3fold_alloc.patch
revert-mm-z3foldc-allow-__gfp_highmem-in-z3fold_alloc.patch
mm-z3fold-put-z3fold-page-back-into-unbuddied-list-when-reclaim-or-migration-fails.patch
mm-z3fold-always-clear-page_claimed-under-z3fold-page-lock.patch
mm-z3fold-fix-z3fold_reclaim_page-races-with-z3fold_free.patch
mm-z3fold-fix-z3fold_page_migrate-races-with-z3fold_map.patch
mm-swapfile-unuse_pte-can-map-random-data-if-swap-read-fails.patch
mm-swapfile-fix-lost-swap-bits-in-unuse_pte.patch
mm-madvise-free-hwpoison-and-swapin-error-entry-in-madvise_free_pte_range.patch
mm-shmem-fix-infinite-loop-when-swap-in-shmem-error-at-swapoff-time.patch
mm-filter-out-swapin-error-entry-in-shmem-mapping.patch

