Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197D727FB31;
	Tue, 12 Aug 2025 00:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754957508; cv=none; b=qwOCCdXrc0GMSIgr5R3Zj9MgO5LnbmHNFRZv4SfT/lDI4wrCfOew5kbCRsAY57ykM+Cj3jtqmBi9WZI8ipoOvjwWOlDQj+XKnYPiy9GNPuBUwaZgW/wjw93qKvfj95Gr1WeqyYDADx7ASukAywBJsg/HOECr9JoAWTZV67cv7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754957508; c=relaxed/simple;
	bh=1SJJhrg6XOCJUMzgD6SBLY/VMRiHnvLmQouluKvhC38=;
	h=Date:To:From:Subject:Message-Id; b=bx2H2yshGvBz0o7hBXb0rzP2fSd1xy9yXEY2hA4tFJmmTpfxcyhzFjKT8jTniqJ2CtPvf85klqJLR9L4gEdBL46FMq5XnZC2ZFL14S9HnLpWiC3hoGIRTKaGzzLu9w9OeSwR0owyCqCfvRSC7vTpLKJ5EfxcwX1oWQ8qcF7wJxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FBwpo30h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FBwpo30h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90047C4CEED;
	Tue, 12 Aug 2025 00:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754957507;
	bh=1SJJhrg6XOCJUMzgD6SBLY/VMRiHnvLmQouluKvhC38=;
	h=Date:To:From:Subject:From;
	b=FBwpo30hro3rgYj3tHiJx+SxNgkEkIsXpkNGAU7H0TcVfNS1sBSRiG47OOt9kXnnx
	 36QIMCitGCd0bQr+41kc7ramr3OGOd1wuA0lRKj6KKnehafYRph1yqPMYjYFZks5SS
	 w1QrW+G/YEH822WrGAoj+OD29tTJTdfudCST6Eeo=
Date: Mon, 11 Aug 2025 17:11:46 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,scottzhguo@tencent.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-memory-leak-in-squashfs_fill_super.patch added to mm-hotfixes-unstable branch
Message-Id: <20250812001147.90047C4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix memory leak in squashfs_fill_super
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-memory-leak-in-squashfs_fill_super.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-memory-leak-in-squashfs_fill_super.patch

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
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: fix memory leak in squashfs_fill_super
Date: Mon, 11 Aug 2025 23:37:40 +0100

If sb_min_blocksize returns 0, squashfs_fill_super exits without freeing
allocated memory (sb->s_fs_info).

Fix this by moving the call to sb_min_blocksize to before memory is
allocated.

Link: https://lkml.kernel.org/r/20250811223740.110392-1-phillip@squashfs.org.uk
Fixes: 734aa85390ea ("Squashfs: check return result of sb_min_blocksize")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Scott GUO <scottzhguo@tencent.com>
Closes: https://lore.kernel.org/all/20250811061921.3807353-1-scott_gzh@163.com
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/super.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/fs/squashfs/super.c~squashfs-fix-memory-leak-in-squashfs_fill_super
+++ a/fs/squashfs/super.c
@@ -187,10 +187,15 @@ static int squashfs_fill_super(struct su
 	unsigned short flags;
 	unsigned int fragments;
 	u64 lookup_table_start, xattr_id_table_start, next_table;
-	int err;
+	int err, devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
 
 	TRACE("Entered squashfs_fill_superblock\n");
 
+	if (!devblksize) {
+		errorf(fc, "squashfs: unable to set blocksize\n");
+		return -EINVAL;
+	}
+
 	sb->s_fs_info = kzalloc(sizeof(*msblk), GFP_KERNEL);
 	if (sb->s_fs_info == NULL) {
 		ERROR("Failed to allocate squashfs_sb_info\n");
@@ -201,12 +206,7 @@ static int squashfs_fill_super(struct su
 
 	msblk->panic_on_errors = (opts->errors == Opt_errors_panic);
 
-	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
-	if (!msblk->devblksize) {
-		errorf(fc, "squashfs: unable to set blocksize\n");
-		return -EINVAL;
-	}
-
+	msblk->devblksize = devblksize;
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

squashfs-fix-memory-leak-in-squashfs_fill_super.patch

