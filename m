From: akpm@linux-foundation.org
Subject: + fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch added to -mm tree
Date: Tue, 12 Jul 2011 15:24:58 -0700
Message-ID: <201107122224.p6CMOwoe007343@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52609 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756072Ab1GLWZF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 12 Jul 2011 18:25:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com, gregkh@suse.de


The patch titled
     fs/libfs.c: fix simple_attr_write() on 32bit machines
has been added to the -mm tree.  Its filename is
     fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

fs-libfsc-fix-simple_attr_write-on-32bit-machines.patch
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

