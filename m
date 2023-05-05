Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97D37C7EE24
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231817AbjEEWnL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233466AbjEEWnI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:43:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86205FF9
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:43:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DBE764155
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6675C433D2;
        Fri,  5 May 2023 22:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326586;
        bh=9mYtYI3OaZtXILZvfA0Nk6GKzpaSj0vMDlDIO1AqD68=;
        h=Date:To:From:Subject:From;
        b=XQ3vDswYCOjPuqq1LSY8JVl75jdSUVBLtrcLFNskrrK2k68sCTYWUtKiGrpnHJvdA
         zZjg9OFP89jlWqZVvS/QSp/O8jRsskwLIqTkyhfYfu1Oy45LPSPDNHSZL4jHkkJuPQ
         8YuotRHDwVRbdseg1+xJkXhFSCsD9ZZMoT5UufLQ=
Date:   Fri, 05 May 2023 15:43:06 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        marc.dionne@auristor.com, jack@suse.cz, dhowells@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] afs-fix-the-afs_dir_get_folio-return-value.patch removed from -mm tree
Message-Id: <20230505224306.C6675C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: afs: fix the afs_dir_get_folio return value
has been removed from the -mm tree.  Its filename was
     afs-fix-the-afs_dir_get_folio-return-value.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


