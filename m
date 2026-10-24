Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832296;
	b=Sc6Uy9bNqnmXCfUKH/mNi/E9ZxKDsj/j5DPz5Nl+IExWiOyD+Ymscw8qowuPat794XM+
	 LutqCI3Pi+ialM4TWtfu4ee+zGQYcn39fIQJjza/wGMo8orJX3FyXsGQaKr9O0grOekKF
	 mMtL0xLmvKv6EvSt/gzmkCFOxMlif5fPRwO3ZbYHGiBrfa1wU8+KBY0u48LgUXnJX9OrN
	 bAPY9T7jfsk9/gBe8nyZJiLKoUwZZmTw2sjFscL8bmOHLF53e6gNSufFnei39waDH3xuJ
	 W5hqBAuhH1kW5tI+2CWmZTyWCyvOv1g4vuQt7ZiypQyreLb5Z4xFoqRiTqRaXkpsooA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832296;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=YdMY538IelBtVnHgIbJ21YlpQr3ES6J5aZLPfKA2zwI=;
	b=YHNmNIzp8r4q6A+Ut9RYHiZe/MDAlniM5O8ZXF9yCaIjBZ2q3viBPztknybkVulhayXJ
	 EU5JLQxW06zUx6Wf5aJj+7/2c6lYv3KijNxngj75KoWncxi1YMPCczWWGmR7GlUgiWLGM
	 fXyhxhxAg3CKiUPeNw5iJj21UWAEKllDkNwpM9R8eBMm8BP1KQRTOdkVCiZP+xweMkqEi
	 SG9dXsvAx2aFZPfb83zI2IEy6vdklMDFseqG5QUMbKISzP00q0gMqz7+dC8zmPoYySrY+
	 Asm98lLNJGz465hrfu28fnlYHqSBcyTdunle443DJtqL7N6I1s9t81DvLQSzrQEADjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Trj/4o4k";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E1A5606A31F
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Trj/4o4k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3541F01828;
	Sat, 24 Oct 2026 08:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832296;
	bh=YdMY538IelBtVnHgIbJ21YlpQr3ES6J5aZLPfKA2zwI=;
	h=Date:To:From:Subject;
	b=Trj/4o4kiWH+ufUoCPQ7cUSo2r3t79pNIAuwd236F5Opd9c2/NMKsi9CTHtmVrY+8
	 ei4E3vhG/yLxj8sOVXiC8e8pL7gUKjh58RJkNgiYEWRGextqOe4UbHpmaELHOEEqGG
	 xShbQWiYBdc1Gg1OBiaie3vAPNtHfzIfhnhImBT4=
Date: Sat, 24 Oct 2026 01:58:15 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,ravis.opensrc@gmail.com,ndesaulniers@google.com,nathan@kernel.org,morbo@google.com,justinstitt@google.com,arnd@arndb.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-reduce-stack-usage-further.patch removed from -mm tree
Message-Id: <20261024085815.ED3541F01828@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/core: reduce stack usage further
has been removed from the -mm tree.  Its filename was
     mm-damon-core-reduce-stack-usage-further.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


