Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 950B513AD1C
	for <mm-commits@vger.kernel.org>; Sun, 29 Mar 2026 00:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744947; cv=none; b=o/yoY6o+UAdDDEwE8eeY2h1sQF/XtiSN6G3jVSNFBUjbLOfy9pKLYmWxUNtzzMUF1XF5V8rNtdvgQ7wERZMvlp2fqEFHih3xg9QiCxyGUHFqaIlEGIxayARMhcNEbzBc9IJHRjL5+ctafjOens2jvxEEv25mnjaleUO45JdZqZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744947; c=relaxed/simple;
	bh=zQ0YSFyMXNEth1ai84s1AzD9ltMWSIptpgFNj3keMQA=;
	h=Date:To:From:Subject:Message-Id; b=rZ7XHTE1z+tZmQDw3nYQRTltoeGaBGZfEbWFdUHFNtXW3kLMASiR8q3hrZmzDocEDMdJPr0JHb8kU3V7E9w/Q/xVFQ8wiG8XdEUXm2Pus9SaEcUXvkwmq6ijF7Wq/Rv860sPaHKiATtYTkXIeqM/LGbMyw93XkjjDGgyLLqZzk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=F9mdzdWE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="F9mdzdWE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE1BC4CEF7;
	Sun, 29 Mar 2026 00:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744947;
	bh=zQ0YSFyMXNEth1ai84s1AzD9ltMWSIptpgFNj3keMQA=;
	h=Date:To:From:Subject:From;
	b=F9mdzdWEZOK91jQSFJjYheu6cUGWmJUwqqFlD/5xCmpxkxy4u+Y0MKZ6spB99gaWI
	 rf2bdVy5kVx/rKPyPKUpggEUMr3X6Lkz+SKGw1QjZjvPOZbwgX3Ghianaeu2D4plTn
	 VYU9/3BrBD6cDI1us44ECa5sj5C9nXPVKGrq7ON8=
Date: Sat, 28 Mar 2026 17:42:26 -0700
To: mm-commits@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,zhuhui@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch removed from -mm tree
Message-Id: <20260329004227.6AE1BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: zsmalloc: return -EBUSY for zspage migration lock contention
has been removed from the -mm tree.  Its filename was
     zsmalloc-return-ebusy-for-zspage-migration-lock-contention.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: teawater <zhuhui@kylinos.cn>
Subject: zsmalloc: return -EBUSY for zspage migration lock contention
Date: Thu, 19 Mar 2026 14:59:24 +0800

movable_operations::migrate_page() should return an appropriate error code
for temporary migration failures so the migration core can handle them
correctly.

zs_page_migrate() currently returns -EINVAL when zspage_write_trylock()
fails.  That path reflects transient lock contention, not invalid input,
so -EINVAL is clearly wrong.

However, -EAGAIN is also inappropriate here: the zspage's reader-lock
owner may hold the lock for an unbounded duration due to slow
decompression or reader-lock owner preemption.  Since migration retries
are bounded by NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
delay between attempts, there is no guarantee the lock will be released in
time for a retry to succeed.  -EAGAIN implies "try again soon", which does
not hold in this case.

Return -EBUSY instead, which more accurately conveys that the resource is
occupied and migration cannot proceed at this time.

Link: https://lkml.kernel.org/r/20260319065924.69337-1-hui.zhu@linux.dev
Signed-off-by: teawater <zhuhui@kylinos.cn>
Acked-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/zsmalloc.c~zsmalloc-return-ebusy-for-zspage-migration-lock-contention
+++ a/mm/zsmalloc.c
@@ -1727,7 +1727,19 @@ static int zs_page_migrate(struct page *
 	if (!zspage_write_trylock(zspage)) {
 		spin_unlock(&class->lock);
 		write_unlock(&pool->lock);
-		return -EINVAL;
+		/*
+		 * Return -EBUSY but not -EAGAIN: the zspage's reader-lock
+		 * owner may hold the lock for an unbounded duration due to a
+		 * slow decompression or reader-lock owner preemption.
+		 * Since migration retries are bounded by
+		 * NR_MAX_MIGRATE_PAGES_RETRY and performed with virtually no
+		 * delay between attempts, there is no guarantee the lock will
+		 * be released in time for a retry to succeed.
+		 * -EAGAIN implies "try again soon", which does not hold here.
+		 * -EBUSY more accurately conveys "resource is occupied,
+		 * migration cannot proceed".
+		 */
+		return -EBUSY;
 	}
 
 	/* We're committed, tell the world that this is a Zsmalloc page. */
_

Patches currently in -mm which might be from zhuhui@kylinos.cn are

mm-memcontrol-batch-memcg-charging-in-__memcg_slab_post_alloc_hook.patch

