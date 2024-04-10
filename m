Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D31181BB4
	for <mm-commits@vger.kernel.org>; Wed, 10 Apr 2024 20:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712781191; cv=none; b=YvA8gqNfoSyEorbASN980mghfUefh1+jjmUFnhlkfEsZ1V+wBvEMReivpJO4WSYPOzQviv2kRR/3Y+ybd76zqPN1P081L7A7NcJuAYjA6QxDhrggl+xj10xjPvZhtmhRkWqiIhFnsURVAR7QytYr9ra76zaSCQy+nhqvxcKVi0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712781191; c=relaxed/simple;
	bh=AEyF1u4wwFlxNnIOp8d1ypxSHF4ZkGzWVqLA2sYrHgQ=;
	h=Date:To:From:Subject:Message-Id; b=Hs8zo3fnRXSRdSsmzUAdL/eyt3xrIpYJx3rl7HZxAR8xYkD1Gi+nuv1PIWzMj0yml5GxakNET7d91OLYgmuDBNEwATcdAP2SZc8zJqVzsHRLVxsT7dq3TYmZEbHb9LwzpI9GwzGxmE9JVtMAgYnJq+Is3KtseKMn8/KZES++q/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u3ADdS14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u3ADdS14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63AFBC43390;
	Wed, 10 Apr 2024 20:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1712781189;
	bh=AEyF1u4wwFlxNnIOp8d1ypxSHF4ZkGzWVqLA2sYrHgQ=;
	h=Date:To:From:Subject:From;
	b=u3ADdS14Rjd+VkPk/8gykk3Q11fVDuC6HLL0E8vZz3Sb6FFfto9HEfpuYxf+qFc4E
	 pkLFzlWq6+aPAgAwWW/gV8gSY4PePTo8m51BRQLWvOesypbNcLDE0K8Q4txwJxV71L
	 Da3vL/c3DtLBzN9+HrsTqE3QNGIFTTDl3r3xCZi4=
Date: Wed, 10 Apr 2024 13:33:08 -0700
To: mm-commits@vger.kernel.org,konishi.ryusuke@gmail.com,yang.lee@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch added to mm-nonmm-unstable branch
Message-Id: <20240410203309.63AFBC43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: nilfs2: add kernel-doc comments to nilfs_remove_all_gcinodes()
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: nilfs2: add kernel-doc comments to nilfs_remove_all_gcinodes()
Date: Wed, 10 Apr 2024 16:56:29 +0900

This commit adds kernel-doc style comments with complete parameter
descriptions for the function nilfs_remove_all_gcinodes.

Link: https://lkml.kernel.org/r/20240410075629.3441-4-konishi.ryusuke@gmail.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/gcinode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/nilfs2/gcinode.c~nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes
+++ a/fs/nilfs2/gcinode.c
@@ -175,6 +175,7 @@ int nilfs_init_gcinode(struct inode *ino
 
 /**
  * nilfs_remove_all_gcinodes() - remove all unprocessed gc inodes
+ * @nilfs: NILFS filesystem instance
  */
 void nilfs_remove_all_gcinodes(struct the_nilfs *nilfs)
 {
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

fs-add-kernel-doc-comments-to-fat_parse_long.patch
nilfs2-add-kernel-doc-comments-to-nilfs_do_roll_forward.patch
nilfs2-add-kernel-doc-comments-to-nilfs_btree_convert_and_insert.patch
nilfs2-add-kernel-doc-comments-to-nilfs_remove_all_gcinodes.patch

