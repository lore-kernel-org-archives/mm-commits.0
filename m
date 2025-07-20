Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87CF715687D
	for <mm-commits@vger.kernel.org>; Sun, 20 Jul 2025 02:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752977368; cv=none; b=YfVqTlPVpZZmk+Vws0G7jVxsiS5NzVoq0azYNuTxeBUcQyjfG2YIXUyOXIEdGZMPIVXrFfpP8PvYoovSAyJQ3qRWDh92PI6R6cFLP9QD0q84FydMEm/XvpNKX1JxaTFTRVy0082f/fnnT6xa75j/LHz5/GhfEH8JphIhTWVOx4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752977368; c=relaxed/simple;
	bh=hpZqjU5RkPXkQjxFA65kmCvv/KlYAyQnHx/bvHKxvxE=;
	h=Date:To:From:Subject:Message-Id; b=LRQ647gilLx02s2wrpfBwuIeb8RHXjPNy74Mc9Oxv4T7/3WXbaeib3CV50gjSR9cLxvzGHbqEMPLCx3tlYmBGLcfHjNGzHcWdBoMLd2m7ZtjDO6cNkXNSTLaMMztgV8HqI5KQBkvQkXQJB/cEGrVcxfDN4INbHZ+R+q1r+U7b48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FMEptT0I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FMEptT0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A5C4CEE3;
	Sun, 20 Jul 2025 02:09:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752977368;
	bh=hpZqjU5RkPXkQjxFA65kmCvv/KlYAyQnHx/bvHKxvxE=;
	h=Date:To:From:Subject:From;
	b=FMEptT0IU4HCh3vmcxHuYY1QfVr8GoTYllIe1ju1yPiVDho0uKuuGt15iviqYADKN
	 9oRsWuxOoaxopJhv6uWmO8u1w0sXHm32QXjp43s2O4K3CQcYFNZQFTwcUcBmq5c34A
	 P1UKSQUioeYk9u58yQw04MVNEiFQqfKCO4mpVVec=
Date: Sat, 19 Jul 2025 19:09:27 -0700
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,chanho.min@lge.com,colin.i.king@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch removed from -mm tree
Message-Id: <20250720020928.5D9A5C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: squashfs: fix incorrect argument to sizeof in kmalloc_array call
has been removed from the -mm tree.  Its filename was
     squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Colin Ian King <colin.i.king@gmail.com>
Subject: squashfs: fix incorrect argument to sizeof in kmalloc_array call
Date: Tue, 8 Jul 2025 15:26:04 +0100

The sizeof(void *) is the incorrect argument in the kmalloc_array call, it
best to fix this by using sizeof(*cache_folios) instead.

Fortunately the sizes of void* and folio* happen to be the same, so this
has not shown up as a run time issue.

[akpm@linux-foundation.org: fix build]
Link: https://lkml.kernel.org/r/20250708142604.1891156-1-colin.i.king@gmail.com
Fixes: 2e227ff5e272 ("squashfs: add optional full compressed block caching")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/block.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/block.c~squashfs-fix-incorrect-argument-to-sizeof-in-kmalloc_array-call
+++ a/fs/squashfs/block.c
@@ -89,7 +89,7 @@ static int squashfs_bio_read_cached(stru
 	int err = 0;
 #ifdef CONFIG_SQUASHFS_COMP_CACHE_FULL
 	struct folio **cache_folios = kmalloc_array(page_count,
-			sizeof(void *), GFP_KERNEL | __GFP_ZERO);
+			sizeof(*cache_folios), GFP_KERNEL | __GFP_ZERO);
 #endif
 
 	bio_for_each_folio_all(fi, fullbio) {
_

Patches currently in -mm which might be from colin.i.king@gmail.com are


