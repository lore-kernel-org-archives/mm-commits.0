Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F89DC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234740AbjDFCoq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234951AbjDFCoS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112608A45
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 95D6064266
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF7EBC433EF;
        Thu,  6 Apr 2023 02:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749056;
        bh=tFd6JkyPrf0coYKG+Szo3R6v6EtUZG+OtU/BktrE9lQ=;
        h=Date:To:From:Subject:From;
        b=oLtezTCdsst1XBpeWwWSbyOTgHbbmiXoFEdTeLcjvcGV1Wqyz11u3/C5OZ6GsIS9z
         /trc8dvjmu+XJjIL/RZJnhPdwHIEzqZ/L3vc+DxNx1P9r2K0m04Ukx6JoRx/CndaXj
         HaRE+/DnHT6WExbvy41ijlLertTyM41c+nKuZrFc=
Date:   Wed, 05 Apr 2023 19:44:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hch@lst.de, agruenba@redhat.com,
        hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-shmem_get_partial_folio-use-filemap_get_entry.patch removed from -mm tree
Message-Id: <20230406024415.EF7EBC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: shmem_get_partial_folio use filemap_get_entry
has been removed from the -mm tree.  Its filename was
     shmem-shmem_get_partial_folio-use-filemap_get_entry.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: shmem: shmem_get_partial_folio use filemap_get_entry
Date: Sun, 19 Mar 2023 22:19:21 -0700 (PDT)

To avoid use of the FGP_ENTRY flag, adapt shmem_get_partial_folio() to use
filemap_get_entry() and folio_lock() instead of __filemap_get_folio(). 
Update "page" in the comments there to "folio".

Link: https://lkml.kernel.org/r/9d1aaa4-1337-fb81-6f37-74ebc96f9ef@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/mm/shmem.c~shmem-shmem_get_partial_folio-use-filemap_get_entry
+++ a/mm/shmem.c
@@ -885,14 +885,21 @@ static struct folio *shmem_get_partial_f
 
 	/*
 	 * At first avoid shmem_get_folio(,,,SGP_READ): that fails
-	 * beyond i_size, and reports fallocated pages as holes.
+	 * beyond i_size, and reports fallocated folios as holes.
 	 */
-	folio = __filemap_get_folio(inode->i_mapping, index,
-					FGP_ENTRY | FGP_LOCK, 0);
-	if (!xa_is_value(folio))
+	folio = filemap_get_entry(inode->i_mapping, index);
+	if (!folio)
 		return folio;
+	if (!xa_is_value(folio)) {
+		folio_lock(folio);
+		if (folio->mapping == inode->i_mapping)
+			return folio;
+		/* The folio has been swapped out */
+		folio_unlock(folio);
+		folio_put(folio);
+	}
 	/*
-	 * But read a page back from swap if any of it is within i_size
+	 * But read a folio back from swap if any of it is within i_size
 	 * (although in some cases this is just a waste of time).
 	 */
 	folio = NULL;
_

Patches currently in -mm which might be from hughd@google.com are


