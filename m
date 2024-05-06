Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B80B2F50A
	for <mm-commits@vger.kernel.org>; Mon,  6 May 2024 01:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714957865; cv=none; b=aC8U+AWu4iyLAd0/L6BY/PvcSGwhcTOfYderkFnNyltslqJSNuoJBbNPjyF2XdkpPiYskuz6zHDlcoi0TDAjUk4kGd5yrHgtOIWvHU7XyF2F2c/Wm6LziDA7eRMNU7KQ9UTglgURzqza4IzabjdVP4DmwPJF0stZ0F3A1OwOtag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714957865; c=relaxed/simple;
	bh=HcaKZlypffWE1Tn8RTKFp0mu2DCB3we7+BrjelOsE6I=;
	h=Date:To:From:Subject:Message-Id; b=NEM+SrUpeOGQrfFBwVx0gOr4xQgHcZtjEkEFnh9t7o4LE6hocbIxveKWq0TorTfYDRa/oFrFJkhNo4nU8jUu3Vuvo6anstOdNxx4xeMuHLhRZNhKQImAdar64r9iwOuuoZNTFrn8CbxwyQ9pfUxkPJr4OfTaW+ElRHkINCRN3mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Emn+msB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Emn+msB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1150C113CC;
	Mon,  6 May 2024 01:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714957864;
	bh=HcaKZlypffWE1Tn8RTKFp0mu2DCB3we7+BrjelOsE6I=;
	h=Date:To:From:Subject:From;
	b=Emn+msB6+YbVGf1+O27oPrKJJiLwxNqEu5Y8OCDN8vR2EfiJfvSnM5W5HIb6VU0ew
	 TOMKwLJM+tXuz7YLCnQtZ+m+HW+UWN3fn0Oy74bRxPVIL9dyMZVNlhF0czHuTCcton
	 81HCIE+n22xAnKlhOGX2R5WbPmOm/7+ZlwuRiDCE=
Date: Sun, 05 May 2024 18:11:03 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,sandeen@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] nilfs2-convert-to-use-the-new-mount-api-v2.patch removed from -mm tree
Message-Id: <20240506011104.B1150C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2-convert-to-use-the-new-mount-api-v2
has been removed from the -mm tree.  Its filename was
     nilfs2-convert-to-use-the-new-mount-api-v2.patch

This patch was dropped because it was folded into nilfs2-convert-to-use-the-new-mount-api.patch

------------------------------------------------------
From: Eric Sandeen <sandeen@redhat.com>
Subject: nilfs2-convert-to-use-the-new-mount-api-v2
Date: Fri, 26 Apr 2024 04:05:26 +0900

- fix UAF read for fc->root in put_fs_context() when call to
  nilfs_reconfigure() from nilfs_get_tree() fails.
- fix reference to uninitialized variable 's' in nilfs_get_tree().
- fix duplicate inclusion of fs_context.h.
- reflect function argument changes to kernel-doc comments.

[konishi.ryusuke: fixed missing SB_RDONLY flag repair, UAF read for
 fc->root on error, reference to uninitialized variable, duplicate header
 inclusion, and missing update of kernel-doc comments]
Link: https://lkml.kernel.org/r/33d078a7-9072-4d8e-a3a9-dec23d4191da@redhat.com
Link: https://lkml.kernel.org/r/20240425190526.10905-1-konishi.ryusuke@gmail.com
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/super.c     |   24 +++++++++++++++---------
 fs/nilfs2/the_nilfs.c |    1 -
 2 files changed, 15 insertions(+), 10 deletions(-)

--- a/fs/nilfs2/super.c~nilfs2-convert-to-use-the-new-mount-api-v2
+++ a/fs/nilfs2/super.c
@@ -29,14 +29,13 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
-#include <linux/fs_context.h>
-#include <linux/fs_parser.h>
 #include <linux/crc32.h>
 #include <linux/vfs.h>
 #include <linux/writeback.h>
 #include <linux/seq_file.h>
 #include <linux/mount.h>
 #include <linux/fs_context.h>
+#include <linux/fs_parser.h>
 #include "nilfs.h"
 #include "export.h"
 #include "mdt.h"
@@ -1025,8 +1024,7 @@ int nilfs_checkpoint_is_mounted(struct s
 /**
  * nilfs_fill_super() - initialize a super block instance
  * @sb: super_block
- * @data: mount options
- * @silent: silent mode flag
+ * @fc: filesystem context
  *
  * This function is called exclusively by nilfs->ns_mount_mutex.
  * So, the recovery process is protected from other simultaneous mounts.
@@ -1193,8 +1191,9 @@ nilfs_get_tree(struct fs_context *fc)
 	int err;
 
 	if (ctx->cno && !(fc->sb_flags & SB_RDONLY)) {
-		nilfs_err(s, "invalid option \"cp=%llu\": read-only option is not specified",
-			ctx->cno);
+		nilfs_err(NULL,
+			  "invalid option \"cp=%llu\": read-only option is not specified",
+			  ctx->cno);
 		return -EINVAL;
 	}
 
@@ -1225,13 +1224,20 @@ nilfs_get_tree(struct fs_context *fc)
 			}
 		} else {
 			/*
-			 * Try remount to setup mount states if the current
+			 * Try reconfigure to setup mount states if the current
 			 * tree is not mounted and only snapshots use this sb.
+			 *
+			 * Since nilfs_reconfigure() requires fc->root to be
+			 * set, set it first and release it on failure.
 			 */
-			fc->root = s->s_root;
+			fc->root = dget(s->s_root);
 			err = nilfs_reconfigure(fc);
-			if (err)
+			if (err) {
+				dput(fc->root);
+				fc->root = NULL;  /* prevent double release */
 				goto failed_super;
+			}
+			return 0;
 		}
 	}
 
--- a/fs/nilfs2/the_nilfs.c~nilfs2-convert-to-use-the-new-mount-api-v2
+++ a/fs/nilfs2/the_nilfs.c
@@ -659,7 +659,6 @@ static int nilfs_load_super_block(struct
  * init_nilfs - initialize a NILFS instance.
  * @nilfs: the_nilfs structure
  * @sb: super block
- * @data: mount options
  *
  * init_nilfs() performs common initialization per block device (e.g.
  * reading the super block, getting disk layout information, initializing
_

Patches currently in -mm which might be from sandeen@redhat.com are

nilfs2-convert-to-use-the-new-mount-api.patch

