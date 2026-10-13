Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A294825BC
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865936; cv=none; b=GiQ8J80qJj60HvWRFzOnSYecmsX28NeIrwSFaQLUKyRuILENfZ73lhLpudsOQalY60/FC4IkwkGAojmmEJ3VD3BR5wAk67gHxbRKGLaYDK3aLcvExymr7KCipyexomRWMgchZCFPuQe0ubyREb0XExeKxLqR5qJ41wAqJIN8vCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865936; c=relaxed/simple;
	bh=W6O6jytwvAQbwcu+NXtTDGGtqgS0P8eR15L/8kzXkhw=;
	h=Date:To:From:Subject:Message-Id; b=SStpRVZzi9/9MnD6Hgoe1VtmRc4i6ew+n/tTIBvl/dZ6D/Nv3HcBwZqRiVgbT4ocm/JmXlgUlOA2fu4f3JNLQG2E3JnHDOF0+OkEFEm8IhbpECB7c3kvNVIXTdOPy19qTTKtk/fsJXNuvXey9Bz9tOjTAesWehuCbYJ99dGrF1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=u1oNHtra; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="u1oNHtra"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DC841F00893;
	Tue, 13 Oct 2026 04:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865934;
	bh=vwpTzcyfJvk9eX5BrOEhkh751T+pR0+Vgov4F5EyVGw=;
	h=Date:To:From:Subject;
	b=u1oNHtraeYjD7fxKEnkYeYkDLtGyvrUmjSPPLgz5DoYQPamf7AAhzNv6aewkLsAnp
	 7h1gmOOz0+C0yvghdDDtVWhQbGwcoOQ9Q4TcdtZQHSjMp+sj9e1LcvohNz9DNAaBW9
	 kuETtizN+9J/UrbptwD13EPcB5MLXPeP+07Twkug=
Date: Mon, 12 Oct 2026 21:32:14 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,rppt@kernel.org,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,david@kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch removed from -mm tree
Message-Id: <20261013043214.7DC841F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/mm/damon/usage: update for hugepage_size
has been removed from the -mm tree.  Its filename was
     docs-admin-guide-mm-damon-usage-update-for-hugepage_size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: Docs/admin-guide/mm/damon/usage: update for hugepage_size
Date: Tue, 15 Sep 2026 07:33:56 -0700

Update DAMON usage document for the newly added hugepage_size data
attribute filter type.

[akpm@linux-foundation.org: s/files acts/file acts/, per SJ]
[akpm@linux-foundation.org: fix the fix]
Link: https://lore.kernel.org/20260915143359.91472-8-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-admin-guide-mm-damon-usage-update-for-hugepage_size
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ │ 0/prep_action
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ │ filters/nr_filters
-    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path
+    │ │ │ │ │ │ │ │ │ 0/type,matching,allow,path,min,max
     │ │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`targets <sysfs_targets>`/nr_targets
@@ -308,6 +308,8 @@ Writing a number (``N``) to the file cre
 named ``0`` to ``N-1``.  Each directory represents each filter and works in a
 way similar to that for :ref:`DAMOS filter <sysfs_filters>`.  When the filter
 ``type`` is ``memcg``, ``path`` file acts as ``memcg_path`` for :ref:`DAMOS
+filter <sysfs_filters>`.  When the filter ``type`` is ``hugepage_size``,
+``min`` and ``max`` files act as files of the same names for :ref:`DAMOS
 filter <sysfs_filters>`.
 
 .. _sysfs_targets:
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-introduce-damos_quota_goal-complement.patch
mm-damon-core-add-complement-argument-to-damos_new_quota_goal.patch
mm-damon-sysfs-schemes-support-quota-goal-complement-flag.patch
mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch
selftests-damon-sysfssh-test-quota-goal-complement-flag-file.patch
docs-mm-damon-design-document-damos-quota-goal-complement-flag.patch
docs-admin-guide-mm-damon-usage-update-for-quota-goal-complement-file.patch
docs-abi-damon-update-for-quota-goal-metric-complement-sysfs-file.patch

