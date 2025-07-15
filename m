Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F2A2CCC0
	for <mm-commits@vger.kernel.org>; Tue, 15 Jul 2025 22:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752616921; cv=none; b=uaIEnABwYxqstwcQt526KjnwPTBVM/jv4UY4wMTATeBHRI0EXKc9zta6CgTknMxkxd1yL5pqrPC+sI/Y+w1wF8wdHiVkNxxULyFqwQqIlprpTvv3+lj3rwtlGfO4Oo/cZRDdqOZK7u99gTjR3NOTkCU0bGDoIXEJB/V1JthsrVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752616921; c=relaxed/simple;
	bh=UVg54IWU/kT7DnfecichtYWfuPUybJaftSD/aXUMV2c=;
	h=Date:To:From:Subject:Message-Id; b=LC/ZC0/EzTssGKDgDXMogyxv1I5k7o8K7wN2vLv5GD1E31Or8DY13j96i6NWiGpgqC51/+jBS8t9EW8Ii3xR2FKKUSxClpyfFKnBiAOPXcd2EYjs2fapM2PjGAuExyZc/JeFLUT/dYMffq8u8XFcUvqtbmYJSD14DXB7pZiGZ1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yBQV642S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yBQV642S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B56FC4CEE3;
	Tue, 15 Jul 2025 22:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1752616920;
	bh=UVg54IWU/kT7DnfecichtYWfuPUybJaftSD/aXUMV2c=;
	h=Date:To:From:Subject:From;
	b=yBQV642SciJvuy64LNtLF7MhLR8k2ElXKTY+DfVR9A52aa/3AVFR1aXVJcAPfVy3+
	 j46WIJa4bKHFNKsZX85vf/azbFspTh7NyyR2MVv/cC0xQRYtqfwGmwkTHe6WBBaUJ3
	 ilphPVNcbfaIK7GQYxI3TgtCkMtnP099DW6+D9CU=
Date: Tue, 15 Jul 2025 15:01:59 -0700
To: mm-commits@vger.kernel.org,sfr@canb.auug.org.au,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-add-cleanup_target-ops-callback-fix.patch added to mm-unstable branch
Message-Id: <20250715220200.5B56FC4CEE3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: add kernel-doc comment for damon_operations->cleanup_target
has been added to the -mm mm-unstable branch.  Its filename is
     mm-damon-core-add-cleanup_target-ops-callback-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-add-cleanup_target-ops-callback-fix.patch

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
Subject: mm/damon: add kernel-doc comment for damon_operations->cleanup_target
Date: Tue, 15 Jul 2025 11:52:38 -0700

Commit 769bd386e490 ("mm/damon/core: add cleanup_target() ops callback")
on mm-unstable added cleanup_target field to damon_operations, but forgot
adding the kernel-doc description.  This causes a build warning.  Fix it
by adding the description.

Link: https://lkml.kernel.org/r/20250715185239.89152-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/20250715185549.264260b8@canb.auug.org.au
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/damon.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/damon.h~mm-damon-core-add-cleanup_target-ops-callback-fix
+++ a/include/linux/damon.h
@@ -576,6 +576,7 @@ enum damon_ops_id {
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
+ * @cleanup_target:		Clean up each target before deallocation.
  * @cleanup:			Clean up the context.
  *
  * DAMON can be extended for various address spaces and usages.  For this,
_

Patches currently in -mm which might be from sj@kernel.org are

samples-damon-wsse-rename-to-have-damon_sample_-prefix.patch
samples-damon-prcl-rename-to-have-damon_sample_-prefix.patch
samples-damon-mtier-rename-to-have-damon_sample_-prefix.patch
mm-damon-sysfs-use-damon-core-api-damon_is_running.patch
mm-damon-sysfs-dont-hold-kdamond_lock-in-before_terminate.patch
docs-mm-damon-maintainer-profile-update-for-mm-new-tree.patch
mm-damon-add-struct-damos_migrate_dests.patch
mm-damon-core-add-damos-migrate_dests-field.patch
mm-damon-sysfs-schemes-implement-damos-action-destinations-directory.patch
mm-damon-sysfs-schemes-set-damos-migrate_dests.patch
docs-abi-damon-document-schemes-dests-directory.patch
docs-admin-guide-mm-damon-usage-document-dests-directory.patch
mm-damon-accept-parallel-damon_call-requests.patch
mm-damon-core-introduce-repeat-mode-damon_call.patch
mm-damon-stat-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-reclaim-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-lru_sort-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-prcl-use-damon_call-repeat-mode-instead-of-damon_callback.patch
samples-damon-wsse-use-damon_call-repeat-mode-instead-of-damon_callback.patch
mm-damon-core-do-not-call-opscleanup-when-destroying-targets.patch
mm-damon-core-add-cleanup_target-ops-callback.patch
mm-damon-core-add-cleanup_target-ops-callback-fix.patch
mm-damon-vaddr-put-pid-in-cleanup_target.patch
mm-damon-sysfs-remove-damon_sysfs_destroy_targets.patch
mm-damon-core-destroy-targets-when-kdamond_fn-finish.patch
mm-damon-sysfs-remove-damon_sysfs_before_terminate.patch
mm-damon-core-remove-damon_callback.patch

