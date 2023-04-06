Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 436A9C7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:44:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234984AbjDFCob (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbjDFCoO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:44:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E9B86B6
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:44:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C87D6421A
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:44:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4D58C433D2;
        Thu,  6 Apr 2023 02:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749052;
        bh=qq29vNkA6zJtdwbeSPMd16H0OI/iOjaTkPAhtkwpimE=;
        h=Date:To:From:Subject:From;
        b=WqJCgrm/gZNUv2orfaCcxvvYm2OYTq1TWnH+EJDuuU/hue8ZPiZQLTfopN0TrHBZf
         pB0a+B2nVsYg4453og1BOBml1ztG9kB5t/1ZRNWeiAPNVebxxfLbKd4uauCPnQXVRZ
         sZXZkq5BUFYvJnbyBq7ICuGeAiuy5ZaLq+ylTlTQ=
Date:   Wed, 05 Apr 2023 19:44:12 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        konishi.ryusuke@gmail.com, hughd@google.com, agruenba@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch removed from -mm tree
Message-Id: <20230406024412.A4D58C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: don't look at xarray value entries in split_huge_pages_in_file
has been removed from the -mm tree.  Its filename was
     mm-dont-look-at-xarray-value-entries-in-split_huge_pages_in_file.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
@@ -3089,11 +3089,10 @@ static int split_huge_pages_in_file(cons
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


