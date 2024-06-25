Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532A721A0C
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719290080; cv=none; b=tv9fgMaApZSRdHG2xPYJRwqk4PkdaBMhbztmRU+LNKFGKe56rSgA0dm7whZ4n2mX2QGKpaAyC+2UsO2HVMIcCeGTEGe6XNTs236s4jcp+rSXr4U/ZPD1zblGnGounBNTlWvXBjFJfjVoxGrIK/t/sE8xBZ3TcwPGPsJShzHIu2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719290080; c=relaxed/simple;
	bh=BYhUnK0E87l4NZkoXE0zj07gvaQJfzRmgnvQfXqbZpQ=;
	h=Date:To:From:Subject:Message-Id; b=SnxbS+GwU3/vEXJglNGmaQNnoD4YNtCOULuXTp+7hMVPlZ+Q+ljdFQzfRa5or6Et0la9BeJ78phKMJVpjrT0MB7Dj6JpwuPYlSwW7FzP2IfzGUcgh58fCNqaWjcqJBqlXifUz58Sh2j0HKrSIUNQ6KDiQfcPYZUj2pHRR3/uUUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Teoy1tGU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Teoy1tGU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27037C32782;
	Tue, 25 Jun 2024 04:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719290080;
	bh=BYhUnK0E87l4NZkoXE0zj07gvaQJfzRmgnvQfXqbZpQ=;
	h=Date:To:From:Subject:From;
	b=Teoy1tGUlS7ixtG+YF9CWhciAKRPqodDTR5zKcrY3qgGET0Bb+RpTCQorjoeg+wHh
	 KBnufxJeuM2n26wCJJnXwkSA7E5lBarOrI5CEOLVZe9EjC5rDbl1ogWfl0RqVvXTMz
	 ySxXsoToBTFCtudt0nGwcVa6SkcwcI1St2Wo9vDw=
Date: Mon, 24 Jun 2024 21:34:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] docs-damon-document-damos_migrate_hotcold-fix.patch removed from -mm tree
Message-Id: <20240625043440.27037C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: Docs/admin-guide/damon/usage: trivial fixups for DAMOS_MIGRATE_{HOT,COLD} documetnation
has been removed from the -mm tree.  Its filename was
     docs-damon-document-damos_migrate_hotcold-fix.patch

This patch was dropped because it was folded into docs-damon-document-damos_migrate_hotcold.patch

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: Docs/admin-guide/damon/usage: trivial fixups for DAMOS_MIGRATE_{HOT,COLD} documetnation
Date: Tue, 18 Jun 2024 14:36:29 -0700

Fixup below three trivial issues in DAMOS_MIGRATE_{HOT,COLD} usage
documentation[1,2].

1. Add target_nid on sysfs files hierarchy
2. Fix scheme directory section to mention target_nid file
3. Explain target_nid before apply_interval_us

Link: https://lkml.kernel.org/r/20240618213630.84846-2-sj@kernel.org
Fixes: c100fc71858a ("Docs/damon: document damos_migrate_{hot,cold}") # mm-unstable [1]
Link: https://lore.kernel.org/20240614030010.751-8-honggyu.kim@sk.com # [2]Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/mm/damon/usage.rst |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/Documentation/admin-guide/mm/damon/usage.rst~docs-damon-document-damos_migrate_hotcold-fix
+++ a/Documentation/admin-guide/mm/damon/usage.rst
@@ -78,7 +78,7 @@ comma (",").
     │ │ │ │ │ │ │ │ ...
     │ │ │ │ │ │ ...
     │ │ │ │ │ :ref:`schemes <sysfs_schemes>`/nr_schemes
-    │ │ │ │ │ │ :ref:`0 <sysfs_scheme>`/action,apply_interval_us
+    │ │ │ │ │ │ :ref:`0 <sysfs_scheme>`/action,target_nid,apply_interval_us
     │ │ │ │ │ │ │ :ref:`access_pattern <sysfs_access_pattern>`/
     │ │ │ │ │ │ │ │ sz/min,max
     │ │ │ │ │ │ │ │ nr_accesses/min,max
@@ -289,21 +289,21 @@ schemes/<N>/
 ------------
 
 In each scheme directory, five directories (``access_pattern``, ``quotas``,
-``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and two files
-(``action`` and ``apply_interval``) exist.
+``watermarks``, ``filters``, ``stats``, and ``tried_regions``) and three files
+(``action``, ``target_nid`` and ``apply_interval``) exist.
 
 The ``action`` file is for setting and getting the scheme's :ref:`action
 <damon_design_damos_action>`.  The keywords that can be written to and read
 from the file and their meaning are same to those of the list on
 :ref:`design doc <damon_design_damos_action>`.
 
-The ``apply_interval_us`` file is for setting and getting the scheme's
-:ref:`apply_interval <damon_design_damos>` in microseconds.
-
 The ``target_nid`` file is for setting the migration target node, which is
 only meaningful when the ``action`` is either ``migrate_hot`` or
 ``migrate_cold``.
 
+The ``apply_interval_us`` file is for setting and getting the scheme's
+:ref:`apply_interval <damon_design_damos>` in microseconds.
+
 .. _sysfs_access_pattern:
 
 schemes/<N>/access_pattern/
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-merge-regions-aggressively-when-max_nr_regions-is-unmet.patch
docs-damon-document-damos_migrate_hotcold.patch
mm-damon-core-implement-damos-quota-goals-online-commit-function.patch
mm-damon-core-implement-damon-context-commit-function.patch
mm-damon-sysfs-use-damon_commit_ctx.patch
mm-damon-sysfs-schemes-use-damos_commit_quota_goals.patch
mm-damon-sysfs-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-rename-damon_sysfs_set_targets-to-add_targets.patch
mm-damon-sysfs-schemes-remove-unnecessary-online-tuning-handling-code.patch
mm-damon-sysfs-schemes-rename-_set_schemesscheme_filtersquota_scoreschemes.patch
mm-damon-reclaim-use-damon_commit_ctx.patch
mm-damon-reclaim-remove-unnecessary-code-for-online-tuning.patch
mm-damon-lru_sort-use-damon_commit_ctx.patch
mm-damon-lru_sort-remove-unnecessary-online-tuning-handling-code.patch
docs-mm-damon-maintainer-profile-introduce-hackermail.patch
docs-mm-damon-maintainer-profile-document-damon-community-meetups.patch

