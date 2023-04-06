Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C493C761A6
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234901AbjDFCkZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234857AbjDFCkS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 578A58A7A
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD78664217
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CBBCC4339E;
        Thu,  6 Apr 2023 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680748816;
        bh=QaLe65gv5vTHcr8veHySCRx7Yj5v8fH/S1Pf5rQVxYo=;
        h=Date:To:From:Subject:From;
        b=YR2Ndz/z6XiJy3v7CPG2T1Lm2HT5PqexnCybuCHBcCo+1UQElyVI2bOvc0qG/1P+M
         hEXiTvhJN3K0Dv/k1x9v+GKk34zkcFjdkFJP8j7kmSRb5j02nXK/lpymO+p3sppqWZ
         AUnMhslMlzqjVysUvARsYNGvGs6q0YxI41uHVM+8=
Date:   Wed, 05 Apr 2023 19:40:15 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        naoya.horiguchi@linux.dev, konishi.ryusuke@gmail.com,
        hughd@google.com, agruenba@redhat.com, hch@lst.de,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch removed from -mm tree
Message-Id: <20230406024016.2CBBCC4339E@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm-return-an-err_ptr-from-__filemap_get_folio-fix
has been removed from the -mm tree.  Its filename was
     mm-return-an-err_ptr-from-__filemap_get_folio-fix.patch

This patch was dropped because it was folded into mm-return-an-err_ptr-from-__filemap_get_folio.patch

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm-return-an-err_ptr-from-__filemap_get_folio-fix
Date: Fri, 10 Mar 2023 08:00:23 +0100

fix null-pointer deref

Link: https://lkml.kernel.org/r/20230310070023.GA13563@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Naoya Horiguchi <naoya.horiguchi@linux.dev>
  Link: https://lkml.kernel.org/r/20230310043137.GA1624890@u2004
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/swap_state.c~mm-return-an-err_ptr-from-__filemap_get_folio-fix
+++ a/mm/swap_state.c
@@ -390,6 +390,8 @@ struct folio *filemap_get_incore_folio(s
 	struct swap_info_struct *si;
 	struct folio *folio = filemap_get_entry(mapping, index);
 
+	if (!folio)
+		return ERR_PTR(-ENOENT);
 	if (!xa_is_value(folio))
 		return folio;
 	if (!shmem_mapping(mapping))
_

Patches currently in -mm which might be from hch@lst.de are

mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch
mm-make-mapping_get_entry-available-outside-of-filemapc.patch
mm-use-filemap_get_entry-in-filemap_get_incore_folio.patch
shmem-open-code-the-page-cache-lookup-in-shmem_get_folio_gfp.patch
mm-remove-fgp_entry.patch
mm-return-an-err_ptr-from-__filemap_get_folio.patch

