Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DF021C173
	for <mm-commits@vger.kernel.org>; Sun, 28 Jun 2026 05:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782624867; cv=none; b=Lz/ylnSvmOYOGTuSoGvQ07nkZkHMXMvu0n8taqIXkUNMidO75YkPAFp5SIjUWb2eg3MKuFhlqKJpEkZPV4MIfOiQsne1MyJTLKHT1EmWRHuht+vC8aEYLySTO1e5PxmvSFSusCLquFdIh1X0eliDb1Cg81zBi8+pdF9ck1Ht2IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782624867; c=relaxed/simple;
	bh=0ee9kkymBbVekZSJDXlYoho700H1p//vx3FFkAhFMqs=;
	h=Date:To:From:Subject:Message-Id; b=tHRuV1nsxdzMCLlC/IwgTyjrpDmZufpAZDT1cI4R1irNfdSYlYUUeICvtyKDbOWKaVPnD10EooVuOO+vPi+Vh+SBDupTKZKrbPWwXeB50tXg6zAKWIcCAy84saDN/hA0qiYjHwSfrfUQMTnFpUDbsVSFXSRar0Oy0hqtl1oWRx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bovBqPvG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bovBqPvG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511991F000E9;
	Sun, 28 Jun 2026 05:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782624866;
	bh=GbiURNbXY5txFypX+qvd2pA6QFyCUbcw8WGzqJshu/w=;
	h=Date:To:From:Subject;
	b=bovBqPvGHafMIl5rBZgdPekVCW3w2NK4i63X3TogwHVojvFyd8rISfPFJ0jYVihLh
	 0LbkCoF2HEOvKAF+o0U5wfg3aEEiU2oV/rfvC8J27dShXQh+6eQRNkU4IoIVkxw0hY
	 0FN1kLzew1golSW62jIf2pPzmO4l53pFUXc9pL9g=
Date: Sat, 27 Jun 2026 22:34:25 -0700
To: mm-commits@vger.kernel.org,yanquanmin1@huawei.com,sj@kernel.org,nathan@kernel.org,morbo@google.com,justinstitt@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-reduce-kernel-stack-usage.patch added to mm-new branch
Message-Id: <20260628053426.511991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: reduce kernel stack usage
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-reduce-kernel-stack-usage.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-reduce-kernel-stack-usage.patch

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
From: Arnd Bergmann <arnd@arndb.de>
Subject: mm/damon/core: reduce kernel stack usage
Date: Thu, 11 Jun 2026 14:56:57 +0200

The main thread function has recently grown to the point of exceeding
stack frame size warning limits in some configurations.  This is what I
hit on s390 with clang and CONFIG_KASAN:

mm/damon/core.c:3440:31: error: stack frame size (1352) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3440 | static int kdamond_fn(struct damon_ctx *ctx)

The largest stack usage here is inside of the kdamond_tune_intervals(), so
by marking that one as noinline_for_stack, the functions individually stay
below the warning limit, though kdamond_fn() itself still uses hundreds of
kilobytes for some reason.

Link: https://lore.kernel.org/20260611125704.3386176-1-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/damon/core.c~mm-damon-core-reduce-kernel-stack-usage
+++ a/mm/damon/core.c
@@ -2039,7 +2039,7 @@ static unsigned long damon_get_intervals
 	return adaptation_bp;
 }
 
-static void kdamond_tune_intervals(struct damon_ctx *c)
+static noinline_for_stack void kdamond_tune_intervals(struct damon_ctx *c)
 {
 	unsigned long adaptation_bp;
 	struct damon_attrs new_attrs;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-damon-core-reduce-kernel-stack-usage.patch

