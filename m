Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DF33876B7
	for <mm-commits@vger.kernel.org>; Mon, 12 Jan 2026 18:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768243242; cv=none; b=nFZVTXBEyp7QqRLtzHw2kab8X27k/90mh4vWaEa9nFpA4PTAu04jlGPLEaZZ4Af/DFBjOutY1jrgKoU9dJnHF3cran4PqUJiSeQNLKGulnuwuFVMGmMkPv4O856c5HrODHY8TogHEdzutxpKWAyUI6IdWbMIjDI+Efe+GccIbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768243242; c=relaxed/simple;
	bh=Mrdvwr+lnZLhGsUAmfk4P4p5wWy41pjkcRxic2Fbg68=;
	h=Date:To:From:Subject:Message-Id; b=CwpyMwfINwbJcbLE0lou5gw5i3wns8qq4pztxq+Fp7JZrdBQnZlievq5UmTqYDln+t0GC8gnWeJaAaYdK0ySvq7tVbBB2KuXu69rVjmrYxQVxQfiksmcwMAzaj+Oga8ShBOcAREKetY34bTflq0rsDhGwj9rDcTSvEk41uibiuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xRe5cQkN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xRe5cQkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397E1C19422;
	Mon, 12 Jan 2026 18:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768243242;
	bh=Mrdvwr+lnZLhGsUAmfk4P4p5wWy41pjkcRxic2Fbg68=;
	h=Date:To:From:Subject:From;
	b=xRe5cQkNL+99QSPg2RMhjrsLYyt7yhWXJnck3KFzVFvALJIXRflBgfpo8OTJcE8cV
	 ggA75ONpwbszLq4jhB6B2I6TO/8FyQaUBjmKzabPt4Nffjor2GJJdYikRGVjYhgrnF
	 0DGMQaCT4Tl71NlMNo6UR0Xvdu3KC9VM08r6HQ+M=
Date: Mon, 12 Jan 2026 10:40:41 -0800
To: mm-commits@vger.kernel.org,viro@zeniv.linux.org.uk,jack@suse.cz,hirofumi@mail.parknet.co.jp,brauner@kernel.org,zhiyuzhang999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fat-avoid-parent-link-count-underflow-in-rmdir.patch added to mm-nonmm-unstable branch
Message-Id: <20260112184042.397E1C19422@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fat: avoid parent link count underflow in rmdir
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fat-avoid-parent-link-count-underflow-in-rmdir.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fat-avoid-parent-link-count-underflow-in-rmdir.patch

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
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Subject: fat: avoid parent link count underflow in rmdir
Date: Thu, 1 Jan 2026 19:11:48 +0800

Corrupted FAT images can leave a directory inode with an incorrect
i_nlink (e.g. 2 even though subdirectories exist). rmdir then
unconditionally calls drop_nlink(dir) and can drive i_nlink to 0,
triggering the WARN_ON in drop_nlink().

Add a sanity check in vfat_rmdir() and msdos_rmdir(): only drop the
parent link count when it is at least 3, otherwise report a filesystem
error.

Link: https://lkml.kernel.org/r/20260101111148.1437-1-zhiyuzhang999@gmail.com
Fixes: 9a53c3a783c2 ("[PATCH] r/o bind mounts: unlink: monitor i_nlink")
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/aVN06OKsKxZe6-Kv@casper.infradead.org/T/#t
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/fat/namei_msdos.c |    7 ++++++-
 fs/fat/namei_vfat.c  |    7 ++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

--- a/fs/fat/namei_msdos.c~fat-avoid-parent-link-count-underflow-in-rmdir
+++ a/fs/fat/namei_msdos.c
@@ -325,7 +325,12 @@ static int msdos_rmdir(struct inode *dir
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_CTIME);
--- a/fs/fat/namei_vfat.c~fat-avoid-parent-link-count-underflow-in-rmdir
+++ a/fs/fat/namei_vfat.c
@@ -804,7 +804,12 @@ static int vfat_rmdir(struct inode *dir,
 	err = fat_remove_entries(dir, &sinfo);	/* and releases bh */
 	if (err)
 		goto out;
-	drop_nlink(dir);
+	if (dir->i_nlink >= 3)
+		drop_nlink(dir);
+	else {
+		fat_fs_error(sb, "parent dir link count too low (%u)",
+			dir->i_nlink);
+	}
 
 	clear_nlink(inode);
 	fat_truncate_time(inode, NULL, S_ATIME|S_MTIME);
_

Patches currently in -mm which might be from zhiyuzhang999@gmail.com are

fat-avoid-parent-link-count-underflow-in-rmdir.patch

