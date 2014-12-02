From: akpm@linux-foundation.org
Subject: + nilfs2-avoid-duplicate-segment-construction-for-fsync.patch
 added to -mm tree
Date: Tue, 02 Dec 2014 14:08:16 -0800
Message-ID: <547e3850.IFf4gEd7hXZTtGOd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932980AbaLBWIR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 2 Dec 2014 17:08:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: andreas.rohner@gmx.net, konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: avoid duplicate segment construction for fsync()
has been added to the -mm tree.  Its filename is
     nilfs2-avoid-duplicate-segment-construction-for-fsync.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-avoid-duplicate-segment-construction-for-fsync.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-avoid-duplicate-segment-construction-for-fsync.patch

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
Subject: nilfs2: avoid duplicate segment construction for fsync()

This patch removes filemap_write_and_wait_range() from nilfs_sync_file(),
because it triggers a data segment construction by calling
nilfs_writepages() with WB_SYNC_ALL.  A data segment construction does not
remove the inode from the i_dirty list and it does not clear the
NILFS_I_DIRTY flag.  Therefore nilfs_inode_dirty() still returns true,
which leads to an unnecessary duplicate segment construction in
nilfs_sync_file().

A call to filemap_write_and_wait_range() is not needed, because NILFS2
does not rely on the generic writeback mechanisms.  Instead it implements
its own mechanism to collect all dirty pages and write them into segments.
 It is more efficient to initiate the segment construction directly in
nilfs_sync_file() without the detour over filemap_write_and_wait_range().

Additionally the lock of i_mutex is not needed, because all code blocks
that are protected by i_mutex are also protected by a NILFS transaction:

Function                i_mutex     nilfs_transaction
------------------------------------------------------
nilfs_ioctl_setflags:   yes         yes
nilfs_fiemap:           yes         no
nilfs_write_begin:      yes         yes
nilfs_write_end:        yes         yes
nilfs_lookup:           yes         no
nilfs_create:           yes         yes
nilfs_link:             yes         yes
nilfs_mknod:            yes         yes
nilfs_symlink:          yes         yes
nilfs_mkdir:            yes         yes
nilfs_unlink:           yes         yes
nilfs_rmdir:            yes         yes
nilfs_rename:           yes         yes
nilfs_setattr:          yes         yes

For nilfs_lookup() i_mutex is held for the parent directory, to protect it
from modification.  The segment construction does not modify directory
inodes, so no lock is needed.

nilfs_fiemap() reads the block layout on the disk, by using
nilfs_bmap_lookup_contig(). This is already protected by bmap->b_sem.

Signed-off-by: Andreas Rohner <andreas.rohner@gmx.net>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/file.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff -puN fs/nilfs2/file.c~nilfs2-avoid-duplicate-segment-construction-for-fsync fs/nilfs2/file.c
--- a/fs/nilfs2/file.c~nilfs2-avoid-duplicate-segment-construction-for-fsync
+++ a/fs/nilfs2/file.c
@@ -39,21 +39,15 @@ int nilfs_sync_file(struct file *file, l
 	 */
 	struct the_nilfs *nilfs;
 	struct inode *inode = file->f_mapping->host;
-	int err;
