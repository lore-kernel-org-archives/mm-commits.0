From: akpm@linux-foundation.org
Subject: + file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds.patch added to -mm tree
Date: Fri, 11 Jul 2008 17:20:49 -0700
Message-ID: <200807120020.m6C0KnBx012130@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58107 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbYGLAVA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 11 Jul 2008 20:21:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: richard@rsk.demon.co.uk, bfields@fieldses.org


The patch titled
     file lock: reorder struct file_lock to save space on 64 bit builds
has been added to the -mm tree.  Its filename is
     file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds.patch

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
Subject: file lock: reorder struct file_lock to save space on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>

Reduce sizeof struct file_lock by 8 on 64 bit builds allowing +1 objects
per slab in the file_lock_cache

Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/fs.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/linux/fs.h~file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds include/linux/fs.h
--- a/include/linux/fs.h~file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds
+++ a/include/linux/fs.h
@@ -952,12 +952,12 @@ struct file_lock {
 	struct list_head fl_link;	/* doubly linked list of all locks */
 	struct list_head fl_block;	/* circular list of blocked processes */
 	fl_owner_t fl_owner;
+	unsigned char fl_flags;
+	unsigned char fl_type;
 	unsigned int fl_pid;
 	struct pid *fl_nspid;
 	wait_queue_head_t fl_wait;
 	struct file *fl_file;
-	unsigned char fl_flags;
-	unsigned char fl_type;
 	loff_t fl_start;
 	loff_t fl_end;
 
_

Patches currently in -mm which might be from richard@rsk.demon.co.uk are

linux-next.patch
shrink-struct-pid-by-removing-padding-on-64-bit-builds.patch
file-lock-reorder-struct-file_lock-to-save-space-on-64-bit-builds.patch

