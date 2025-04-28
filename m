Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC681B4138
	for <mm-commits@vger.kernel.org>; Mon, 28 Apr 2025 09:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745832486; cv=none; b=Jx4vwwjTzxMQY0fkkJmtAoVnlYI0jL4KVvyMzntaH0EhND2rFwg9McbMblAcCnCNTgt7zj7zwSoWwNAl8v3Vt8IV+8nWTcqS4Ok38Q2KQD4VYqGNxkq7Tm46MdMDm3OcyFwqxEzBDEDYobmRx4jEckcxQMGi/FlggPrNMYaMd7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745832486; c=relaxed/simple;
	bh=/x5pAqlgUJLNVUA9ib0JzhmURIcsqLOaesLTKL1xQUs=;
	h=Date:To:From:Subject:Message-Id; b=nlK49aJ/ruH50smON614DQfWvYjSCZ45bhIxFKb2Nbc0ztnfxi66GSmHgFPhKIecJdap8zwy92cCwu/faM1eDjJEVhZ5LKl/WeePTudORws4KT7U+nopDoeeVvghcAqB3cf7B6/LJ++stJvD+ha28ptlzBXB8xV8jD1Dgm9fpUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EeuDGqRF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EeuDGqRF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56FC7C4CEE4;
	Mon, 28 Apr 2025 09:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1745832485;
	bh=/x5pAqlgUJLNVUA9ib0JzhmURIcsqLOaesLTKL1xQUs=;
	h=Date:To:From:Subject:From;
	b=EeuDGqRFXL/hhn37ceazNNEeRHIlpTPwaLNa+EJkf2drmxjNgp6AICBGn1yXBdu9V
	 iRVAwTm8F+Vq1q9dEwpOMkJr2ZmMgJLOUFiMkMt2OnQtKh0Qz9yymuJWnKyIHqDPAE
	 6tNGXrdqCVdlM2Xm5Sh1+NAn6kO+Od/glBmHXJjg=
Date: Mon, 28 Apr 2025 02:28:04 -0700
To: mm-commits@vger.kernel.org,yosry.ahmed@linux.dev,vitaly.wool@konsulko.se,shakeel.butt@linux.dev,nphamcs@gmail.com,hannes@cmpxchg.org,david@redhat.com,igor.b@beldev.am,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zblock-add-debugfs.patch added to mm-new branch
Message-Id: <20250428092805.56FC7C4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zblock: add debugfs
has been added to the -mm mm-new branch.  Its filename is
     mm-zblock-add-debugfs.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zblock-add-debugfs.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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

mm-zblock-add-debugfs.patch
mm-zblock-avoid-failing-the-build.patch

