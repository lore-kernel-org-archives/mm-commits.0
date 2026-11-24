Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795540593;
	b=Xxi8MGceAL9GQJIqW7eQMr8vCksFqLWzBYShloVAIgAQkM6t8BpgcTwBZO7IeOBJzFIr
	 vbvmNXidv4o50WPOImuCVVfcOBK+bj6xnRGtMqrfuGu3WYggPatbm7HFL+Wb3xYacGMMx
	 EerpF3FCnVd2epim3SYXk6jLHiaPo1cY4MNECZ9ZVam+9nK9dimbcAIC5mG/x8SotugBS
	 wVanrpF/IwUupixv9Ep1XqyCAcrbzedlv+ENCwRXswLCOKNoTVJW/YiRTAG72otLHvhhh
	 FafURTWxpFa1rItON1XzrA/5UUtxcRwcTnPSFxIuwU/dxKgmasRoJlW7cfpEWo7/FKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795540593;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=wVbiBjlh6chN+LNaKv55Jd1bKJC5C0DuF+mOGVFIJDk=;
	b=qxS4jnotVq1CqgcBe6vHGMLPWT4VEF5SeqZIShwf1ngJvKLlh68tiTWXeV9Cv90nTOP8
	 PMxYIFCvBZP9gbgskammEIWSv18sVT3DwT9+DSQ7uWZsKUVFOwFvMAeg6Dr1bxAnwE5UP
	 6jNDaErZMvvcw0zfOAXe9d/KaXwr68nB0Xkc4Em3SFoGXcpt5Vw2qBOxaAhgmgDBEzacP
	 brw5dyr732ZRtfI9QeXQLnYBgYnJoYNtLnEJA67zk+Q5EWLHBJoTZTE9kFn5ax0Z4dTkr
	 blJlPta7qU3T4S8CMD+CL3vstqxICemrLXZbIQ6i4HqEKb3uOX3w2A5mqaqwwsnWtPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="F/fprbUx";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0668606A321
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=F/fprbUx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AD71F000CA;
	Tue, 24 Nov 2026 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795540593;
	bh=wVbiBjlh6chN+LNaKv55Jd1bKJC5C0DuF+mOGVFIJDk=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=F/fprbUxM+0iuoWCeqdrFW/akYn3aVFeLDWdi0rlM1dEOpv9HE/rGsNMsIRvL9rA2
	 IEjF+f3hGnLRY4J7ByBdP6lqDphbCJUHh2dTwzsLgMPqLj0J1H5d1PbFsL6pQOWE3D
	 DwXroelrk2WiO49AmhH2Mt0KY/463dkVeRaAAs0o=
Date: Tue, 24 Nov 2026 09:16:32 -0800
To: mm-commits@vger.kernel.org,sj@kernel.org,saileshnandanavanam@gmail.com,
	lienze@kylinos.cn,jm5905938@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261124153021.90142-3-sj@kernel.org>
References: <20261124153021.90142-3-sj@kernel.org>
Subject: + mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch added to mm-new branch
Message-Id: <20261124171633.21AD71F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: mm/damon/core: skip apply_probes() when no probes are installed
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch

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
From: Aveline Noir <jm5905938@gmail.com>
Subject: mm/damon/core: skip apply_probes() when no probes are installed
Date: Tue, 24 Nov 2026 07:30:18 -0800

While measuring vaddr monitoring overhead, I noticed that kdamond calls
apply_probes() every sampling interval even if no probes are installed.
The vaddr callback walks the page tables for each region's sample, and
paddr looks up a folio and takes a reference if it can. There are no
probe hits to count in either case.

Skip the callback when the probe list is empty. Ordinary access checks
still run, and installed probes with zero weight are still applied.

Link: https://patch.msgid.link/20261124153021.90142-3-sj@kernel.org
Signed-off-by: Aveline Noir <jm5905938@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Sailesh Nandanavanam <saileshnandanavanam@gmail.com>
Cc: Enze Li <lienze@kylinos.cn>

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-skip-apply_probes-when-no-probes-are-installed
+++ a/mm/damon/core.c
@@ -4105,7 +4105,7 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes) {
+		if (ctx->ops.apply_probes && !list_empty(&ctx->probes)) {
 			if (time_after_eq(ctx->passed_sample_intervals,
 						next_aggregation_sis) &&
 					access_check_disabled)
_

Patches currently in -mm which might be from jm5905938@gmail.com are

mm-damon-ops-common-align-mmu-notifier-range-when-clearing-pmd-young-bit.patch
mm-damon-stat-avoid-32-bit-overflow-in-idle-percentiles.patch
mm-damon-pvaddr-skip-folios-already-on-the-migration-target-node.patch
docs-admin-guide-mm-damon-start-fix-grammar.patch
docs-admin-guide-mm-damon-stat-fix-pronoun-agreement.patch
docs-admin-guide-mm-damon-usage-fix-grammar.patch
docs-admin-guide-mm-damon-lru_sort-fix-remaining-grammar.patch
docs-mm-damon-design-fix-grammar-and-typos.patch
docs-mm-damon-api-fix-verb-form.patch
docs-mm-damon-maintainer-profile-fix-subject-verb-agreement.patch
docs-mm-damon-monitoring_intervals_tuning_example-fix-grammar-and-typos.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion.patch
mm-damon-paddr-add-kunit-tests-for-addr_unit-conversion-fix.patch
mm-hmm-account-for-subpage-offsets-in-device-private-pmds.patch
mm-damon-paddr-skip-non-lru-folios-as-a-whole-in-pageout.patch
mm-damon-core-skip-apply_probes-when-no-probes-are-installed.patch
selftests-damon-damos_quota-skip-the-last-sample-when-counting-exceeds.patch

