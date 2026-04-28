Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76679351C2E;
	Tue, 28 Apr 2026 14:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777386583; cv=none; b=W/lxAnzsY02NQhO4nWrEGluBP8l0gwHPqasIzWkOnOr5N51SwVzZtPP1ewqAfoeanjWohqgTx8HUvxrn+DutsOlPh5Wfs+dj/oXhUuQKoArdPb7donnoWdh7sEj8di1ObztlA4vnzUypJJV33fumsiBmpXcxTxE6tGbeyGZFAYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777386583; c=relaxed/simple;
	bh=ZeqAw7GshDUVVPoMN36PQAnXsF9iQzDiavrgmuyk9ME=;
	h=Date:To:From:Subject:Message-Id; b=euTdZZSaFmwwTzC0hhoPVK/IaPisY9xBRqNlyQ1F3fgJn+sG/ZqpK4OjSrVsm2P8svCplW8a+shaRoilbRJpa9ORmUv6cSgRz8qixSkmUgcHOMu1YhuWM/fYiLOK6V5UD8k3jW4k8XRgtJYUrWtbZX7wK18urZn+JM86dV6veOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b5UwPuXO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b5UwPuXO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC48C2BCAF;
	Tue, 28 Apr 2026 14:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777386583;
	bh=ZeqAw7GshDUVVPoMN36PQAnXsF9iQzDiavrgmuyk9ME=;
	h=Date:To:From:Subject:From;
	b=b5UwPuXOPd2+BRerGy3VS0kUvTzbQxLPS4/OlvNoYOpcttMurt+hU25k2oiPM1Zec
	 R/sfaELJCjbTxkafrkLWjnE8QKPQVYlQCD0P1QfckreAB+V3DjLj3+VAzifaDHhaLI
	 uGXl61upc0v/rcYo0DHySwLGItPwaK/+4UsoSJYw=
Date: Tue, 28 Apr 2026 07:29:42 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch added to mm-hotfixes-unstable branch
Message-Id: <20260428142942.ECC48C2BCAF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: make charge_addr_from aware of end-address exclusivity
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch

This patch will later appear in the mm-hotfixes-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Subject: mm/damon/core: make charge_addr_from aware of end-address exclusivity
Date: Mon, 27 Apr 2026 21:29:40 -0700

DAMON region end address is exclusive one, but charge_addr_from is
assigned assuming the end address is inclusive.  As a result, DAMOS action
to next up to min_region_sz memory can be skipped.  This is quite
negligible user impact.  But, the bug is a bug that can be very simply
fixed.  Fix the wrong assignment to respect the exclusiveness of the
address.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20260428042942.118230-1-sj@kernel.org
Link: https://lore.kernel.org/20260428032324.115663-1-sj@kernel.org [1]
Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity
+++ a/mm/damon/core.c
@@ -2106,7 +2106,7 @@ static void damos_apply_scheme(struct da
 		if (damos_quota_is_set(quota) &&
 				quota->charged_sz >= quota->esz) {
 			quota->charge_target_from = t;
-			quota->charge_addr_from = r->ar.end + 1;
+			quota->charge_addr_from = r->ar.end;
 		}
 	}
 	if (s->action != DAMOS_STAT)
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-sysfs-schemes-call-missing-mem_cgroup_iter_break.patch
mm-damon-fix-damos_stat-tracepoint-format-for-sz_applied.patch
mm-damon-core-make-charge_addr_from-aware-of-end-address-exclusivity.patch
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

