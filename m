Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B093B42EC
	for <mm-commits@vger.kernel.org>; Fri,  7 Aug 2026 02:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786068147; cv=none; b=ExdKTYsX/b10V9bBRfosHUaHEPoYwYUqL5DWeDP0BFrieY+5pSlSHXifcg6n/D36Ib8TY2o0+N7K6DA7k0UGXhOuKMM9ATmw+K3/LpxBgCcnk5eO8BeVo36dwKSC1uhsWNAlZzANI+m8S5myxEaogbUrO4DXBYZTh8MbXgX/q7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786068147; c=relaxed/simple;
	bh=EhfMbWLUOTTLWs0LebQFU6Qi7jALiZoCc3TUAVgGBlw=;
	h=Date:To:From:Subject:Message-Id; b=dmGR62YeoiRiJu6knXKyfwOWxTVQVvsPU7v2Cf2RU709vJ02hpKHIlKHdWAwhZjgbfkN3n58UY7rNPcqTdDw6v55XfEr9EQu4xsOG7N3j4vojn4N2nrNmukmjmC8V+fcmndqWOgSGSuwkIx87VwVmKo2WdNrQ+VBeRc/uifH06I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=yKK+J02S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="yKK+J02S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D621F000E9;
	Fri,  7 Aug 2026 02:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786068146;
	bh=S7GFOf9lDTdE49lPjs/cLBBtCq/SLhnwBtAkYT2N8pk=;
	h=Date:To:From:Subject;
	b=yKK+J02Slsdu/6rQArYYXrEF2o3NTsB+cTUEsww8tyYkhO6w2j3qBdCB/AyQ6n/SG
	 vGwwz8u5kjuJXQh3t34+335nQ505ZF1tHLrs6jO7yVviA5I6kkKBTErcAwX57S/4b8
	 sGNaB0v66rtLQmeVehx7AurmFjxp3iCtHLGr3WTk=
Date: Thu, 06 Aug 2026 19:02:26 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-remove-trailing-semicolons-after-function-definitions.patch removed from -mm tree
Message-Id: <20260807020226.99D621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon: remove trailing semicolons after function definitions
has been removed from the -mm tree.  Its filename was
     mm-damon-remove-trailing-semicolons-after-function-definitions.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Xuewen Wang <wangxuewen@kylinos.cn>
Subject: mm/damon: remove trailing semicolons after function definitions
Date: Tue, 21 Jul 2026 06:53:31 -0700

Three function definitions terminate with '};' instead of '}', which is
unnecessary and inconsistent with kernel coding style:

- damon_pa_initcall() in paddr.c
- damon_va_initcall() in vaddr.c
- damos_get_some_mem_psi_total() in core.c

No functional change intended.

Link: https://lore.kernel.org/20260721135333.241106-1-sj@kernel.org
Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c  |    2 +-
 mm/damon/paddr.c |    2 +-
 mm/damon/vaddr.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

--- a/mm/damon/core.c~mm-damon-remove-trailing-semicolons-after-function-definitions
+++ a/mm/damon/core.c
@@ -2791,7 +2791,7 @@ static u64 damos_get_some_mem_psi_total(
 static inline u64 damos_get_some_mem_psi_total(void)
 {
 	return 0;
-};
+}
 
 #endif	/* CONFIG_PSI */
 
--- a/mm/damon/paddr.c~mm-damon-remove-trailing-semicolons-after-function-definitions
+++ a/mm/damon/paddr.c
@@ -447,6 +447,6 @@ static int __init damon_pa_initcall(void
 	};
 
 	return damon_register_ops(&ops);
-};
+}
 
 subsys_initcall(damon_pa_initcall);
--- a/mm/damon/vaddr.c~mm-damon-remove-trailing-semicolons-after-function-definitions
+++ a/mm/damon/vaddr.c
@@ -959,7 +959,7 @@ static int __init damon_va_initcall(void
 	if (err)
 		return err;
 	return damon_register_ops(&ops_fvaddr);
-};
+}
 
 subsys_initcall(damon_va_initcall);
 
_

Patches currently in -mm which might be from wangxuewen@kylinos.cn are


