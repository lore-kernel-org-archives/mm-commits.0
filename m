Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C583939A2
	for <mm-commits@vger.kernel.org>; Wed, 29 Jul 2026 04:14:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785298499; cv=none; b=brSLXW8xrbojeMw/tQ5nZ1RW5nkvQ/SvxZyGH/3J1FGJ988hm8zjCGxpulvbztXSX5fcYlMpxKflyRlJAIhpNCJ24Pq06cv+a1uqCoF0IYcqXt+0st1EhgXgWiIIgtN+hgO7Pqzmg5O3TYlD6ZW3oElUkdZl3ohlN7AzsX5e57s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785298499; c=relaxed/simple;
	bh=1IAMdn6nNA1XBrcP28XAqK9knG01ngknvWprc2tzel4=;
	h=Date:To:From:Subject:Message-Id; b=D40CWvkREffVfi342QQaYCOMhrABrHc5QJFdKtRlBmOOVLc1QH/wzopajMfPIBFjADzIzEzozlDzBmcoN9pmyc7Dzloz/x+pOK0ISArRdCyNNek+QsatY9qNA6kHNz43v1aCGEu89b9yO452tpNP9dncWvzlca04u7DnLPXUUXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=g2ZjuFjS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="g2ZjuFjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D986C1F00A3A;
	Wed, 29 Jul 2026 04:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785298498;
	bh=7Xh1z+6VXtKkpKNwFg9hcAgnNuO8XCwMYXh0pqcGd3U=;
	h=Date:To:From:Subject;
	b=g2ZjuFjSCQrrx+TjWheqlvn/Vp+OSjxqR7rAwoLOaJ76LTef4+dGseGqCFnR+EOtl
	 HQge3+AHd+6T5CaK5sVp4FioQK+ftcG7/QyYbSvclOPwDgb8nTaFir6pFZVFW15KBj
	 ud5DgYx8A4gA/+UjC7smlliqN/uImKrLuDvcvWmA=
Date: Tue, 28 Jul 2026 21:14:57 -0700
To: mm-commits@vger.kernel.org,xueyuan.chen21@gmail.com,senozhatsky@chromium.org,nphamcs@gmail.com,minchan@kernel.org,joshua.hahnjy@gmail.com,baohua@kernel.org,haowenchao@xiaomi.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zsmalloc-document-free_zspage-helper-variants.patch removed from -mm tree
Message-Id: <20260729041457.D986C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zsmalloc: document free_zspage helper variants
has been removed from the -mm tree.  Its filename was
     mm-zsmalloc-document-free_zspage-helper-variants.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Wenchao Hao <haowenchao@xiaomi.com>
Subject: mm/zsmalloc: document free_zspage helper variants
Date: Fri, 26 Jun 2026 09:50:03 +0800

After splitting __free_zspage() into a lockless core and a wrapper that
does the class-stat bookkeeping, three similarly-named helpers coexist:
free_zspage / __free_zspage / __free_zspage_lockless.

Add a comment block above them describing what each does and where it is
used, so the names are not easy to confuse.

No functional change.

Link: https://lore.kernel.org/20260626015003.2965881-5-haowenchao22@gmail.com
Signed-off-by: Wenchao Hao <haowenchao@xiaomi.com>
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zsmalloc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/mm/zsmalloc.c~mm-zsmalloc-document-free_zspage-helper-variants
+++ a/mm/zsmalloc.c
@@ -877,6 +877,22 @@ unlock:
 	return 0;
 }
 
+/*
+ * Three free helpers, kept apart here:
+ *
+ * __free_zspage_lockless(): bare core; walks zpdescs and returns pages
+ *   to the buddy allocator.  Caller owns all zpdesc locks and has
+ *   removed the zspage from its class list.  Used by zs_free() outside
+ *   class->lock so the buddy-side work does not stall the class.
+ *
+ * __free_zspage(): __free_zspage_lockless() + per-class accounting,
+ *   under class->lock.  Used by async_free_zspage(), the worker for
+ *   zspages whose trylock_zspage() failed.
+ *
+ * free_zspage(): full wrapper - trylock zpdescs, remove from class
+ *   list, call __free_zspage(); kicks deferred free on contention.
+ *   Used by compaction.
+ */
 static inline void __free_zspage_lockless(struct zspage *zspage)
 {
 	struct zpdesc *zpdesc, *next;
_

Patches currently in -mm which might be from haowenchao@xiaomi.com are


