From: akpm@linux-foundation.org
Subject: [merged] ext4-online-defrag-not-supported-with-dax.patch removed
 from -mm tree
Date: Mon, 29 Feb 2016 12:24:54 -0800
Message-ID: <56d4a916.3eppX6rOfpzB54Z4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40787 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754444AbcB2UYz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 29 Feb 2016 15:24:55 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, axboe@fb.com, dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz, matthew.r.wilcox@intel.com, tytso@mit.edu, viro@ftp.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: ext4: online defrag not supported with DAX
has been removed from the -mm tree.  Its filename was
     ext4-online-defrag-not-supported-with-dax.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: ext4: online defrag not supported with DAX

Online defrag operations for ext4 are hard coded to use the page cache. 
See ext4_ioctl() -> ext4_move_extents() -> move_extent_per_page()

When combined with DAX I/O, which circumvents the page cache, this can
result in data corruption.  This was observed with xfstests ext4/307 and
ext4/308.

Fix this by only allowing online defrag for non-DAX files.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Al Viro <viro@ftp.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jens Axboe <axboe@fb.com>
Cc: Matthew Wilcox <matthew.r.wilcox@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext4/ioctl.c |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN fs/ext4/ioctl.c~ext4-online-defrag-not-supported-with-dax fs/ext4/ioctl.c
--- a/fs/ext4/ioctl.c~ext4-online-defrag-not-supported-with-dax
+++ a/fs/ext4/ioctl.c
@@ -583,6 +583,11 @@ group_extend_out:
 				 "Online defrag not supported with bigalloc");
 			err = -EOPNOTSUPP;
 			goto mext_out;
+		} else if (IS_DAX(inode)) {
+			ext4_msg(sb, KERN_ERR,
+				 "Online defrag not supported with DAX");
+			err = -EOPNOTSUPP;
+			goto mext_out;
 		}
 
 		err = mnt_want_write_file(filp);
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are


