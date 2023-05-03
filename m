Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C157FC77B75
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 20:23:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229455AbjECUXf (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 16:23:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjECUXe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 16:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A59D583D5
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 13:23:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3ACDF60EDC
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 20:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD05C433EF;
        Wed,  3 May 2023 20:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683145412;
        bh=7wg9CQdtwXvMyBBWB0kZvSYLnUJzitZasK3cB5hwNeo=;
        h=Date:To:From:Subject:From;
        b=0RsgWC7gFdhkynePuGWBHZhPsD1xxD71qBihH5bVqsVea7KHoPRwYqS2cBugiem3q
         tuD9h2KS1wyGntzeX2W5aFwEzQUAsWd52kvfnlrE34W9+Lca9h2oaU/B93FUrHgD7z
         UoUr5cQSHpeezMkYgvT1BBHWAH2GF4Y5ggEe/ozU=
Date:   Wed, 03 May 2023 13:23:31 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        marc.dionne@auristor.com, jack@suse.cz, dhowells@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + afs-fix-the-afs_dir_get_folio-return-value.patch added to mm-hotfixes-unstable branch
Message-Id: <20230503202332.8CD05C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: afs: fix the afs_dir_get_folio return value
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     afs-fix-the-afs_dir_get_folio-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/afs-fix-the-afs_dir_get_folio-return-value.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: afs: fix the afs_dir_get_folio return value
Date: Wed, 3 May 2023 17:45:26 +0200

Keep returning NULL on failure instead of letting an ERR_PTR escape to
callers that don't expect it.

Link: https://lkml.kernel.org/r/20230503154526.1223095-2-hch@lst.de
Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: David Howells <dhowells@redhat.com>
Tested-by: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir_edit.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/fs/afs/dir_edit.c~afs-fix-the-afs_dir_get_folio-return-value
+++ a/fs/afs/dir_edit.c
@@ -115,11 +115,12 @@ static struct folio *afs_dir_get_folio(s
 	folio = __filemap_get_folio(mapping, index,
 				    FGP_LOCK | FGP_ACCESSED | FGP_CREAT,
 				    mapping->gfp_mask);
-	if (IS_ERR(folio))
+	if (IS_ERR(folio)) {
 		clear_bit(AFS_VNODE_DIR_VALID, &vnode->flags);
-	else if (folio && !folio_test_private(folio))
+		return NULL;
+	}
+	if (!folio_test_private(folio))
 		folio_attach_private(folio, (void *)1);
-
 	return folio;
 }
 
_

Patches currently in -mm which might be from hch@lst.de are

filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
afs-fix-the-afs_dir_get_folio-return-value.patch

