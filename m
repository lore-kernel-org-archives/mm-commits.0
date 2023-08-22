Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F6EFEE49AB
	for <mm-commits@archiver.kernel.org>; Tue, 22 Aug 2023 20:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjHVUZa (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Aug 2023 16:25:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbjHVUZa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 22 Aug 2023 16:25:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E2CDCEE
        for <mm-commits@vger.kernel.org>; Tue, 22 Aug 2023 13:25:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ijAYWjym56ERUggYyvL6npyLnjV76dKxIQtbufrBYqE=; b=pV156LhIGClP+9SMM7Fkulao4v
        R945/XO71D/lVYJCs3YKKR1AXvMWt4AIV73jStKNh2flGqd8i6kMMqPS6eRpjfViW4BWElS3mDL1J
        gS+92k/5Wlsy1cb8xUmdlayWTIphyuWFNKXmSXOc0iDR9KOC8lfCpU8I2DdFgNGKbmRsM2M630c8A
        fZxt7D+b+TfByYzdEJyIDybeDdf87E0AsTWXEMHWeIF+7unpGA/a0OOOVKxEYEocewZJq9XuQO8BN
        d90/5FTrH3oqkNHmW5yMC+x6X3zKrcHN1ICI5NV+1TIE0CuMgFqSOj+yU1+H7KC5Ppnf0uH9iWyYj
        JjftwciQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1qYXwL-000kfG-N5; Tue, 22 Aug 2023 20:25:25 +0000
Date:   Tue, 22 Aug 2023 21:25:25 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, rppt@kernel.org, rdunlap@infradead.org
Subject: Re: + mm-fix-get_mctgt_type-kernel-doc-fix.patch added to
 mm-unstable branch
Message-ID: <ZOUZtZizeQG7PcsM@casper.infradead.org>
References: <20230821185454.618FDC433C8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821185454.618FDC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Mon, Aug 21, 2023 at 11:54:53AM -0700, Andrew Morton wrote:
> ------------------------------------------------------
> From: Andrew Morton <akpm@linux-foundation.org>
> Subject: mm-fix-get_mctgt_type-kernel-doc-fix
> Date: Mon Aug 21 11:53:43 AM PDT 2023
> 
> changes suggested by Randy

Randy and I had a further discussion offline, and I added this change
too:

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 26ba9d1a66d1..b29b850cf399 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5855,10 +5855,10 @@ static int mem_cgroup_move_account(struct page *page,
  * * MC_TARGET_NONE - If the pte is not a target for move charge.
  * * MC_TARGET_PAGE - If the page corresponding to this pte is a target for
  *   move charge. If @target is not NULL, the page is stored in target->page
- *   with extra refcnt taken (Callers should handle it).
+ *   with extra refcnt taken (Caller should release it).
  * * MC_TARGET_SWAP - If the swap entry corresponding to this pte is a
- *   target for charge migration.  If @target is not NULL, the entry is stored
- *   in target->ent.
+ *   target for charge migration.  If @target is not NULL, the entry is
+ *   stored in target->ent.
  * * MC_TARGET_DEVICE - Like MC_TARGET_PAGE but page is device memory and
  *   thus not on the lru.  For now such page is charged like a regular page
  *   would be as it is just special memory taking the place of a regular page.
