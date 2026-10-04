Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1355447F78B
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144708; cv=none; b=U0m8X6DupJx3nK45cVwN3bAsT5pKKuU6RutMPHFMkImQCnN0X/UU0fXuO0nP05f1+QpoTqgbAfjHpf10HyJ5LyVARXPySaeTvyQzr+vL2YHtgFPTIctSTAMxH+j8o49glUeHJ252RB+IeOokTcDJDLYqFbC8QXO3ms2iEJq8Hqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144708; c=relaxed/simple;
	bh=fxCjFH+EkbaO56OR/05LdouITSIRwI+d4nq3daOIGKI=;
	h=Date:To:From:Subject:Message-Id; b=IYprMgllgfYFcw1v6M3CSmhpytCnGTtg1g0P0WFXDuK4GQ0V6iAVTJSZLo3dIFBo6m1Fu3nzcj820PAnSC0OPDI7pRxhGGX51IclIk4mHWJ4Glw1gBdsoUeyIie3hfowTKsJpZW3AfU6R6z7ZZKCSgoePHUybSKfigvbNjFgKgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=kUrleMn/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="kUrleMn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938941F000FF;
	Sun,  4 Oct 2026 20:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144706;
	bh=2L2NcnWa8ox7dq1De8zDERaUdfcZHiqZ+qtIiy0JSdg=;
	h=Date:To:From:Subject;
	b=kUrleMn/jB+ipiThaT3lt3Fe39CpJTUfHaJBYU70PdHQB5bTkpygrVtOM0/raVIWe
	 q+P1nPp9AAVQacCjO0/LG6rpOBvufsP0UAnYBUE46wnACcBOruwSJd+ZqfPFp45y3U
	 VDJbdpZbylqPNBFgRfALjKSoogT9BS2ENl6T5rpg=
Date: Sun, 04 Oct 2026 13:11:46 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,osalvador@suse.de,muchun.song@linux.dev,joe@perches.com,david@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch added to mm-unstable branch
Message-Id: <20261004201146.938941F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
has been added to the -mm mm-unstable branch.  Its filename is
     maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via various
branches at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there most days

------------------------------------------------------
From: Enze Li <lienze@kylinos.cn>
Subject: MAINTAINERS: cover all hugetlb headers under HUGETLB SUBSYSTEM
Date: Sat,  3 Oct 2026 14:00:28 +0800

The HUGETLB SUBSYSTEM F: entries list include/linux/hugetlb.h explicitly,
but other hugetlb headers are not covered, so get_maintainer.pl does not
attribute them to the hugetlb maintainers.

Enumerating headers by hand is also fragile: any header not listed (such
as hugetlb_cgroup.h) falls outside the subsystem.  Joe Perches suggested
using a glob F: entry, which covers all current and future hugetlb headers
in one line and avoids the gap.

Link: https://lore.kernel.org/20261003060029.2152489-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Joe Perches <joe@perches.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/MAINTAINERS~maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem
+++ a/MAINTAINERS
@@ -12097,7 +12097,7 @@ F:	Documentation/admin-guide/mm/hugetlbp
 F:	Documentation/mm/hugetlbfs_reserv.rst
 F:	Documentation/mm/vmemmap_dedup.rst
 F:	fs/hugetlbfs/
-F:	include/linux/hugetlb.h
+F:	include/linux/hugetlb*
 F:	include/linux/vmemmap-optimization.h
 F:	include/trace/events/hugetlbfs.h
 F:	mm/hugetlb.c
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-core-introduce-damon_set_target_pid.patch
samples-damon-mtier-add-comment-for-struct-region_range.patch
maintainers-cover-all-hugetlb-headers-under-hugetlb-subsystem.patch
mm-hugetlb_cgroup-add-trailing-endif-comment-for-include-guard.patch
docs-hugetlbpagerst-fix-typo-in-per-node-attribute-description.patch

