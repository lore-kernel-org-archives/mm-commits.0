Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF953F822B
	for <mm-commits@vger.kernel.org>; Thu, 13 Aug 2026 22:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786660979; cv=none; b=WPBvjr/CM1FMnM5zX6juYMaxTAZ8HHmKr5arn+aEmjXXN+7/PqksUBgUNR67afJV6NGN94q86RxwYR8Qdpa2zjrDnNuxtZYtjeJggKLevd7YI0Qa5QhwJ4BHQnohTI6iNi08YR1owg+oMS4JWRhbiNDuZZHoMLlrcSYxtXnrG5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786660979; c=relaxed/simple;
	bh=1/Qducu9kIn/aLGfIhWpRQPb+pcZfr1dGpH9r+klSlQ=;
	h=Date:To:From:Subject:Message-Id; b=qBTNN55jd7oaTWduPQkPkrO1t260RzBkHdcBFBetOXfG7PxNA8DuRY7GRfkUOfn8FSQEHsBprUqueXwhJ9pz4ZgzmNjSvD6AJYsZmxDa/OQ/fkD8j94958f3n64A0UL9nBks4N8oJb00H4rYFCz3d6SBEp7qB7BWDP/ARg2yDlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tYhIPYgd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tYhIPYgd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B091F00A3A;
	Thu, 13 Aug 2026 22:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786660978;
	bh=K8Ek99Tw4JpiKRn4/ud69s/738rsaHrhWuMjULGL43k=;
	h=Date:To:From:Subject;
	b=tYhIPYgdcXqjYhsNdtltyBjpRmQd85YnBD8wuPUhryFoYDb8SKXUF5Q7fbbS810IS
	 HwA2n+g0M4rVUVF0mXlFBAwV5aE3gst5onGLpvwsF9XUXd1ZwCDCeG2gG9WmNH7tMU
	 kSA7wByI8XemhovVwxvrKBFI2lcGatIBA1NwdTo0=
Date: Thu, 13 Aug 2026 15:42:57 -0700
To: mm-commits@vger.kernel.org,syjcnss@gmail.com,phillip@squashfs.org.uk,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] squashfs-check-block-offset-is-not-negative.patch removed from -mm tree
Message-Id: <20260813224258.23B091F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Squashfs: check block offset is not negative
has been removed from the -mm tree.  Its filename was
     squashfs-check-block-offset-is-not-negative.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Phillip Lougher <phillip@squashfs.org.uk>
Subject: Squashfs: check block offset is not negative
Date: Fri, 7 Aug 2026 17:29:51 +0100

If a negative offset is read off disk (for example the offset into the
decompressed fragment block), this will cause squashfs_copy_data() to
perform an out of bounds access.

Fix by checking if offset is negative, and returning 0.  This matches
existing behaviour where an offset beyond the block returns 0 bytes
copied.

To trigger this out of bounds access requires a crafted Squashfs
filesystem and CAP_SYS_ADMIN to mount it.  Unprivileged users will not be
able to mount such a filesystem, but once mounted, an unprivileged user
can trigger the out of bounds access by reading the crafted file with the
negative offset.

Link: https://lore.kernel.org/20260807162951.672510-1-phillip@squashfs.org.uk
Fixes: f400e12656ab ("Squashfs: cache operations")
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: Yuejie Shi <syjcnss@gmail.com>
Closes: https://lore.kernel.org/all/20260803032735.81785-1-syjcnss@gmail.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/cache.c~squashfs-check-block-offset-is-not-negative
+++ a/fs/squashfs/cache.c
@@ -299,7 +299,7 @@ int squashfs_copy_data(void *buffer, str
 {
 	int remaining = length;
 
-	if (length == 0)
+	if (length == 0 || offset < 0)
 		return 0;
 	else if (buffer == NULL)
 		return min(length, entry->length - offset);
_

Patches currently in -mm which might be from phillip@squashfs.org.uk are

maintainers-remove-git-url-for-squashfs.patch

