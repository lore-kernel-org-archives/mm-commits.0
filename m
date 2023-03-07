Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33334C6FD1E
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:42:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231258AbjCGVmk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:42:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbjCGVmh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:42:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318FFA648E
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:42:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C50E86154D
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B912C433D2;
        Tue,  7 Mar 2023 21:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678225348;
        bh=Mj5PcjxN+lCyCWU76vXZdbWVSleSPGOmuCBh3B2mj4o=;
        h=Date:To:From:Subject:From;
        b=eImtCEk3q4wuiSVQCUiocjGVKUkt3RObDa6dmC1EXZ+Eh09zAC2LBMzcBAdNIVJ21
         1Z9efURb9rt5bYjZ5AFb3UqRNLSwgDQGUHSbLQgTrabWW+HPuGAApKv4QbeC2IqH0i
         0jglou9bEJQFQpC96bAXrCj9UvOe7S4a/RlaauBE=
Date:   Tue, 07 Mar 2023 13:42:27 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch added to mm-unstable branch
Message-Id: <20230307214228.2B912C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: use filemap_get_entry in filemap_get_incore_folio
has been added to the -mm mm-unstable branch.  Its filename is
     mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch

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

