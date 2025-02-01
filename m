Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22553153565;
	Sat,  1 Feb 2025 11:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738410852; cv=none; b=MnFeD64CkbCc9KT7B2dpUCvaDdfkjUpY68ErZOz8ZgQPYva3x57MiC8XVcQJYCaYiKwAdq1SUj/RFxy+mmpjWCDlY1Z1epgQJewJF1fCe5e6pBxtfXKxrZcLbkJxE7Wci07EFTC/Uwv5S0AQdVB/QceP9sYispFaMVq5HtqcEps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738410852; c=relaxed/simple;
	bh=78hzdtyjlOkhhhM/MpG6ZbrRfnzj6otwvb7Fow+WeOA=;
	h=Date:To:From:Subject:Message-Id; b=iJ5J1mjDpormJpw4cVnAu5c9HKjC4QZzgW0FX9rrfJdwVQrYMKVayrbP1oAHmgT1buAK2z9/fxBhw+7fvQj6Ixd7QDEUHJDSarN9YQUHzH3BiXy2y+YPyjc4YtDai3eIR2pAPqQe+/VydniylT9ba0Mh1ztLnCretA9LOtdEpL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TnyJhMXc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TnyJhMXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC835C4CEE3;
	Sat,  1 Feb 2025 11:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738410852;
	bh=78hzdtyjlOkhhhM/MpG6ZbrRfnzj6otwvb7Fow+WeOA=;
	h=Date:To:From:Subject:From;
	b=TnyJhMXcRXh/2wE0LCmNUdJlMkEBnWurOlZPwGdvnv+vDbaOmuvjBK4PaSUF1rG5Z
	 Eo5l5b/xUpaL9enNTImXuLtNGDY8PU3TzCnCRr+YmwY6dgiwA1p5DiMkliGcecOTaU
	 W8N9aQoqNYE5r4ow8bbWXMrIMsvwwf8R/1UNwzXs=
Date: Sat, 01 Feb 2025 03:54:11 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,n.zhandarovich@fintech.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch removed from -mm tree
Message-Id: <20250201115411.EC835C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: fix possible int overflows in nilfs_fiemap()
has been removed from the -mm tree.  Its filename was
     nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Subject: nilfs2: fix possible int overflows in nilfs_fiemap()
Date: Sat, 25 Jan 2025 07:20:53 +0900

Since nilfs_bmap_lookup_contig() in nilfs_fiemap() calculates its result
by being prepared to go through potentially maxblocks == INT_MAX blocks,
the value in n may experience an overflow caused by left shift of blkbits.

While it is extremely unlikely to occur, play it safe and cast right hand
expression to wider type to mitigate the issue.

Found by Linux Verification Center (linuxtesting.org) with static analysis
tool SVACE.

Link: https://lkml.kernel.org/r/20250124222133.5323-1-konishi.ryusuke@gmail.com
Fixes: 622daaff0a89 ("nilfs2: fiemap support")
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/inode.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/nilfs2/inode.c~nilfs2-fix-possible-int-overflows-in-nilfs_fiemap
+++ a/fs/nilfs2/inode.c
@@ -1186,7 +1186,7 @@ int nilfs_fiemap(struct inode *inode, st
 			if (size) {
 				if (phys && blkphy << blkbits == phys + size) {
 					/* The current extent goes on */
-					size += n << blkbits;
+					size += (u64)n << blkbits;
 				} else {
 					/* Terminate the current extent */
 					ret = fiemap_fill_next_extent(
@@ -1199,14 +1199,14 @@ int nilfs_fiemap(struct inode *inode, st
 					flags = FIEMAP_EXTENT_MERGED;
 					logical = blkoff << blkbits;
 					phys = blkphy << blkbits;
-					size = n << blkbits;
+					size = (u64)n << blkbits;
 				}
 			} else {
 				/* Start a new extent */
 				flags = FIEMAP_EXTENT_MERGED;
 				logical = blkoff << blkbits;
 				phys = blkphy << blkbits;
-				size = n << blkbits;
+				size = (u64)n << blkbits;
 			}
 			blkoff += n;
 		}
_

Patches currently in -mm which might be from n.zhandarovich@fintech.ru are


