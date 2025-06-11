Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B41F15B54C
	for <mm-commits@vger.kernel.org>; Wed, 11 Jun 2025 01:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749607065; cv=none; b=DLoVxoE0Fc4QIXk/rT/44Mo9+37IQ/Aqd78mRwKqqsGKTOgksRdpedI5TZzyaPaG80/mfIKhfnpZpxmpEMHaAizCeufGCWhUZErnthppWcVpZIj/C/k9BTAVmYbCGr0HqlRbsL0GmqcvGdnJQF2zP+lAgpseo31NZ6/71p67T7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749607065; c=relaxed/simple;
	bh=HcEeuUhE/1Qec4ai9iCsmRMAfdyeBL9Pmr1BI6aSUw0=;
	h=Date:To:From:Subject:Message-Id; b=f/A4nkMLSzQtkbtVdGHTjyV+RwWdw7DCJXjXBJb2EvlEwuoiHdM6c/nfvLyEPz+rtnwGHIYGYp7vVTRB/1AtPUAFm+T4mNpMpkgR22ebXAEQn/4MSqM5XBnHFXlt7QNybyKhbuv5O47oCc6/DuqGRyvEMu7kUppap+pvG1jvl3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=keT6gbIO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="keT6gbIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3F8C4CEED;
	Wed, 11 Jun 2025 01:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749607065;
	bh=HcEeuUhE/1Qec4ai9iCsmRMAfdyeBL9Pmr1BI6aSUw0=;
	h=Date:To:From:Subject:From;
	b=keT6gbIOZFkBZDPk1Bxr/VP/KAt3M+/3Dvv+7feUlkkJq0bgG4A/5uq5JxzAL+Uty
	 Iow9UdHVR0z8+/ESj55+jQtY/60UUotpjGOB0s6Veg+jir6wmGVDpmb03QMmhGxIFX
	 hO2SLGALtfenbnZUuDAfa9V29AsDRy4yL85NOMMM=
Date: Tue, 10 Jun 2025 18:57:44 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-zblock-add-debugfs.patch removed from -mm tree
Message-Id: <20250611015745.0B3F8C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zblock: add debugfs
has been removed from the -mm tree.  Its filename was
     mm-zblock-add-debugfs.patch

This patch was dropped because it was folded into mm-add-zblock-allocator.patch

------------------------------------------------------
From: Igor Belousov <igor.b@beldev.am>
Subject: mm/zblock: add debugfs
Date: Mon, 28 Apr 2025 08:49:24 +0200

Add debugfs entry to monitor number of blocks allocated for different
block sizes.

Link: https://lkml.kernel.org/r/20250428064924.53496-1-igor.b@beldev.am
Signed-off-by: Igor Belousov <igor.b@beldev.am>

Cc: David Hildenbrand <david@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>
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
+			i, block_list->block_count, 1 << block_desc[i].order,
+			block_list->block_count << block_desc[i].order);
+	}
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(zblock_blocks);
+
 /*****************
  * API Functions
  *****************/
@@ -139,6 +157,9 @@ static struct zblock_pool *zblock_create
 		INIT_LIST_HEAD(&block_list->active_list);
 		block_list->block_count = 0;
 	}
+
+	debugfs_create_file("blocks", S_IFREG | 0444, zblock_debugfs_root,
+			    pool, &zblock_blocks_fops);
 	return pool;
 }
 
@@ -425,12 +446,15 @@ static int __init init_zblock(void)
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

mm-add-zblock-allocator.patch
mm-zblock-avoid-failing-the-build.patch
mm-zblock-use-vmalloc-for-page-allocations.patch

