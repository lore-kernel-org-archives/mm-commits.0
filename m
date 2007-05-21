From: akpm@linux-foundation.org
Subject: + udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch added to -mm tree
Date: Mon, 21 May 2007 14:31:40 -0700
Message-ID: <200705212131.l4LLVek4020510@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41878 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756887AbXEUVcz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 21 May 2007 17:32:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com


The patch titled
     udf-check-for-allocated-memory-for-data-of-new-inodes fix
has been added to the -mm tree.  Its filename is
     udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

udf-check-for-allocated-memory-for-data-of-new-inodes.patch
udf-check-for-allocated-memory-for-data-of-new-inodes-fix.patch
udf-check-for-allocated-memory-for-inode-data-v2.patch
