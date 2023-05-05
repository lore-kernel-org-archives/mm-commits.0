Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03336C7EE2C
	for <mm-commits@archiver.kernel.org>; Fri,  5 May 2023 22:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233010AbjEEWnK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 May 2023 18:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbjEEWnH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 5 May 2023 18:43:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820F35FF2
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 15:43:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 637B660FA4
        for <mm-commits@vger.kernel.org>; Fri,  5 May 2023 22:43:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7761C433D2;
        Fri,  5 May 2023 22:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1683326585;
        bh=RRcoDH2IliZHlHeh7wMC4cvCTANNtybdB5ifnYjC0L4=;
        h=Date:To:From:Subject:From;
        b=bGs6bOuzpuR5PV1FjoCEcZ35uulnz/KWPoHjgfDInJ7z3q8UQUHDVKIhVfhPQyMo+
         xXXba8jQoLZMgFEbQTM7MS2BpUDEHLDcFW5YxqQH+ccDax2Bz3fWi/Q5DvZcIOkKBQ
         0G2ZpzSbcWC+us8dJbEbmCXAQr0ZKuf8xKGWQYkw=
Date:   Fri, 05 May 2023 15:43:05 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        marc.dionne@auristor.com, jack@suse.cz, dhowells@redhat.com,
        hch@lst.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] filemap-fix-the-conditional-folio_put-in-filemap_fault.patch removed from -mm tree
Message-Id: <20230505224305.B7761C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: filemap: fix the conditional folio_put in filemap_fault
has been removed from the -mm tree.  Its filename was
     filemap-fix-the-conditional-folio_put-in-filemap_fault.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


