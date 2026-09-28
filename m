Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A0BB499F0C
	for <mm-commits@vger.kernel.org>; Mon, 28 Sep 2026 22:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790635871; cv=none; b=E1Bi0da/c1u71T+4snWB/P4moZ4kfZR8nBAX4LTy+qtrtYcIw4DLnMSs8zt/H4kYv+YCXto92zMJyBSxZRYRDNZcJ7kHPVlBtMxPovmcPQeSpgubS7bjiSUMls/3t9IjYqoW7qDSbZtIKGxZECzlHW5XG7ztgobPrRmsMLJiCpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790635871; c=relaxed/simple;
	bh=Prz0bo32pwjvRI80bteBMJ55OXV548Z/w0ZT5iCeJ64=;
	h=Date:To:From:Subject:Message-Id; b=iJ3Ss8Dad0qlaEzwBro6rM7IPTXMW7xgQeAiDq2hSdnJ+buIcFGcPEkAJ1QuvK3GCREGVb++E0Vj9qXpi/V4fkNVaH3WpNBV+4yR0+7WSwEUD+jze7lcw8NgBoLUC17cJVOIz+gvfD9C/qPMWnU/yKA3VgnImse3wuQ5bY6DCOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=w2KvAOSN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="w2KvAOSN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801241F00893;
	Mon, 28 Sep 2026 22:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790635869;
	bh=r5nOsML/WzUqWAINv/BdS6B+LcubHJd8j99fjjN/uog=;
	h=Date:To:From:Subject;
	b=w2KvAOSNR6qNWT1jqFdhAX0mF+j+Y43fH/7uCjaZXiB8Gv5pKsRoVMQPVKUx1q680
	 gW/yMt3qg64sjXXk8TuStkykGeBQFJ5uPNcMI9gLWaqKTzfTMmqHL6ydJqAjJwd/0D
	 pr5PtiomRMhJU3tNdNSVegNq1TPuS8RzEVx2ZmHM=
Date: Mon, 28 Sep 2026 15:51:09 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@gmail.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-core-reduce-stack-usage-further.patch added to mm-new branch
Message-Id: <20260928225109.801241F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/core: reduce stack usage further
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-core-reduce-stack-usage-further.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-core-reduce-stack-usage-further.patch

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
Subject: mm/damon/core: reduce stack usage further
Date: Mon, 28 Sep 2026 01:39:56 -0700

In a previous patch, I had annotated kdamond_tune_intervals() as
noinline_for_stack in order to not exceed the stack frame warning limit. 
Unfortunately, my current linux-next randconfig builds show a similar
problem again with clang-21:

mm/damon/core.c:3953:12: error: stack frame size (1288) exceeds limit (1280) in 'kdamond_fn' [-Werror,-Wframe-larger-than]
 3953 | static int kdamond_fn(void *data)

Do the same thing with kdamond_apply_schemes(), kdamond_merge_regions(),
and kdamond_split_regions(), which also have individually large stacks. 
This should work to keep the deepest total stack depth down much more as
well as avoid the warning.

I also tried to reduce the complexity of kdamond_fn() itself by splitting
out the while() loop into a separate function.  While this arguably led to
slightly more readable code, it had no effect on the total stack usage and
just made the new function the largest stack user and had a nonzero risk
of me getting the conversion wrong.

Link: https://lore.kernel.org/20260928083959.4030-3-sj@kernel.org
Fixes: 5a00cae64de1 ("mm/damon/core: reduce kernel stack usage")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
---

 mm/damon/core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-reduce-stack-usage-further
+++ a/mm/damon/core.c
@@ -3433,7 +3433,7 @@ static void damos_trace_stat(struct damo
 	trace_call__damos_stat_after_apply_interval(cidx, sidx, &s->stat);
 }
 
-static void kdamond_apply_schemes(struct damon_ctx *c)
+static noinline_for_stack void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
 	struct damos *s;
@@ -3589,8 +3589,9 @@ set_prev_continue:
  * while DAMON is running.  For such a case, repeat merging until the limit is
  * met while increasing @threshold up to possible maximum level.
  */
-static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
-				  unsigned long sz_limit)
+static noinline_for_stack void kdamond_merge_regions(struct damon_ctx *c,
+						     unsigned int threshold,
+						     unsigned long sz_limit)
 {
 	struct damon_target *t;
 	unsigned int nr_regions;
@@ -3734,7 +3735,7 @@ static void damon_split_some_regions(str
  * split was unnecessarily made, later 'kdamond_merge_regions()' will revert
  * it.
  */
-static void kdamond_split_regions(struct damon_ctx *ctx)
+static noinline_for_stack void kdamond_split_regions(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	unsigned long nr_regions = 0;
_

Patches currently in -mm which might be from arnd@arndb.de are

mm-vmscan-avoid-false-positive-wuninitialized-warning-again.patch
mm-damon-core-reduce-stack-usage-further.patch

