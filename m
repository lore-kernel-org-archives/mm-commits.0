Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9062E315D29
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303184; cv=none; b=q5Nt/nfukJ1TUS1ZVPd+kck+DVXHXcweHpJHPt3/uZZTfl/eGNcxMyA/nvZdbF48CaKVVHanap5wDPSxr40vIc6lN4VXC0f71eFYw3BbS5UeDQGEpH6SzOGP880fOnoCJKHZRgh/4UrrM+oW6eWNctWoJKqrMuvIWxt1nFAkgC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303184; c=relaxed/simple;
	bh=Xj4NlSEd5VBInXbFAUUxB3Bg+RAisJy08T1Qz89dnN8=;
	h=Date:To:From:Subject:Message-Id; b=oeYwP0RjVX0r+AmI6WB0FxpQ16tY+KMxn4hViJQG0hm422tqh0vGmpQ9nZAx0LpmKe0PgEJyMlLwR93nq9ZPnL+UCSG41SoUxnLm9lE8eAS5ggGWuolsEYI8Qr4SnwQ4cbcCgA2f5ZQJgncgNbvMswezRso5ColO8h/C4tFqlq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L+Bfse0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+Bfse0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 504EFC2BCB5;
	Mon, 27 Apr 2026 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777303184;
	bh=Xj4NlSEd5VBInXbFAUUxB3Bg+RAisJy08T1Qz89dnN8=;
	h=Date:To:From:Subject:From;
	b=L+Bfse0jK6lYsNrFs0znIVyJk6JBWr2XXWYzK/GkulflHbUv1dw1HzcRuvVwW1ps/
	 LYwFZ0KLM+AdrZmbIO6kTN9bJZ9M4AAa4VYtURkeGoLxP8JgLvwVfCF4NEEmdxCAw7
	 JWS4eVRlRE1v+mdYY4MPcTF/v2/geNq9CSFMkprk=
Date: Mon, 27 Apr 2026 08:19:43 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-mm-damon-design-update-for-context-pause-resume-feature.patch added to mm-new branch
Message-Id: <20260427151944.504EFC2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/mm/damon/design: update for context pause/resume feature
has been added to the -mm mm-new branch.  Its filename is
     docs-mm-damon-design-update-for-context-pause-resume-feature.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-mm-damon-design-update-for-context-pause-resume-feature.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

If a few days of testing in mm-new is successful, the patch will me moved
into mm.git's mm-unstable branch, which is included in linux-next

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
From: SeongJae Park <sj@kernel.org>
Subject: Docs/mm/damon/design: update for context pause/resume feature
Date: Mon, 27 Apr 2026 08:12:22 -0700

Update DAMON design document for the context execution pause/resume
feature.

Link: https://lore.kernel.org/20260427151231.113429-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/mm/damon/design.rst |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/mm/damon/design.rst~docs-mm-damon-design-update-for-context-pause-resume-feature
+++ a/Documentation/mm/damon/design.rst
@@ -19,6 +19,13 @@ types of monitoring.
 To know how user-space can do the configurations and start/stop DAMON, refer to
 :ref:`DAMON sysfs interface <sysfs_interface>` documentation.
 
+Users can also request each context execution to be paused and resumed.  When
+it is paused, the kdamond does nothing other than applying online parameter
+update.
+
+To know how user-space can pause/resume each context, refer to :ref:`DAMON
+sysfs context <sysfs_context>` usage documentation.
+
 
 Overall Architecture
 ====================
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
docs-mm-damon-maintainer-profile-add-ai-review-usage-guideline.patch
mm-damon-core-introduce-damon_ctx-paused.patch
mm-damon-sysfs-add-pause-file-under-context-dir.patch
docs-mm-damon-design-update-for-context-pause-resume-feature.patch
docs-admin-guide-mm-damon-usage-update-for-pause-file.patch
docs-abi-damon-update-for-pause-sysfs-file.patch
mm-damon-tests-core-kunit-test-pause-commitment.patch
selftests-damon-_damon_sysfs-support-pause-file-staging.patch
selftests-damon-drgn_dump_damon_status-dump-pause.patch
selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch
selftests-damon-sysfspy-pause-damon-before-dumping-status.patch

