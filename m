Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BDFDC38142
	for <mm-commits@archiver.kernel.org>; Wed,  1 Feb 2023 00:38:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231185AbjBAAis (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 31 Jan 2023 19:38:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbjBAAir (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 31 Jan 2023 19:38:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9845268B
        for <mm-commits@vger.kernel.org>; Tue, 31 Jan 2023 16:38:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90B24B81FBA
        for <mm-commits@vger.kernel.org>; Wed,  1 Feb 2023 00:38:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27520C433EF;
        Wed,  1 Feb 2023 00:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675211923;
        bh=PQebJx5F4dmdrnj0suB4K3cSH1UrkTUxNzN2It0D+74=;
        h=Date:To:From:Subject:From;
        b=kqCKQWrs0TPypAzUARpmaDPeROmTaArdUMD1RWQBMzo0qk5FdP9Fs4oKUqa+mCipT
         YMygPy/ieDCfgOQogjvWS26CMkr3D67hFXXKO7nT/twiqVoSSLC72TJRVpkOf2cmcv
         y5mNdx4U2APJip9q9roA7Zd8QtXO/zlCFDX41Z1o=
Date:   Tue, 31 Jan 2023 16:38:42 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        vishal.moola@gmail.com, songmuchun@bytedance.com,
        shy828301@gmail.com, peterx@redhat.com, naoya.horiguchi@linux.dev,
        mike.kravetz@oracle.com, mhocko@suse.com, jthoughton@google.com,
        david@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch removed from -mm tree
Message-Id: <20230201003843.27520C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix.patch

This patch was dropped because it was folded into mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
Date: Fri Jan 27 03:00:32 PM PST 2023

simplification, per David

Cc: David Hildenbrand <david@redhat.com>
Cc: James Houghton <jthoughton@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Naoya Horiguchi <naoya.horiguchi@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/fs/proc/task_mmu.c~mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix
+++ a/fs/proc/task_mmu.c
@@ -745,18 +745,10 @@ static int smaps_hugetlb_range(pte_t *pt
 			page = pfn_swap_entry_to_page(swpent);
 	}
 	if (page) {
-		int mapcount = page_mapcount(page);
-
-		if (mapcount >= 2)
+		if (page_mapcount(page) >= 2 || hugetlb_pmd_shared(pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
-		else {
-			if (hugetlb_pmd_shared(pte))
-				mss->shared_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-			else
-				mss->private_hugetlb +=
-						huge_page_size(hstate_vma(vma));
-		}
+		else
+			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
 	}
 	return 0;
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps.patch
mm-hugetlb-proc-check-for-hugetlb-shared-pmd-in-proc-pid-smaps-fix-2.patch
mm-add-folio_add_new_anon_rmap-fix.patch
mm-remove-page_evictable-fix.patch
mm-remove-the-swap_readpage-return-value-fix.patch
block-remove-rw_page-fix.patch
mm-add-memcpy_from_file_folio-fix.patch
mm-replace-vma-vm_flags-direct-modifications-with-modifier-calls-fix.patch
error-injection-remove-ei_etype_none-fix.patch
hfsplus-remove-unnecessary-variable-initialization-fix.patch
scripts-gdb-add-mm-introspection-utils-fix.patch
lib-stackdepot-mm-rename-stack_depot_want_early_init-fix.patch
lib-stackdepot-annotate-racy-slab_index-accesses-fix.patch

