Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF213C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:17:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232637AbiEJEVw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:21:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236255AbiEJEUd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:20:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B8982B0318
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:15:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD446176A
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:15:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECB4C385C5;
        Tue, 10 May 2022 04:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156120;
        bh=dUahzq/t8cSG3+u2cyxV1jCWggVkBvV3PBzL4KFm2Fc=;
        h=Date:To:From:Subject:From;
        b=jF0mEn7Ffb1zNTLwLpQ7Ny73TDl8yvSbUfQtDFWUjvoS2V9NLMd2i7i5WyT3xetgZ
         7MQWtq5wq/GvjL290FXrOY/z8qv1eEfWYfHiDKQ0BuhscDT/hhTSmvsHobg4A0wHbs
         DOgnAmVW/Zm2pmDmTTs2YEd3LHDsQGWJnyEgI0eI=
Date:   Mon, 09 May 2022 21:15:19 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, shy828301@gmail.com, linmiaohe@huawei.com,
        hch@lst.de, geert+renesas@glider.be, neilb@suse.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-handle-thp-in-swap_page_fs-count_vm_events.patch removed from -mm tree
Message-Id: <20220510041520.3ECB4C385C5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: MM: handle THP in swap_*page_fs() - count_vm_events()
has been removed from the -mm tree.  Its filename was
     mm-handle-thp-in-swap_page_fs-count_vm_events.patch

This patch was dropped because it was merged into mm-stable

------------------------------------------------------
From: "NeilBrown" <neilb@suse.de>
Subject: MM: handle THP in swap_*page_fs() - count_vm_events()

We need to use count_swpout_vm_event() for sio_write_complete() to get
correct counting.

Note that THP swap in (if it ever happens) is current accounted 1 for each
page, whether HUGE or normal.  This is different from swap-out accounting.

This patch should be squashed into
    MM: handle THP in swap_*page_fs()

Link: https://lkml.kernel.org/r/165146948934.24404.5909750610552745025@noble.neil.brown.name
Signed-off-by: NeilBrown <neilb@suse.de>
Reported-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_io.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_io.c~mm-handle-thp-in-swap_page_fs-count_vm_events
+++ a/mm/page_io.c
@@ -280,8 +280,10 @@ static void sio_write_complete(struct ki
 			set_page_dirty(page);
 			ClearPageReclaim(page);
 		}
-	} else
-		count_vm_events(PSWPOUT, sio->pages);
+	} else {
+		for (p = 0; p < sio->pages; p++)
+			count_swpout_vm_event(sio->bvec[p].bv_page);
+	}
 
 	for (p = 0; p < sio->pages; p++)
 		end_page_writeback(sio->bvec[p].bv_page);
_

Patches currently in -mm which might be from neilb@suse.de are

mm-discard-__gfp_atomic.patch

