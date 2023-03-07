Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AD23C6FA99
	for <mm-commits@archiver.kernel.org>; Tue,  7 Mar 2023 21:42:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbjCGVm3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 7 Mar 2023 16:42:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjCGVm2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 7 Mar 2023 16:42:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A0BBA648E
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 13:42:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0431261538
        for <mm-commits@vger.kernel.org>; Tue,  7 Mar 2023 21:42:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DC05C433EF;
        Tue,  7 Mar 2023 21:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1678225344;
        bh=SW4cezRDHB6CP1zmBNVGxTnW4hTlzr9OpOEoBbl45Ag=;
        h=Date:To:From:Subject:From;
        b=x0n8c1ofAhW7q2fA9wRp//NATQ1Kd9PtmS/swkzuijTCpHxYe69iKFvI4bbKhQCLx
         3ry74EXid5jHLf3rBgdmNkRCrPrA1VZhekZbLQ+0Wg3+DZU0Hirsxm+z5erOgshgeA
         vzbEaCTAeSF3AL52/CompH2HdNLx1MHW2GW4iYlI=
Date:   Tue, 07 Mar 2023 13:42:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch added to mm-unstable branch
Message-Id: <20230307214224.5DC05C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't look at xarray value entries in split_huge_pages_in_file
has been added to the -mm mm-unstable branch.  Its filename is
     mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch

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
Subject: mm: don't look at xarray value entries in split_huge_pages_in_file
Date: Tue, 7 Mar 2023 15:34:04 +0100

Patch series "return an ERR_PTR from __filemap_get_folio", v3.

__filemap_get_folio and its wrappers can return NULL for three different
conditions, which in some cases requires the caller to reverse engineer
the decision making.  This is fixed by returning an ERR_PTR instead of
NULL and thus transporting the reason for the failure.  But to make
that work we first need to ensure that no xa_value special case is
returned and thus return the FGP_ENTRY flag.  It turns out that flag
is barely used and can usually be deal with in a better way.


This patch (of 7):

split_huge_pages_in_file never wants to do anything with the special value
enties.  Switch to using filemap_get_folio to not even see them.

Link: https://lkml.kernel.org/r/20230307143410.28031-1-hch@lst.de
Link: https://lkml.kernel.org/r/20230307143410.28031-2-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c~mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file
+++ a/mm/huge_memory.c
@@ -3093,11 +3093,10 @@ static int split_huge_pages_in_file(cons
 	mapping = candidate->f_mapping;
 
 	for (index = off_start; index < off_end; index += nr_pages) {
-		struct folio *folio = __filemap_get_folio(mapping, index,
-						FGP_ENTRY, 0);
+		struct folio *folio = filemap_get_folio(mapping, index);
 
 		nr_pages = 1;
-		if (xa_is_value(folio) || !folio)
+		if (!folio)
 			continue;
 
 		if (!folio_test_large(folio))
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

