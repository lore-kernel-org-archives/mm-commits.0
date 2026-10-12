Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EBB16A395
	for <mm-commits@vger.kernel.org>; Mon, 12 Oct 2026 01:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791769377; cv=none; b=nOU3esyEERrfekE88mCRd8WJ5pDvlAUtnQ90uZ1t2ZMepnAlcn0iUx7QJ/PSeHuBxiNlrvTP6KjXbe2JoAVcblsEpvxl9a/Z9s/icsZKr1ilibxx3QzPLUNP791suDUjN8WEGaN41aN90tJa0IUcLG2D2i87jFSvAo7jOWYN5kI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791769377; c=relaxed/simple;
	bh=NbAAljsq9/Zzbch5UbUQRrpbTvw586ckAnlzQk02DkI=;
	h=Date:To:From:Subject:Message-Id; b=rNJJCC1XjSI09Hg85Rlg1/P6Cn7M1UxPBA8pruY/68Fnqsg3+JuWXK/VXf9oULYyV3KyM344/OoY177js0wyeFqUJa19nz56N193DZ9BOaLLtcVPXKGSws8VOUwFFKiseP979E02N6NPD2nPLw7nIHoKDylQZsn/mKBzOOX4fuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d82L5bss; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d82L5bss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CA691F0089B;
	Mon, 12 Oct 2026 01:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791769375;
	bh=3T4YOZCv7pJfNZSBFxybY6B/L51Cbcl29xBkmFXJTGU=;
	h=Date:To:From:Subject;
	b=d82L5bssH0HnMmm1Z0diyITaEsYf0MEnrGHYvPA4a5Dx1t63x6gNeyMKOQViqO69Y
	 pv/4R0xHpGUEstZ4uofxW7l2kJYtJerN/mMe9V7lLqdOCH9xCe/XSynu61VkN3d/IZ
	 KE4mGcJgAtXETusW2RWGri6PLx4eXoc3NeJMTvyo=
Date: Sun, 11 Oct 2026 18:42:54 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,sj@kernel.org,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch removed from -mm tree
Message-Id: <20261012014255.5CA691F0089B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix.patch

This patch was dropped because it was folded into docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
Date: Tue Sep 15 04:33:09 PM PDT 2026

s/files acts/file acts/, per SJ

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: SJ Park <sj@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -309,7 +309,7 @@ named ``0`` to ``N-1``.  Each directory
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
 filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
-``min`` and ``max`` files acts as files of the same names for :ref:`DAMOS
+``min`` and ``max`` file acts as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch
docs-admin-guide-mm-damon-usage-update-for-hugepage_size-fix-fix.patch
mm-selftests-add-shmem-into-memory-failure-test-fix.patch
proc-task_mmu-remove-unnecessary-inlines-in-function-definitions-fix.patch
mm-update-comments-to-refer-to-anon-rmap-rather-than-anon_vma-fix.patch
mm-damon-core-introduce-damos_quota_goal-complement-fix.patch
lib-cmdline-fix-get_options-count-and-overflow-with-large-ranges-fix.patch
drivers-media-v4l2-core-v4l2-vp9c-reduce-inlining.patch

