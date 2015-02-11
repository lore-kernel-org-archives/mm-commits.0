From: akpm@linux-foundation.org
Subject: [merged] fs-make-generic_block_fiemap-sig-tolerant.patch removed
 from -mm tree
Date: Wed, 11 Feb 2015 12:21:32 -0800
Message-ID: <54dbb9cc.+YAO+994K+x2Lhfg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40869 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbbBKUVd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Feb 2015 15:21:33 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dmonakhov@openvz.org, mtk.manpages@gmail.com, tytso@mit.edu, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: fsioctl.c: make generic_block_fiemap() signal-tolerant
has been removed from the -mm tree.  Its filename was
     fs-make-generic_block_fiemap-sig-tolerant.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dmitry Monakhov <dmonakhov@openvz.org>
Subject: fsioctl.c: make generic_block_fiemap() signal-tolerant

__generic_block_fiemap may spin very long time for large sparse files.

Without this patch an unprivileged user may abuse system resources simply
by spawning a vast number of unkilable busyloops (works on ext2/ext3):

truncate --size 1T test
for ((i=0;i<1024;i++))
do
       filefrag test > /dev/null &
done

Signed-off-by: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/filesystems/fiemap.txt |    3 ++-
 fs/ioctl.c                           |    5 +++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff -puN Documentation/filesystems/fiemap.txt~fs-make-generic_block_fiemap-sig-tolerant Documentation/filesystems/fiemap.txt
--- a/Documentation/filesystems/fiemap.txt~fs-make-generic_block_fiemap-sig-tolerant
+++ a/Documentation/filesystems/fiemap.txt
@@ -196,7 +196,8 @@ struct fiemap_extent_info {
 };
 
 It is intended that the file system should not need to access any of this
-structure directly.
+structure directly. Filesystem handlers should be tolerant to signals and return
+EINTR once fatal signal received.
 
 
 Flag checking should be done at the beginning of the ->fiemap callback via the
diff -puN fs/ioctl.c~fs-make-generic_block_fiemap-sig-tolerant fs/ioctl.c
--- a/fs/ioctl.c~fs-make-generic_block_fiemap-sig-tolerant
+++ a/fs/ioctl.c
@@ -379,6 +379,11 @@ int __generic_block_fiemap(struct inode
 				past_eof = true;
 		}
 		cond_resched();
+		if (fatal_signal_pending(current)) {
+			ret = -EINTR;
+			break;
+		}
+
 	} while (1);
 
 	/* If ret is 1 then we just hit the end of the extent array */
_

Patches currently in -mm which might be from dmonakhov@openvz.org are

origin.patch
linux-next.patch

