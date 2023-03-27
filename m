Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1180C6FD1D
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 19:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229452AbjC0Ty2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 15:54:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjC0Ty1 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 15:54:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D8389E
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 12:54:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6477614C6
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 19:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38940C433EF;
        Mon, 27 Mar 2023 19:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679946865;
        bh=6gIrRQFT5ezqg+zK/DTWLtVWIB/3cs4hRdPraZdXQYo=;
        h=Date:To:From:Subject:From;
        b=inSAsdFHSJeSrPNndWELXHmFYcY1xJzoBRcvU9cswFhAz/72ONVZ6uoniN0nOCZE1
         N5a3OyqyLwzKBLS/agOcg5ZqufhNKjlRtSEfmH9DZ+xdpxZjM/p8GpAeAPuarnBN6K
         xJB5nx3khjpnEh7eno7iM5uLnilG9lUbIUSrIDmw=
Date:   Mon, 27 Mar 2023 12:54:24 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        david@fromorbit.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + xfs-remove-xfs_filemap_map_pages-wrapper.patch added to mm-unstable branch
Message-Id: <20230327195425.38940C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: xfs: remove xfs_filemap_map_pages() wrapper
has been added to the -mm mm-unstable branch.  Its filename is
     xfs-remove-xfs_filemap_map_pages-wrapper.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/xfs-remove-xfs_filemap_map_pages-wrapper.patch

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
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: xfs: remove xfs_filemap_map_pages() wrapper
Date: Mon, 27 Mar 2023 18:45:13 +0100

Patch series "Prevent ->map_pages from sleeping", v2.

In preparation for a larger patch series which will handle (some, easy)
page faults protected only by RCU, change the two filesystems which have
sleeping locks to not take them and hold the RCU lock around calls to
->map_page to prevent other filesystems from adding sleeping locks.


This patch (of 3):

XFS doesn't actually need to be holding the XFS_MMAPLOCK_SHARED to do
this.  filemap_map_pages() cannot bring new folios into the page cache
and the folio lock is taken during filemap_map_pages() which provides
sufficient protection against a truncation or hole punch.

Link: https://lkml.kernel.org/r/20230327174515.1811532-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20230327174515.1811532-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>
Cc: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/xfs_file.c |   17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

--- a/fs/xfs/xfs_file.c~xfs-remove-xfs_filemap_map_pages-wrapper
+++ a/fs/xfs/xfs_file.c
@@ -1388,25 +1388,10 @@ xfs_filemap_pfn_mkwrite(
 	return __xfs_filemap_fault(vmf, PE_SIZE_PTE, true);
 }
 
-static vm_fault_t
-xfs_filemap_map_pages(
-	struct vm_fault		*vmf,
-	pgoff_t			start_pgoff,
-	pgoff_t			end_pgoff)
-{
-	struct inode		*inode = file_inode(vmf->vma->vm_file);
-	vm_fault_t ret;
-
-	xfs_ilock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	ret = filemap_map_pages(vmf, start_pgoff, end_pgoff);
-	xfs_iunlock(XFS_I(inode), XFS_MMAPLOCK_SHARED);
-	return ret;
-}
-
 static const struct vm_operations_struct xfs_file_vm_ops = {
 	.fault		= xfs_filemap_fault,
 	.huge_fault	= xfs_filemap_huge_fault,
-	.map_pages	= xfs_filemap_map_pages,
+	.map_pages	= filemap_map_pages,
 	.page_mkwrite	= xfs_filemap_page_mkwrite,
 	.pfn_mkwrite	= xfs_filemap_pfn_mkwrite,
 };
_

Patches currently in -mm which might be from willy@infradead.org are

xfs-remove-xfs_filemap_map_pages-wrapper.patch
afs-split-afs_pagecache_valid-out-of-afs_validate.patch
mm-hold-the-rcu-read-lock-over-calls-to-map_pages.patch

