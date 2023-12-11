Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB7BA7493
	for <mm-commits@vger.kernel.org>; Mon, 11 Dec 2023 01:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="1RivItiQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6D9C433C7;
	Mon, 11 Dec 2023 01:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1702257843;
	bh=YSDP8fPH4PGOWM4Y72Ex55GgZQQnPcLF7M9qXp6Dxs4=;
	h=Date:To:From:Subject:From;
	b=1RivItiQqciW9HXlPQTKFqlkfCk+/y2a387Lwg6BRpHfxbrfprKvJIY9FBLkHNBxY
	 WLC/UMnc3DzebhX3j/zm4ha9XeR5gLXhJGRVfRYiAEnWkamGuqm8sEysnxbYJ1NTpE
	 tWPxOL4tngEUw33lfz3CpWcIvRbxADJdFFu7psVg=
Date: Sun, 10 Dec 2023 17:24:02 -0800
To: mm-commits@vger.kernel.org,willy@infradead.org,konishi.ryusuke@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch removed from -mm tree
Message-Id: <20231211012403.6F6D9C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: nilfs2: eliminate staggered calls to kunmap in nilfs_rename
has been removed from the -mm tree.  Its filename was
     nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: nilfs2: eliminate staggered calls to kunmap in nilfs_rename
Date: Mon, 27 Nov 2023 23:30:21 +0900

In nilfs_rename(), calls to nilfs_put_page() to release pages obtained
with nilfs_find_entry() or nilfs_dotdot() are alternated in the normal
path.

When replacing the kernel memory mapping method from kmap to
kmap_local_{page,folio}, this violates the constraint on the calling order
of kunmap_local().

Swap the order of nilfs_put_page calls where the kmap sections of multiple
pages overlap so that they are nested, allowing direct replacement of
nilfs_put_page() -> unmap_and_put_page().

Without this reordering, that replacement will cause a kernel WARNING in
kunmap_local_indexed() on architectures with high memory mapping.

Link: https://lkml.kernel.org/r/20231127143036.2425-3-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/namei.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/namei.c~nilfs2-eliminate-staggered-calls-to-kunmap-in-nilfs_rename
+++ a/fs/nilfs2/namei.c
@@ -411,13 +411,14 @@ static int nilfs_rename(struct mnt_idmap
 	inode_set_ctime_current(old_inode);
 
 	nilfs_delete_entry(old_de, old_page);
-	nilfs_put_page(old_page);
 
 	if (dir_de) {
 		nilfs_set_link(old_inode, dir_de, dir_page, new_dir);
 		nilfs_put_page(dir_page);
 		drop_nlink(old_dir);
 	}
+	nilfs_put_page(old_page);
+
 	nilfs_mark_inode_dirty(old_dir);
 	nilfs_mark_inode_dirty(old_inode);
 
_

Patches currently in -mm which might be from konishi.ryusuke@gmail.com are

nilfs2-switch-warn_ons-to-warning-output-in-nilfs_sufile_do_free.patch

