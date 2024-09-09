Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32C18D647
	for <mm-commits@vger.kernel.org>; Mon,  9 Sep 2024 23:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725925312; cv=none; b=Vzu3RnxAz7/ZiZotd3pbRi2CyImYFxPn9EqWnlz+7Ywe6mQB6gaiQFtI6for2/X6ZPDMB44k4kI6HmyrIktdqUaA0QhT45pDrNdlQUx1IOwBoRGOFr1pIcuNSdRnLquCpGZGG+6zDQdvNSVuAO9LGMpqD5eNRRPZCmPNCwgJFoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725925312; c=relaxed/simple;
	bh=M4NrMdvl/wBlzhhVIjuce1+ckH4rW7zbd3uPHoRr774=;
	h=Date:To:From:Subject:Message-Id; b=nAUJUpNnNrnmOG9tHD9AXl7LcmVuTetdZTfgkBqzGDCd00ttbNMBD3RJkUH1s/KTzC2je3oJrcyvMDGvKtiSxCjIVP3HoLjbAYA7LxpeZEDpjSmT6cEgQ15DmjZ252meLZCbqN2+5jE7ahcJOK0x1osMnNumVB2WJJkj+vgcXhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hwZBbwG5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hwZBbwG5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A228CC4CEC5;
	Mon,  9 Sep 2024 23:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725925312;
	bh=M4NrMdvl/wBlzhhVIjuce1+ckH4rW7zbd3uPHoRr774=;
	h=Date:To:From:Subject:From;
	b=hwZBbwG5O302giiT0eXyGyHspTc9Xed5/XO8PBlAmYqPDrQG5ScVxh9EIbf/uUM4L
	 f2vt0i65j8d8cztxB8PhVli4YxXlPpKRaJXEUK2/J3p4Q45B7LIVop2gFDtJ965G57
	 hn8XXbXDXRJpLUyKnJ2FUYxHfVjvz2uRxtnl0j/Y=
Date: Mon, 09 Sep 2024 16:41:52 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,hughd@google.com,hannes@cmpxchg.org,kinseyho@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-dont-hold-css-refcnt-during-traversal.patch removed from -mm tree
Message-Id: <20240909234152.A228CC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: don't hold css->refcnt during traversal
has been removed from the -mm tree.  Its filename was
     mm-dont-hold-css-refcnt-during-traversal.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kinsey Ho <kinseyho@google.com>
Subject: mm: don't hold css->refcnt during traversal
Date: Thu, 5 Sep 2024 00:30:51 +0000

To obtain the pointer to the next memcg position, mem_cgroup_iter()
currently holds css->refcnt during memcg traversal only to put css->refcnt
at the end of the routine.  This isn't necessary as an rcu_read_lock is
already held throughout the function.  The use of the RCU read lock with
css_next_descendant_pre() guarantees that sibling linkage is safe without
holding a ref on the passed-in @css.

Remove css->refcnt usage during traversal by leveraging RCU.

Link: https://lkml.kernel.org/r/20240905003058.1859929-3-kinseyho@google.com
Signed-off-by: Kinsey Ho <kinseyho@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

--- a/mm/memcontrol.c~mm-dont-hold-css-refcnt-during-traversal
+++ a/mm/memcontrol.c
@@ -1013,20 +1013,7 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		else if (reclaim->generation != iter->generation)
 			goto out_unlock;
 
-		while (1) {
-			pos = READ_ONCE(iter->position);
-			if (!pos || css_tryget(&pos->css))
-				break;
-			/*
-			 * css reference reached zero, so iter->position will
-			 * be cleared by ->css_released. However, we should not
-			 * rely on this happening soon, because ->css_released
-			 * is called from a work queue, and by busy-waiting we
-			 * might block it. So we clear iter->position right
-			 * away.
-			 */
-			(void)cmpxchg(&iter->position, pos, NULL);
-		}
+		pos = READ_ONCE(iter->position);
 	} else if (prev) {
 		pos = prev;
 	}
@@ -1067,9 +1054,6 @@ struct mem_cgroup *mem_cgroup_iter(struc
 		 */
 		(void)cmpxchg(&iter->position, pos, memcg);
 
-		if (pos)
-			css_put(&pos->css);
-
 		if (!memcg)
 			iter->generation++;
 	}
_

Patches currently in -mm which might be from kinseyho@google.com are


