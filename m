Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF9DC19F2B
	for <mm-commits@archiver.kernel.org>; Sat, 30 Jul 2022 01:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239748AbiG3BI5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Jul 2022 21:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239682AbiG3BIk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Jul 2022 21:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C9A84ED4
        for <mm-commits@vger.kernel.org>; Fri, 29 Jul 2022 18:08:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34793B829CB
        for <mm-commits@vger.kernel.org>; Sat, 30 Jul 2022 01:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5EBEC433D6;
        Sat, 30 Jul 2022 01:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1659143309;
        bh=hlHFdKnjKCbs9M+Rq0iD9xcwFIlQRZfzXR64m3HhRBY=;
        h=Date:To:From:Subject:From;
        b=j3eHw+SA15VXDxDT2pI6JnzzcLsU7NQMy/E4e6wmIB/51FXpoOL7REmjr3v2nsrYA
         uAbiyDGJtfTqwCoT1Uy4N9EKMnKPbwhP6+0GW3LP9KuvNigWD9O61dmnQ4ghvrqC2K
         g0IanAYUjAZKay5jIoQTNwYxRfTT7E4hoODkR2ec=
Date:   Fri, 29 Jul 2022 18:08:28 -0700
To:     mm-commits@vger.kernel.org, david@redhat.com, linmiaohe@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch removed from -mm tree
Message-Id: <20220730010828.E5EBEC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: remove unneeded PageAnon check in restore_exclusive_pte()
has been removed from the -mm tree.  Its filename was
     mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: remove unneeded PageAnon check in restore_exclusive_pte()
Date: Sat, 16 Jul 2022 16:18:16 +0800

When code reaches here, the page must be !PageAnon.  There's no need to
check PageAnon again.  Remove it.

Link: https://lkml.kernel.org/r/20220716081816.10752-1-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-remove-unneeded-pageanon-check-in-restore_exclusive_pte
+++ a/mm/memory.c
@@ -744,7 +744,7 @@ static void restore_exclusive_pte(struct
 		 * Currently device exclusive access only supports anonymous
 		 * memory so the entry shouldn't point to a filebacked page.
 		 */
-		WARN_ON_ONCE(!PageAnon(page));
+		WARN_ON_ONCE(1);
 
 	set_pte_at(vma->vm_mm, address, ptep, pte);
 
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-hugetlb-avoid-corrupting-page-mapping-in-hugetlb_mcopy_atomic_pte.patch
mm-page_alloc-minor-clean-up-for-memmap_init_compound.patch

