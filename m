Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263DDC77B70
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234555AbjDFCoe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234914AbjDFCoS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E735A8A7A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 81DDF640CA
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB07BC433EF;
        Thu,  6 Apr 2023 02:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749055;
        bh=/xplFuytTaXUxlG+U14PBAun19N7KMGS0tFf/18Db28=;
        h=Date:To:From:Subject:From;
        b=jFiqO6t6TvGgr1Pyt7vcYLF30ts49QFt3TwD52H7KJisH7+hCc5xpxNjfiVLxGXSw
         uOJF+NiTGuqK5YdvkagKjD8CukEXH3z86JqJZO6sAHzLmyRYAh0v9imv92Mhtyzrpb
         r5cYtI7LQBkJdSy8iZgH2X6+rGKOZj8x/vyC70Qk=
Date:   Wed, 05 Apr 2023 19:44:14 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch removed from -mm tree
Message-Id: <20230406024414.DB07BC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: use filemap_get_entry in filemap_get_incore_folio
has been removed from the -mm tree.  Its filename was
     mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: use filemap_get_entry in filemap_get_incore_folio
Date: Tue, 7 Mar 2023 15:34:06 +0100

filemap_get_incore_folio wants to look at the details of xa_is_value
entries, but doesn't need any of the other logic in filemap_get_folio. 
Switch it to use the lower-level filemap_get_entry interface.

Link: https://lkml.kernel.org/r/20230307143410.28031-4-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap_state.c~mm-use-filemap_get_entry-in-filemap_get_incore_folio
+++ a/mm/swap_state.c
@@ -386,7 +386,7 @@ struct folio *filemap_get_incore_folio(s
 {
 	swp_entry_t swp;
 	struct swap_info_struct *si;
-	struct folio *folio = __filemap_get_folio(mapping, index, FGP_ENTRY, 0);
+	struct folio *folio = filemap_get_entry(mapping, index);
 
 	if (!xa_is_value(folio))
 		goto out;
_

Patches currently in -mm which might be from hch@lst.de are


