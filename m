Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1ADA2DBF78
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 05:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280957; cv=none; b=nwziHYvixpFlgpcUyromwgfQl1tVSjWV+3XKcc6/Ov4Ohel0ELp0lUTD73tY9Sgx9SoeX5lWSB+wgpgEpOEYGB6a0/r3ZMG+tWG5nrxi7GrzqZkJX8+FdfHOPRwgphcjsfSeHm5mbZo8HfLMLJbtBcBGJ5Q8wYQgu1aaH5xjyS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280957; c=relaxed/simple;
	bh=DEyb9dRDUKRIlbJlba0s4e5wp68R3u9eAQ/puQxwYtw=;
	h=Date:To:From:Subject:Message-Id; b=Kpwd9ewrVLdLjZ5EaAvlqn89i16cD0eDD8Xg8uQVKywfrl/m96bxY9Tv5cAV7B8xR8B0ruCl6dLEKzmZhGfK39eO7Ts2AmnFoUzqOzdszBfKztBVZUs63xhpai/wHn9K+nzCLgX1uq2yYkY43dLWuppjYiwA+XPCoS29WpwRiXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=IpNhVyBx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="IpNhVyBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82D01C116C6;
	Tue, 13 Jan 2026 05:09:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768280957;
	bh=DEyb9dRDUKRIlbJlba0s4e5wp68R3u9eAQ/puQxwYtw=;
	h=Date:To:From:Subject:From;
	b=IpNhVyBxZzdTBmlnrVBeOsu+fk+/Nf87VVCzpMfBzf6QjFq/8kkQ05XPqhNcXHdhf
	 SxR2EOUSzQJISE6znljgQyyrw+0KPoSBkL+ogl+T0BKpRE7GEu/cWKScSVfmpiEvM8
	 Cml65WRSZkG5ccm2x0PWiAPYkMXSf1Lfqjn8LYp0=
Date: Mon, 12 Jan 2026 21:09:16 -0800
To: mm-commits@vger.kernel.org,harry.yoo@oracle.com,david@kernel.org,bagasdotme@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-describe-flags-parameter-in-memalloc_flags_save.patch removed from -mm tree
Message-Id: <20260113050917.82D01C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: describe @flags parameter in memalloc_flags_save()
has been removed from the -mm tree.  Its filename was
     mm-describe-flags-parameter-in-memalloc_flags_save.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: mm: describe @flags parameter in memalloc_flags_save()
Date: Fri, 19 Dec 2025 08:40:04 +0700

Patch series "mm kernel-doc fixes".

Here are kernel-doc fixes for mm subsystem.  I'm also including textsearch
fix since there's currently no maintainer for include/linux/textsearch.h
(get_maintainer.pl only shows LKML).


This patch (of 4):

Sphinx reports kernel-doc warning:

WARNING: ./include/linux/sched/mm.h:332 function parameter 'flags' not described in 'memalloc_flags_save'

Describe @flags to fix it.

Link: https://lkml.kernel.org/r/20251219014006.16328-2-bagasdotme@gmail.com
Link: https://lkml.kernel.org/r/20251219014006.16328-3-bagasdotme@gmail.com
Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
Fixes: 3f6d5e6a468d ("mm: introduce memalloc_flags_{save,restore}")
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched/mm.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/sched/mm.h~mm-describe-flags-parameter-in-memalloc_flags_save
+++ a/include/linux/sched/mm.h
@@ -325,6 +325,7 @@ static inline void might_alloc(gfp_t gfp
 
 /**
  * memalloc_flags_save - Add a PF_* flag to current->flags, save old value
+ * @flags: Flags to add.
  *
  * This allows PF_* flags to be conveniently added, irrespective of current
  * value, and then the old version restored with memalloc_flags_restore().
_

Patches currently in -mm which might be from bagasdotme@gmail.com are


