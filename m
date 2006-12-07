From: akpm@osdl.org
Subject: - corrupted-cramfs-filesystems-cause-kernel-oops.patch removed from -mm tree
Date: Thu, 07 Dec 2006 15:04:17 -0800
Message-ID: <200612072304.kB7N4Hnb030032@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:52031 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163843AbWLGXEX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 7 Dec 2006 18:04:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: phillip@lougher.org.uk, mm-commits@vger.kernel.org


The patch titled
     corrupted cramfs filesystems cause kernel oops
has been removed from the -mm tree.  Its filename was
     corrupted-cramfs-filesystems-cause-kernel-oops.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: corrupted cramfs filesystems cause kernel oops
From: Phillip Lougher <phillip@lougher.org.uk>

Steve Grubb's fzfuzzer tool (http://people.redhat.com/sgrubb/files/
fsfuzzer-0.6.tar.gz) generates corrupt Cramfs filesystems which cause
Cramfs to kernel oops in cramfs_uncompress_block().  The cause of the oops
is an unchecked corrupted block length field read by cramfs_readpage().

This patch adds a sanity check to cramfs_readpage() which checks that the
block length field is sensible.  The (PAGE_CACHE_SIZE << 1) size check is
intentional, even though the uncompressed data is not going to be larger
than PAGE_CACHE_SIZE, gzip sometimes generates compressed data larger than
the original source data.  Mkcramfs checks that the compressed size is
always less than or equal to PAGE_CACHE_SIZE << 1.  Of course Cramfs could
use the original uncompressed data in this case, but it doesn't.

Signed-off-by: Phillip Lougher <phillip@lougher.org.uk>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/cramfs/inode.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN fs/cramfs/inode.c~corrupted-cramfs-filesystems-cause-kernel-oops fs/cramfs/inode.c
--- a/fs/cramfs/inode.c~corrupted-cramfs-filesystems-cause-kernel-oops
+++ a/fs/cramfs/inode.c
@@ -481,6 +481,8 @@ static int cramfs_readpage(struct file *
 		pgdata = kmap(page);
 		if (compr_len == 0)
 			; /* hole */
+		else if (compr_len > (PAGE_CACHE_SIZE << 1))
+			printk(KERN_ERR "cramfs: bad compressed blocksize %u\n", compr_len);
 		else {
 			mutex_lock(&read_mutex);
 			bytes_filled = cramfs_uncompress_block(pgdata,
_

Patches currently in -mm which might be from phillip@lougher.org.uk are

origin.patch

