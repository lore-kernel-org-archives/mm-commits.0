Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC7FAB663
	for <mm-commits@vger.kernel.org>; Sat, 24 Feb 2024 01:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708739437; cv=none; b=LrXb4URZIZIRcDCzL3Wc9T/OSBfRkWvgnJpdxCmzbPETozTzLldWqZ5pOQ+MjwnlnuYCZ8mslZm6R8MqZT5+2av+A3LRTAMNyzLY5Lkng1IMTZ02BWaYhuL+/D10uXqzNVGTFCHqVg7KQhQwTUzyGpfWv7FuD0gGlcSgcFPQeoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708739437; c=relaxed/simple;
	bh=y91QvSW1TDtwHYKidbWUmSjB444D+yGYeIX7dL4nX/Q=;
	h=Date:To:From:Subject:Message-Id; b=Bl2b721svrj10DqUdy/jE5fPvVy3RWcoWHFbEPjgny5ZqNJyRkQnrryEp3Swz6fR/0vzFVtBGD7DMZOkCCkb6hPobgxEI+ThP5MEfwNKAG6o1OHNrYPqlGlasellu6rG5zS68825moEtWxJ/FLJT1dFBpl9v5hn2q85WbsXMW/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2s1ke6rA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2s1ke6rA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AD9C433A6;
	Sat, 24 Feb 2024 01:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708739436;
	bh=y91QvSW1TDtwHYKidbWUmSjB444D+yGYeIX7dL4nX/Q=;
	h=Date:To:From:Subject:From;
	b=2s1ke6rALYll2JW0TtwDsRvrsoxb5wJvj0eRNQpTGOBD3RKzaI5dVT89F7ZsOwvaZ
	 Z0bvHMnF224HmBbIgkwQCK2ewts10njKLA+1eiMBvrYve6RmEmxlQoDnUBln5q/Oaa
	 D5CFsdWNQB894uizdRWNNCHKXSpJmSq5dhhMeIBA=
Date: Fri, 23 Feb 2024 17:50:35 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,linmiaohe@huawei.com,hannes@cmpxchg.org,hezhongkun.hzk@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-z3fold-fix-the-comment-for-__encode_handle.patch removed from -mm tree
Message-Id: <20240224015036.62AD9C433A6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/z3fold: fix the comment for __encode_handle()
has been removed from the -mm tree.  Its filename was
     mm-z3fold-fix-the-comment-for-__encode_handle.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Zhongkun He <hezhongkun.hzk@bytedance.com>
Subject: mm/z3fold: fix the comment for __encode_handle()
Date: Mon, 19 Feb 2024 10:44:53 +0800

The comment is confusing that Pool lock should be held as this function
accesses first_num above the __encode_handle() because first_num is the
element of z3fold_header which is protected by z3fold_header->page_lock.

I found the same comment for encode_handle() in zbud.c by accident ,Pool
lock should be held as this function accesses first|last_chunks, which is
the element of zbud_header and it does not have any lock, so pool lock
should be held.

Z3fold is based on zbud, maybe the comment come from zbud, but it was
wrong, so fix it.

Link: https://lkml.kernel.org/r/20240219024453.2240147-1-hezhongkun.hzk@bytedance.com
Signed-off-by: Zhongkun He <hezhongkun.hzk@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/z3fold.c~mm-z3fold-fix-the-comment-for-__encode_handle
+++ a/mm/z3fold.c
@@ -364,8 +364,9 @@ static inline int __idx(struct z3fold_he
 }
 
 /*
- * Encodes the handle of a particular buddy within a z3fold page
- * Pool lock should be held as this function accesses first_num
+ * Encodes the handle of a particular buddy within a z3fold page.
+ * Zhdr->page_lock should be held as this function accesses first_num
+ * if bud != HEADLESS.
  */
 static unsigned long __encode_handle(struct z3fold_header *zhdr,
 				struct z3fold_buddy_slots *slots,
_

Patches currently in -mm which might be from hezhongkun.hzk@bytedance.com are


