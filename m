Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334792C08CF
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995270; cv=none; b=NfOrY5KPNyMf3SVGEtegn1gioGgbAeomZJWDD0iupOnHV0C0oZpxYbIHpNO19C4bggOvEYzwl1TOgQ7h/4u0HL6XwOgHbfGeUoskpyJRHQ5UVavnfZ27y3t+lq53W+GNpsHVsJAXcdiI0NssXdcwS/tiHkGEQeFu7jed3MnmEJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995270; c=relaxed/simple;
	bh=WMkjWFZ5tyMjxpnmLuM+C0+vm7RG6r/WXBatVqFOmxA=;
	h=Date:To:From:Subject:Message-Id; b=t408XCDkKtH3q38H2o89ho+6FBl7nCDFtCaYhfygzdFrN+uw+VerI+Y6KYClgiyyavUCF8jSHLKiusPIFAA4yh8jOeWiyPgY3+VGmBjnzOiaJYoAUyaQMe2qbb6P+nDiJObd7xl8dBnw1p/rrcf3nzjKx/kitjNWyC31HDp/LEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I4MjUIga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I4MjUIga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD6C4CEEB;
	Tue, 16 Sep 2025 04:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995269;
	bh=WMkjWFZ5tyMjxpnmLuM+C0+vm7RG6r/WXBatVqFOmxA=;
	h=Date:To:From:Subject:From;
	b=I4MjUIgazg0PTHvvgDN3WZxItkutUVx+lRCwY/OZ48etf+UZTgSs9UjHioTkeaotZ
	 99iUORlquU85kChxfle3n7noPZCE8BjhFoKnz0NFyZnslqe4SGJa1xKqQu6abVqEy4
	 17Fk726gFq/pctfsgK0Y3vSn4Ei9nFlhD+LxPg8w=
Date: Mon, 15 Sep 2025 21:01:09 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-lru_sort-use-param_ctx-correctly.patch added to mm-new branch
Message-Id: <20250916040109.C3CD6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/lru_sort: use param_ctx correctly
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-lru_sort-use-param_ctx-correctly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-lru_sort-use-param_ctx-correctly.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/lru_sort: use param_ctx correctly
Date: Sun, 14 Sep 2025 18:58:04 -0700

damon_lru_sort_apply_parameters() allocates a new DAMON context, stages
user-specified DAMON parameters on it, and commits to running DAMON
context at once, using damon_commit_ctx().  The code is, however, directly
updating the monitoring attributes of the running context.  This doesn't
cause a real user problem but apparently this is an unintentional mistake
that can cause code review confusions and future real problems.  Fix the
wrong use of the parameter context.

Link: https://lkml.kernel.org/r/20250915015807.101505-4-sj@kernel.org
Fixes: a30969436428 ("mm/damon/lru_sort: use damon_commit_ctx()")
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/lru_sort.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/lru_sort.c~mm-damon-lru_sort-use-param_ctx-correctly
+++ a/mm/damon/lru_sort.c
@@ -219,7 +219,7 @@ static int damon_lru_sort_apply_paramete
 		goto out;
 	}
 
-	err = damon_set_attrs(ctx, &damon_lru_sort_mon_attrs);
+	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
 	if (err)
 		goto out;
 
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
mm-damon-lru_sort-use-param_ctx-correctly.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

