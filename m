Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB80820C321;
	Wed,  6 Nov 2024 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730925238; cv=none; b=CDI0zr+PuSVmvy6f4TEROnulUOHIDWwmZ9/7bicTHVK9mh3X6KMMp6o99NSW856uPYgDzy5BBtyWuVWyw3twvSqwKKx0A5OIrrhpdaX3L3n0idEBxYkwnGJVtQKVysxt0Brix8rPACweGdfcYWFVotj+QdNiTcXFnt0qjiHwBrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730925238; c=relaxed/simple;
	bh=wS72UGPkFSidBhzEYvwy1SNy5R8GRQG2aMCfLzn04Iw=;
	h=Date:To:From:Subject:Message-Id; b=CKkrhQdTiXrvA7dohP3W6MbcyoDDGPkGaKxR0I2KvqPooXtPIWweEv6LBMNfZekXbTiweQGQ7T4XuSJIPkzlCBoDO1j/6dsAaZ82ylE4NlY6RzTbpb6z16gnRjm7+PkTcwJliOVhMtNjTkWZdJUnv4yuXzMMeICfAPFefnq+i3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Y8E62Ru6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Y8E62Ru6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA0BC4CED4;
	Wed,  6 Nov 2024 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1730925237;
	bh=wS72UGPkFSidBhzEYvwy1SNy5R8GRQG2aMCfLzn04Iw=;
	h=Date:To:From:Subject:From;
	b=Y8E62Ru69JfVrj2hxOfxvbYarnfBP7QgysXqTZbmL4b9LNqoSk9d3XyuH7tTPOi1s
	 aLfPh5tLjJg8D1Lm7GFezBt5DbVujNZ4jdLizuKCAkkDvfReitxWG4VfDNkERdkLht
	 OcftPnZ/H3qpyYrI4ssKH4cvU+NLl3E7BqXdwNws=
Date: Wed, 06 Nov 2024 12:33:56 -0800
To: mm-commits@vger.kernel.org,tj@kernel.org,stable@vger.kernel.org,bugreport@valiantsec.com,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint.patch added to mm-hotfixes-unstable branch
Message-Id: <20241106203357.4AA0BC4CED4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint.patch

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
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint
Date: Thu, 7 Nov 2024 01:07:33 +0900

When using the "block:block_dirty_buffer" tracepoint, mark_buffer_dirty()
may cause a NULL pointer dereference, or a general protection fault when
KASAN is enabled.

This happens because, since the tracepoint was added in
mark_buffer_dirty(), it references the dev_t member bh->b_bdev->bd_dev
regardless of whether the buffer head has a pointer to a block_device
structure.

In the current implementation, nilfs_grab_buffer(), which grabs a buffer
to read (or create) a block of metadata, including b-tree node blocks,
does not set the block device, but instead does so only if the buffer is
not in the "uptodate" state for each of its caller block reading
functions.  However, if the uptodate flag is set on a folio/page, and the
buffer heads are detached from it by try_to_free_buffers(), and new buffer
heads are then attached by create_empty_buffers(), the uptodate flag may
be restored to each buffer without the block device being set to
bh->b_bdev, and mark_buffer_dirty() may be called later in that state,
resulting in the bug mentioned above.

Fix this issue by making nilfs_grab_buffer() always set the block device
of the super block structure to the buffer head, regardless of the state
of the buffer's uptodate flag.

Link: https://lkml.kernel.org/r/20241106160811.3316-3-konishi.ryusuke@gmail.com
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ubisectech Sirius <bugreport@valiantsec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btnode.c  |    2 --
 fs/nilfs2/gcinode.c |    4 +---
 fs/nilfs2/mdt.c     |    1 -
 fs/nilfs2/page.c    |    1 +
 4 files changed, 2 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/btnode.c~nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint
+++ a/fs/nilfs2/btnode.c
@@ -68,7 +68,6 @@ nilfs_btnode_create_block(struct address
 		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = blocknr;
 	set_buffer_mapped(bh);
 	set_buffer_uptodate(bh);
@@ -133,7 +132,6 @@ int nilfs_btnode_submit_block(struct add
 		goto found;
 	}
 	set_buffer_mapped(bh);
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
--- a/fs/nilfs2/gcinode.c~nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint
+++ a/fs/nilfs2/gcinode.c
@@ -83,10 +83,8 @@ int nilfs_gccache_submit_read_data(struc
 		goto out;
 	}
 
-	if (!buffer_mapped(bh)) {
-		bh->b_bdev = inode->i_sb->s_bdev;
+	if (!buffer_mapped(bh))
 		set_buffer_mapped(bh);
-	}
 	bh->b_blocknr = pbn;
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
--- a/fs/nilfs2/mdt.c~nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint
+++ a/fs/nilfs2/mdt.c
@@ -89,7 +89,6 @@ static int nilfs_mdt_create_block(struct
 	if (buffer_uptodate(bh))
 		goto failed_bh;
 
-	bh->b_bdev = sb->s_bdev;
 	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
 	if (likely(!err)) {
 		get_bh(bh);
--- a/fs/nilfs2/page.c~nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint
+++ a/fs/nilfs2/page.c
@@ -63,6 +63,7 @@ struct buffer_head *nilfs_grab_buffer(st
 		folio_put(folio);
 		return NULL;
 	}
+	bh->b_bdev = inode->i_sb->s_bdev;
 	return bh;
 }
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-fix-null-ptr-deref-in-block_touch_buffer-tracepoint.patch
nilfs2-fix-null-ptr-deref-in-block_dirty_buffer-tracepoint.patch

