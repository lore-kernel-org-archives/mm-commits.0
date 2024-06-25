Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B402417D8B2
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 20:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719348650; cv=none; b=C7Oko57PrQtXK7m5xrGUrdl2d/HMPZRlMtFKFrwvtG12PG6pjwrUfcOR5lFFG9OtF9rjObyEoMmuKVz7bhLHs4TJ1oRw+H388/welqryg2N8c6mUmtx2bjj6siBPGmc88+057DD1uyAVkLCkor1/0ivCCLyP0ZjO80eoQayRjKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719348650; c=relaxed/simple;
	bh=/Yopq1y47k/WxKF8tu3nKt4q8EpI9eQ2LYFCr7o/LQo=;
	h=Date:To:From:Subject:Message-Id; b=OYW+VGSOUVPTkBjJwLlRoiez4wc+Kv5Hc07BM7Up0b0tOQraFvaHwWod0+9YFT+x9oHrkh8X9fhoc7zDSzlX4gHNXaleGcaBogIDp4DIzX6OdGj9Lo1t0wO+WkySlYtBqbiA6U2EmG+7LfUEnedjKAz7DzUtoyuQl6nCT72Qqqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=efmnar4j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="efmnar4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80189C32781;
	Tue, 25 Jun 2024 20:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719348650;
	bh=/Yopq1y47k/WxKF8tu3nKt4q8EpI9eQ2LYFCr7o/LQo=;
	h=Date:To:From:Subject:From;
	b=efmnar4jkQHd8addRyCIyLAUgl3ibxpWGgOZ5TZLApt2AQDAkXK7LxzfTV1g4eadV
	 ts7m+CzFDeEb01GxBx4DhzjqTlg2AHZ0cyIp7m6rAK9xfOw5fWcY1q1ZYsJhzIRp+v
	 slk8NWqmcHsKGYh3+N/c6pWbp4wLmkV60qr52HME=
Date: Tue, 25 Jun 2024 13:50:50 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,shakeel.butt@linux.dev,muchun.song@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,roman.gushchin@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch added to mm-unstable branch
Message-Id: <20240625205050.80189C32781@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: MAINTAINERS: add mm/memcontrol-v1.c/h to the list of maintained files
Date: Mon, 24 Jun 2024 17:59:06 -0700

Link: https://lkml.kernel.org/r/20240625005906.106920-15-roman.gushchin@linux.dev
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 ++
 1 file changed, 2 insertions(+)

--- a/MAINTAINERS~maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files
+++ a/MAINTAINERS
@@ -5582,6 +5582,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/linux/memcontrol.h
 F:	mm/memcontrol.c
+F:	mm/memcontrol-v1.c
+F:	mm/memcontrol-v1.h
 F:	mm/swap_cgroup.c
 F:	samples/cgroup/*
 F:	tools/testing/selftests/cgroup/memcg_protection.m
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-memcg-introduce-memcontrol-v1c.patch
mm-memcg-move-soft-limit-reclaim-code-to-memcontrol-v1c.patch
mm-memcg-rename-soft-limit-reclaim-related-functions.patch
mm-memcg-move-charge-migration-code-to-memcontrol-v1c.patch
mm-memcg-rename-charge-move-related-functions.patch
mm-memcg-move-legacy-memcg-event-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_check_events.patch
mm-memcg-move-cgroup-v1-oom-handling-code-into-memcontrol-v1c.patch
mm-memcg-rename-memcg_oom_recover.patch
mm-memcg-move-cgroup-v1-interface-files-to-memcontrol-v1c.patch
mm-memcg-make-memcg1_update_tree-static.patch
mm-memcg-group-cgroup-v1-memcg-related-declarations.patch
mm-memcg-put-cgroup-v1-related-members-of-task_struct-under-config-option.patch
maintainers-add-mm-memcontrol-v1c-h-to-the-list-of-maintained-files.patch

