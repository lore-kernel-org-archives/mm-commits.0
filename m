Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5D7537F6
	for <mm-commits@vger.kernel.org>; Mon, 29 Jan 2024 06:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706509298; cv=none; b=cFkR9MVUrVppWslVLj5ASfAH4ow0ZAHrrKMWwd4aSrwAiKfLNUqFHiEjm2F8CpH08wVwMppxcfFhmOCQu11OJc2R9DdJBHYNqiAfVghoc6i272aw+yZnqd1XGoQMpJmCB2SGhIOprxeBjApPRbOugjgtok/0InpSxNt7NGyS6UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706509298; c=relaxed/simple;
	bh=tf3M02ZmJBpUsPHpiyHSvVaSHYc5EPJAVmn+2ZpkVaw=;
	h=Date:To:From:Subject:Message-Id; b=UJvVYxlNDx7YXEZWOLRoBwZkCtLqC9nzvWT3SsSfCLg9UbUM6H6stP4PZvbEx+6s7oqoF0/mydq1rDa2ZVLA5zIC08jtEdkdUcJVEq5KvBSlS9/wTNdYqGF0rnZNJfe4S2gsX15wflAB4QN9Ws6dlKOivSH5PavT1j28RQ8KkMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FNp6EV8n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FNp6EV8n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E38AC433B1;
	Mon, 29 Jan 2024 06:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1706509298;
	bh=tf3M02ZmJBpUsPHpiyHSvVaSHYc5EPJAVmn+2ZpkVaw=;
	h=Date:To:From:Subject:From;
	b=FNp6EV8nwswrSzQ7IijFusYznSF+ld7Bt4MO94N8hTt1CoaQ5OjhTDKH/f+xGVWdF
	 ww4uEfjbbd97ZYbEnx7QW9ftu8ewhvXUfEwOVZum8PggV3cDPZ6ZwWOr4TYLYkChNN
	 WD2Y/Qjf2AJQU6l/zmnvTadq0VwAmQeAoL5D5o6k=
Date: Sun, 28 Jan 2024 22:21:34 -0800
To: mm-commits@vger.kernel.org,yosryahmed@google.com,nphamcs@gmail.com,hannes@cmpxchg.org,chriscli@google.com,zhouchengming@bytedance.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch added to mm-unstable branch
Message-Id: <20240129062137.6E38AC433B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/zswap: don't return LRU_SKIP if we have dropped lru lock
has been added to the -mm mm-unstable branch.  Its filename is
     mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch

This patch will later appear in the mm-unstable branch at
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
From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: mm/zswap: don't return LRU_SKIP if we have dropped lru lock
Date: Sun, 28 Jan 2024 13:28:49 +0000

Patch series "mm/zswap: fix race between lru writeback and swapoff", v2.

This series mainly fix the race problem between lru writeback and swapoff,
which is spotted by Yosry [1]. Please see the commits for details.

[1] https://lore.kernel.org/all/CAJD7tkasHsRnT_75-TXsEe58V9_OW6m3g6CF7Kmsvz8CKRG_EA@mail.gmail.com/


This patch (of 3):

LRU_SKIP can only be returned if we don't ever dropped lru lock, or we
need to return LRU_RETRY to restart from the head of lru list.

Otherwise, the iteration might continue from a cursor position that was
freed while the locks were dropped.

Actually we may need to introduce another LRU_STOP to really terminate the
ongoing shrinking scan process, when we encounter a warm page already in
the swap cache.  The current list_lru implementation doesn't have this
function to early break from __list_lru_walk_one.

Link: https://lkml.kernel.org/r/20240126-zswap-writeback-race-v2-1-b10479847099@bytedance.com
Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Reviewed-by: Nhat Pham <nphamcs@gmail.com>
Cc: Chris Li <chriscli@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/zswap.c~mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock
+++ a/mm/zswap.c
@@ -901,10 +901,8 @@ static enum lru_status shrink_memcg_cb(s
 		 * into the warmer region. We should terminate shrinking (if we're in the dynamic
 		 * shrinker context).
 		 */
-		if (writeback_result == -EEXIST && encountered_page_in_swapcache) {
-			ret = LRU_SKIP;
+		if (writeback_result == -EEXIST && encountered_page_in_swapcache)
 			*encountered_page_in_swapcache = true;
-		}
 
 		goto put_unlock;
 	}
_

Patches currently in -mm which might be from zhouchengming@bytedance.com are

mm-zswap-make-sure-each-swapfile-always-have-zswap-rb-tree.patch
mm-zswap-split-zswap-rb-tree.patch
mm-zswap-dont-return-lru_skip-if-we-have-dropped-lru-lock.patch
mm-zswap-fix-race-between-lru-writeback-and-swapoff.patch
mm-list_lru-remove-list_lru_putback.patch

