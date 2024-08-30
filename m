Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF2F1BC9E1
	for <mm-commits@vger.kernel.org>; Fri, 30 Aug 2024 22:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725057149; cv=none; b=ZnsAJhUUaNMH9bX9zS30emd9T0FBdIlSzxIk3y9CHTQtzdxdy45s+DOiJXq6nLQ5QNrX4bZ3jLD/p+W4ZcLWe0d6uKWwxJ6DwZt+K6QDntczNOGQxgAzCgnqaH9Y8YKwuZNJEut8jyu7pENuDkEpxelmBX6J2JzEeKAe53HyPPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725057149; c=relaxed/simple;
	bh=338koK65pmw+ovV7o7vhFiM4wOIeimDxMvB2rPGTMcA=;
	h=Date:To:From:Subject:Message-Id; b=VaIohDy/QAgeOAM8J5HWhS+CC4iyY4pNLZLzkeErvbVNyq3Q0HrXt1icrChfVZflTXDyUtj0yPexZE5Ua7+khAtJ0uq5KOHw178HtnTQ9ToMA6zG1yXlsQ+hzFz33Knv47ebIizWiey1y3HFU1IgqfWyfunrUIkTeo6sMVA67ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eNH6jnq4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eNH6jnq4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7856C4CEC2;
	Fri, 30 Aug 2024 22:32:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1725057148;
	bh=338koK65pmw+ovV7o7vhFiM4wOIeimDxMvB2rPGTMcA=;
	h=Date:To:From:Subject:From;
	b=eNH6jnq4pE2HW6DxulgQSg8ykKIS/Jzi798cEXKqUomYt6fX/xAV/XveY9jc29fFd
	 Zx/vjK5hpuh/+x0Pfloh/pM48fntmclKZhZVnwA1ONh9akPfKgpN2B4ycywkZLH5NZ
	 BmEJ8doE4iUyJB2qlfMqm6t7ma9kSplpLNY0cXtc=
Date: Fri, 30 Aug 2024 15:32:28 -0700
To: mm-commits@vger.kernel.org,yosryahmed@google.com,tjmercier@google.com,tj@kernel.org,shakeel.butt@linux.dev,roman.gushchin@linux.dev,muchun.song@linux.dev,mkoutny@suse.com,mhocko@kernel.org,lizefan.x@bytedance.com,kinseyho@google.com,hannes@cmpxchg.org,hughd@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-restart-if-multiple-traversals-raced-fix.patch added to mm-unstable branch
Message-Id: <20240830223228.B7856C4CEC2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-restart-if-multiple-traversals-raced-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-restart-if-multiple-traversals-raced-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-restart-if-multiple-traversals-raced-fix.patch

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
From: Hugh Dickins <hughd@google.com>
Subject: mm-restart-if-multiple-traversals-raced-fix
Date: Fri, 30 Aug 2024 03:04:01 -0700 (PDT)

mem_cgroup_iter() reset memcg to NULL before the goto restart, so that
goto out_unlock does not then return an ungotten memcg, causing oopses on
stale memcg in many places (often in memcg_rstat_updated()).

Link: https://lkml.kernel.org/r/56d42242-37fe-b94f-d3cb-00673f1e5efb@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Acked-by: Kinsey Ho <kinseyho@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: T.J. Mercier <tjmercier@google.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Zefan Li <lizefan.x@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-restart-if-multiple-traversals-raced-fix
+++ a/mm/memcontrol.c
@@ -1049,6 +1049,7 @@ restart:
 		if (cmpxchg(&iter->position, pos, memcg) != pos) {
 			if (css && css != &root->css)
 				css_put(css);
+			memcg = NULL;
 			goto restart;
 		}
 
_

Patches currently in -mm which might be from hughd@google.com are

mm-attempt-to-batch-free-swap-entries-for-zap_pte_range-fix-2.patch
mm-shmem-split-large-entry-if-the-swapin-folio-is-not-large-fix.patch
mm-shmem-support-large-folio-swap-out-fix.patch
mm-restart-if-multiple-traversals-raced-fix.patch
mm-shmem-fix-minor-off-by-one-in-shrinkable-calculation.patch
mm-shmem-extend-shmem_unused_huge_shrink-to-all-sizes.patch

