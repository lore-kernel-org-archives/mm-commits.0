From: akpm@linux-foundation.org
Subject: [patch 30/84] nilfs2: remove loops of single statement macros
Date: Mon, 23 May 2016 16:23:45 -0700
Message-ID: <57439101.la2XZhxmg2UJN4gO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42180 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXXq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: remove loops of single statement macros

This fixes checkpatch.pl warning "WARNING: Single statement macros
should not use a do {} while (0) loop".

Link: http://lkml.kernel.org/r/1462886671-3521-7-git-send-email-konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/the_nilfs.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/the_nilfs.h~nilfs2-remove-loops-of-single-statement-macros fs/nilfs2/the_nilfs.h
--- a/fs/nilfs2/the_nilfs.h~nilfs2-remove-loops-of-single-statement-macros
+++ a/fs/nilfs2/the_nilfs.h
@@ -222,15 +222,14 @@ THE_NILFS_FNS(SB_DIRTY, sb_dirty)
  * Mount option operations
  */
 #define nilfs_clear_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt &= ~NILFS_MOUNT_##opt)
 #define nilfs_set_opt(nilfs, opt)  \
-	do { (nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt; } while (0)
+	((nilfs)->ns_mount_opt |= NILFS_MOUNT_##opt)
 #define nilfs_test_opt(nilfs, opt) ((nilfs)->ns_mount_opt & NILFS_MOUNT_##opt)
 #define nilfs_write_opt(nilfs, mask, opt)				\
-	do { (nilfs)->ns_mount_opt =					\
+	((nilfs)->ns_mount_opt =					\
 		(((nilfs)->ns_mount_opt & ~NILFS_MOUNT_##mask) |	\
-		 NILFS_MOUNT_##opt);					\
-	} while (0)
+		 NILFS_MOUNT_##opt))					\
 
 /**
  * struct nilfs_root - nilfs root object
_
