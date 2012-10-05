From: akpm@linux-foundation.org
Subject: [merged] omfs-convert-to-use-bexx_add_cpu.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:22:20 -0700
Message-ID: <20121005202220.BC5C1100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57660 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932319Ab2JEUWV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:22:21 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so236199ggm.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:22:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yongjun_wei@trendmicro.com.cn, me@bobcopeland.com, mm-commits@vger.kernel.org


The patch titled
     Subject: omfs: convert to use beXX_add_cpu()
has been removed from the -mm tree.  Its filename was
     omfs-convert-to-use-bexx_add_cpu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Subject: omfs: convert to use beXX_add_cpu()

Convert cpu_to_beXX(beXX_to_cpu(E1) + E2) to use beXX_add_cpu().

dpatch engine is used to auto generate this patch.
(https://github.com/weiyj/dpatch)

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Acked-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/omfs/file.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff -puN fs/omfs/file.c~omfs-convert-to-use-bexx_add_cpu fs/omfs/file.c
--- a/fs/omfs/file.c~omfs-convert-to-use-bexx_add_cpu
+++ a/fs/omfs/file.c
@@ -146,8 +146,7 @@ static int omfs_grow_extent(struct inode
 			be64_to_cpu(entry->e_blocks);
 
 		if (omfs_allocate_block(inode->i_sb, new_block)) {
-			entry->e_blocks =
-				cpu_to_be64(be64_to_cpu(entry->e_blocks) + 1);
+			be64_add_cpu(&entry->e_blocks, 1);
 			terminator->e_blocks = ~(cpu_to_be64(
 				be64_to_cpu(~terminator->e_blocks) + 1));
 			goto out;
@@ -177,7 +176,7 @@ static int omfs_grow_extent(struct inode
 		be64_to_cpu(~terminator->e_blocks) + (u64) new_count));
 
 	/* write in new entry */
-	oe->e_extent_count = cpu_to_be32(1 + be32_to_cpu(oe->e_extent_count));
+	be32_add_cpu(&oe->e_extent_count, 1);
 
 out:
 	*ret_block = new_block;
_

Patches currently in -mm which might be from yongjun_wei@trendmicro.com.cn are

origin.patch
linux-next.patch

