Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C369A155342
	for <mm-commits@vger.kernel.org>; Thu,  6 Mar 2025 22:10:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741299026; cv=none; b=pIJnoplgdPwQK1Ezoec9jEMhQ6JN7zFBZn2EqAgyUz+ayMGv+i8EE970hLUlN8fAKiXxZBy79Men8uB0ltlfyIptyvRwBeRMo/pMmLz8NoSzbgTxdJs+qTB9me8VvhDvOKRHzlLFeubbgt9ttPMjDayy+69UxAMdxgU8wlyTfGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741299026; c=relaxed/simple;
	bh=l4j3Yo+rruS2eCRVl+HFyPHS0ZrmiZQAFiQjPdNz7/g=;
	h=Date:To:From:Subject:Message-Id; b=YwKXuQcLrgoeyFzpzf9wirxF4swu/16SllnVL0eTXJ2nlSRrW8DyF90D7jERMNTcOIOTxGQ1PG9COd3ezU0ms16uAger34+D4W3FTWR80aV3rX1kc0PZkReByOp0QawUXn+o7sLX9jGEM8FZBCPQAmDuki95PfPTILvaZETuU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=LGy08OFa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="LGy08OFa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CAB3C4CEE0;
	Thu,  6 Mar 2025 22:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1741299026;
	bh=l4j3Yo+rruS2eCRVl+HFyPHS0ZrmiZQAFiQjPdNz7/g=;
	h=Date:To:From:Subject:From;
	b=LGy08OFafVHuZL5UGkLXJST7gUexvXh0STlZiuvDtcCtsGrAISNd26sXG68DaISUX
	 YvcCoG57A/ZNwo7KAAadVC13KRTWAEupwsuJEyfA5zD36G0AudKByvmBGf7VH72Eoj
	 pW33aMmJUeidoEzMuPPSTjW+0G/+WDfbhyKNkByU=
Date: Thu, 06 Mar 2025 14:10:25 -0800
To: mm-commits@vger.kernel.org,phillip@squashfs.org.uk,zhiyuzhang999@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch added to mm-hotfixes-unstable branch
Message-Id: <20250306221026.2CAB3C4CEE0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: squashfs: fix invalid pointer dereference in squashfs_cache_delete
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch

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
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Subject: squashfs: fix invalid pointer dereference in squashfs_cache_delete
Date: Thu, 6 Mar 2025 21:28:55 +0800

When mounting a squashfs fails, squashfs_cache_init() may return an error
pointer (e.g., -ENOMEM) instead of NULL.  However, squashfs_cache_delete()
only checks for a NULL cache, and attempts to dereference the invalid
pointer.  This leads to a kernel crash (BUG: unable to handle kernel
paging request in squashfs_cache_delete).

This patch fixes the issue by checking IS_ERR(cache) before accessing it.

Link: https://lkml.kernel.org/r/20250306132855.2030-1-zhiyuzhang999@gmail.com
Fixes: 49ff29240ebb ("squashfs: make squashfs_cache_init() return ERR_PTR(-ENOMEM)")
Signed-off-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reported-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Closes: https://lore.kernel.org/linux-fsdevel/CALf2hKvaq8B4u5yfrE+BYt7aNguao99mfWxHngA+=o5hwzjdOg@mail.gmail.com/
Tested-by: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Reviewed-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/squashfs/cache.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/squashfs/cache.c~squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete
+++ a/fs/squashfs/cache.c
@@ -198,7 +198,7 @@ void squashfs_cache_delete(struct squash
 {
 	int i, j;
 
-	if (cache == NULL)
+	if (IS_ERR(cache) || cache == NULL)
 		return;
 
 	for (i = 0; i < cache->entries; i++) {
_

Patches currently in -mm which might be from zhiyuzhang999@gmail.com are

squashfs-fix-invalid-pointer-dereference-in-squashfs_cache_delete.patch

