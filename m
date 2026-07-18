Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96D52E7376
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 04:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784349331; cv=none; b=thcODOt8Y90rqbP0aJOepmbEKcRV/iLB+XSeNDnLwWcDvsddMiC1Mb3+5idtlBpeumBeJ/gcylnE2SNpNeQNfGsTLLrxLH4SF9pakZGacOnUxV94NQNvbQY/V3Nlds3GhndtDNOrbRSmRPN9nKskg55mU76JA4AWd0zGbUApVR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784349331; c=relaxed/simple;
	bh=/B/fbwXukQ8Ifvt6HTGJqRaR4po0WuVnNYx/eEuRKT4=;
	h=Date:To:From:Subject:Message-Id; b=hZirHQKBt+E1N7a4LKGR6Xw+Hc5TGQGMPH0CVlAZAEZTKutheVT6eUlzPblSa9MnpMIeWwZHoHFQNFYdkiI9CNcG5yAIrejcN2MGl44F/jU5KArLQEl7er+QWhJ9kQ2lp+PoUnBDbzLOOSoXv1aoxkt9F/2xU6P98k5tvSbxMYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tlKwIlck; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tlKwIlck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EFEC1F000E9;
	Sat, 18 Jul 2026 04:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784349330;
	bh=SdWjtc7YlDH2N3xxLjEY6trUuGtFdQYt5c+Dgn3ykUw=;
	h=Date:To:From:Subject;
	b=tlKwIlckp0Ob/hyVmko5EjaV99pWTnkn2EWnOR7FYGueQNE8joi+fePNxCGX722nf
	 9a9wHoHiisDba+WNpVR2mQ6PlbSHsq64Qjh+No/ZAftVmA/Ko02qXgjQhD/S8B6k5k
	 jx35FYu1Gw8/aIHpW7kGQJhzoUV+AFDW0lHbUkU4=
Date: Fri, 17 Jul 2026 21:35:29 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,lienze@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch added to mm-new branch
Message-Id: <20260718043530.3EFEC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch

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
From: Enze Li <lienze@kylinos.cn>
Subject: mm/damon/ops-common: remove redundant local variable in damon_migrate_folio_list()
Date: Sat, 18 Jul 2026 08:21:25 +0800

In damon_migrate_folio_list(), we're redeclaring folio inside the first
while loop, but it just shadows the outer one.  Since the second loop uses
the outer folio anyway, the inner declaration is pointless.

Remove it to consistently reuse the same variable throughout the
function and improve readability.

Link: https://lore.kernel.org/20260718002125.637104-1-lienze@kylinos.cn
Signed-off-by: Enze Li <lienze@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/ops-common.c |    2 --
 1 file changed, 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list
+++ a/mm/damon/ops-common.c
@@ -339,8 +339,6 @@ static unsigned int damon_migrate_folio_
 	LIST_HEAD(migrate_folios);
 
 	while (!list_empty(folio_list)) {
-		struct folio *folio;
-
 		cond_resched();
 
 		folio = lru_to_folio(folio_list);
_

Patches currently in -mm which might be from lienze@kylinos.cn are

mm-damon-ops-common-remove-redundant-local-variable-in-damon_migrate_folio_list.patch

