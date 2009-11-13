From: akpm@linux-foundation.org
Subject: [merged] __generic_block_fiemap-fix-for-files-bigger-than-4gb.patch removed from -mm tree
Date: Fri, 13 Nov 2009 11:27:32 -0800
Message-ID: <200911131927.nADJRWqk030881@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757216AbZKMT2I (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Nov 2009 14:28:08 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mh@glandium.org, jbacik@redhat.com, mfasheh@suse.com, sandeen@sgi.com, swhiteho@redhat.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     __generic_block_fiemap(): fix for files bigger than 4GB
has been removed from the -mm tree.  Its filename was
     __generic_block_fiemap-fix-for-files-bigger-than-4gb.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: __generic_block_fiemap(): fix for files bigger than 4GB
From: Mike Hommey <mh@glandium.org>

Because of an integer overflow on start_blk, various kind of wrong results
would be returned by the generic_block_fiemap() handler, such as no
extents when there is a 4GB+ hole at the beginning of the file, or wrong
fe_logical when an extent starts after the first 4GB.

Signed-off-by: Mike Hommey <mh@glandium.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@sgi.com>
Cc: Josef Bacik <jbacik@redhat.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN fs/ioctl.c~__generic_block_fiemap-fix-for-files-bigger-than-4gb fs/ioctl.c
--- a/fs/ioctl.c~__generic_block_fiemap-fix-for-files-bigger-than-4gb
+++ a/fs/ioctl.c
@@ -254,7 +254,7 @@ int __generic_block_fiemap(struct inode 
 			   u64 len, get_block_t *get_block)
 {
 	struct buffer_head tmp;
-	unsigned int start_blk;
+	unsigned long long start_blk;
 	long long length = 0, map_len = 0;
 	u64 logical = 0, phys = 0, size = 0;
 	u32 flags = FIEMAP_EXTENT_MERGED;
_

Patches currently in -mm which might be from mh@glandium.org are


