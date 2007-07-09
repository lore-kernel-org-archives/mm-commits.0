From: akpm@linux-foundation.org
Subject: - udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch removed from -mm tree
Date: Mon, 09 Jul 2007 14:47:10 -0700
Message-ID: <200707092147.l69LlA6F014076@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40626 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754816AbXGIVrT (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Jul 2007 17:47:19 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, mm-commits@vger.kernel.org


The patch titled
     udf-check-for-allocated-memory-for-data-of-new-inodes fix
has been removed from the -mm tree.  Its filename was
     udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch

This patch was dropped because it was folded into udf-check-for-allocated-memory-for-data-of-new-inodes.patch

------------------------------------------------------
Subject: udf-check-for-allocated-memory-for-data-of-new-inodes fix
From: Cyrill Gorcunov <gorcunov@gmail.com>

It seems my previous patch didn't release mutex

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/udf/ialloc.c |    1 +
 1 files changed, 1 insertion(+)

diff -puN fs/udf/ialloc.c~udf-check-for-allocated-memory-for-data-of-new-inodes-fix fs/udf/ialloc.c
--- a/fs/udf/ialloc.c~udf-check-for-allocated-memory-for-data-of-new-inodes-fix
+++ a/fs/udf/ialloc.c
@@ -140,6 +140,7 @@ struct inode * udf_new_inode (struct ino
 	{
 		iput(inode);
 		*err = -ENOMEM;
+		mutex_unlock(&sbi->s_alloc_mutex);
 		return NULL;
 	}
 	if (UDF_QUERY_FLAG(inode->i_sb, UDF_FLAG_USE_AD_IN_ICB))
_

Patches currently in -mm which might be from gorcunov@gmail.com are

sky-cpu-and-nexus-code-style-improvement.patch
sky-cpu-and-nexus-include-ioh.patch
sky-cpu-and-nexus-check-for-platform_get_resource-ret.patch
sky-cpu-and-nexus-check-for-create_proc_entry-ret-code.patch
sky-cpu-use-c99-style-for-struct-init.patch
udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
udf-coding-style-conversion-lindent.patch
udf-coding-style-conversion-lindent-fixups.patch
udf-coding-style-conversion-lindent-fixups-2.patch
udf-fix-function-name-from-udf_crc16-to-udf_crc.patch
