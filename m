Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C72ECAAD3
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 03:31:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbiILDbR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Sep 2022 23:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiILD32 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Sep 2022 23:29:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 258B6286EC
        for <mm-commits@vger.kernel.org>; Sun, 11 Sep 2022 20:29:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5EC36116F
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 03:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193D0C433D7;
        Mon, 12 Sep 2022 03:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1662953348;
        bh=klVibZZdcnO6LnNaKrTzt8HkIAm8iUh3sx+Fqgt7vG0=;
        h=Date:To:From:Subject:From;
        b=YRR76UhKwo0zFPQ70Gsu+kg/tF3ngdgVu3OPJtdbAjmT1AFrawj9ymEDYPKpzKg+x
         PZLrxszVfQoD3geWE1+7KFanTg9TmOCGwAQM5R/jIzCnITvFOw0pMfn115ByIT1oeF
         CV3GCBtkXlwEB5tP52I/1k2SooEb2h5kt79ED5HA=
Date:   Sun, 11 Sep 2022 20:29:07 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        mike.kravetz@oracle.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch removed from -mm tree
Message-Id: <20220912032908.193D0C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/hugetlb: fix incorrect update of max_huge_pages
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-fix-incorrect-update-of-max_huge_pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/hugetlb: fix incorrect update of max_huge_pages
Date: Tue, 16 Aug 2022 21:05:48 +0800

Patch series "A few fixup patches for hugetlb".

This series contains a few fixup patches to fix incorrect update of
max_huge_pages, fix WARN_ON(!kobj) in sysfs_create_group() and so on.
More details can be found in the respective changelogs.


This patch (of 6):

There should be pages_per_huge_page(h) /
pages_per_huge_page(target_hstate) pages incremented for
target_hstate->max_huge_pages when page is demoted.  Update max_huge_pages
accordingly for consistency.

Link: https://lkml.kernel.org/r/20220816130553.31406-1-linmiaohe@huawei.com
Link: https://lkml.kernel.org/r/20220816130553.31406-2-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-fix-incorrect-update-of-max_huge_pages
+++ a/mm/hugetlb.c
@@ -3472,7 +3472,8 @@ static int demote_free_huge_page(struct
 	 * based on pool changes for the demoted page.
 	 */
 	h->max_huge_pages--;
-	target_hstate->max_huge_pages += pages_per_huge_page(h);
+	target_hstate->max_huge_pages +=
+		pages_per_huge_page(h) / pages_per_huge_page(target_hstate);
 
 	return rc;
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

