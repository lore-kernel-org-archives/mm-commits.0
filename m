From: akpm@linux-foundation.org
Subject: + nilfs2-fix-data-loss-with-mmap.patch added to -mm tree
Date: Thu, 18 Sep 2014 12:17:14 -0700
Message-ID: <541b2fba.Gogd6xmXqm9IIUGP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40697 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbaIRTRP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Sep 2014 15:17:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp, stable@vger.kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: fix data loss with mmap()
has been added to the -mm tree.  Its filename is
     nilfs2-fix-data-loss-with-mmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-fix-data-loss-with-mmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-fix-data-loss-with-mmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andreas Rohner <andreas.rohner@gmx.net>
Subject: nilfs2: fix data loss with mmap()

This bug leads to reproducible silent data loss, despite the use of
msync(), sync() and a clean unmount of the file system.  It is easily
reproducible with the following script:

----------------[BEGIN SCRIPT]--------------------
mkfs.nilfs2 -f /dev/sdb
mount /dev/sdb /mnt

dd if=/dev/zero bs=1M count=30 of=/mnt/testfile

umount /mnt
mount /dev/sdb /mnt
CHECKSUM_BEFORE="$(md5sum /mnt/testfile)"

/root/mmaptest/mmaptest /mnt/testfile 30 10 5

sync
CHECKSUM_AFTER="$(md5sum /mnt/testfile)"
umount /mnt
mount /dev/sdb /mnt
CHECKSUM_AFTER_REMOUNT="$(md5sum /mnt/testfile)"
umount /mnt

echo "BEFORE MMAP:\t$CHECKSUM_BEFORE"
echo "AFTER MMAP:\t$CHECKSUM_AFTER"
echo "AFTER REMOUNT:\t$CHECKSUM_AFTER_REMOUNT"
----------------[END SCRIPT]--------------------

The mmaptest tool looks something like this (very simplified, with
error checking removed):

----------------[BEGIN mmaptest]--------------------
data = mmap(NULL, file_size - file_offset, PROT_READ | PROT_WRITE,
		MAP_SHARED, fd, file_offset);

for (i = 0; i < write_count; ++i) {
	memcpy(data + i * 4096, buf, sizeof(buf));
	msync(data, file_size - file_offset, MS_SYNC))
}
----------------[END mmaptest]--------------------

The output of the script looks something like this:

BEFORE MMAP:    281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile
AFTER MMAP:     6604a1c31f10780331a6850371b3a313  /mnt/testfile
AFTER REMOUNT:  281ed1d5ae50e8419f9b978aab16de83  /mnt/testfile

So it is clear, that the changes done using mmap() do not survive a
remount.  This can be reproduced a 100% of the time.  The problem was
introduced with 136e877 ("nilfs2: fix issue of nilfs_set_page_dirty() for
page at EOF boundary").

If the page was read with mpage_readpage() or mpage_readpages() for
example, then it has no buffers attached to it.  In that case
page_has_buffers(page) in nilfs_set_page_dirty() will be false.  Therefore
nilfs_set_file_dirty() is never called and the pages are never collected
and never written to disk.

This patch fixes the problem by also calling nilfs_set_file_dirty() if the
page has no buffers attached to it.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Tested-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN fs/nilfs2/inode.c~nilfs2-fix-data-loss-with-mmap fs/nilfs2/inode.c
--- a/fs/nilfs2/inode.c~nilfs2-fix-data-loss-with-mmap
+++ a/fs/nilfs2/inode.c
@@ -219,10 +219,10 @@ static int nilfs_writepage(struct page *
 
 static int nilfs_set_page_dirty(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
 	int ret = __set_page_dirty_nobuffers(page);
 
 	if (page_has_buffers(page)) {
-		struct inode *inode = page->mapping->host;
 		unsigned nr_dirty = 0;
 		struct buffer_head *bh, *head;
 
@@ -245,6 +245,10 @@ static int nilfs_set_page_dirty(struct p
 
 		if (nr_dirty)
 			nilfs_set_file_dirty(inode, nr_dirty);
+	} else if (ret) {
+		unsigned nr_dirty = 1 << (PAGE_SHIFT - inode->i_blkbits);
+
+		nilfs_set_file_dirty(inode, nr_dirty);
 	}
 	return ret;
 }
_

Patches currently in -mm which might be from andreas.rohner@gmx.net are

nilfs2-fix-data-loss-with-mmap.patch
nilfs2-fix-data-loss-with-mmap-fix.patch

