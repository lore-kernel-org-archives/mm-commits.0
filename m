Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573841779A9
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 22:08:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718748520; cv=none; b=tu5u667U5btNtiO/yccfqqvz36nBQwqrbWhHVIQPlM15jd4lEyvgp0+UP1+uoxAjJRR2JZZMtMEKvjPixcjnGGk3gI/bbvcgcUG92UOxxVjH+eBxzhF4vsdTeLSVwtF26cYy6f4e4a56FRjeQwhB3pZG5gHoJw0Gre/Ed9Uh3/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718748520; c=relaxed/simple;
	bh=aLeaKvGi7a3i0ubVl6ntFbRdlYDy/q/MjfkSGl/ui/I=;
	h=Date:To:From:Subject:Message-Id; b=J8cRf6DKZiU1Az1AEboVdt5AaRQ99cE235IzOBRIP/B9c6uWopisXWWt/Gil0i2H9r3oX7Kv1IgLILRjk670uKlapMsU4lWuGd6mF+QZOk4Kg+aGdo93RkWKq/gl1PP/NJehb50JCnKL3F3epfJC5FBVYp2b2vQPeAoXgQWTMVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dYPCcRdO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dYPCcRdO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A899BC3277B;
	Tue, 18 Jun 2024 22:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718748519;
	bh=aLeaKvGi7a3i0ubVl6ntFbRdlYDy/q/MjfkSGl/ui/I=;
	h=Date:To:From:Subject:From;
	b=dYPCcRdO7RL3PMzypDTnbWGBB0sZm2Llusl7OvTkz+NLahS50fWXAPUxz/+KkCkUy
	 sB6WILKaMewiGrC7bZ7VXpiSYZ6uJjTu+LWe+ME8Nr1Z/xeyDfVZj3p7bN4S6M3QuR
	 iq6tGvHv+96Gv2ITp20QXbGp3sno6TeJXwoNdBAY=
Date: Tue, 18 Jun 2024 15:08:39 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + docs-damon-document-damos_migrate_hotcold-fix.patch added to mm-unstable branch
Message-Id: <20240618220839.A899BC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: Docs/admin-guide/damon/usage: trivial fixups for DAMOS_MIGRATE_{HOT,COLD} documetnation
has been added to the -mm mm-unstable branch.  Its filename is
     docs-damon-document-damos_migrate_hotcold-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/docs-damon-document-damos_migrate_hotcold-fix.patch

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

docs-damon-document-damos_migrate_hotcold-fix.patch
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
docs-abi-damon-document-target_nid-file.patch

