Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFCF25761
	for <mm-commits@vger.kernel.org>; Mon, 13 Jan 2025 04:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736742244; cv=none; b=u/jRKv0laokSnnhog7VA3B9wo0f/MSvax8P6JULvxZTEhs4YvM7A0+vaKwylDVhnaSbF+yDqWC5EOYbFd3V40hnTFh8k9PYnwMqYIlnhs9gdnkNOwbq8LvYITJ78B/o24vg0cQGe/yDi9fQxW1MlWDYCaautnctFuezoT0xn13k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736742244; c=relaxed/simple;
	bh=7xsSazfohZwyhy+jVZnu7B4SIkysTrZXjKe2KDVICMg=;
	h=Date:To:From:Subject:Message-Id; b=a9oZv2xGHSIIsU6plGEq/N3WL4XJbMtaJBTlDCqdzTfySjJRRsEcms6Ivd25HWG5Is4PDEdDGzsEsf5KyM67LxhTm5SHEjUvcd5wk97UInIugYgJO8P7kAMScvmOm888oZF/xnv7sm8Ch/3ycszLO/Q4MeLGkzbplgvHS5oigzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NFIp51jy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NFIp51jy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056BFC4CED6;
	Mon, 13 Jan 2025 04:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1736742244;
	bh=7xsSazfohZwyhy+jVZnu7B4SIkysTrZXjKe2KDVICMg=;
	h=Date:To:From:Subject:From;
	b=NFIp51jyDW6+WsiWgFh4d5sauF9sN7WEuf4B8etT2+CY7s/KcNO4iSKOD6zDUNZ1W
	 jSYZH+ioaKRkpo9odDN31ivRfLlDyViG9qnQ0DFidnB1ihO5Zd1Hph/qqOzHRds7FC
	 Y7NEx7QznOyfKFqJGIEUsnT6Zh9D3LyR1VYO0Sp4=
Date: Sun, 12 Jan 2025 20:24:03 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch removed from -mm tree
Message-Id: <20250113042404.056BFC4CED6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: don't allocate read_page cache if SQUASHFS_FILE_DIRECT configured
has been removed from the -mm tree.  Its filename was
     squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: squashfs: don't allocate read_page cache if SQUASHFS_FILE_DIRECT configured
Date: Sun, 29 Dec 2024 23:37:50 +0000

If Squashfs has been configured to directly read datablocks into the page
cache (SQUASHFS_FILE_DIRECT), then the read_page cache is unnecessary.

This improvement is due to the following two commits, which added the
ability to read datablocks into the page cache when pages were missing,
enabling the fallback which used an intermediate buffer to be removed.

commit f268eedddf359 ("squashfs: extend "page actor" to handle missing pages")
commit 1bb1a07afad97 ("squashfs: don't use intermediate buffer if pages missing")

This reduces the amount of memory used when mounting a filesystem by
block_size * maximum number of threads.

Link: https://lkml.kernel.org/r/20241229233752.54481-3-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/squashfs.h |    6 ++++++
 fs/squashfs/super.c    |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/fs/squashfs/squashfs.h~squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured
+++ a/fs/squashfs/squashfs.h
@@ -14,6 +14,12 @@
 
 #define WARNING(s, args...)	pr_warn("SQUASHFS: "s, ## args)
 
+#ifdef CONFIG_SQUASHFS_FILE_CACHE
+#define SQUASHFS_READ_PAGES msblk->max_thread_num
+#else
+#define SQUASHFS_READ_PAGES 0
+#endif
+
 /* block.c */
 extern int squashfs_read_data(struct super_block *, u64, int, u64 *,
 				struct squashfs_page_actor *);
--- a/fs/squashfs/super.c~squashfs-dont-allocate-read_page-cache-if-squashfs_file_direct-configured
+++ a/fs/squashfs/super.c
@@ -323,7 +323,7 @@ static int squashfs_fill_super(struct su
 
 	/* Allocate read_page block */
 	msblk->read_page = squashfs_cache_init("data",
-		msblk->max_thread_num, msblk->block_size);
+		SQUASHFS_READ_PAGES, msblk->block_size);
 	if (IS_ERR(msblk->read_page)) {
 		errorf(fc, "Failed to allocate read_page block");
 		err = PTR_ERR(msblk->read_page);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are


