Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B68BC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 17 Jun 2022 02:49:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379789AbiFQCtS (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Jun 2022 22:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiFQCtS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Jun 2022 22:49:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7064E64D0B
        for <mm-commits@vger.kernel.org>; Thu, 16 Jun 2022 19:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2358EB826EF
        for <mm-commits@vger.kernel.org>; Fri, 17 Jun 2022 02:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E76C34114;
        Fri, 17 Jun 2022 02:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1655434154;
        bh=GuynP1b44BAKjBe1/WoNHzdYusCdRJgCUW40NvjE76g=;
        h=Date:To:From:Subject:From;
        b=otTK54GoRZANZkJ9fL5u0k1vAnudpvi1j10vQvx54R1n6SyMhDj9zrEa4ischsTbq
         xFz+KfN0sLZSdA7AnFwRyyafMiH/J/2wsUtQ+N23aGw6/HHvX0s4ashM6RNzZvVTKu
         JwNCnf4ZL6L1Ivxm7A2pjarlNk+aebhOhynEDHgE=
Date:   Thu, 16 Jun 2022 19:49:14 -0700
To:     mm-commits@vger.kernel.org, songmuchun@bytedance.com,
        linmiaohe@huawei.com, bh1scw@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-page_aligned-instead-of-is_aligned.patch removed from -mm tree
Message-Id: <20220617024914.C1E76C34114@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use PAGE_ALIGNED instead of IS_ALIGNED
has been removed from the -mm tree.  Its filename was
     mm-use-page_aligned-instead-of-is_aligned.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Fanjun Kong <bh1scw@gmail.com>
Subject: mm: use PAGE_ALIGNED instead of IS_ALIGNED
Date: Thu, 26 May 2022 22:02:57 +0800

<linux/mm.h> already provides the PAGE_ALIGNED macro.  Let's use this
macro instead of IS_ALIGNED and passing PAGE_SIZE directly.

Link: https://lkml.kernel.org/r/20220526140257.1568744-1-bh1scw@gmail.com
Signed-off-by: Fanjun Kong <bh1scw@gmail.com>
Acked-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse-vmemmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/sparse-vmemmap.c~mm-use-page_aligned-instead-of-is_aligned
+++ a/mm/sparse-vmemmap.c
@@ -200,8 +200,8 @@ static int vmemmap_remap_range(unsigned
 	unsigned long next;
 	pgd_t *pgd;
 
-	VM_BUG_ON(!IS_ALIGNED(start, PAGE_SIZE));
-	VM_BUG_ON(!IS_ALIGNED(end, PAGE_SIZE));
+	VM_BUG_ON(!PAGE_ALIGNED(start));
+	VM_BUG_ON(!PAGE_ALIGNED(end));
 
 	pgd = pgd_offset_k(addr);
 	do {
_

Patches currently in -mm which might be from bh1scw@gmail.com are


