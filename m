Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312191;
	b=jLUCGToPywZePVj9V5fEkoaYEfycNGdIpR6H0b74lZVe2wRoJXtBqX6SUelIfIFwvslJ
	 efBeXGACyMyCrAZQq2aGH5n2EK+z2lFReNaIFJyzYrrWsLxTJG5FZTdyBg8HzsUjSgXUT
	 0kpRuRofv0wyA8nDGxj9NbGZ77mkwuuSQFExVQqYQ8RwRqf5n0IsNAEVnCl2g14CxHOhJ
	 7O8gKJuOMVq/VqPKtCi7nQFsFvpy5mMDpnLBeX1frdxB3Ltn/CR3j/X7/ShyXL13UNrJ2
	 LpxQs2zTxOQ2157QbalB8UQNpV+qpdmyFOd+MUQ7LRvuwoTJt2lWQfXWj5DjK3cS4/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312191;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=Qjhy7wAlm7HLIhon9TeUbKAxaVHpkybb2oS0ncQ6mwg=;
	b=wDpF0sNNrZRxxyLOHYRp2qLh30FlrX5I6PdEb5+w0rjA6P8CtYCR/tND+xDPOS3ZMN50
	 Psf6ieZGbflBC5oWF+PsFRFPHGWmHWZbIIJmakeOdOWUPei49UmZnZspeiSDBr32WJKN2
	 FgRDY3aLTiyPSop+9xDtxYCXID+YCL7RFg7gyd6PhCMKlCUB8Wj+h+CMwR27Chd7tkPaa
	 MONUcW1u6YFRql+ibIryO3VB3ANUK1WrCNpMVcJrbGPjgtElW8Nuo+dt9o7Aw9h7McgI8
	 V2sWxFCAoTLRIN7fkvcSvyB8ZAgR/pFC61G6Z1xYOiLiVw0QcJm6F+xu9u4DcIGYBQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gxvvnrCc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955AB606A31C
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=gxvvnrCc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C4D61F01816;
	Thu, 29 Oct 2026 22:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312191;
	bh=Qjhy7wAlm7HLIhon9TeUbKAxaVHpkybb2oS0ncQ6mwg=;
	h=Date:To:From:Subject;
	b=gxvvnrCca7pvSC507u56RsJ+FnzQoguiZR60PRHaMSfW9pRCBOLaZg+nlKp1TEGkU
	 BeU1I43NDqY2fkLQkSxz/adIWs/J73Pqu/r6ttZFxxWcMO0uUNeJ7lFPpEBa/Bj0PO
	 JRgquddWW8n/ZAdwlCXj2LXnSv00Ddt/cSjhkF7w=
Date: Thu, 29 Oct 2026 15:16:30 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch removed from -mm tree
Message-Id: <20261029221631.2C4D61F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: fat: fix parent link count when replacing a sibling directory
has been removed from the -mm tree.  Its filename was
     fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Hungyu Lin <dennylin0707@gmail.com>
Subject: fat: fix parent link count when replacing a sibling directory
Date: Wed, 28 Oct 2026 21:16:25 +0000

vfat_rename() and do_msdos_rename() adjust parent link counts only when
updating the dotdot entry for a move between different parents. Replacing
an existing empty directory in the same parent also removes a
subdirectory, but leaves the parent's link count unchanged.

For example, renaming one of two sibling directories over the other
leaves the parent with four links instead of three. stat and ls report
the stale count, and find -links 3 does not match the parent.

Drop the parent's link count for this case after the source entry has
been removed successfully. Leave cross-parent renames, regular files
and the existing error paths unchanged.

Link: https://lore.kernel.org/20261028211626.26103-1-dennylin0707@gmail.com
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
---

 fs/fat/namei_msdos.c |    2 ++
 fs/fat/namei_vfat.c  |    2 ++
 2 files changed, 4 insertions(+)

--- a/fs/fat/namei_msdos.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_msdos.c
@@ -565,6 +565,8 @@ static int do_msdos_rename(struct inode
 		(void)sync_inode_metadata(old_dir, 1);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir)
+			drop_nlink(old_dir);
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
--- a/fs/fat/namei_vfat.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_vfat.c
@@ -1011,6 +1011,8 @@ static int vfat_rename(struct inode *old
 	vfat_update_dir_metadata(old_dir, &ts);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir)
+			drop_nlink(old_dir);
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
mm-migrate-untag-addresses-when-querying-page-nodes.patch

