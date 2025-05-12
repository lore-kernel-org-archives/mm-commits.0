Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C851A76D4
	for <mm-commits@vger.kernel.org>; Mon, 12 May 2025 00:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747011383; cv=none; b=GoliVbD91ROtsBs3Ry96xoZ6GG9IavrZZkSWsbA+s1xvsHD8hXgg9eDVEcWRBHwbUN8HHE0TgTJTtWelc10kUZdD+qBEiOaXgdmQaFft69UJqgHSyoL2k8adCU/xyXPHR8/C3jnQmhQR+6q9/9ZNjYMIyVDP1Y0w/hKCrvXfywA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747011383; c=relaxed/simple;
	bh=6S6Ev9iCixBwhytldwG7yHIfJbU5+8DWjQSIvqM8ruo=;
	h=Date:To:From:Subject:Message-Id; b=XHJW22kEU0JHs6CU6SFo51hwt3F77NUC+de14UKPgXZQiLxDHSrEEndvjlAGJBjr5csdQNLLCbGexlOMTOxxOQmu+6vS2VfoDncvN/I4f4eaNU2C5VFxdvg79Bnp5ECJqdm3qWTDZap4syqdXF5QxbWjCP7vxhKIf79BP0LbUas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=qivs06f7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="qivs06f7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DB2AC4CEE4;
	Mon, 12 May 2025 00:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1747011383;
	bh=6S6Ev9iCixBwhytldwG7yHIfJbU5+8DWjQSIvqM8ruo=;
	h=Date:To:From:Subject:From;
	b=qivs06f7Xzlvy3x9VXDko+zcImtUV9B1ngYivo2I/VZr6NLFoZASBg9RuuDyzfns8
	 BxctRWesRxDElT72w28EgXEFg5xHazpaseyDIDjHy3KYB49vNIaYy1t5G5r3b3U8PE
	 CWn2UrayTZ6C39muJ2fEF6EnxmRh9w+vs7sTMg8s=
Date: Sun, 11 May 2025 17:56:23 -0700
To: mm-commits@vger.kernel.org,vulab@iscas.ac.cn,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch removed from -mm tree
Message-Id: <20250512005623.8DB2AC4CEE4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
has been removed from the -mm tree.  Its filename was
     nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: do not propagate ENOENT error from nilfs_btree_propagate()
Date: Tue, 29 Apr 2025 02:37:08 +0900

In preparation for writing logs, in nilfs_btree_propagate(), which makes
parent and ancestor node blocks dirty starting from a modified data block
or b-tree node block, if the starting block does not belong to the b-tree,
i.e.  is isolated, nilfs_btree_do_lookup() called within the function
fails with -ENOENT.

In this case, even though -ENOENT is an internal code, it is propagated to
the log writer via nilfs_bmap_propagate() and may be erroneously returned
to system calls such as fsync().

Fix this issue by changing the error code to -EINVAL in this case, and
having the bmap layer detect metadata corruption and convert the error
code appropriately.

Link: https://lkml.kernel.org/r/20250428173808.6452-3-konishi.ryusuke@gmail.com
Fixes: 1f5abe7e7dbc ("nilfs2: replace BUG_ON and BUG calls triggerable from ioctl")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/btree.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/btree.c~nilfs2-do-not-propagate-enoent-error-from-nilfs_btree_propagate
+++ a/fs/nilfs2/btree.c
@@ -2102,11 +2102,13 @@ static int nilfs_btree_propagate(struct
 
 	ret = nilfs_btree_do_lookup(btree, path, key, NULL, level + 1, 0);
 	if (ret < 0) {
-		if (unlikely(ret == -ENOENT))
+		if (unlikely(ret == -ENOENT)) {
 			nilfs_crit(btree->b_inode->i_sb,
 				   "writing node/leaf block does not appear in b-tree (ino=%lu) at key=%llu, level=%d",
 				   btree->b_inode->i_ino,
 				   (unsigned long long)key, level);
+			ret = -EINVAL;
+		}
 		goto out;
 	}
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are


