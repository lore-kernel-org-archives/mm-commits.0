Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3046C4332F
	for <mm-commits@archiver.kernel.org>; Mon, 12 Dec 2022 02:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231274AbiLLCQc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 11 Dec 2022 21:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiLLCOj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 11 Dec 2022 21:14:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC298DAC
        for <mm-commits@vger.kernel.org>; Sun, 11 Dec 2022 18:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E8960EC3
        for <mm-commits@vger.kernel.org>; Mon, 12 Dec 2022 02:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3217C433D2;
        Mon, 12 Dec 2022 02:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670811274;
        bh=GdTp9kpzV92GRdLRA4Fl2/lyQIMkijX6b/+VXjeDuTo=;
        h=Date:To:From:Subject:From;
        b=zQsoMhBpWygg3GcYA7z9dgXn4la1WVpcco5Efmsucm9o/OKb21ZvKmSXjb5wafFyA
         MN7QgqRGQzHkO8x1H9fQolTpuYB6IA6XKqSUfhjmDFLgfDRKjsrC0qF7i8L7XcONuP
         xiE1ozEHXwWlLsdQhhuqdIo+sfx7oBgSdg1PU2NQ=
Date:   Sun, 11 Dec 2022 18:14:34 -0800
To:     mm-commits@vger.kernel.org, jhubbard@nvidia.com, jgg@nvidia.com,
        djwong@kernel.org, david@fromorbit.com, dan.j.williams@intel.com,
        apopple@nvidia.com, ruansy.fnst@fujitsu.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch removed from -mm tree
Message-Id: <20221212021434.B3217C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: fsdax,xfs: set the shared flag when file extent is shared
has been removed from the -mm tree.  Its filename was
     fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax,xfs: set the shared flag when file extent is shared
Date: Thu, 1 Dec 2022 15:28:54 +0000

If a dax page is shared, mapread at different offsets can also trigger
page fault on same dax page.  So, change the flag from "cow" to "shared". 
And get the shared flag from filesystem when read.

Link: https://lkml.kernel.org/r/1669908538-55-5-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |   19 +++++++------------
 fs/xfs/xfs_iomap.c |    2 +-
 2 files changed, 8 insertions(+), 13 deletions(-)

--- a/fs/dax.c~fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared
+++ a/fs/dax.c
@@ -846,12 +846,6 @@ static bool dax_fault_is_synchronous(con
 		(iter->iomap.flags & IOMAP_F_DIRTY);
 }
 
-static bool dax_fault_is_cow(const struct iomap_iter *iter)
-{
-	return (iter->flags & IOMAP_WRITE) &&
-		(iter->iomap.flags & IOMAP_F_SHARED);
-}
-
 /*
  * By this point grab_mapping_entry() has ensured that we have a locked entry
  * of the appropriate size so we don't have to worry about downgrading PMDs to
@@ -865,13 +859,14 @@ static void *dax_insert_entry(struct xa_
 {
 	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
 	void *new_entry = dax_make_entry(pfn, flags);
-	bool dirty = !dax_fault_is_synchronous(iter, vmf->vma);
-	bool cow = dax_fault_is_cow(iter);
+	bool write = iter->flags & IOMAP_WRITE;
+	bool dirty = write && !dax_fault_is_synchronous(iter, vmf->vma);
+	bool shared = iter->iomap.flags & IOMAP_F_SHARED;
 
 	if (dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
 
-	if (cow || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
+	if (shared || (dax_is_zero_entry(entry) && !(flags & DAX_ZERO_PAGE))) {
 		unsigned long index = xas->xa_index;
 		/* we are replacing a zero page with block mapping */
 		if (dax_is_pmd_entry(entry))
@@ -883,12 +878,12 @@ static void *dax_insert_entry(struct xa_
 
 	xas_reset(xas);
 	xas_lock_irq(xas);
-	if (cow || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
+	if (shared || dax_is_zero_entry(entry) || dax_is_empty_entry(entry)) {
 		void *old;
 
 		dax_disassociate_entry(entry, mapping, false);
 		dax_associate_entry(new_entry, mapping, vmf->vma, vmf->address,
-				cow);
+				shared);
 		/*
 		 * Only swap our new entry into the page cache if the current
 		 * entry is a zero page or an empty entry.  If a normal PTE or
@@ -908,7 +903,7 @@ static void *dax_insert_entry(struct xa_
 	if (dirty)
 		xas_set_mark(xas, PAGECACHE_TAG_DIRTY);
 
-	if (cow)
+	if (write && shared)
 		xas_set_mark(xas, PAGECACHE_TAG_TOWRITE);
 
 	xas_unlock_irq(xas);
--- a/fs/xfs/xfs_iomap.c~fsdaxxfs-set-the-shared-flag-when-file-extent-is-shared
+++ a/fs/xfs/xfs_iomap.c
@@ -1215,7 +1215,7 @@ xfs_read_iomap_begin(
 		return error;
 	error = xfs_bmapi_read(ip, offset_fsb, end_fsb - offset_fsb, &imap,
 			       &nimaps, 0);
-	if (!error && (flags & IOMAP_REPORT))
+	if (!error && ((flags & IOMAP_REPORT) || IS_DAX(inode)))
 		error = xfs_reflink_trim_around_shared(ip, &imap, &shared);
 	xfs_iunlock(ip, lockmode);
 
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are


