From: akpm@linux-foundation.org
Subject: + omfs-convert-to-use-bexx_add_cpu.patch added to -mm tree
Date: Mon, 01 Oct 2012 12:46:38 -0700
Message-ID: <20121001194639.107B4200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:59160 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991Ab2JATql (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 1 Oct 2012 15:46:41 -0400
Received: by lahj13 with SMTP id j13so103595lah.1
        for <mm-commits@vger.kernel.org>; Mon, 01 Oct 2012 12:46:40 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yongjun_wei@trendmicro.com.cn, me@bobcopeland.com


The patch titled
     From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
has been added to the -mm tree.  Its filename is
     omfs-convert-to-use-bexx_add_cpu.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

linux-next.patch
kdump-remove-unneeded-include.patch
omfs-convert-to-use-bexx_add_cpu.patch

