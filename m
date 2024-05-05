Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD6A7580E
	for <mm-commits@vger.kernel.org>; Sun,  5 May 2024 21:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714942887; cv=none; b=DHcYs15mDCtH45t0Mjo/ioH7eg1F0jMpmOt5gfzjbkuf97EQMy8XPJHextKUrOMrMDzh9rANC5VOuf/NMxYHPvUPw0nXDi3Cs5NyJSFnbO0RIEu99ptdcviPWMQ/xKB1HBL2H5wyJsvLStMj4Mgg/E4JBkrLfetKoLwglJvS6NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714942887; c=relaxed/simple;
	bh=MjWfdg+mZvWo6CHVPX8JBkcrVbknpTf8pAeIWAEojcU=;
	h=Date:To:From:Subject:Message-Id; b=XmP/1YteGDlt+3at9KKlRALt13iWh2Bw+7+zl66ycuyifsZe82K0qinBoHmtFYGE98z96WNV1feLz5QTVi+psl9WUgxGRDK4y9fWMluKf9rjA+XC80Z4Ndm2NZqqvVuXBfM+qwTk9oQPvySELmL03mFyj4douISUP8E0olyEXzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q2kajzR7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q2kajzR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A360C113CC;
	Sun,  5 May 2024 21:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714942887;
	bh=MjWfdg+mZvWo6CHVPX8JBkcrVbknpTf8pAeIWAEojcU=;
	h=Date:To:From:Subject:From;
	b=q2kajzR7e5lXTuFQbpp1AorM6tuGq9EITXVsbQSe8bF/Z6v1j8OL8LGOimBjzbfLu
	 6LcLQj0pmzrLejLep5lgpFVcL9zma/Tu3t5n8KHGoLYxUKprBqxW8PwWVc6pde4T4N
	 smrRMCrXHOeWPvJJ+OsMUXw9blDWF76Gf3VUExx8=
Date: Sun, 05 May 2024 14:01:26 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,corbet@lwn.net,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch added to mm-unstable branch
Message-Id: <20240505210127.6A360C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/maintainer-profile: allow posting patches based on damon/next tree
has been added to the -mm mm-unstable branch.  Its filename is
     docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree.patch

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
Subject: Docs/mm/damon/maintainer-profile: allow posting patches based on damon/next tree
Date: Fri, 3 May 2024 11:03:18 -0700

The document mentions any patches for review should based on mm-unstable
instead of damon/next.  It should be the recommended process, but
sometimes patches based on damon/next could be posted for some reasons. 
Actually, the DAMON-based tiered memory management patchset[1] was written
on top of 'young page' DAMOS filter patchset, which was in damon/next tree
as of the writing.

Allow such case and just ask such things to be clearly specified.

[1] https://lore.kernel.org/20240405060858.2818-1-honggyu.kim@sk.com

Link: https://lkml.kernel.org/r/20240503180318.72798-11-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/maintainer-profile.rst |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/Documentation/mm/damon/maintainer-profile.rst~docs-mm-damon-maintainer-profile-allow-posting-patches-based-on-damon-next-tree
+++ a/Documentation/mm/damon/maintainer-profile.rst
@@ -20,9 +20,10 @@ management subsystem maintainer.  After
 be queued in mm-stable [3]_ , and finally pull-requested to the mainline by the
 memory management subsystem maintainer.
 
-Note again the patches for review should be made against the mm-unstable
-tree [1]_ whenever possible.  damon/next is only for preview of others' works
-in progress.
+Note again the patches for mm-unstable tree [1]_ are queued by the memory
+management subsystem maintainer.  If the patches requires some patches in
+damon/next tree [2]_ which not yet merged in mm-unstable, please make sure the
+requirement is clearly specified.
 
 Submit checklist addendum
 -------------------------
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

