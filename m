Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00CC371887
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 01:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769381; cv=none; b=MtEqKE9pZv9Uj7FVmdY+2CpXlP631ID10ieCydl05Q1xS+scMOERp+m+FUCAvV1DSJtYUHoBPMQtuDPK0QPX+nsmcIMBa+ec/kb3/TcuQgeGRyEosSVnZ41r3HXhUm6CpAPws/w/N5Wy/IkHexeHizuMwVbNBwTz48CAnp7PgFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769381; c=relaxed/simple;
	bh=+dfUchkmO5AS0HTViQgO5CCRqAIu4Bh/Ujbq39QESGk=;
	h=Date:To:From:Subject:Message-Id; b=S5sUM6yti3aE/l+SaBw4kZxbI5YreGp3gJ2gjONyTdeic79Jb5OmlyhJaoIdg8kDVD81Pk60d1aPubvrXTl2yvOP0IgNVzrTGMjjzbtSA3tXIXWtreG9QCFvt1LUxrOKS/UbtdM4vYxi34TUkFIdu7suv0fpoEN5sIp8jqjPBP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EGYwVpSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EGYwVpSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E19F1F0089C;
	Mon, 12 Oct 2026 01:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791769380;
	bh=YqIB0K+rLc7THxlIkSZj71l+Ln/nmWfVQAcr0K8e3P8=;
	h=Date:To:From:Subject;
	b=EGYwVpScRq8JkTptfec9jEDgPJZ9VxI4RCqoj606wpmtgyF5o739z7/RowppulScn
	 T2iMKDkLX5GUOHI1ig4hjeBwoAMYbarAzdoOYKItP39V4OxKFyqVakjef2gFDUC+sW
	 p4g4I+PBbSenWSr04j0Ie9goRcpqL7Y89xWXuITs=
Date: Sun, 11 Oct 2026 18:42:59 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch removed from -mm tree
Message-Id: <20261012014300.0E19F1F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch

This patch was dropped because it was folded into docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
Date: Wed Sep 16 09:18:41 PM PDT 2026

fix the fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -309,7 +309,7 @@ named ``0`` to ``N-1``.  Each directory
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
 filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
-``min`` and ``max`` file acts as files of the same names for :ref:`DAMOS
+``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

