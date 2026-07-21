Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1915439336
	for <mm-commits@vger.kernel.org>; Tue, 21 Jul 2026 23:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784676330; cv=none; b=bbLK7tM6pknupb2TLZ8GQdHsWu5tcAIfczJWVXTTPTcpEkU7B3mh2brw33WLGsIEagnXyehlL5nGJRF8JpMIN94S6SpXhF833hTf+ye8iP5X/wTibCgc5NDNt1M80HXmp/RT8j9bek5xNrp66/OfRuiX1CcxrzGHoTrA5EiB8I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784676330; c=relaxed/simple;
	bh=9uoShhMD1DjeOIOF2dGoSCuvSabW2xGiyRnP8lfjEXA=;
	h=Date:To:From:Subject:Message-Id; b=GXqJh/zRmgUtYUKe11LE7Qp7KQdeKPGus3GOliAlr91P4gaCpdO8jC/IGo7xHJzWbzyE1yDJlvbFPQU2Rkltp3g95dAkGd6NBjEQmb6h6lyQjGvmppI9Q5CDqbykTU2XxPrfUDv8T8wLSZYh0V/GJHpyVRDbQEPYv3DDF4c88S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b08HtQek; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b08HtQek"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8B01F000E9;
	Tue, 21 Jul 2026 23:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784676329;
	bh=TEPJgVLi0Z+lj3iul9n4Bl0oDbLZ3ElqHDej9PZXzcA=;
	h=Date:To:From:Subject;
	b=b08HtQek3fKEN2rcmzQrLtMdellGCepK5eM2AV/b2uiznh7RPw2y1DP9MJJNNAWtx
	 EO+119Eqq/QJ7GQUVDhkRFIIw1GrDz5XLbRYX7FuO1YWn9eW44YPDcnVvaNDatUbHt
	 4jCL0ellXVbrPkbEf56HyMCQc5yWBY5NU3ZDb72c=
Date: Tue, 21 Jul 2026 16:25:28 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,wangxuewen@kylinos.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-remove-trailing-semicolons-after-function-definitions.patch added to mm-new branch
Message-Id: <20260721232529.2A8B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon: remove trailing semicolons after function definitions
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-remove-trailing-semicolons-after-function-definitions.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-remove-trailing-semicolons-after-function-definitions.patch

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

mm-annotate-data-race-in-cpu_needs_drain.patch
mm-damon-remove-trailing-semicolons-after-function-definitions.patch

