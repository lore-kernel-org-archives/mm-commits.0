From: akpm@linux-foundation.org
Subject: + fs-inodec-properly-init-address_space-writeback_index.patch added to -mm tree
Date: Thu, 14 Aug 2008 12:07:11 -0700
Message-ID: <200808141907.m7EJ7BSR024460@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51881 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYHNTIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 14 Aug 2008 15:08:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: chris.mason@oracle.com


The patch titled
     fs/inode.c: properly init address_space->writeback_index
has been added to the -mm tree.  Its filename is
     fs-inodec-properly-init-address_space-writeback_index.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/inode.c: properly init address_space->writeback_index
From: Chris Mason <chris.mason@oracle.com>

write_cache_pages() uses i_mapping->writeback_index to pick up where it
left off the last time a given inode was found by pdflush or
balance_dirty_pages (or anyone else who sets wbc->range_cyclic)

alloc_inode() should set it to a sane value so that writeback doesn't
start in the middle of a file.  It is somewhat difficult to notice the bug
since write_cache_pages will loop around to the start of the file and the
elevator helps hide the resulting seeks.

For whatever reason, Btrfs hits this often.  Unpatched, untarring 30
copies of the linux kernel in series runs at 47MB/s on a single sata
drive.  With this fix, it jumps to 62MB/s.

Signed-off-by: Chris Mason <chris.mason@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/inode.c~fs-inodec-properly-init-address_space-writeback_index fs/inode.c
--- a/fs/inode.c~fs-inodec-properly-init-address_space-writeback_index
+++ a/fs/inode.c
@@ -166,6 +166,7 @@ static struct inode *alloc_inode(struct 
 		mapping_set_gfp_mask(mapping, GFP_HIGHUSER_PAGECACHE);
 		mapping->assoc_mapping = NULL;
 		mapping->backing_dev_info = &default_backing_dev_info;
+		mapping->writeback_index = 0;
 
 		/*
 		 * If the block_device provides a backing_dev_info for client
_

Patches currently in -mm which might be from chris.mason@oracle.com are

fs-inodec-properly-init-address_space-writeback_index.patch

