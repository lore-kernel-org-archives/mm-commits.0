Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793343223;
	b=0QwNP4mR3J63tmyjnfqUuLS/dktt/2Gk2EPRP6uNp8zRxt02vEV5Ir2/H/IMdOozOs9V
	 Pl9Hxb7PYYLvVvAKlFqt3szS2kH0qzv8HXFJBRp4F8Wfs5z9oMntxzXXoL5i8VElj7ULj
	 U6qvcIDSmHBg+UKzGeZ5K5PtTuZznufn0psEbS/y/yJa4zgMh6wvG/ItNnGLvt2kwRA1s
	 p+QcdW2YN0GAND1SZzmszBPmHoz1KzvsxPuF2sxEX5EOctlXl0HmwY5vnuwJB99Hp3rNe
	 blj1RMeN3wDeZsXkhwJVQqxFjLWXXlkRMU15Z3fhy4KcN+5B6CHUolL7wUTuUgvnuzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793343223;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=viC4k7O7cqhjdjE6V5rE2l+pfbairmtH6ykgqIjWuzo=;
	b=ymWCkD1TIFKEozRIIzwbGQru1c/+JdD7F+yNhffBrrSeXGswhdvZjtxvRbUozROqxeYa
	 GhuSkQR3SMmi5CrQUD9dFp1tQ+X+ou55YJyNoyiCUXrL2HTmhPNbLbpsopI/WkghRFSfT
	 504JAlqRlB8sE5JkzPz6lRlg6EpdUjrVyUIxz0hret2r3yw3+43N8Fz4HzN8vAEFKr53e
	 /LhNQl+MRBLYn+DojWY9L1uMxZz4LCcrKJEkTyxWBZEWLGhmHLNyYbNyUhzbfRWve2lD3
	 oHUEg/jHwTnfUJ/Yy5KG8m3q/ngM5uEJMvXrINq8003MPVv3QcqCsHNoLOeTlalGR3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vMKO9S2K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60B79606A31C
	for <mm-commits@vger.kernel.org>; Fri, 30 Oct 2026 06:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=vMKO9S2K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EBF1F000C1;
	Fri, 30 Oct 2026 06:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1793343223;
	bh=viC4k7O7cqhjdjE6V5rE2l+pfbairmtH6ykgqIjWuzo=;
	h=Date:To:From:Subject;
	b=vMKO9S2Kksk6odI0VY9cH6i9CZ2fQUjS9tMkqNzh/fVGOMiAgZMi1NrwMAearzdg6
	 hOXHrzBqNqFjiNDQ8RqjQLDH9KJbfVV7/HAFU+juPCT/JFepbIsY9AEmjg/MCLjYXT
	 /HRsIGXh3J4jq8udrREQnR0w6KnUhpIUy75b+GTE=
Date: Thu, 29 Oct 2026 23:53:42 -0700
To: mm-commits@vger.kernel.org,hirofumi@mail.parknet.co.jp,brauner@kernel.org,
	dennylin0707@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] fat-fix-parent-link-count-when-replacing-a-sibling-directory.patch removed from -mm tree
Message-Id: <20261030065342.E4EBF1F000C1@smtp.kernel.org>
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
delayacct-preserve-delay-extrema-when-aggregating-taskstats.patch

