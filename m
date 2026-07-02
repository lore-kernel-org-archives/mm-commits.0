Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00A4363B9
	for <mm-commits@vger.kernel.org>; Thu,  2 Jul 2026 00:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782951108; cv=none; b=mFw4thLPO4+E6eg0HDeDoD6K1F+UWgY5NzLcN7ndsKZk6Y0lOx485NonUSbQa8lLHyka68LCnuv7+GbZHoFYhvDnR7P8rFu5xUKOwXm3ePmgVbfNvHcgWTJYdtoJQP6a4D9jE9xdDdWogeH8ttr/pZ01BJZDqJ7lW0ZDX4yMeQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782951108; c=relaxed/simple;
	bh=vJQm/peEiExJoTQvnw4c8/vIyFWT+nsh/ZGrKSImkl8=;
	h=Date:To:From:Subject:Message-Id; b=t+G1jQ1ig9AEmHudZgevZJRq1WxZ73CPJX8ixigl7zJsv3nR0zLbJwp5B/jfEofc5vO1FiQJNsp4T0289+0wvPKcUZCeU/fQiRuiI1+Z7rrMAPRX76aJC/7AMoeFAJK+xIOyLmPwWZVu/+gSnkI1L+O0kD6/dnBIQ2UnBKVBg/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Jslx3Gkm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Jslx3Gkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2271F000E9;
	Thu,  2 Jul 2026 00:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782951106;
	bh=sBzYbKthlG4VI9D5agOUyt+VZvpNUGqcm86nmUra5ck=;
	h=Date:To:From:Subject;
	b=Jslx3GkmcgfzI6ZOgo4oJLS24nGpp3T/lA0zPYo/PNS7Gl5O30bBpQxXJVfGICxnu
	 9Kisyc6CrlriZJGrNLJDVv/k+sBRM9s1A6PZpJly6WN5g+wRP9g+0h2ExpwgMhrtEN
	 We0J+9niM4zWeqRSCCpcAf19C+Ib50M1gGovlgmM=
Date: Wed, 01 Jul 2026 17:11:46 -0700
To: mm-commits@vger.kernel.org,ye.liu@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch added to mm-unstable branch
Message-Id: <20260702001146.BC2271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/page_owner: add missing newline to count_threshold format string
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch

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
From: Ye Liu <ye.liu@linux.dev>
Subject: mm/page_owner: add missing newline to count_threshold format string
Date: Wed, 1 Jul 2026 14:10:48 +0800

The DEFINE_SIMPLE_ATTRIBUTE format string for page_owner_threshold_fops is
missing a trailing \n.  simple_attr_read() uses scnprintf() with the
format string, which does not append a newline, so reading
/sys/kernel/debug/page_owner_stacks/count_threshold produces output
without a terminating newline.  Add the missing \n to match the standard
debugfs attribute convention.

Link: https://lore.kernel.org/20260701061101.344679-6-ye.liu@linux.dev
Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_owner.c~mm-page_owner-add-missing-newline-to-count_threshold-format-string
+++ a/mm/page_owner.c
@@ -974,7 +974,7 @@ static int page_owner_threshold_set(void
 }
 
 DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
-			&page_owner_threshold_set, "%llu");
+			&page_owner_threshold_set, "%llu\n");
 
 
 static int __init pageowner_init(void)
_

Patches currently in -mm which might be from ye.liu@linux.dev are

mm-page_owner-extract-skip_buddy_pages-helper-to-unify-buddy-page-skipping.patch
mm-page_owner-add-mr_never-to-enum-migrate_reason-and-use-it-for-last_migrate_reason.patch
mm-use-enum-migrate_reason-instead-of-int-for-migration-reason-parameters.patch
mm-page_owner-hoist-config_memcg-to-function-level-for-print_page_owner_memcg.patch
mm-page_owner-add-missing-newline-to-count_threshold-format-string.patch
mm-page_owner-move-free_ts_nsec-output-to-free-section-in-__dump_page_owner.patch
mm-page_owner-drop-redundant-page_owner-prefix-from-static-symbols.patch
mm-page_owner-clamp-skip_buddy_pages-pfn-advance-at-max_order_nr_pages-boundary.patch
mm-page_owner-use-memcg_data-snapshot-instead-of-pagememcgkmem-to-avoid-toctou-vm_bug_on.patch

