Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28F7C77B78
	for <mm-commits@archiver.kernel.org>; Wed,  3 May 2023 20:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjECUXe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 3 May 2023 16:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjECUXe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 3 May 2023 16:23:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28CAE5BA0
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 13:23:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8269B60F61
        for <mm-commits@vger.kernel.org>; Wed,  3 May 2023 20:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1EE3C433EF;
        Wed,  3 May 2023 20:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683145410;
        bh=jwPGgZbie3rpJPYhRkih5c0tBKu+yao+D7T/owh9jQw=;
        h=Date:To:From:Subject:From;
        b=uHsiGyuivtypuOhXWtT61IerkMVtHRJrLkzqB7oWLgj5U7sBhWz9FAZ2Td0KocN4X
         2+LTpCwk6Dxv0TqtRwF+jvFDd1MxcSHgoH1X73snMIw0Ob3jRHCjirFjmTLKdxEME+
         pgY9yOJGgU/doot5JvBSnrW+/U6AuQry9ReyEXrg=
Date:   Wed, 03 May 2023 13:23:30 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        marc.dionne@auristor.com, jack@suse.cz, dhowells@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + filemap-fix-the-conditional-folio_put-in-filemap_fault.patch added to mm-hotfixes-unstable branch
Message-Id: <20230503202330.D1EE3C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: filemap: fix the conditional folio_put in filemap_fault
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     filemap-fix-the-conditional-folio_put-in-filemap_fault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/filemap-fix-the-conditional-folio_put-in-filemap_fault.patch

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
Subject: filemap: fix the conditional folio_put in filemap_fault
Date: Wed, 3 May 2023 17:45:25 +0200

folio can't be NULL here now that __filemap_get_folio returns an ERR_PTR. 
Remove the conditional folio_put after the out_retry label and add a new
label for the cases where we have a valid folio.

Link: https://lkml.kernel.org/r/20230503154526.1223095-1-hch@lst.de
Fixes: 66dabbb65d67 ("mm: return an ERR_PTR from __filemap_get_folio")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: syzbot+48011b86c8ea329af1b9@syzkaller.appspotmail.com
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Marc Dionne <marc.dionne@auristor.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/filemap.c~filemap-fix-the-conditional-folio_put-in-filemap_fault
+++ a/mm/filemap.c
@@ -3298,7 +3298,7 @@ retry_find:
 	}
 
 	if (!lock_folio_maybe_drop_mmap(vmf, folio, &fpin))
-		goto out_retry;
+		goto out_retry_put_folio;
 
 	/* Did it get truncated? */
 	if (unlikely(folio->mapping != mapping)) {
@@ -3334,7 +3334,7 @@ retry_find:
 	 */
 	if (fpin) {
 		folio_unlock(folio);
-		goto out_retry;
+		goto out_retry_put_folio;
 	}
 	if (mapping_locked)
 		filemap_invalidate_unlock_shared(mapping);
@@ -3363,7 +3363,7 @@ page_not_uptodate:
 	fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 	error = filemap_read_folio(file, mapping->a_ops->read_folio, folio);
 	if (fpin)
-		goto out_retry;
+		goto out_retry_put_folio;
 	folio_put(folio);
 
 	if (!error || error == AOP_TRUNCATED_PAGE)
@@ -3372,14 +3372,14 @@ page_not_uptodate:
 
 	return VM_FAULT_SIGBUS;
 
+out_retry_put_folio:
+	folio_put(folio);
 out_retry:
 	/*
 	 * We dropped the mmap_lock, we need to return to the fault handler to
 	 * re-find the vma and come back and find our hopefully still populated
 	 * page.
 	 */
-	if (folio)
-		folio_put(folio);
 	if (mapping_locked)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
_

Patches currently in -mm which might be from hch@lst.de are

filemap-fix-the-conditional-folio_put-in-filemap_fault.patch
afs-fix-the-afs_dir_get_folio-return-value.patch

