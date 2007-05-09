From: akpm@linux-foundation.org
Subject: - is_power_of_2-in-fs-hfs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:44:49 -0700
Message-ID: <200705090244.l492inQx008629@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:33593 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S969211AbXEICpA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:45:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vignesh.babu@wipro.com, zippel@linux-m68k.org, mm-commits@vger.kernel.org


The patch titled
     is_power_of_2 in fs/hfs
has been removed from the -mm tree.  Its filename was
     is_power_of_2-in-fs-hfs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: is_power_of_2 in fs/hfs
From: Vignesh Babu BM <vignesh.babu@wipro.com>

Replace (n & (n-1)) in the context of power of 2 checks with is_power_of_2

Signed-off-by: vignesh babu <vignesh.babu@wipro.com>
Cc: Roman Zippel <zippel@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/hfs/btree.c     |    3 ++-
 fs/hfsplus/btree.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff -puN fs/hfs/btree.c~is_power_of_2-in-fs-hfs fs/hfs/btree.c
--- a/fs/hfs/btree.c~is_power_of_2-in-fs-hfs
+++ a/fs/hfs/btree.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/pagemap.h>
+#include <linux/log2.h>
 
 #include "btree.h"
 
@@ -76,7 +77,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	tree->depth = be16_to_cpu(head->depth);
 
 	size = tree->node_size;
-	if (!size || size & (size - 1))
+	if (!is_power_of_2(size))
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
diff -puN fs/hfsplus/btree.c~is_power_of_2-in-fs-hfs fs/hfsplus/btree.c
--- a/fs/hfsplus/btree.c~is_power_of_2-in-fs-hfs
+++ a/fs/hfsplus/btree.c
@@ -10,6 +10,7 @@
 
 #include <linux/slab.h>
 #include <linux/pagemap.h>
+#include <linux/log2.h>
 
 #include "hfsplus_fs.h"
 #include "hfsplus_raw.h"
@@ -69,7 +70,7 @@ struct hfs_btree *hfs_btree_open(struct 
 	}
 
 	size = tree->node_size;
-	if (!size || size & (size - 1))
+	if (!is_power_of_2(size))
 		goto fail_page;
 	if (!tree->node_count)
 		goto fail_page;
_

Patches currently in -mm which might be from vignesh.babu@wipro.com are

origin.patch
git-alsa.patch
git-ia64.patch
git-scsi-misc.patch
