From: akpm@linux-foundation.org
Subject: + ramfs-enable-splice-write.patch added to -mm tree
Date: Tue, 24 Jun 2008 15:51:07 -0700
Message-ID: <200806242251.m5OMp7nJ010291@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52719 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754515AbYFXWvu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Jun 2008 18:51:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: opurdila@ixiacom.com, jens.axboe@oracle.com


The patch titled
     ramfs: enable splice write
has been added to the -mm tree.  Its filename is
     ramfs-enable-splice-write.patch

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
Subject: ramfs: enable splice write
From: Octavian Purdila <opurdila@ixiacom.com>

Signed-off-by: Octavian Purdila <opurdila@ixiacom.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ramfs/file-mmu.c   |    1 +
 fs/ramfs/file-nommu.c |    1 +
 2 files changed, 2 insertions(+)

diff -puN fs/ramfs/file-mmu.c~ramfs-enable-splice-write fs/ramfs/file-mmu.c
--- a/fs/ramfs/file-mmu.c~ramfs-enable-splice-write
+++ a/fs/ramfs/file-mmu.c
@@ -45,6 +45,7 @@ const struct file_operations ramfs_file_
 	.mmap		= generic_file_mmap,
 	.fsync		= simple_sync_file,
 	.splice_read	= generic_file_splice_read,
+	.splice_write	= generic_file_splice_write,
 	.llseek		= generic_file_llseek,
 };
 
diff -puN fs/ramfs/file-nommu.c~ramfs-enable-splice-write fs/ramfs/file-nommu.c
--- a/fs/ramfs/file-nommu.c~ramfs-enable-splice-write
+++ a/fs/ramfs/file-nommu.c
@@ -43,6 +43,7 @@ const struct file_operations ramfs_file_
 	.aio_write		= generic_file_aio_write,
 	.fsync			= simple_sync_file,
 	.splice_read		= generic_file_splice_read,
+	.splice_write		= generic_file_splice_write,
 	.llseek			= generic_file_llseek,
 };
 
_

Patches currently in -mm which might be from opurdila@ixiacom.com are

ramfs-enable-splice-write.patch

