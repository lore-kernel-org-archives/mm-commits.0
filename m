Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17165C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 26 May 2022 21:04:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240459AbiEZVD6 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 26 May 2022 17:03:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239889AbiEZVDx (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 26 May 2022 17:03:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C59FE7328
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 14:03:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3598EB82216
        for <mm-commits@vger.kernel.org>; Thu, 26 May 2022 21:03:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B279DC3411A;
        Thu, 26 May 2022 21:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1653599028;
        bh=VhqX78djzVUunQDnXUvw5QoSfNQYMLlC6bu8YlMfjI8=;
        h=Date:To:From:Subject:From;
        b=g1h/o/Qsjks1o+mr05q84Ypw+D+nkx7pb1qtlW0lhiuXlsnfldpjM5FXCdcCQmi4O
         O7N1zQG5HqXIugceaYO8ucOdBnxWKqDVRnyE9ri3lkUu4/vZJyzD2k8cxtJ0h70p0f
         Q4O8zpqIcx7qkyQBvMUtKM+En750lDf0PIh/MSvk=
Date:   Thu, 26 May 2022 14:03:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, hch@lst.de, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-shmem-fix-shmem-folio-swapoff-hang.patch removed from -mm tree
Message-Id: <20220526210348.B279DC3411A@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/shmem: fix shmem folio swapoff hang
has been removed from the -mm tree.  Its filename was
     mm-shmem-fix-shmem-folio-swapoff-hang.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/shmem: fix shmem folio swapoff hang
Date: Sat, 21 May 2022 19:53:04 -0700 (PDT)

Shmem swapoff makes no progress: the index to indices is not incremented. 
But "ret" is no longer a return value, so use folio_batch_count() instead.

Link: https://lkml.kernel.org/r/c32bee8a-f0aa-245-f94e-24dd271924fa@google.com
Fixes: da08e9b79323 ("mm/shmem: convert shmem_swapin_page() to shmem_swapin_folio()")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Tested-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/shmem.c~mm-shmem-fix-shmem-folio-swapoff-hang
+++ a/mm/shmem.c
@@ -1164,7 +1164,6 @@ static int shmem_find_swap_entries(struc
 	XA_STATE(xas, &mapping->i_pages, start);
 	struct folio *folio;
 	swp_entry_t entry;
-	unsigned int ret = 0;
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, ULONG_MAX) {
@@ -1178,7 +1177,7 @@ static int shmem_find_swap_entries(struc
 		if (swp_type(entry) != type)
 			continue;
 
-		indices[ret] = xas.xa_index;
+		indices[folio_batch_count(fbatch)] = xas.xa_index;
 		if (!folio_batch_add(fbatch, folio))
 			break;
 
_

Patches currently in -mm which might be from hughd@google.com are


