Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD2811DA4E
	for <mm-commits@vger.kernel.org>; Tue, 19 Aug 2025 02:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755571705; cv=none; b=Q51JcqM7oauU2pHpSgnujLSGYxlEefLXkkRFoP5lGHW3Nd7D3f1ig/kyv6aAYmbLdNVxipTBt91+F8pNAwmhtZX3XssVUW9yxlgK+i6DJmNYnN/sjRzyHG4HjjWEbT4iLb4Msn9V0zcBlbDb8hyEaVW5d0YQVviPmaiT6SBBnME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755571705; c=relaxed/simple;
	bh=H5cV8PSBNvCG/Sh0DiA9KEPzYdM9NA/UvxzkbmbVgw0=;
	h=Date:To:From:Subject:Message-Id; b=Aa7adD1vrdMAY/hdJHHrKDBtdZATZersu66CykCzOo+EDA4TAFMIl3+XiymIjGBZfd02c+DSgSFr5J0AGxBcW3d6YVia2fM4fvHAMc5agMguvhCVdASepqyi5PV9Cpo3e8nO0ItSK5nbPOZlZE6vXv7OGvVyNZ+2J30dUgQjY6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XJpwU+IK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XJpwU+IK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3778EC4CEEB;
	Tue, 19 Aug 2025 02:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755571705;
	bh=H5cV8PSBNvCG/Sh0DiA9KEPzYdM9NA/UvxzkbmbVgw0=;
	h=Date:To:From:Subject:From;
	b=XJpwU+IKf6p//wf6/BJiFkyivj/6BnRa3sGm0nAEF/0VRVfpluiNAzmOVwV+BvJeT
	 DX+HkTR02XnrPTbKaFHQXvNVXTzYfrPfzlUl61R7+n/t4KQ2/3OO75lidvbccDXM1h
	 WMXJVbGpywxEuLCALVlVYs3F+A8Kw384vAuYrwiA=
Date: Mon, 18 Aug 2025 19:48:24 -0700
To: mm-commits@vger.kernel.org,wqu@suse.com,willy@infradead.org,roman.gushchin@linux.dev,muchun.song@linux.dev,mhocko@kernel.org,josef@toxicpanda.com,hannes@cmpxchg.org,dsterba@suse.com,clm@fb.com,shakeel.butt@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + memcg-remove-warning-from-folio_lruvec.patch added to mm-new branch
Message-Id: <20250819024825.3778EC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: memcg: remove warning from folio_lruvec
has been added to the -mm mm-new branch.  Its filename is
     memcg-remove-warning-from-folio_lruvec.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/memcg-remove-warning-from-folio_lruvec.patch

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
From: Shakeel Butt <shakeel.butt@linux.dev>
Subject: memcg: remove warning from folio_lruvec
Date: Mon, 18 Aug 2025 17:36:56 -0700

Commit a4055888629bc ("mm/memcg: warning on !memcg after readahead page
charged") added the warning in folio_lruvec (older name was
mem_cgroup_page_lruvec) for !memcg when charging of readahead pages were
added to the kernel.  Basically lru pages on a memcg enabled system were
always expected to be charged to a memcg.

However a recent functionality to allow metadata of btrfs, which is in
page cache, to be uncharged is added to the kernel.  We can either change
the condition to only check anon pages or file pages which does not have
AS_UNCHARGED in their mapping.  Instead of such complicated check, let's
just remove the warning as it is not really helpful anymore.

Link: https://lkml.kernel.org/r/0cf22669a203b8671b6774408bfa4864ba3dbf60.1755562487.git.boris@bur.io
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69
Cc: Chris Mason <clm@fb.com>
Cc: David Sterba <dsterba@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Qu Wenruo <wqu@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/include/linux/memcontrol.h~memcg-remove-warning-from-folio_lruvec
+++ a/include/linux/memcontrol.h
@@ -729,10 +729,7 @@ out:
  */
 static inline struct lruvec *folio_lruvec(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
-
-	VM_WARN_ON_ONCE_FOLIO(!memcg && !mem_cgroup_disabled(), folio);
-	return mem_cgroup_lruvec(memcg, folio_pgdat(folio));
+	return mem_cgroup_lruvec(folio_memcg(folio), folio_pgdat(folio));
 }
 
 struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
_

Patches currently in -mm which might be from shakeel.butt@linux.dev are

memcg-remove-warning-from-folio_lruvec.patch

