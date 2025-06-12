Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D41153BD9
	for <mm-commits@vger.kernel.org>; Thu, 12 Jun 2025 22:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749769145; cv=none; b=dEUZtMtHjKw5Qr3yUhbnHx1OWL9Spe0jR+MfEbCoInBfRCxa/2F6DAOZb8lkp28uHvW+rFszPsTM9lcbgu+f2Li0cbEE8nKLJur1I8yb7lnguiEIgLw8Bv85tgbe0774MbMPK8WprGSxjvTfPYAJ21wLmJLyhIL6nV4RY5WWtIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749769145; c=relaxed/simple;
	bh=RaW5J1eudUKxhU18sMqejNCwJdzPleZr84P4Ggiya7s=;
	h=Date:To:From:Subject:Message-Id; b=n19hqmtV20/5Roophn2xtA9rLB/G+5pRUkgIiUavw6I3rlifxfq/1j89j9fj/bHEJJBWYpD95dmHD/idpdxGFIg2aanZlZc/j+e9eOI0dPtpjEmwuDZga6Djv6XA2/XNcQi9WvdAC1GqSQFMQ3unLBOyCH93cVH07BcpApMfWEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LSCn8BEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LSCn8BEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BEA8C4CEEA;
	Thu, 12 Jun 2025 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749769144;
	bh=RaW5J1eudUKxhU18sMqejNCwJdzPleZr84P4Ggiya7s=;
	h=Date:To:From:Subject:From;
	b=LSCn8BEXbKzUBsUYshP73ATTaKFLR2mDG0SE1x9CgUBp2FSN12HFBzYT+P1DFYhpz
	 pcplBt/D4Y6ytkIuXg6ZBgCkGtQbIg1fPoTpjbgGenh/g8TRCIJA+mzSAlzHBQYgSQ
	 ZniWhWaZaSO4cE8KXzDlW6nB/uDXzvIdGXL/7gPE=
Date: Thu, 12 Jun 2025 15:59:03 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,willy@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch added to mm-nonmm-unstable branch
Message-Id: <20250612225904.9BEA8C4CEEA@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: pass the inode to squashfs_readahead_fragment()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
Subject: squashfs: pass the inode to squashfs_readahead_fragment()
Date: Thu, 12 Jun 2025 15:39:00 +0100

Patch series "squashfs: Remove page->mapping references".

We're close to being able to kill page->mapping.  These two patches get us
a little bit closer.


Eliminate a reference to page->mapping by passing the inode from the
caller.

Link: https://lkml.kernel.org/r/20250612143903.2849289-1-willy@infradead.org
Link: https://lkml.kernel.org/r/20250612143903.2849289-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/file.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/fs/squashfs/file.c~squashfs-pass-the-inode-to-squashfs_readahead_fragment
+++ a/fs/squashfs/file.c
@@ -493,10 +493,9 @@ out:
 	return res;
 }
 
-static int squashfs_readahead_fragment(struct page **page,
+static int squashfs_readahead_fragment(struct inode *inode, struct page **page,
 	unsigned int pages, unsigned int expected, loff_t start)
 {
-	struct inode *inode = page[0]->mapping->host;
 	struct squashfs_cache_entry *buffer = squashfs_get_fragment(inode->i_sb,
 		squashfs_i(inode)->fragment_block,
 		squashfs_i(inode)->fragment_size);
@@ -605,8 +604,8 @@ static void squashfs_readahead(struct re
 
 		if (start >> msblk->block_log == file_end &&
 				squashfs_i(inode)->fragment_block != SQUASHFS_INVALID_BLK) {
-			res = squashfs_readahead_fragment(pages, nr_pages,
-							  expected, start);
+			res = squashfs_readahead_fragment(inode, pages,
+					nr_pages, expected, start);
 			if (res)
 				goto skip_pages;
 			continue;
_

Patches currently in -mm which might be from willy@infradead.org are

mm-restore-documentation-for-__free_pages.patch
squashfs-pass-the-inode-to-squashfs_readahead_fragment.patch
squashfs-use-folios-in-squashfs_bio_read_cached.patch

