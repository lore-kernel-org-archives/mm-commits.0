Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DABC7619A
	for <mm-commits@archiver.kernel.org>; Thu,  6 Apr 2023 02:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234993AbjDFCtP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 5 Apr 2023 22:49:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234995AbjDFCsX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 5 Apr 2023 22:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2C2A5CE
        for <mm-commits@vger.kernel.org>; Wed,  5 Apr 2023 19:45:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4B45E6425C
        for <mm-commits@vger.kernel.org>; Thu,  6 Apr 2023 02:45:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0FFAC433D2;
        Thu,  6 Apr 2023 02:45:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1680749148;
        bh=5HHexe89j1Px71Nwe3P5k3m2398X/QFgfc0iihNt76k=;
        h=Date:To:From:Subject:From;
        b=LcnaPXnbSObCHS3HGrvuh0mWJOFh6hFtbFjtOcZ1VP5qf1Stg/PEgK7TMIXJkTVau
         lxCvULwSQyMzaxz+Fjzjfe4fvEKQHgvbjIk072n4syp4BQYfweU8BN+bUrJM/GBsBB
         cigR3P5566LQKTfLGyiILNAmiZHqq0I+ELhAUZDg=
Date:   Wed, 05 Apr 2023 19:45:48 -0700
To:     mm-commits@vger.kernel.org, djwong@kernel.org, dhowells@redhat.com,
        dchinner@redhat.com, willy@infradead.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] xfs-remove-xfs_filemap_map_pages-wrapper.patch removed from -mm tree
Message-Id: <20230406024548.A0FFAC433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: xfs: remove xfs_filemap_map_pages() wrapper
has been removed from the -mm tree.  Its filename was
     xfs-remove-xfs_filemap_map_pages-wrapper.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Cc: Darrick J. Wong <djwong@kernel.org>
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

hugetlb-remove-pageheadhuge.patch

