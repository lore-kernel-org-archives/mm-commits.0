Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150363839A9
	for <mm-commits@vger.kernel.org>; Tue, 25 Aug 2026 01:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787622988; cv=none; b=eRlGrxdC344T7koq7OpjDRb/Cny4Bm3oemWePWxDtVp7u5y4MNRKxmUjXuDH9KaYwO7a/XXo8Bv8ZHNBCXo+HRt6e74bDYflLZCSYr+ICL4yX/RDCvQaWWkgdSh+T4WV+7Jc/CkkIU9H/JLrWbomQ6BxRURwDprSZqX7jQXiBIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787622988; c=relaxed/simple;
	bh=i0joe9Gd5qoGdxuV7nEAB/XZuNldxOApBw6gWVg/ufs=;
	h=Date:To:From:Subject:Message-Id; b=ONTLBV0/dxHqq0F0jYoRvsZSvQrJFbiLgcqISSEbDEHDaEJsyl9tkNfV3R7mv3phhPJbW20mKIvGs6OFnIKyYJWMX3QYgZA2fMInp9G8FOL9bGPds5goC1ibF/7Gqx0Zni8LCL2vdac+euKHT36iTTaLmMoIdK1jzysVEdJYKe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=RyNxkOll; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="RyNxkOll"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DAB1F00A3A;
	Tue, 25 Aug 2026 01:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1787622986;
	bh=NOW5BzXOwh26ybeBTmFrKpmsHEnZjZX8uxvOCMYZqDg=;
	h=Date:To:From:Subject;
	b=RyNxkOllzbO9HrKMEtaLjny1BqlwuehjIQx1p6WX/oNg9jwqsjHzsT/WBd88dtqGw
	 FxhYXRBGOouviCeR0vzhzmVjI4MvZRUJmVdW6AVVb3SJZoW20R+m0YNY6Vm7kbnjFx
	 L1NjJNUfk7jXpiuaHG8fvUwSmGPlDnIhUECqchDo=
Date: Mon, 24 Aug 2026 18:56:26 -0700
To: mm-commits@vger.kernel.org,will@kernel.org,riel@surriel.com,peterz@infradead.org,mingo@redhat.com,longman@redhat.com,leitao@debian.org,joe@perches.com,jgg@ziepe.ca,clm@meta.com,cel@kernel.org,boqun.feng@gmail.com,liam@infradead.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] maple_tree-fix-argument-name-in-header.patch removed from -mm tree
Message-Id: <20260825015626.B4DAB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: maple_tree: fix argument name in header
has been removed from the -mm tree.  Its filename was
     maple_tree-fix-argument-name-in-header.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Liam R. Howlett (Oracle)" <liam@infradead.org>
Subject: maple_tree: fix argument name in header
Date: Fri, 21 Aug 2026 15:26:25 -0400

The mas_prev_range() function takes a min and not a max.

Link: https://lore.kernel.org/20260821192627.4085470-18-liam@infradead.org
Fixes: 6b9e93e01020 ("maple_tree: add mas_prev_range() and mas_find_range_rev interface")
Signed-off-by: Liam R. Howlett (Oracle) <liam@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Breno Leitao <leitao@debian.org>
Cc: Chris Mason <clm@meta.com>
Cc: Chuck Lever <cel@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Joe Perches <joe@perches.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/maple_tree.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/maple_tree.h~maple_tree-fix-argument-name-in-header
+++ a/include/linux/maple_tree.h
@@ -577,7 +577,7 @@ void maple_tree_init(void);
 void mas_destroy(struct ma_state *mas);
 
 void *mas_prev(struct ma_state *mas, unsigned long min);
-void *mas_prev_range(struct ma_state *mas, unsigned long max);
+void *mas_prev_range(struct ma_state *mas, unsigned long min);
 void *mas_next(struct ma_state *mas, unsigned long max);
 void *mas_next_range(struct ma_state *mas, unsigned long max);
 
_

Patches currently in -mm which might be from liam@infradead.org are


