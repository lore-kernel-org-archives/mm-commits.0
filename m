Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 021A7C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234717AbjDFC2y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:28:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234734AbjDFC2x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:28:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3045A7DB2
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:28:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3FC06410D
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:28:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2197BC433D2;
        Thu,  6 Apr 2023 02:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748132;
        bh=MrOqvGeYqFLmyIqNNw+fgkUibkhqSMyNOIuORldL6QM=;
        h=Date:To:From:Subject:From;
        b=efMOq7El8HnI1sXssTs1W9YVJRDZ0+Z7OwHsBy1bOlk5oaUI1koPtkik+KmOTg1PG
         oHCCMekoWsOS3Iliy3Vtl8CI2yrV9Yniwmb8cdVG39pyOpPRJGCkc8fZDhabdEXYJC
         zAARXcq3+01yDiGWQkbLY/4KgECHriG8fNpRWQGY=
Date:   Wed, 05 Apr 2023 19:28:51 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hch@lst.de, agruenba@redhat.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch removed from -mm tree
Message-Id: <20230406022852.2197BC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
has been removed from the -mm tree.  Its filename was
     shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix.patch

This patch was dropped because it was folded into shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
Date: Sun, 19 Mar 2023 22:23:36 -0700 (PDT)

Adjust the new comment line: shmem folio may have been swapped out.

Link: https://lkml.kernel.org/r/af178ebb-1076-a38c-1dc1-2a37ccce4a3@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/shmem.c~shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp-fix
+++ a/mm/shmem.c
@@ -1904,7 +1904,7 @@ repeat:
 	if (folio) {
 		folio_lock(folio);
 
-		/* Has the page been truncated? */
+		/* Has the folio been truncated or swapped out? */
 		if (unlikely(folio->mapping != mapping)) {
 			folio_unlock(folio);
 			folio_put(folio);
_

Patches currently in -mm which might be from hughd@google.com are

shmem-shmem_get_partial_folio-use-filemap_get_entry.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch

