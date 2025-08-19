Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B77535337A;
	Tue, 19 Aug 2025 23:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755646590; cv=none; b=P5g+xZ4s0MFMU3+qqQEMz81AN3VOe/EyoxJnaWaKTasJIQXACEvS8i0+78acYF5i4O9BIuygjsOVBkxfF92s1Gq/oHSvGSq+K2+a0c00gieIZMLQjOgkjIhTFb3Vht4WbuJA9v99TyhRJmOAL/z8h9Z1QTPLlfPztFhFZo14A9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755646590; c=relaxed/simple;
	bh=1skGaMpaLQ0s+qI/ImgxzQzEO0klhuiloDt+0CZtaLg=;
	h=Date:To:From:Subject:Message-Id; b=HLCpm8OMhP5M/20hIe2cuoYXbhusMA6G4UEm5+9smMQldD4ZK8rd9tukTn9S18LqoYWyoFCH7/vJHZ4QDWmqDXcKdbUg7fiUzZY32jCremcMGnZ7m5YFrw14mcg/V0rC00eyCyZLHgprwriM2cIjBqcd/DEd6QREsFjgR/fw0D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OJNmfXYE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OJNmfXYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27607C4CEF1;
	Tue, 19 Aug 2025 23:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755646590;
	bh=1skGaMpaLQ0s+qI/ImgxzQzEO0klhuiloDt+0CZtaLg=;
	h=Date:To:From:Subject:From;
	b=OJNmfXYEJDVEFwwoIjg+S+j0TBgFELgmk61Dz+ZIT25saghgg5r3HITiI3nkgiaZS
	 F/ZOOg5O6bFuH1uedwT0PaezXG//pEsoNX0PA3hVubeEmS7g3fJd75CQil1nEwawiV
	 LXPILMrie9PYcc1ITRgL/S+4OU/Ww+GrfY7d719o=
Date: Tue, 19 Aug 2025 16:36:29 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,scottzhguo@tencent.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] squashfs-fix-memory-leak-in-squashfs_fill_super.patch removed from -mm tree
Message-Id: <20250819233630.27607C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix memory leak in squashfs_fill_super
has been removed from the -mm tree.  Its filename was
     squashfs-fix-memory-leak-in-squashfs_fill_super.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


