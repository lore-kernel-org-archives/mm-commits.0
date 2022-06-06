Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2E67C433EF
	for <mm-commits@archiver.kernel.org>; Mon,  6 Jun 2022 20:08:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232982AbiFFUIA (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Jun 2022 16:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232917AbiFFUH5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jun 2022 16:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A54BFD0B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 13:07:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9AB6B80E8B
        for <mm-commits@vger.kernel.org>; Mon,  6 Jun 2022 20:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C77BC385A9;
        Mon,  6 Jun 2022 20:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1654546073;
        bh=TYVfzFbiM5KZzCzpKGPJL0JS0aqWGVNXabpQBWsoauM=;
        h=Date:To:From:Subject:From;
        b=dIDmgt10W1FuStjHdjxiZmoOj2ntzZ2ZxA/NO/y2MKkhSPJJ5uU86U7JDM6rxdzi4
         jyzio+nGn5lmFoO/qbTfbiyyVtTvt9J+6sW8vb5WKfOJJPbaCNh0iAxAjwFjWjtSt+
         LVTilJJ/Uc13UGzjO9tmatfunnHVKYcz5QpBzueE=
Date:   Mon, 06 Jun 2022 13:07:52 -0700
To:     mm-commits@vger.kernel.org, urezki@gmail.com, npiggin@gmail.com,
        bhe@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmalloc-fix-typo-in-local-variable-name.patch added to mm-unstable branch
Message-Id: <20220606200753.8C77BC385A9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/vmalloc: fix typo in local variable name
has been added to the -mm mm-unstable branch.  Its filename is
     mm-vmalloc-fix-typo-in-local-variable-name.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmalloc-fix-typo-in-local-variable-name.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Baoquan He <bhe@redhat.com>
Subject: mm/vmalloc: fix typo in local variable name
Date: Mon, 6 Jun 2022 16:39:07 +0800

In __purge_vmap_area_lazy(), rename local_pure_list to local_purge_list.

Link: https://lkml.kernel.org/r/20220606083909.363350-4-bhe@redhat.com
Signed-off-by: Baoquan He <bhe@redhat.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmalloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/vmalloc.c~mm-vmalloc-fix-typo-in-local-variable-name
+++ a/mm/vmalloc.c
@@ -1673,32 +1673,32 @@ static void purge_fragmented_blocks_allc
 static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end)
 {
 	unsigned long resched_threshold;
-	struct list_head local_pure_list;
+	struct list_head local_purge_list;
 	struct vmap_area *va, *n_va;
 
 	lockdep_assert_held(&vmap_purge_lock);
 
 	spin_lock(&purge_vmap_area_lock);
 	purge_vmap_area_root = RB_ROOT;
-	list_replace_init(&purge_vmap_area_list, &local_pure_list);
+	list_replace_init(&purge_vmap_area_list, &local_purge_list);
 	spin_unlock(&purge_vmap_area_lock);
 
-	if (unlikely(list_empty(&local_pure_list)))
+	if (unlikely(list_empty(&local_purge_list)))
 		return false;
 
 	start = min(start,
-		list_first_entry(&local_pure_list,
+		list_first_entry(&local_purge_list,
 			struct vmap_area, list)->va_start);
 
 	end = max(end,
-		list_last_entry(&local_pure_list,
+		list_last_entry(&local_purge_list,
 			struct vmap_area, list)->va_end);
 
 	flush_tlb_kernel_range(start, end);
 	resched_threshold = lazy_max_pages() << 1;
 
 	spin_lock(&free_vmap_area_lock);
-	list_for_each_entry_safe(va, n_va, &local_pure_list, list) {
+	list_for_each_entry_safe(va, n_va, &local_purge_list, list) {
 		unsigned long nr = (va->va_end - va->va_start) >> PAGE_SHIFT;
 		unsigned long orig_start = va->va_start;
 		unsigned long orig_end = va->va_end;
_

Patches currently in -mm which might be from bhe@redhat.com are

mm-vmalloc-remove-the-unnecessary-type-check.patch
mm-vmalloc-remove-the-redundant-boundary-check.patch
mm-vmalloc-fix-typo-in-local-variable-name.patch
mm-vmalloc-add-code-comment-for-find_vmap_area_exceed_addr.patch
mm-ioremap-rename-ioremap_page_range-to-ioremap_range.patch

