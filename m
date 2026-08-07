Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 094D032B989
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068097; cv=none; b=BcEBx5t730jRPierMhEQu5pZHCV9IokrnbeZcqEuYP5ecIGcvHfNDqxKqrSTmvenyHRdGBeIahUl/8MALorK6nQw3kKZSVS9A3kEjqd69rofVSiMJyh65gbwdvs31iRbtXeteJE7Q6pzFIfO7xE2FNOhRFdpLGG944saIyaMcd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068097; c=relaxed/simple;
	bh=Ltin6son4qHVJecAz1HmJnYHz/j0yMDhAw4OFYpMM5I=;
	h=Date:To:From:Subject:Message-Id; b=i1WieHcN+HPsBhKwuss1DwFrsljMAcmRKHSqbWeXgEoM812oJPlUBnpPFbYP8MlGzkqN7JP2nCwI/lsqw956K330tr+9du9Z377DSKQ+Nx5UR8lP2vqP5HFAbzCa+6+nhx2d11LenpQ5QuHkKCp9gKdXtXZgUk17wfZxVGTVrN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KVEL35iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KVEL35iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964C91F00A3F;
	Fri,  7 Aug 2026 02:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068090;
	bh=jnExqwt0/u+02yLdTzl1GfNLalGm9HuXIGlAbc4TTWs=;
	h=Date:To:From:Subject;
	b=KVEL35iFGfNT6T8usba7NDeVvPutRvK533oAAmCmBieAssv13dtOCH+PZb1DaQkOZ
	 s4uAHdFy0lbp/BtpRf33WjGB0TWL5IsDeJjQE46vSYZXySwGN4vyqN0ieFu3jYJJzZ
	 QJo1t6VGeA6BmDVVbq+eldCHtQI3rIgvZU9H4DXs=
Date: Thu, 06 Aug 2026 19:01:30 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,tj@kernel.org,surenb@google.com,rppt@kernel.org,rostedt@goodmis.org,mkoutny@suse.com,mhocko@suse.com,longman@redhat.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,brendan.jackman@linux.dev,bigeasy@linutronix.de,jackmanb@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch removed from -mm tree
Message-Id: <20260807020130.964C91F00A3F@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Brendan Jackman <jackmanb@google.com>
Subject: mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
Date: Wed, 15 Jul 2026 11:03:20 +0000

Update the comment to reflect the recent change to allow flags in
gfp_nolock.

Link: https://lore.kernel.org/20260715-spin-trylock-followup-v3-3-fc4d246f705d@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=6
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-fixup-alloc_pages_nolock_noprof-comment
+++ a/mm/page_alloc.c
@@ -7982,7 +7982,8 @@ struct page *alloc_frozen_pages_nolock_n
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, plus some flags that get set
+ *             internally regardless (see %gfp_nolock) are allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *
_

Patches currently in -mm which might be from jackmanb@google.com are


