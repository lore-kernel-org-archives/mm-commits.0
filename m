Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70244C54EE9
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiILDbY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbiILD3i (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:38 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 582EE2870B
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id BC784CE0E79
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03B8C433D7;
        Mon, 12 Sep 2022 03:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953351;
        bh=uH21z89pKbSnHrD2mKgLP99tMQc/ZZUFSuWCmrHiIoM=;
        h=Date:To:From:Subject:From;
        b=vLaDf7JRbD6yGgqOt5D3yB0rZUXA8H/swlmmBApsYoRexpkVTSsXoSRC0uII6UxSo
         L2CeSgTg2AJMhUZ6tHD6zjBC2iGAOxIfgMq6sUYRj4BqB2xnaFMiN/6Rfsca3ky/SP
         ot7818MJBuZYVa2ui9lAOkEHzztlqenudf/fWPRw=
Date:   Sun, 11 Sep 2022 20:29:11 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, fengwei.yin@intel.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch removed from -mm tree
Message-Id: <20220912032911.B03B8C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: hugetlb_vmemmap: add missing smp_wmb() before set_pte_at()
has been removed from the -mm tree.  Its filename was
     mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: hugetlb_vmemmap: add missing smp_wmb() before set_pte_at()
Date: Tue, 16 Aug 2022 21:05:51 +0800

The memory barrier smp_wmb() is needed to make sure that preceding stores
to the page contents become visible before the below set_pte_at() write.

Link: https://lkml.kernel.org/r/20220816130553.31406-5-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Yin Fengwei <fengwei.yin@intel.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb_vmemmap.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/hugetlb_vmemmap.c~mm-hugetlb_vmemmap-add-missing-smp_wmb-before-set_pte_at
+++ a/mm/hugetlb_vmemmap.c
@@ -287,6 +287,11 @@ static void vmemmap_restore_pte(pte_t *p
 	copy_page(to, (void *)walk->reuse_addr);
 	reset_struct_pages(to);
 
+	/*
+	 * Makes sure that preceding stores to the page contents become visible
+	 * before the set_pte_at() write.
+	 */
+	smp_wmb();
 	set_pte_at(&init_mm, addr, pte, mk_pte(page, pgprot));
 }
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hwpoison-use-clearpagehwpoison-in-memory_failure.patch
mm-hwpoison-use-__pagemovable-to-detect-non-lru-movable-pages.patch
mm-hwpoison-use-num_poisoned_pages_sub-to-decrease-num_poisoned_pages.patch
mm-hwpoison-avoid-unneeded-page_mapped_in_vma-overhead-in-collect_procs_anon.patch
mm-hwpoison-check-pagetable-explicitly-in-hwpoison_user_mappings.patch
mm-hwpoison-cleanup-some-obsolete-comments.patch
writeback-remove-unused-macro-dirty_full_scope.patch

