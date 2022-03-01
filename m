Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A22FC433EF
	for <mm-commits@archiver.kernel.org>; Tue,  1 Mar 2022 16:51:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbiCAQvy (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 1 Mar 2022 11:51:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiCAQvy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 1 Mar 2022 11:51:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4569EBC35
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 08:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4266B81B9C
        for <mm-commits@vger.kernel.org>; Tue,  1 Mar 2022 16:51:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CFB8C340EE;
        Tue,  1 Mar 2022 16:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646153470;
        bh=Q1C7jD6pRYo/pVzKCIQYhvs2YibNbFQX5zwfeSHKh4k=;
        h=Date:To:From:Subject:From;
        b=Pbj4z8ssLwU70nslomgLJYwEJoz4+kvBuZxzjmwhF0L2YQgJFdo/xZp4Gp5xlsMLC
         ncNY8A/viMHX+lPmGA11KCgxl7WQx4838JLbo7vIQNvyy3mxobcK9Gr+NZKvhSSZFF
         JZQC5CaXabM/3ZzGS95qU5cPMGEk6nXlWMblJJCA=
Date:   Tue, 01 Mar 2022 08:51:09 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-thp-fix-collapse_files-try_to_unmapfolio.patch removed from -mm tree
Message-Id: <20220301165110.8CFB8C340EE@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: fix collapse_file()'s try_to_unmap(folio,)
has been removed from the -mm tree.  Its filename was
     mm-thp-fix-collapse_files-try_to_unmapfolio.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: fix collapse_file()'s try_to_unmap(folio,)

The foliation of THP collapse_file()'s call to try_to_unmap() is currently
wrong, crashing on a test in rmap_walk() when xas_next() delivered a value
(after which page has been loaded independently).

Link: https://lkml.kernel.org/r/3f187b6c-e5e8-e66d-e0c0-7455ca6abb4c@google.com
Fixes: c3b522d9a698 ("mm/rmap: Convert try_to_unmap() to take a folio")
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/khugepaged.c~mm-thp-fix-collapse_files-try_to_unmapfolio
+++ a/mm/khugepaged.c
@@ -1835,7 +1835,8 @@ static void collapse_file(struct mm_stru
 		}
 
 		if (page_mapped(page))
-			try_to_unmap(folio, TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
+			try_to_unmap(page_folio(page),
+				     TTU_IGNORE_MLOCK | TTU_BATCH_FLUSH);
 
 		xas_lock_irq(&xas);
 		xas_set(&xas, index);
_

Patches currently in -mm which might be from hughd@google.com are

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch

