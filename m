Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BA2A945
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 01:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745804131; cv=none; b=EjBtXpv69sx43VB0pyrnJVDERGb4Sdw/8xPlvjn8cfPZvyLqI2100mBvoLdHbgN2iOegpvfu9h3cBN0i35UsuwN0pxg2Q1oZDudsU749STvToJQFaH65O8/7zmg5WNODUcXFw62WJblEQTbq+LQrzw1TIDYhaZDu7aM9lMasoq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745804131; c=relaxed/simple;
	bh=MkOPSgnXm8xmpfIBoIy7fMUCmOPLdHn4ufc4B8VLAoo=;
	h=Date:To:From:Subject:Message-Id; b=fYSNgegdFk2LibpsO5QC5gMPBn1sNUvUvYGomP7L2VKlZ1FKwlrWGhMPFbMQFnlYHNZiPBpudHW/Jw2IiwUp55/OFZn0YJUw2eR51wy7g/fF30fWechhn1mxYSS477WEw8VqKRYZqwu1fttTX7EM7VP9x4WXThuyP6HesTg0Io0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=CgRneNik; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="CgRneNik"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2A1C4CEE9;
	Mon, 28 Apr 2025 01:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745804130;
	bh=MkOPSgnXm8xmpfIBoIy7fMUCmOPLdHn4ufc4B8VLAoo=;
	h=Date:To:From:Subject:From;
	b=CgRneNikCNXyn7UuOnSjiyQ4ppr2dJBpcUtkQ6ppuuRBh0UqpjVAmpFKlzDn359mY
	 f8BzGJkTz640JbxxgK1vQms5RhpAaPfxyvup+TC1PlBPspYLizG6fOf/Klp4SkQucG
	 wDM+KmbL/CAgB/US2Ydb6Nj+68mjiMHK1q4ZK5R0=
Date: Sun, 27 Apr 2025 18:35:29 -0700
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,hannes@cmpxchg.org,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [failures] mm-zblock-add-debugfs.patch removed from -mm tree
Message-Id: <20250428013530.4E2A1C4CEE9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zblock: add debugfs
has been removed from the -mm tree.  Its filename was
     mm-zblock-add-debugfs.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Igor Belousov <igor.b@beldev.am>
Subject: mm/zblock: add debugfs
Date: Sun, 27 Apr 2025 22:19:58 +0200

Add debugfs entry to monitor number of blocks allocated for different
block sizes.

Link: https://lkml.kernel.org/r/20250427201958.491806-1-vitaly.wool@konsulko.se
Signed-off-by: Igor Belousov <igor.b@beldev.am>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zblock.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/mm/zblock.c~mm-zblock-add-debugfs
+++ a/mm/zblock.c
@@ -17,6 +17,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/atomic.h>
+#include <linux/debugfs.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/module.h>
@@ -27,6 +28,7 @@
 #include "zblock.h"
 
 static struct rb_root block_desc_tree = RB_ROOT;
+static struct dentry *zblock_debugfs_root;
 
 /* Encode handle of a particular slot in the pool using metadata */
 static inline unsigned long metadata_to_handle(struct zblock_block *block,
@@ -111,6 +113,22 @@ static struct zblock_block *alloc_block(
 	return block;
 }
 
+static int zblock_blocks_show(struct seq_file *s, void *v)
+{
+	struct zblock_pool *pool = s->private;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(block_desc); i++) {
+		struct block_list *block_list = &pool->block_lists[i];
+
+		seq_printf(s, "%d: %ld blocks of %d pages (total %ld pages)\n",
+			i, block_list->block_count, block_desc[i].num_pages,
+			block_list->block_count * block_desc[i].num_pages);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(zblock_blocks);
+
 /*****************
  * API Functions
  *****************/
@@ -140,6 +158,9 @@ static struct zblock_pool *zblock_create
 		INIT_LIST_HEAD(&block_list->active_list);
 		block_list->block_count = 0;
 	}
+
+	debugfs_create_file("blocks", S_IFREG | 0444, zblock_debugfs_root,
+			    pool, &zblock_blocks_fops);
 	return pool;
 }
 
@@ -426,12 +447,15 @@ static int __init init_zblock(void)
 		return ret;
 
 	zpool_register_driver(&zblock_zpool_driver);
+
+	zblock_debugfs_root = debugfs_create_dir("zblock", NULL);
 	return 0;
 }
 
 static void __exit exit_zblock(void)
 {
 	zpool_unregister_driver(&zblock_zpool_driver);
+	debugfs_remove_recursive(zblock_debugfs_root);
 	delete_rbtree();
 }
 
_

Patches currently in -mm which might be from igor.b@beldev.am are


