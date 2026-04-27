Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E547C3264DA
	for <mm-commits@vger.kernel.org>; Mon, 27 Apr 2026 15:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777303197; cv=none; b=owELmRAgD3YHsY7TuWGs6v3wGn20ISd9nnwpQQnT71AMD/0FNLZMQsqlLlmiDY8OLsdJ0sueu4CdxxKtW1n1jYSqB6Ybk8ywXn/qxq73MOirxgMybmOyajLiBIzc/5ffRE5kcBVvPvkAYOVLraj9licttgAkn9VPYb1rslXJq9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777303197; c=relaxed/simple;
	bh=K/u+Qz7FL1SzNqwyqYZADu3cBGXHR3d0mvJPT6Ga7K0=;
	h=Date:To:From:Subject:Message-Id; b=RnxdJf5zyyKLLyHYxYyhD9ssomiP5ny6g+d+RI1FvguJkkEIGP45u4JfDW6rLlygCQs9rppo4TsUaidEn999w9n/H4ZE/Q0LjM1hUh2Hv4AMRVRo3ZZ8BjPeQRxO0Dc6jfDuRq4YvwpsD8ZSldgmIi0DThBtazGdQwf2GKRnKyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bc0aNkvG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bc0aNkvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A31C2BCB5;
	Mon, 27 Apr 2026 15:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777303196;
	bh=K/u+Qz7FL1SzNqwyqYZADu3cBGXHR3d0mvJPT6Ga7K0=;
	h=Date:To:From:Subject:From;
	b=bc0aNkvGgC4jaYpLCNzVBignqFpfy2xV18MsQYbin/15q9/DXVNGa32vMsEnc1UD3
	 Ro0a8FwEo4oIfdePRLVKQi2TKg1yqyMGSUrq4isq0XG6s9Jr2otPApxyONN8Nhzg4+
	 CW51df74NLyBifyRiYVYWysEOyY2KKzf9qf5elTM=
Date: Mon, 27 Apr 2026 08:19:55 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,corbet@lwn.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch added to mm-new branch
Message-Id: <20260427151956.81A31C2BCB5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/damon/sysfs.py: check pause on assert_ctx_committed()
has been added to the -mm mm-new branch.  Its filename is
     selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-damon-sysfspy-check-pause-on-assert_ctx_committed.patch

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
Subject: selftests/damon/sysfs.py: check pause on assert_ctx_committed()
Date: Mon, 27 Apr 2026 08:12:28 -0700

Extend sysfs.py tests to confirm damon_ctx->pause can be set using the
pause sysfs file.

Link: https://lore.kernel.org/20260427151231.113429-10-sj@kernel.org
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

 tools/testing/selftests/damon/sysfs.py |    1 +
 1 file changed, 1 insertion(+)

--- a/tools/testing/selftests/damon/sysfs.py~selftests-damon-sysfspy-check-pause-on-assert_ctx_committed
+++ a/tools/testing/selftests/damon/sysfs.py
@@ -191,6 +191,7 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_attrs_committed(ctx.monitoring_attrs, dump['attrs'])
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
+    assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
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

