From: akpm@linux-foundation.org
Subject: + is_power_of_2-in-fs-hfs.patch added to -mm tree
Date: Sun, 25 Feb 2007 04:30:55 -0800
Message-ID: <200702251230.l1PCUve9029320@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:34745 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964855AbXBYMbL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Sun, 25 Feb 2007 07:31:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vignesh.babu@wipro.com, zippel@linux-m68k.org


The patch titled
     is_power_of_2 in fs/hfs
has been added to the -mm tree.  Its filename is
     is_power_of_2-in-fs-hfs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

is_power_of_2-in-fat.patch
is_power_of_2-in-fs-hfs.patch
