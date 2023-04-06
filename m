Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89447C7618D
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjDFCor (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234950AbjDFCoT (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E4797A9A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB2F6426A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306B9C433D2;
        Thu,  6 Apr 2023 02:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749057;
        bh=xjN2ICG2S7wFSMUPP13OAphGYYs/TUe9nqQOshl1Hsc=;
        h=Date:To:From:Subject:From;
        b=kr1WQUXKRTN1ihwKfdXSF/ZcDTQ5qxWcvlIS+UKBNYbWD41SOyQpR7K3nDPFej4cq
         /WOhryZ3gofJS/vfpgJPnk8AdQNkg5NV/U2fUNYvvoFYo7uSFsTrPCxO2IIyBG0TWL
         s2dQA2iqpiXqEHL1HAtzqyt5FLWdgDO8E/O8+gyw=
Date:   Wed, 05 Apr 2023 19:44:16 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch removed from -mm tree
Message-Id: <20230406024417.306B9C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: shmem: open code the page cache lookup in shmem_get_folio_gfp
has been removed from the -mm tree.  Its filename was
     shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: shmem: open code the page cache lookup in shmem_get_folio_gfp
Date: Tue, 7 Mar 2023 15:34:08 +0100

Use the very low level filemap_get_entry helper to look up the entry in
the xarray, and then:

 - don't bother locking the folio if only doing a userfault notification
 - open code locking the page and checking for truncation in a related
   code block

This will allow to eventually remove the FGP_ENTRY flag.

[hughd@google.com: adjust the new comment line]
  Link: https://lkml.kernel.org/r/af178ebb-1076-a38c-1dc1-2a37ccce4a3@google.com
Link: https://lkml.kernel.org/r/20230307143410.28031-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1880,12 +1880,10 @@ repeat:
 	sbinfo = SHMEM_SB(inode->i_sb);
 	charge_mm = vma ? vma->vm_mm : NULL;
 
-	folio = __filemap_get_folio(mapping, index, FGP_ENTRY | FGP_LOCK, 0);
+	folio = filemap_get_entry(mapping, index);
 	if (folio && vma && userfaultfd_minor(vma)) {
-		if (!xa_is_value(folio)) {
-			folio_unlock(folio);
+		if (!xa_is_value(folio))
 			folio_put(folio);
-		}
 		*fault_type = handle_userfault(vmf, VM_UFFD_MINOR);
 		return 0;
 	}
@@ -1901,6 +1899,14 @@ repeat:
 	}
 
 	if (folio) {
+		folio_lock(folio);
+
+		/* Has the folio been truncated or swapped out? */
+		if (unlikely(folio->mapping != mapping)) {
+			folio_unlock(folio);
+			folio_put(folio);
+			goto repeat;
+		}
 		if (sgp == SGP_WRITE)
 			folio_mark_accessed(folio);
 		if (folio_test_uptodate(folio))
_

Patches currently in -mm which might be from hch@lst.de are


