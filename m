Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4803C6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjCGVms (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:42:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231492AbjCGVmi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:42:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2EEA76BE
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:42:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D9B7B819D8
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21024C433D2;
        Tue,  7 Mar 2023 21:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678225352;
        bh=ncrxn55N0IKlD7xbLo8R8sv64M6XHywPyTtxjDROuZo=;
        h=Date:To:From:Subject:From;
        b=cQ8Sz1sv6mzipYjifWYArcVoFm0wboGLFMNF5nwVbITBPmD/C2wwvzrnjlnLCPftR
         TU82JSSSYU4mAU+wahodrTIbyNKRxPYS0hj0P1htEPL+avoM6XEbTWE1rbjCDaRLsU
         Dt/XOMA20jX4mK6TiLG3kZck0U1K9t8aMjM40w1g=
Date:   Tue, 07 Mar 2023 13:42:31 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch added to mm-unstable branch
Message-Id: <20230307214232.21024C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: shmem: open code the page cache lookup in shmem_get_folio_gfp
has been added to the -mm mm-unstable branch.  Its filename is
     shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

Link: https://lkml.kernel.org/r/20230307143410.28031-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/shmem.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/shmem.c~shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp
+++ a/mm/shmem.c
@@ -1859,12 +1859,10 @@ repeat:
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
@@ -1880,6 +1878,14 @@ repeat:
 	}
 
 	if (folio) {
+		folio_lock(folio);
+
+		/* Has the page been truncated? */
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

ufs-dont-flush-page-immediately-for-dirsync-directories.patch
ocfs2-dont-use-write_one_page-in-ocfs2_duplicate_clusters_by_page.patch
mmjfs-move-write_one_page-folio_write_one-to-jfs.patch
mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-remove-shmem_get_partial_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch

