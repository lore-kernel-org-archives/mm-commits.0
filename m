From: akpm@linux-foundation.org
Subject: [merged] fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch removed from -mm tree
Date: Thu, 21 Jul 2011 12:12:20 -0700
Message-ID: <201107211912.p6LJCDfr032233@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753189Ab1GUTMS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 21 Jul 2011 15:12:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, gregkh@suse.de, mm-commits@vger.kernel.org


The patch titled
     fs/libfs.c: fix simple_attr_write() on 32bit machines
has been removed from the -mm tree.  Its filename was
     fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/libfs.c: fix simple_attr_write() on 32bit machines
From: Akinobu Mita <akinobu.mita@gmail.com>

Assume that /sys/kernel/debug/dummy64 is debugfs file created by
debugfs_create_x64().

	# cd /sys/kernel/debug
	# echo 0x1234567812345678 > dummy64
	# cat dummy64
	0x0000000012345678

	# echo 0x80000000 > dummy64
	# cat dummy64
	0xffffffff80000000

A value larger than INT_MAX cannot be written to the debugfs file created
by debugfs_create_u64 or debugfs_create_x64 on 32bit machine.  Because
simple_attr_write() uses simple_strtol() for the conversion.

To fix this, use simple_strtoll() instead.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/libfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/libfs.c~fs-libfsc-fix-simple_attr_write-on-32bit-machines fs/libfs.c
--- a/fs/libfs.c~fs-libfsc-fix-simple_attr_write-on-32bit-machines
+++ a/fs/libfs.c
@@ -822,7 +822,7 @@ ssize_t simple_attr_write(struct file *f
 		goto out;
 
 	attr->set_buf[size] = '\0';
-	val = simple_strtol(attr->set_buf, NULL, 0);
+	val = simple_strtoll(attr->set_buf, NULL, 0);
 	ret = attr->set(attr->data, val);
 	if (ret == 0)
 		ret = len; /* on success, claim we got the whole input */
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

origin.patch
linux-next.patch
ext4-use-proper-little-endian-bitops.patch
ocfs2-avoid-unaligned-access-to-dqc_bitmap.patch
reiserfs-use-proper-little-endian-bitops.patch
reiserfs-use-hweight_long.patch
fault-injection-do-not-include-unneeded-header.patch
fault-injection-remove-nonexistent-function-extern.patch
fault-injection-cleanup-simple-attribute-of-stacktrace_depth.patch
fault-injection-use-debugfs_remove_recursive.patch
failslab-simplify-debugfs-initialization.patch
fail_page_alloc-simplify-debugfs-initialization.patch
fail_make_request-cleanup-should_fail_request.patch
asm-generic-add-another-generic-ext2-atomic-bitops.patch

