From: akpm@linux-foundation.org
Subject: [merged] nilfs2-remove-loops-of-single-statement-macros.patch
 removed from -mm tree
Date: Fri, 27 May 2016 11:43:12 -0700
Message-ID: <57489540.N54IXDr+wGrVnymr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42470 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783AbcE0SnN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 27 May 2016 14:43:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: konishi.ryusuke@lab.ntt.co.jp, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: remove loops of single statement macros
has been removed from the -mm tree.  Its filename was
     nilfs2-remove-loops-of-single-statement-macros.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from konishi.ryusuke@lab.ntt.co.jp are


