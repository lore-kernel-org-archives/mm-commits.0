Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ACE2289E07
	for <mm-commits@vger.kernel.org>; Tue, 16 Sep 2025 04:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757995268; cv=none; b=EDnm87Cr67fGHxWKOH6JEYWlkezsX9xT7a+1jEUT+PnoTstsdMq32fzzMza7e+Q6hpHlgD+XEJVEujDHm08ZJEYfDunYndXF2dVhMjdKDmQsLlDRJMCua3RwcTHxzUOoRLfFXOkBSOdBBfpZ8EoTRUa5ImDx8IwdjAUQSqK5Oes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757995268; c=relaxed/simple;
	bh=lnEQtuITlz0+hibDVaWad0z7mqL2fjGWaT6alqcOH/E=;
	h=Date:To:From:Subject:Message-Id; b=audFoF0vtHlbZcA36KvwCz7aAmVjIrE9xX7xZ3pnEaykroiRm3z4GUxJ6ef43+4q+5ST2okc9fDMsKSZjZsdIC+NUjzusHp3r3/QSfVZLEDALRvE5VkceFNOQ4sgww9mzppWzbTwkHhALJg3te5zgNQ25CgMQva0eQwUCCZe3t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=NLCNxUkO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="NLCNxUkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA1DC4CEEB;
	Tue, 16 Sep 2025 04:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757995267;
	bh=lnEQtuITlz0+hibDVaWad0z7mqL2fjGWaT6alqcOH/E=;
	h=Date:To:From:Subject:From;
	b=NLCNxUkOx/VhmgxMZFaNSOghdM9fyGNAqy3vCCJzOpvFDNsewhgeP6KMWFChEVJsj
	 nVhjXm5FGyZ3xKQD5K8L3ntBUO+1hlyaNges7pZlGPYF0CiWT6OLlJ7VahQd1fqhha
	 kaZfYmA4K1P2IfjTxOHfngq+TQ3XVHOJKRn4h2I0=
Date: Mon, 15 Sep 2025 21:01:07 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,rppt@kernel.org,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,joshua.hahnjy@gmail.com,david@redhat.com,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-set-effective-quota-on-first-charge-window.patch added to mm-new branch
Message-Id: <20250916040107.BFA1DC4CEEB@smtp.kernel.org>
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
Date: Sun, 14 Sep 2025 18:58:03 -0700

The effective quota of a scheme is initialized zero, which means there is
no quota.  It is set based on user-specified time/quota/quota goals.  But
the later value set is done only from the second charge window.  As a
result, a scheme having a user-specified quota can work as not having the
quota (unexpectedly fast) for the first charge window.  In practical and
common use cases the quota interval is not too long, and the scheme's
target access pattern is restrictive.  Hence the issue should be modest. 
That said, it is apparently an unintended misbehavior.  Fix the problem by
setting esz on the first charge window.

Link: https://lkml.kernel.org/r/20250915015807.101505-3-sj@kernel.org
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

mm-damon-core-reset-age-if-nr_accesses-changes-between-non-zero-and-zero.patch
mm-damon-core-set-effective-quota-on-first-charge-window.patch
mm-damon-lru_sort-use-param_ctx-correctly.patch
docs-mm-damon-maintainer-profile-update-community-meetup-for-reservation-requirements.patch
docs-admin-guide-mm-damon-start-add-target_pid-to-damos-example-command.patch
maintainers-rename-damon-section.patch

