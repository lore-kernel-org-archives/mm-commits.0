Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312171;
	b=WB+bEThnNyJ986RBP1gtt30stzF/VonRTNWqmHLgMgKAOxHzv2fwgsnducTC4j+psJaL
	 rHyflPeRc2dBtIXvkdvvCX71zu/7Y9/wPWcU56kMjfHkX0p+/P4aPi2AGmfASipSXkCYj
	 1Mle65trJHYAwFu6mNcfzrsC5h2NwfXiCfglcU+REphW/N0G7a+lLK3jk0ENSFQx1uVw5
	 xIsBXfSCptSXFncfJIF9sWJFDt/zTG9HkKLAxaubojc3vQo3BQa0csvdtf+tvnx4z8fO+
	 L+1rCPhKgHDdHFOuAvQ2MPnpA2cvS1DoFa/wVhISSnoF0VBu/LAmMjkKNy31UAznrLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312171;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=xDZQNAfKTO7XbJ/+QmMm3qCBBFVv1E36vsoVJ/Otzqg=;
	b=xTEf37t7ckr0aDxWuL+DXoaDZWitEAwNKbWTF/04FQByadp6Y0VXfEAmqFuymeVHbt2W
	 NpAVLe2sKQVCSvu0y6QrDcFdtXyFKdKIh3ip8SkWw1ZU120GfjO9YPRdKWiHRzQ+KDsa4
	 AmrpM4U5G6msGuIFW4CAtK5GP50v3TgizAkELcfdosyHjjjoF0uAfgK3BgFJK6mUnDp0C
	 4noWcZOAMwFSdV3NhkPI48Scan9Ig/lDcIlZsdxKVLbf7D3QVKdtvjais1iKR7V1vM92j
	 X7qlFhwE9wFBHJnJp1t/vgw9SmUF9ezOSK+BowTgPtRu4WPaZncZCg8HtGl8h8PkITQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="U/U0Lm6k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26E4606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=U/U0Lm6k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A460D1F01816;
	Thu, 29 Oct 2026 22:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312170;
	bh=xDZQNAfKTO7XbJ/+QmMm3qCBBFVv1E36vsoVJ/Otzqg=;
	h=Date:To:From:Subject;
	b=U/U0Lm6kXKlnIGp0djiHGsKU7gfBqtbGvN/tR0QpDYtHk1/gL5m8wa7VWrVHx809B
	 jOcdJNwiv4Er8D3ZE3OaHiPmVC+H08bmAZwodzFz0NLaSP5k9k+H36maChDsVfvcht
	 vEwqoKD7xrbYC5AA63sLvssM2jJIJgIsZm0ZicEg=
Date: Thu, 29 Oct 2026 15:16:10 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch added to mm-nonmm-unstable branch
Message-Id: <20261029221610.A460D1F01816@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: fat: fix parent link count when replacing a sibling directory
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

This patch will later appear in the mm-nonmm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

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
fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

