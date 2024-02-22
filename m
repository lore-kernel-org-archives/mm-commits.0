Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FEB8F4D
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560068; cv=none; b=IsdRPSBWtH3iaBWqBTGmtv0mBDx9BP4pNEKX6fOPx0ptQEDK8gG3QbXWSfzjO8bt9h+Fgss7BBVbhXR06PtV4q4OGgUgO0WQXhTLt68XJRdoDcTiZCsMK0UwR9tIjvVT/+VzbkB13e3iIYN8pUrva0yV5xBbx1tcctuSqQvL9QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560068; c=relaxed/simple;
	bh=FvnpmcTh+Pbnk2D/PAE6fh7eEoybbNyOMYvoTewG1qo=;
	h=Date:To:From:Subject:Message-Id; b=SRChPLW7dCionw+JHziZMUh9NCro9TSlmD4wxPWfNcLMCMza8vhbOCAXFw+a1pmzWOwI/Q1QACGSYJVD3AqdcocMrpJhQf8fhlSOPS7+3IEYSSeg9xmjfSgn0ib1zGS9aVkeEvToIf+j0PS6iHW4mcI0xRI/qI2OYe9ZSL5aVzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bm1iA8Kr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bm1iA8Kr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236BFC43394;
	Thu, 22 Feb 2024 00:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560068;
	bh=FvnpmcTh+Pbnk2D/PAE6fh7eEoybbNyOMYvoTewG1qo=;
	h=Date:To:From:Subject:From;
	b=bm1iA8KrpOlfZ1mgj+ObM3o17F2/KORYjU2gcBaht9rA2eKSum8UGiq13zuBQAgR4
	 JnLVGjcUM6CzIvgtbzRvNppp7EJdFsq2UP7k3K9MDX/ZkuGZHnMDQWoBYqOsXvHXcP
	 bSW7WLbq8ba87O615J4/cxDreTwlm7RJBvsgeygM=
Date: Wed, 21 Feb 2024 16:01:07 -0800
To: mm-commits@vger.kernel.org,shakeelb@google.com,roman.gushchin@linux.dev,mhocko@kernel.org,hannes@cmpxchg.org,haifeng.xu@shopee.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-list_lru-remove-unused-macro-list_lru_init_key.patch removed from -mm tree
Message-Id: <20240222000108.236BFC43394@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: list_lru: remove unused macro list_lru_init_key()
has been removed from the -mm tree.  Its filename was
     mm-list_lru-remove-unused-macro-list_lru_init_key.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Haifeng Xu <haifeng.xu@shopee.com>
Subject: mm: list_lru: remove unused macro list_lru_init_key()
Date: Thu, 28 Dec 2023 06:27:15 +0000

list_lru_init_key() isn't used by anyone, remove it to clean up.

Link: https://lkml.kernel.org/r/20231228062715.338672-2-haifeng.xu@shopee.com
Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/list_lru.h |    2 --
 1 file changed, 2 deletions(-)

--- a/include/linux/list_lru.h~mm-list_lru-remove-unused-macro-list_lru_init_key
+++ a/include/linux/list_lru.h
@@ -62,8 +62,6 @@ int __list_lru_init(struct list_lru *lru
 
 #define list_lru_init(lru)				\
 	__list_lru_init((lru), false, NULL, NULL)
-#define list_lru_init_key(lru, key)			\
-	__list_lru_init((lru), false, (key), NULL)
 #define list_lru_init_memcg(lru, shrinker)		\
 	__list_lru_init((lru), true, NULL, shrinker)
 
_

Patches currently in -mm which might be from haifeng.xu@shopee.com are


