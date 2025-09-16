Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9776B13C9C4
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757996332; cv=none; b=XDWr7pnrUk/NAqpF+pJNPhmEjvJ2v2XEuAtuLQx3m8AT4dKNU1ppYhhFM6faqIiMfUKDNM5Og7ADtkoeHpNTybhpCkoSG7+WmvrbZWNiaEwThDwgu5c/e0rnIhXOs4GxR0gAXhboEYJaWHmnwegYdWZrtdPOJolM+8WOvFsnjCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757996332; c=relaxed/simple;
	bh=68j6flCmY2XvjatuBO8L0fBmThD8yf9yGCohvIYy7jQ=;
	h=Date:To:From:Subject:Message-Id; b=QJEk16jPs1Uwy/Ht0XQGWD/dN0VpqYvRuFDV1wlXH5XFAyM3AKkheCMH/2EeQNKZ+OvGC5K5gmhVNySm5U/t2TalNMysntySSogVP86QvFy4WARgUgfYmMQwc7+wfETJuqaW+1b33Fjsc3ajDmVXsx3l3UiLinq8QMKlhds5LM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=r8Gr5qOn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="r8Gr5qOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE8B9C4CEEB;
	Tue, 16 Sep 2025 04:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757996331;
	bh=68j6flCmY2XvjatuBO8L0fBmThD8yf9yGCohvIYy7jQ=;
	h=Date:To:From:Subject:From;
	b=r8Gr5qOn4xK/XG7YrmyXktuWaiLKImbz0L0OfZtL26F/py80w//pqkKPOyBeiTpWG
	 J5hohgWWx0xzLOQiouVdxVp/bulhI8f8WpcWmwPSor3BqIjP6xDOj/5vf27UaMb8Gn
	 JdLtsVNwN/NEm11WY1wy7igpSeRBugYD6mnoykCs=
Date: Mon, 15 Sep 2025 21:18:51 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-effective-quota-on-first-charge-window.patch added to mm-new branch
Message-Id: <20250916041851.BE8B9C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: set effective quota on first charge window
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-set-effective-quota-on-first-charge-window.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-set-effective-quota-on-first-charge-window.patch

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
Subject: mm/damon/core: set effective quota on first charge window
Date: Mon, 15 Sep 2025 20:23:36 -0700

The effective quota of a scheme is initialized zero, which means there is
no quota.  It is set based on user-specified time/quota/quota goals.  But
the later value set is done only from the second charge window.  As a
result, a scheme having a user-specified quota can work as not having the
quota (unexpectedly fast) for the first charge window.  In practical and
common use cases the quota interval is not too long, and the scheme's
target access pattern is restrictive.  Hence the issue should be modest. 
That said, it is apparently an unintended misbehavior.  Fix the problem by
setting esz on the first charge window.

Link: https://lkml.kernel.org/r/20250916032339.115817-3-sj@kernel.org
Fixes: 1cd243030059 ("mm/damon/schemes: implement time quota") # 5.16.x
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-set-effective-quota-on-first-charge-window
+++ a/mm/damon/core.c
@@ -2142,8 +2142,10 @@ static void damos_adjust_quota(struct da
 		return;
 
 	/* First charge window */
-	if (!quota->total_charged_sz && !quota->charged_from)
+	if (!quota->total_charged_sz && !quota->charged_from) {
 		quota->charged_from = jiffies;
+		damos_set_effective_quota(quota);
+	}
 
 	/* New charge window starts */
 	if (time_after_eq(jiffies, quota->charged_from +
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-lru_sort-use-param_ctx-for-damon_attrs-staging.patch
mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

