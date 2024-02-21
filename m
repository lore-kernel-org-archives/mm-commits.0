Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E79E14A1D
	for <mm-commits@vger.kernel.org>; Wed, 21 Feb 2024 22:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708554256; cv=none; b=TlWZsmAAAbDvVxDVP44221pRKmGVgFIZT7hZfSw5ORu5kRsPpCHeuf+0QPohkpEYn+EzLe8ACGP9PfDdX3bKEe2E+HS9sZNwuAo376unJc6j5JaoqMBw8oa5Rrt1LAht5SXKkYRRHNYc+X9vauS7A2MVgXSVWM3S8aVV5Edp/H4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708554256; c=relaxed/simple;
	bh=1bQHjpMr2afQrd156MCGH5b+JFCe7j5fNU3kkMgay7Y=;
	h=Date:To:From:Subject:Message-Id; b=ES9IfWMxCPRd7GViP5Q+fUktFCsef2YGBn8uXRx2xJnbcnHeXscJ+0Hv1eG0N4KB5QUY34RlCNOqM0TI12xbeO1Z4XeN10tTNZSDcPgeKtYVWPQLYUMyIkB64riUYXaVSjZo18W6wXst5gcPmdBR1H65P4tJ7OqDXvqZt+Ouv0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Vlr/0rcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Vlr/0rcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B15C43390;
	Wed, 21 Feb 2024 22:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708554255;
	bh=1bQHjpMr2afQrd156MCGH5b+JFCe7j5fNU3kkMgay7Y=;
	h=Date:To:From:Subject:From;
	b=Vlr/0rcHon9rJ7hNuaVLiWXYuZbPNxbHwtXyWQzvcOjdA7plAn9dZJrjPh/Kwar0R
	 Eg3i1VcVvisbiPzImarXIyKRc3S50dtQZyM5XMNcBv76ycI8rHd1l0gYnVn3hV22te
	 V6xwFZpUN/tCGbwKZNvT/V48XORQ8pjf2+ETWzYw=
Date: Wed, 21 Feb 2024 14:24:14 -0800
To: mm-commits@vger.kernel.org,hannes@cmpxchg.org,cerasuolodomenico@gmail.com,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-z3fold-remove-unneeded-spinlock.patch removed from -mm tree
Message-Id: <20240221222415.66B15C43390@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/z3fold: remove unneeded spinlock
has been removed from the -mm tree.  Its filename was
     mm-z3fold-remove-unneeded-spinlock.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: remove unneeded spinlock
Date: Sun, 4 Feb 2024 20:54:04 +0800

There is no need to use spinlock in this section, so remove it.

Link: https://lkml.kernel.org/r/20240204125404.2112384-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-remove-unneeded-spinlock
+++ a/mm/z3fold.c
@@ -442,8 +442,6 @@ static void __release_z3fold_page(struct
 	WARN_ON(!list_empty(&zhdr->buddy));
 	set_bit(PAGE_STALE, &page->private);
 	clear_bit(NEEDS_COMPACTING, &page->private);
-	spin_lock(&pool->lock);
-	spin_unlock(&pool->lock);
 
 	if (locked)
 		z3fold_page_unlock(zhdr);
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are

mm-z3fold-remove-unneeded-spinlock-in-z3fold_alloc.patch
mm-z3fold-fix-the-comment-for-__encode_handle.patch

