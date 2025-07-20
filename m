Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B073595E;
	Sun, 20 Jul 2025 02:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752978408; cv=none; b=cUS3zh2cY/3AeMYGpBynQ/8j090QKCzlrD2OhH3wZEKAnIuVKMnX/o4CgvY0C4FcICtxuXTfrMFImMz9iX1UElGYzsnlKygnKuTDniXto+5mEKxdnOUJqTN4qQgJnpoMIZ1mRqLCAo/eSEzY8bcxMkwB8VoDYVma3shHumvWNxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752978408; c=relaxed/simple;
	bh=3LCtwyt99keBOlHZ4x+xPQFcg3LJRjwfc6AxhUsLNb4=;
	h=Date:To:From:Subject:Message-Id; b=SWYJlPz0lP/H168a0zAOjhkeX1CoSGMLtVGL690Ao4eNoaNCxzQ4nfIa/l2qFn5rtN6kLZSxM4+INosGf5uggcuF2rr/GgRe1YXWs5Gai1vrw/yjNSeKqQa9s0NjfNkQnUz7LT/axJIJLlTMiQGoh1FWnyaUX156X4FfuSXtnxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XQSkH1jF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XQSkH1jF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E45C4CEE3;
	Sun, 20 Jul 2025 02:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752978408;
	bh=3LCtwyt99keBOlHZ4x+xPQFcg3LJRjwfc6AxhUsLNb4=;
	h=Date:To:From:Subject:From;
	b=XQSkH1jF826Fayaih5682wHiF3k7WFYzWDNNwsnywTg0V0ASLQ57SB7p+txMpmtcB
	 /nR7iKvMm4FR7okNfOkY+1pTbayh1XqYkiks+Btq3i3ckDY4vDiPaq6+T+dCrdWVZF
	 347JVYhAtJmszcTXR2tyvrJzllxufI7pemxgj8go=
Date: Sat, 19 Jul 2025 19:26:47 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,senozhatsky@chromium.org,minchan@kernel.org,david@redhat.com,harry.yoo@oracle.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch removed from -mm tree
Message-Id: <20250720022648.50E45C4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Harry Yoo <harry.yoo@oracle.com>
Subject: mm/zsmalloc: do not pass __GFP_MOVABLE if CONFIG_COMPACTION=n
Date: Fri, 4 Jul 2025 19:30:53 +0900

Commit 48b4800a1c6a ("zsmalloc: page migration support") added support for
migrating zsmalloc pages using the movable_operations migration framework.
However, the commit did not take into account that zsmalloc supports
migration only when CONFIG_COMPACTION is enabled.  Tracing shows that
zsmalloc was still passing the __GFP_MOVABLE flag even when compaction is
not supported.

This can result in unmovable pages being allocated from movable page
blocks (even without stealing page blocks), ZONE_MOVABLE and CMA area.

Possible user visible effects:
- Some ZONE_MOVABLE memory can be not actually movable
- CMA allocation can fail because of this
- Increased memory fragmentation due to ignoring the page mobility
  grouping feature  
I'm not really sure who uses kernels without compaction support, though :(


To fix this, clear the __GFP_MOVABLE flag when
!IS_ENABLED(CONFIG_COMPACTION).

Link: https://lkml.kernel.org/r/20250704103053.6913-1-harry.yoo@oracle.com
Fixes: 48b4800a1c6a ("zsmalloc: page migration support")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-do-not-pass-__gfp_movable-if-config_compaction=n
+++ a/mm/zsmalloc.c
@@ -1043,6 +1043,9 @@ static struct zspage *alloc_zspage(struc
 	if (!zspage)
 		return NULL;
 
+	if (!IS_ENABLED(CONFIG_COMPACTION))
+		gfp &= ~__GFP_MOVABLE;
+
 	zspage->magic = ZSPAGE_MAGIC;
 	zspage->pool = pool;
 	zspage->class = class->index;
_

Patches currently in -mm which might be from harry.yoo@oracle.com are


