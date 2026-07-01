Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926FD33D6C1
	for <mm-commits@vger.kernel.org>; Wed,  1 Jul 2026 03:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782878131; cv=none; b=uIkVClMZUJHAui3MfkKkpZ/sjzGUBknM4jj4AQIzsHL+dPV3v4RFOC06MZAOGX+f7C5faOupvQdcfjMz+e6qwKBPtMBoUr/nmm9cV8m0kZjyfSeopVCaU4eIZ/I7jAB80Bci9YNGm8nyLT80h/CWiataaKdcZI9tyKKscxJtCWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782878131; c=relaxed/simple;
	bh=GBo1IfldNWuKQ/7IWWwWx/xtbb9LfKxo+bEyQNTgsjA=;
	h=Date:To:From:Subject:Message-Id; b=rH5MIE5ow4Ug95ptPfmHcCt+90ehJpzJSqqG54OwLhu/PiZlK8LMnG+ofTfhEQ+NekGuZ3CDv8Aqi9C1rzwnmRS/eVVFOX+ZMqZBd/sIZOezFMVI/aR9wHgQ/kmx1O7SdMJZZp06w9HvJTHyb61ir5iSAu5VMPaLBtNJAqDS3NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=I1Q9hSrk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="I1Q9hSrk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27E131F00A3A;
	Wed,  1 Jul 2026 03:55:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782878130;
	bh=RZfSIf1P7las7AfB0rSeJ5Wa+A1exvCtjOPZZbKbecs=;
	h=Date:To:From:Subject;
	b=I1Q9hSrkdJvGoN0CbeZOtlo+mOHZ5nEY8m8LQkzC1gya/rKo4rLxsRAZ07rwVZozx
	 BooS1ofE1Wb6VBMu+Z58RHJYwx0BhwWU7jBHB/sfsm5veOtTDK+FueZTflnEuXo1te
	 TqolpGPOQt+9yZgaE1djtA7NYeDWqvKpXSOKcUiA=
Date: Tue, 30 Jun 2026 20:55:29 -0700
To: mm-commits@vger.kernel.org,vbabka@kernel.org,tj@kernel.org,surenb@google.com,shakeel.butt@linux.dev,rppt@kernel.org,roman.gushchin@linux.dev,mkoutny@suse.com,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,hannes@cmpxchg.org,david@kernel.org,usama.arif@linux.dev,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch added to mm-new branch
Message-Id: <20260701035530.27E131F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
has been added to the -mm mm-new branch.  Its filename is
     mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch

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
From: Usama Arif <usama.arif@linux.dev>
Subject: mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
Date: Tue, 30 Jun 2026 09:25:05 -0700

Simplify the guard. Both cgroup_subsys_on_dfl() and tree are bool, so
the two combinations that have no consumer (v1 + tree=false, v2 +
tree=true) are exactly the cases where dfl == tree.

Link: https://lore.kernel.org/e8e1a409-48d8-4fa7-ae98-49485a1607f6@linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/vmpressure.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/vmpressure.c~mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix
+++ a/mm/vmpressure.c
@@ -251,8 +251,7 @@ void vmpressure(gfp_t gfp, int order, st
 	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
 	 * Skip the other two: nothing consumes the result.
 	 */
-	if ((!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !tree) ||
-	    (cgroup_subsys_on_dfl(memory_cgrp_subsys) && tree))
+	if (cgroup_subsys_on_dfl(memory_cgrp_subsys) == tree)
 		return;
 
 	vmpr = memcg_to_vmpressure(memcg);
_

Patches currently in -mm which might be from usama.arif@linux.dev are

mm-swap_state-remove-unnecessary-lru_add_drain-from-readahead.patch
mm-add-softleaf_to_pmd-and-convert-existing-callers.patch
mm-extract-mm_prepare_for_swap_entries-helper.patch
fs-proc-use-softleaf_has_pfn-in-pagemap-pmd-walker.patch
mm-huge_memory-move-softleaf_to_folio-inside-migration-branch.patch
mm-migrate_device-move-softleaf_to_folio-inside-device-private-branch.patch
mm-rename-arch_enable_thp_migration-to-arch_supports_pmd_softleaf.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2.patch
mm-vmpressure-skip-tree=true-accounting-on-cgroup-v2-fix.patch
mm-vmpressure-move-v1-userspace-eventfd-code-into-memcontrol-v1c.patch

