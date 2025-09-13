Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36BF17BA1
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801402; cv=none; b=qAJzkUaQjdF28I2UzAQaL5Rk1jB1wBlM7gI3LOHaxDbdoch4UgGCNRwCUr0JhHI9orwhm8381kDuutSomro14SQDnXjmT7Yz/Yd3MulYadxKe2Y9i912Nu8NcJm9UN0JsysKoCwYdnuCVw3Tsh1Kvdk15DCN69xRYpv/9VUeZks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801402; c=relaxed/simple;
	bh=14lgKjEjnZ9nrXsoClIr6b8EyAe7Xzqs7WQQ4QzzSik=;
	h=Date:To:From:Subject:Message-Id; b=YKVbcVZhqHF1cdC3+cKJnvEF0iiKAkJmO2B7GC12jxRo1dFqDqQM5iWLxvArt6Fe02iENrep8TltLsLOpjn5kFGCW2RZekEIOjggEkkBN/GRRVOKqjTU8FUWqI2Iwo8HcG8IWti/M6oVpWIUIL7fK4LFvDyJP4vcZk34X3KTgq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=0xihtns8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="0xihtns8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D726C4CEEB;
	Sat, 13 Sep 2025 22:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801402;
	bh=14lgKjEjnZ9nrXsoClIr6b8EyAe7Xzqs7WQQ4QzzSik=;
	h=Date:To:From:Subject:From;
	b=0xihtns8qckd2V4cOUkXsxsdymYSMZ/y2JJtd0Vtu+mX3pxGjtw2Po2xRM7fuEGwy
	 0BHkIU1OKH8fRK1V12RgnbpDpmgd10GOKENmLJEbF30vhYXt9pLxotQnDsopqNsbke
	 e2xMQbzQWl/Gw2hpwAQgEiFzseJW4woWh38SEmb0=
Date: Sat, 13 Sep 2025 15:10:01 -0700
To: mm-commits@vger.kernel.org,bijantabatab@micron.com,bijan311@gmail.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch removed from -mm tree
Message-Id: <20250913221002.6D726C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
has been removed from the -mm tree.  Its filename was
     mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix.patch

This patch was dropped because it was folded into mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
Date: Wed Aug  6 08:32:40 PM PDT 2025

fix whitespace, per SeongJae

Link: https://lkml.kernel.org/r/20250807001924.76275-1-sj@kernel.org
Cc: Bijan Tabatabai <bijan311@gmail.com>
Cc: Bijan Tabatabai <bijantabatab@micron.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx-fix
+++ a/mm/damon/core.c
@@ -585,7 +585,6 @@ static bool damon_attrs_equals(const str
 		ig1->aggrs == ig2->aggrs &&
 		ig1->min_sample_us == ig2->min_sample_us &&
 		ig1->max_sample_us == ig2->max_sample_us;
-
 }
 
 static unsigned int damon_age_for_new_attrs(unsigned int age,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-fix-warnings-caused-by-use-of-arch_enter_lazy_mmu_mode-fix.patch
mm-damon-core-skip-needless-update-of-damon_attrs-in-damon_commit_ctx.patch
mm-convert-core-mm-to-mm_flags_-accessors-fix.patch
memcg-optimize-exit-to-user-space-fix.patch
memfd-move-mfd_all_flags-definition-to-memfdh.patch
mm-constify-highmem-related-functions-for-improved-const-correctness-fix.patch
mm-filemap-align-last_index-to-folio-size-fix-fix.patch
mm-re-enable-kswapd-when-memory-pressure-subsides-or-demotion-is-toggled-fix.patch
panic-remove-redundant-panic-cpu-backtrace-fix.patch
crash-add-kunit-tests-for-crash_exclude_mem_range-fix.patch

