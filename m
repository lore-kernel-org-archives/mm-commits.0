Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C2125CB
	for <mm-commits@vger.kernel.org>; Thu, 22 Feb 2024 00:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708560085; cv=none; b=RGC4zdJlHSe8shpZm6js87togKu9yMv+5CLt23metqrdmh/8i/YSiJ6BRjwuQjPuVJuLtuWJ3/tiBtJujJibIP7voDqtIY6yIgdUZzBksK9TG8/STOgl0LqK9cQgiZZeiZK8Li1elWIgqohdjGg6PoyStunRhzE14OMkF4rzLz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708560085; c=relaxed/simple;
	bh=Jvsjwud7KU057GeQusqYN62npPMHdzR1rZ7JR+TGCjQ=;
	h=Date:To:From:Subject:Message-Id; b=u5SkkssbCpv6aPAQjKdrzUjk2TYuF2Cs7jdzMJUOvFbysiL+IunLrsZBOK4SSaUEtNjIHkwHI3HbPTI2QY7MUvcYcRO+yth72J5wS76Slza25Hhj+6nZJDfFUuyloXjBQI79sCCnLA30haE4yDzJ23/aN7IRCNObLKw4buBK/UY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rYlovuAF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rYlovuAF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F653C433C7;
	Thu, 22 Feb 2024 00:01:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1708560085;
	bh=Jvsjwud7KU057GeQusqYN62npPMHdzR1rZ7JR+TGCjQ=;
	h=Date:To:From:Subject:From;
	b=rYlovuAFs2A68AgVdAqM5HJCjvStoRWHdRYkC5oYib4eaegEdo/YUFPtUqu3h63y0
	 mPRN2TrylwUZb2wWu6jiCdESksB7dRUHntf55j9Qe67P0MX6U4AF0wO2vy2MfXMAzQ
	 nOj5/1S/T2Mgw0bndUB4jPGZZiP6GlexOIkp/GDg=
Date: Wed, 21 Feb 2024 16:01:24 -0800
To: mm-commits@vger.kernel.org,vitaly.wool@konsulko.com,sjenning@redhat.com,nphamcs@gmail.com,hannes@cmpxchg.org,ddstreet@ieee.org,chrisl@kernel.org,debug.penguin32@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-zswap-improve-with-alloc_workqueue-call.patch removed from -mm tree
Message-Id: <20240222000125.5F653C433C7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/zswap: improve with alloc_workqueue() call
has been removed from the -mm tree.  Its filename was
     mm-zswap-improve-with-alloc_workqueue-call.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Ronald Monthero <debug.penguin32@gmail.com>
Subject: mm/zswap: improve with alloc_workqueue() call
Date: Tue, 16 Jan 2024 23:31:45 +1000

The core-api create_workqueue is deprecated, this patch replaces the
create_workqueue with alloc_workqueue.  The previous implementation
workqueue of zswap was a bounded workqueue, this patch uses
alloc_workqueue() to create an unbounded workqueue.  The WQ_UNBOUND
attribute is desirable making the workqueue not localized to a specific
cpu so that the scheduler is free to exercise improvisations in any
demanding scenarios for offloading cpu time slices for workqueues.  For
example if any other workqueues of the same primary cpu had to be served
which are WQ_HIGHPRI and WQ_CPU_INTENSIVE.  Also Unbound workqueue happens
to be more efficient in a system during memory pressure scenarios in
comparison to a bounded workqueue.

shrink_wq = alloc_workqueue("zswap-shrink",
                     WQ_UNBOUND|WQ_MEM_RECLAIM, 1);

Overall the change suggested in this patch should be seamless and does not
alter the existing behavior, other than the improvisation to be an
unbounded workqueue.

Link: https://lkml.kernel.org/r/20240116133145.12454-1-debug.penguin32@gmail.com
Signed-off-by: Ronald Monthero <debug.penguin32@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Li <chrisl@kernel.org>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/zswap.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/zswap.c~mm-zswap-improve-with-alloc_workqueue-call
+++ a/mm/zswap.c
@@ -1887,7 +1887,8 @@ static int zswap_setup(void)
 		zswap_enabled = false;
 	}
 
-	shrink_wq = create_workqueue("zswap-shrink");
+	shrink_wq = alloc_workqueue("zswap-shrink",
+			WQ_UNBOUND|WQ_MEM_RECLAIM, 1);
 	if (!shrink_wq)
 		goto fallback_fail;
 
_

Patches currently in -mm which might be from debug.penguin32@gmail.com are


