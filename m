Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B3981DD889;
	Mon, 27 Jan 2025 22:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738017695; cv=none; b=o/jAt2oJelh4BB3XhgRq+XdBncdFBaUNTe7Jz36LCg/9qzbwtbgyf8N35hLF+1A9KLUzK4gnlpuQW8de0nyzDUFkMytElO+TvayjvNPDUk7icr1qMjXgjspG+pXhanWLZf22nwLdBzAPQwOtfDRXe2v99ACB0elKS11+TRzEy8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738017695; c=relaxed/simple;
	bh=D3aF3EXl2ARW7bdg64oy7Rheixf8W1HTGoRgEyGcoNA=;
	h=Date:To:From:Subject:Message-Id; b=BGq/Da+wvyfTvckG7To/2DnH4TpSb/zfZOukq2qhpDPZlG0WDK+LIaQLjmyhdLr44ZKQ11TEbfJ3hhJL1vL8rTwSY/p66ldBSFYi1Q4bW+JsEztjdvDb350B0Y0rEiPQy0wCutcVGRnM0I1z5O7cgyxb+LSlg5LAHmlMdkUilu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=vbiDBrf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="vbiDBrf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE04C4CED2;
	Mon, 27 Jan 2025 22:41:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1738017694;
	bh=D3aF3EXl2ARW7bdg64oy7Rheixf8W1HTGoRgEyGcoNA=;
	h=Date:To:From:Subject:From;
	b=vbiDBrf7fz7nZsd9HYpF7OY69Liq0yAjMluaoCO4dGV5jXeguQJr7tTO+PF0Tl0h8
	 7VT+6bAzpjF+PgnYA0X5x9nVFaYZZdZARJ3DSVZU9GUVq6qWb92JrNv2HMADjtpx7d
	 z6e7LHGKn0BigVb701VouvSnM2zIFQM5lKIEKato=
Date: Mon, 27 Jan 2025 14:41:34 -0800
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,konishi.ryusuke@gmail.com,n.zhandarovich@fintech.ru,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch added to mm-hotfixes-unstable branch
Message-Id: <20250127224134.BFE04C4CED2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: fix possible int overflows in nilfs_fiemap()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

nilfs2-fix-possible-int-overflows-in-nilfs_fiemap.patch

