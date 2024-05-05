Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221F47580E;
	Sun,  5 May 2024 21:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942885; cv=none; b=bSOaNH+zL61hQZukwbPyPjgKXeQOHgR65KeZYiIIuWN5Xg7KAFjZ1sz4Bf1qRQIRLHDczHCU6+FOZ58DQsIRpEE9HSbc7etzW3PfPa9jsB4M5DFM4FKJJhpxP3+/zpDHH41xY9d7e9wQ5PHS+/sODI0WYUc5nyybggSNmpSmwWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942885; c=relaxed/simple;
	bh=ULMDEcu/1vXrDBV0w6E8/es4et/EeocRfnlZuzrHOUs=;
	h=Date:To:From:Subject:Message-Id; b=YauIblXgFcjH88n36vnoQwCiAqLcBrusBi5rPT4sTVT5c9YkMJoPR5aZGRIl3fXhDE3zU47aOUy6phpxHDxPvYPXLT9rVGbLQiHFXmEs9Iz8LkjqP9jCRsx/YhtpCNj+2vQ5e/2cr2/tV117vqvbJ3fz8FhzoDyTv6g60XO/cQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QzPPRHJM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QzPPRHJM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD773C116B1;
	Sun,  5 May 2024 21:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942884;
	bh=ULMDEcu/1vXrDBV0w6E8/es4et/EeocRfnlZuzrHOUs=;
	h=Date:To:From:Subject:From;
	b=QzPPRHJMHp+QHh7acr+TvsmrwKbj4hm+31rZCZ0dBjhPqJcgEz1B4tI5qwm5EN+At
	 nuikiYyWNpJT3NGprlUX7drdOAz2EKANaY0dquLyaGL9KpdhyFGZD3O77T10+5o5hd
	 Qs+fKp3N7vGgE4h0MgakL0Iq9W/hRqd9uLs2+NC0=
Date: Sun, 05 May 2024 14:01:24 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch added to mm-unstable branch
Message-Id: <20240505210124.AD773C116B1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
has been added to the -mm mm-unstable branch.  Its filename is
     docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: fix wrong schemes effective quota update command
Date: Fri, 3 May 2024 11:03:15 -0700

To update effective size quota of DAMOS schemes on DAMON sysfs file
interface, user should write 'update_schemes_effective_quotas' to the
kdamond 'state' file.  But the document is mistakenly saying the input
string as 'update_schemes_effective_bytes'.  Fix it (s/bytes/quotas/).

Link: https://lkml.kernel.org/r/20240503180318.72798-8-sj@kernel.org
Fixes: a6068d6dfa2f ("Docs/admin-guide/mm/damon/usage: document effective_bytes file")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.9.x]
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -153,7 +153,7 @@ Users can write below commands for the k
 - ``clear_schemes_tried_regions``: Clear the DAMON-based operating scheme
   action tried regions directory for each DAMON-based operation scheme of the
   kdamond.
-- ``update_schemes_effective_bytes``: Update the contents of
+- ``update_schemes_effective_quotas``: Update the contents of
   ``effective_bytes`` files for each DAMON-based operation scheme of the
   kdamond.  For more details, refer to :ref:`quotas directory <sysfs_quotas>`.
 
@@ -342,7 +342,7 @@ Based on the user-specified :ref:`goal <
 effective size quota is further adjusted.  Reading ``effective_bytes`` returns
 the current effective size quota.  The file is not updated in real time, so
 users should ask DAMON sysfs interface to update the content of the file for
-the stats by writing a special keyword, ``update_schemes_effective_bytes`` to
+the stats by writing a special keyword, ``update_schemes_effective_quotas`` to
 the relevant ``kdamonds/<N>/state`` file.
 
 Under ``weights`` directory, three files (``sz_permil``,
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-paddr-implement-damon_folio_young.patch
mm-damon-paddr-implement-damon_folio_mkold.patch
mm-damon-add-damos-filter-type-young.patch
mm-damon-paddr-implement-damos-filter-type-young.patch
docs-mm-damon-design-document-young-page-type-damos-filter.patch
docs-admin-guide-mm-damon-usage-update-for-young-page-type-damos-filter.patch
docs-abi-damon-update-for-youg-page-type-damos-filter.patch
mm-damon-paddr-avoid-unnecessary-page-level-access-check-for-pageout-damos-action.patch
mm-damon-paddr-do-page-level-access-check-for-pageout-damos-action-on-its-own.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_pages.patch
mm-vmscan-remove-ignore_references-argument-of-reclaim_folio_list.patch
selftests-damon-_damon_sysfs-support-quota-goals.patch
selftests-damon-add-a-test-for-damos-quota-goal.patch
mm-damon-core-initialize-esz_bp-from-damos_quota_init_priv.patch
selftests-damon-_damon_sysfs-check-errors-from-nr_schemes-file-reads.patch
selftests-damon-_damon_sysfs-find-sysfs-mount-point-from-proc-mounts.patch
selftests-damon-_damon_sysfs-use-is-instead-of-==-for-none.patch
selftests-damon-classify-tests-for-functionalities-and-regressions.patch
docs-admin-guide-mm-damon-usage-fix-wrong-example-of-damos-filter-matching-sysfs-file.patch
docs-admin-guide-mm-damon-usage-fix-wrong-schemes-effective-quota-update-command.patch
docs-mm-damon-design-use-a-list-for-supported-filters.patch
docs-mm-damon-maintainer-profile-change-the-maintainers-timezone-from-pst-to-pt.patch
docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

