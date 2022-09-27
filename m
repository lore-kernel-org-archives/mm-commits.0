Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DD7C6FA82
	for <mm-commits@archiver.kernel.org>; Tue, 27 Sep 2022 02:47:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiI0Crb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbiI0Cr0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2022 22:47:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B6446171E
        for <mm-commits@vger.kernel.org>; Mon, 26 Sep 2022 19:47:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 46D5DB81901
        for <mm-commits@vger.kernel.org>; Tue, 27 Sep 2022 02:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8B6C433D6;
        Tue, 27 Sep 2022 02:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664246843;
        bh=1Vu1x4e2f+sJcChZEoonZkyRLOYoy5j/LSX3jAzqJYI=;
        h=Date:To:From:Subject:From;
        b=jm+2Zs6uakJPm4aZOYGEYV4kDbHAhUD8YdBc+b5h1XLTJsN6VrQKuanVaBbiYVjgx
         wlrzobSxAt5JTSurbD3dK+qmHlkioAIA+CwoL7q8tW164Mo9p7m1Ijty8JXIHUhD5l
         T7t3XrfTfd/USPMhRYgOqeR0uiTcnmNmBIUL84Ys=
Date:   Mon, 26 Sep 2022 19:47:22 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch removed from -mm tree
Message-Id: <20220927024722.EF8B6C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm, hwpoison: avoid unneeded page_mapped_in_vma() overhead in collect_procs_anon()
has been removed from the -mm tree.  Its filename was
     mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm, hwpoison: avoid unneeded page_mapped_in_vma() overhead in collect_procs_anon()
Date: Tue, 30 Aug 2022 20:36:02 +0800

If vma->vm_mm != t->mm, there's no need to call page_mapped_in_vma() as
add_to_kill() won't be called in this case. Move up the mm check to avoid
possible unneeded calling to page_mapped_in_vma().

Link: https://lkml.kernel.org/r/20220830123604.25763-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon
+++ a/mm/memory-failure.c
@@ -521,11 +521,11 @@ static void collect_procs_anon(struct pa
 		anon_vma_interval_tree_foreach(vmac, &av->rb_root,
 					       pgoff, pgoff) {
 			vma = vmac->vma;
+			if (vma->vm_mm != t->mm)
+				continue;
 			if (!page_mapped_in_vma(page, vma))
 				continue;
-			if (vma->vm_mm == t->mm)
-				add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma,
-					    to_kill);
+			add_to_kill(t, page, FSDAX_INVALID_PGOFF, vma, to_kill);
 		}
 	}
 	read_unlock(&tasklist_lock);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

writeback-remove-unused-macro-dirty_full_scope.patch
mm-page_alloc-ensure-kswapd-doesnt-accidentally-go-to-sleep.patch
mm-page_alloc-make-zone_pcp_update-static.patch
mm-remove-obsolete-macro-nr_pcp_order_mask-and-nr_pcp_order_width.patch
mm-page_alloc-remove-obsolete-comment-in-zone_statistics.patch
mm-page_alloc-add-__init-annotations-to-init_mem_debugging_and_hardening.patch
mm-page_alloc-fix-freeing-static-percpu-memory.patch
mm-remove-obsolete-pgdat_is_empty.patch
mm-page_alloc-add-missing-is_migrate_isolate-check-in-set_page_guard.patch
mm-page_alloc-use-local-variable-zone_idx-directly.patch
mm-memory_hotplug-remove-obsolete-generic_free_nodedata.patch
mm-page_alloc-make-boot_nodestats-static.patch
mm-page_alloc-use-helper-macro-sz_1km.patch
mm-page_alloc-init-local-variable-buddy_pfn.patch
mm-page_alloc-use-costly_order-in-warn_on_once_gfp.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context.patch
mm-page_alloc-remove-obsolete-gfpflags_normal_context-fix.patch
mm-page_alloc-fix-obsolete-comment-in-deferred_pfn_valid.patch

