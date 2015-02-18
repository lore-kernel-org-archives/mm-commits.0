From: akpm@linux-foundation.org
Subject: [merged] fs-affs-filec-fix-direct-io-writes-beyond-eof.patch
 removed from -mm tree
Date: Wed, 18 Feb 2015 11:43:30 -0800
Message-ID: <54e4eb62.NTH3qNBMIk90esM+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46082 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbbBRTnb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 18 Feb 2015 14:43:31 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fabf@skynet.be, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     Subject: fs/affs/file.c: fix direct IO writes beyond EOF
has been removed from the -mm tree.  Its filename was
     fs-affs-filec-fix-direct-io-writes-beyond-eof.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Fabian Frederick <fabf@skynet.be>
Subject: fs/affs/file.c: fix direct IO writes beyond EOF

Use the same fallback to normal IO in case of write
operations beyond EOF as fat direct IO. This patch fixes

fsx file -d -Z -r 4096 -w 4096

Report:
129(129 mod 256): TRUNCATE DOWN from 0x3ff01 to 0xb3f6
130(130 mod 256): WRITE    0x22000 thru 0x2dfff (0xc000 bytes) HOLE

Thanks to Jan for helping me on this problem.

The ideal solution suggested by Jan Kara would be to use
cont_write_begin() but affs direct_IO shouldn't be used a lot anyway...

Signed-off-by: Fabian Frederick <fabf@skynet.be>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/affs/file.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN fs/affs/file.c~fs-affs-filec-fix-direct-io-writes-beyond-eof fs/affs/file.c
--- a/fs/affs/file.c~fs-affs-filec-fix-direct-io-writes-beyond-eof
+++ a/fs/affs/file.c
@@ -398,6 +398,13 @@ affs_direct_IO(int rw, struct kiocb *ioc
 	size_t count = iov_iter_count(iter);
 	ssize_t ret;
 
+	if (rw == WRITE) {
+		loff_t size = offset + count;
+
+		if (AFFS_I(inode)->mmu_private < size)
+			return 0;
+	}
+
 	ret = blockdev_direct_IO(rw, iocb, inode, iter, offset, affs_get_block);
 	if (ret < 0 && (rw & WRITE))
 		affs_write_failed(mapping, offset + count);
_

Patches currently in -mm which might be from fabf@skynet.be are

origin.patch
fs-ext4-fsyncc-generic_file_fsync-call-based-on-barrier-flag.patch

