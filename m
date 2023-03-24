Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6F32C6FD1C
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 19:43:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCXTna (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:43:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjCXTn3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 15:43:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8294459D5
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 12:43:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2705D62C86
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 19:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8214BC4339B;
        Fri, 24 Mar 2023 19:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679687007;
        bh=fjVI8RyOKEWzgwSeo9DDyM/FABWiAawEfjhZ1tJ7GQI=;
        h=Date:To:From:Subject:From;
        b=tRQMdStMaxU4Y9CG5jsFOW6I4/Gl4zRDWIleiFGgdmirvioWdMcHLDFhP+k/UVbCP
         d4JAhL35WKhJgNl/C5gu5qr0Y0QO0IEBvxGpNNGZamsmoSPfz2uP92RhBxc92DTG+H
         ZYKgdMhr9R1Z+fqd6nG0O18i9XSGzYJCsxoSfzRg=
Date:   Fri, 24 Mar 2023 12:43:26 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org, jack@suse.cz,
        djwong@kernel.org, dan.j.williams@intel.com,
        ruansy.fnst@fujitsu.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fsdax-force-clear-dirty-mark-if-cow.patch added to mm-hotfixes-unstable branch
Message-Id: <20230324194327.8214BC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fsdax: force clear dirty mark if CoW
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fsdax-force-clear-dirty-mark-if-cow.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fsdax-force-clear-dirty-mark-if-cow.patch

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
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Subject: fsdax: force clear dirty mark if CoW
Date: Fri, 24 Mar 2023 10:28:00 +0000

XFS allows CoW on non-shared extents to combat fragmentation[1].  The old
non-shared extent could be mwrited before, its dax entry is marked dirty. 
To be able to delete this entry, clear its dirty mark before
invalidate_inode_pages2_range().

[1] https://lore.kernel.org/linux-xfs/20230321151339.GA11376@frogsfrogsfrogs/

Link: https://lkml.kernel.org/r/1679653680-2-1-git-send-email-ruansy.fnst@fujitsu.com
Signed-off-by: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

--- a/fs/dax.c~fsdax-force-clear-dirty-mark-if-cow
+++ a/fs/dax.c
@@ -781,6 +781,33 @@ out:
 	return ret;
 }
 
+static int __dax_clear_dirty_range(struct address_space *mapping,
+		pgoff_t start, pgoff_t end)
+{
+	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int scanned = 0;
+	void *entry;
+
+	xas_lock_irq(&xas);
+	xas_for_each(&xas, entry, end) {
+		entry = get_unlocked_entry(&xas, 0);
+		xas_clear_mark(&xas, PAGECACHE_TAG_DIRTY);
+		xas_clear_mark(&xas, PAGECACHE_TAG_TOWRITE);
+		put_unlocked_entry(&xas, entry, WAKE_NEXT);
+
+		if (++scanned % XA_CHECK_SCHED)
+			continue;
+
+		xas_pause(&xas);
+		xas_unlock_irq(&xas);
+		cond_resched();
+		xas_lock_irq(&xas);
+	}
+	xas_unlock_irq(&xas);
+
+	return 0;
+}
+
 /*
  * Delete DAX entry at @index from @mapping.  Wait for it
  * to be unlocked before deleting it.
@@ -1440,6 +1467,16 @@ static loff_t dax_iomap_iter(const struc
 	 * written by write(2) is visible in mmap.
 	 */
 	if (iomap->flags & IOMAP_F_NEW || cow) {
+		/*
+		 * Filesystem allows CoW on non-shared extents. The src extents
+		 * may have been mmapped with dirty mark before. To be able to
+		 * invalidate its dax entries, we need to clear the dirty mark
+		 * in advance.
+		 */
+		if (cow)
+			__dax_clear_dirty_range(iomi->inode->i_mapping,
+						pos >> PAGE_SHIFT,
+						(end - 1) >> PAGE_SHIFT);
 		invalidate_inode_pages2_range(iomi->inode->i_mapping,
 					      pos >> PAGE_SHIFT,
 					      (end - 1) >> PAGE_SHIFT);
_

Patches currently in -mm which might be from ruansy.fnst@fujitsu.com are

fsdax-unshare-zero-destination-if-srcmap-is-hole-or-unwritten.patch
fsdax-dedupe-should-compare-the-min-of-two-iters-length.patch
fsdax-force-clear-dirty-mark-if-cow.patch

