Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156ED1B87F0;
	Wed,  9 Jul 2025 03:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752030418; cv=none; b=AdmOiwQBxmBZaUBEyT2ZUdEPZVLiQGFHQdwL7VVQGEWVgPR9fPhT218/rZhtpI9Rz3L09NrnrMb5F8b3qrsn5SEkiNoQjOexBf835g/spO8hCMETBWN58ShY+IuxhxyJKltRXGGaQasrY5kwo+iEXOYzR0rMMqXNtASnJSdtcTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752030418; c=relaxed/simple;
	bh=3UXdImVFngjrU07xU94cXC60rGJ4ROdaKComLgcXd9k=;
	h=Date:To:From:Subject:Message-Id; b=ss1jo8ttf0BjG55ia6BDNmbXeWHSmlZadDwHo0M06er/nV0tbtBTmgYTNu4jfB6c3D/bpNvplhTPiyt8vVbzTqdufJClzgmcjJRTwYtxFdGvwtJaF3CrIDLENSRtxUZzYC18H5fu6tKYVyYV2vh+eH1cVRXNeLUw2yP/jWXBHSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bHe+m+5Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bHe+m+5Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E79DC4CEED;
	Wed,  9 Jul 2025 03:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752030417;
	bh=3UXdImVFngjrU07xU94cXC60rGJ4ROdaKComLgcXd9k=;
	h=Date:To:From:Subject:From;
	b=bHe+m+5YtVoxUrJ/EiQ8RZWyg6KX0uJTVdLaae5CEr50MRVdMWza2jvqOUdQF9eif
	 ls6vUmb8DzqMCE9jt+WnXGo68QMOyh7XZt84vudM/FISFC8W7RdSJt9cNF2sBRILRF
	 6gACkHGf8rg7yI9VD52wRuYABhMxIc8CV1yW4Jcc=
Date: Tue, 08 Jul 2025 20:06:56 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,ravis.opensrc@micron.com,corbet@lwn.net,bijantabatab@micron.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-commit-damos-target_nid.patch added to mm-new branch
Message-Id: <20250709030657.4E79DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: commit damos->target_nid
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-commit-damos-target_nid.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-commit-damos-target_nid.patch

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
From: Bijan Tabatabai <bijantabatab@micron.com>
Subject: mm/damon/core: commit damos->target_nid
Date: Tue, 8 Jul 2025 19:47:29 -0500

When committing new scheme parameters from the sysfs, the target_nid field
of the damos struct would not be copied.  This would result in the
target_nid field to retain its original value, despite being updated in
the sysfs interface.

This patch fixes this issue by copying target_nid in damos_commit().

Link: https://lkml.kernel.org/r/20250709004729.17252-1-bijan311@gmail.com
Fixes: 83dc7bbaecae ("mm/damon/sysfs: use damon_commit_ctx()")
Signed-off-by: Bijan Tabatabai <bijantabatab@micron.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Ravi Shankar Jonnalagadda <ravis.opensrc@micron.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/damon/core.c~mm-damon-core-commit-damos-target_nid
+++ a/mm/damon/core.c
@@ -978,6 +978,7 @@ static int damos_commit(struct damos *ds
 		return err;
 
 	dst->wmarks = src->wmarks;
+	dst->target_nid = src->target_nid;
 
 	err = damos_commit_filters(dst, src);
 	return err;
_

Patches currently in -mm which might be from bijantabatab@micron.com are

mm-damon-core-commit-damos-target_nid.patch
mm-damon-core-commit-damos-migrate_dests.patch
mm-damon-move-migration-helpers-from-paddr-to-ops-common.patch
mm-damon-vaddr-add-vaddr-versions-of-migrate_hotcold.patch
docs-mm-damon-design-document-vaddr-support-for-migrate_hotcold.patch
mm-damon-vaddr-use-damos-migrate_dests-in-migrate_hotcold.patch
mm-damon-move-folio-filtering-from-paddr-to-ops-common.patch
mm-damon-vaddr-apply-filters-in-migrate_hot-cold.patch

