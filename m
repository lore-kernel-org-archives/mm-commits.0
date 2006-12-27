From: akpm@osdl.org
Subject: + ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch added to -mm tree
Date: Tue, 26 Dec 2006 22:51:18 -0800
Message-ID: <200612270651.kBR6pItE003671@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:34177 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937AbWL0Gv1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Dec 2006 01:51:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sandeen@redhat.com


The patch titled
     ext2: skip pages past number of blocks in ext2_find_entry
has been added to the -mm tree.  Its filename is
     ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ext2: skip pages past number of blocks in ext2_find_entry
From: Eric Sandeen <sandeen@redhat.com>

This one was pointed out on the MOKB site:
http://kernelfun.blogspot.com/2006/11/mokb-09-11-2006-linux-26x-ext2checkpage.html

If a directory's i_size is corrupted, ext2_find_entry() will keep
processing pages until the i_size is reached, even if there are no more
blocks associated with the directory inode.  This patch puts in some
minimal sanity-checking so that we don't keep checking pages (and issuing
errors) if we know there can be no more data to read, based on the block
count of the directory inode.

This is somewhat similar in approach to the ext3 patch I sent earlier this
year.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/ext2/dir.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff -puN fs/ext2/dir.c~ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry fs/ext2/dir.c
--- a/fs/ext2/dir.c~ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry
+++ a/fs/ext2/dir.c
@@ -368,6 +368,14 @@ struct ext2_dir_entry_2 * ext2_find_entr
 		}
 		if (++n >= npages)
 			n = 0;
+		/* next page is past the blocks we've got */
+		if (unlikely(n > (dir->i_blocks >> (PAGE_CACHE_SHIFT - 9)))) {
+			ext2_error(dir->i_sb, __FUNCTION__,
+				"dir %lu size %lld exceeds block count %llu",
+				dir->i_ino, dir->i_size,
+				(unsigned long long)dir->i_blocks);
+				goto out;
+		}
 	} while (n != start);
 out:
 	return NULL;
_

Patches currently in -mm which might be from sandeen@redhat.com are

ext2-skip-pages-past-number-of-blocks-in-ext2_find_entry.patch

