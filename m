Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793312214;
	b=lZBhlh+xMN7bTFel2IAcb/rNRW96KSAPzndyCmcBES6RqFcrkceQVWU1w6fLYAk8i8PR
	 KpEnNsk3l7x+rxvOu7kZ2+8qzbk2Yg5WQSPiwO4BuhWuqdOxZNxNTdF7D9DlwmIqGTTFz
	 FEhwkrRRHoPLy1A2rJ4Nim/x10lRCIQbTuRkwKT6CtupMNVtyA34D4UASApn4QDZ6MEvN
	 mLBPWNAXFN1mHh6lNhB3FQPetWtYUaKtSi/98cuFFX+d8lpPX6R9HLoFU2mZZwAHm6R/8
	 /nEWtZHvaNv+OLwrFHE+n6QjuH8pGEDjGNOCnd67LhPR5U2pw3gl1ipJj1i0Ft1G8qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793312214;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=nEBg4iWi9cJPk+7KXtfBWM0QCq1SCidjPzMfZHY4T9I=;
	b=xRzQVXljjOr9ogkU07fv/xlhkgdqbkUDikIRllfm7NaVgrl7ipfCslDtw5atJweMCxeH
	 uG0keDqrvKXoyRhLIZyGxba7TrVXB2+VWPAEKqv04p9+uMyZpy649vOmzGgl/jk4GnsuP
	 jXTTRoLnVowdy81ga9o/g/GrH6JiNrC1sawibPxTkuhr3mNLe+JWfgmb+61Ww7KReMxD0
	 f9iiDQWN/UQ4GpoCoTV01hExAONjM7IvyD3mxZJMDuN9SYzRhcI/7Ia8fkbAdmKMWZbKj
	 rV4b4lQrY/TdxxflCAy66rDrCu8Jt1xdFlrFU6N9ExON5rwJQTfufm5xYkWdjcDjIAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ON9B+gXg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C7B606A31A
	for <mm-commits@vger.kernel.org>; Thu, 29 Oct 2026 22:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=ON9B+gXg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A93C11F01816;
	Thu, 29 Oct 2026 22:16:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793312213;
	bh=nEBg4iWi9cJPk+7KXtfBWM0QCq1SCidjPzMfZHY4T9I=;
	h=Date:To:From:Subject;
	b=ON9B+gXgr3lG57URYB5namQg5XiemufsUQq29xJl3hrMgC4nBJoKMsUj/FykZg+HV
	 fn/g73R4pbBMhvHZT9mvJppHPx17Qr5NooafqtgLPKYU/d/ULyo7+v4dkw2+s4j/tx
	 3RLyiwJ3hQ8Os8YsYUD0oV5x9exHSbIJEjF+ueAU=
Date: Thu, 29 Oct 2026 15:16:53 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch added to mm-nonmm-unstable branch
Message-Id: <20261029221653.A93C11F01816@smtp.kernel.org>
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
Date: Thu, 29 Oct 2026 20:23:52 +0000

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

As in rmdir, check that the parent's link count is at least three before
decrementing it. Report a filesystem error if corrupted directory entries
have left the count too low, rather than reducing it below two.

Link: https://lore.kernel.org/20261029202352.59890-1-dennylin0707@gmail.com
Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Christian Brauner <brauner@kernel.org>
---

 fs/fat/namei_msdos.c |    8 ++++++++
 fs/fat/namei_vfat.c  |    8 ++++++++
 2 files changed, 16 insertions(+)

--- a/fs/fat/namei_msdos.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_msdos.c
@@ -565,6 +565,14 @@ static int do_msdos_rename(struct inode
 		(void)sync_inode_metadata(old_dir, 1);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir) {
+			if (old_dir->i_nlink >= 3)
+				drop_nlink(old_dir);
+			else
+				fat_fs_error(old_dir->i_sb,
+					     "parent dir link count too low (%u)",
+					     old_dir->i_nlink);
+		}
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
--- a/fs/fat/namei_vfat.c~fat-fix-parent-link-count-when-replacing-a-sibling-directory
+++ a/fs/fat/namei_vfat.c
@@ -1011,6 +1011,14 @@ static int vfat_rename(struct inode *old
 	vfat_update_dir_metadata(old_dir, &ts);
 
 	if (new_inode) {
+		if (is_dir && old_dir == new_dir) {
+			if (old_dir->i_nlink >= 3)
+				drop_nlink(old_dir);
+			else
+				fat_fs_error(old_dir->i_sb,
+					     "parent dir link count too low (%u)",
+					     old_dir->i_nlink);
+		}
 		drop_nlink(new_inode);
 		if (is_dir)
 			drop_nlink(new_inode);
_

Patches currently in -mm which might be from dennylin0707@gmail.com are

mm-page-writeback-avoid-32-bit-overflow-in-dirty-threshold-shares.patch
mm-migrate-untag-addresses-when-querying-page-nodes.patch
fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch

