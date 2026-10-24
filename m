Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832459;
	b=TCFJ/RlJ0BtgcUirq8Vu/Bd32sbEoHZw6/huBbiFI5ubNpF8x/DfjQ72hNdwRqTmnfDg
	 Cj5TtHJ0iJx6uYjXAFwtOG8Kk1sbjczyTLnlNZPlPqp/dBnsBtzTJGRFu47AZcj+0VBub
	 33ecR0M2jcABi3gsXbbuoeZvJ3WxhOuhR2mrgpDgBTrYh2efDXJ5PTX2mgV2oL8pj2Jds
	 +LM76PNvqm/uUQVYIqEjteFEEKp6p4hcp4u/YQVprd0wKvuJWwB3q5RheEtwsr4rs780R
	 X93MxxhEpJ339j491TY4TP5TqbLDhJTnIdy7FX4vOtC9z3Ya7cmR4q3E75uHBfxXGVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832459;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=ylnJC5f7qy7gr7Xy6XOUTSHN17WnZYPnp96W4vu9iNI=;
	b=Kojnc6rm6SFwaNGU0Gxr2UZ8opmLQ4FKxAy3IHFvzYlCbT2wijseXwk2vZ9crt/liNbv
	 g9KAfdx8SRI09HxcA86andvQgK82HjO1lo8RQwcq7mRKHT1J3vW0x7nQuR43f2mIWwozi
	 leYFnl2/oPHcTFN4EZpHI2b/08YwKvC5pZ+ha3wcqKKmcSNd8M6Nk2WMeHdiGxiHSBcrt
	 aI+sFg3HRE++9gpmcElWsEed1mZxzwqs9ctxpzSk9GtkGXcWjKEtdZEn1HyvR+6LhuJEv
	 XHxZjgHkaDSmFQxbWiGp52H/m8t+FLODgbwweg+vrsf7BGlnMcrgBOwxFR7e8jkvX+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pAZkZmRt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F0C606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 09:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=pAZkZmRt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4E31F01825;
	Sat, 24 Oct 2026 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832458;
	bh=ylnJC5f7qy7gr7Xy6XOUTSHN17WnZYPnp96W4vu9iNI=;
	h=Date:To:From:Subject;
	b=pAZkZmRteU+n8sVIre4grp/DnSXht24ByXURYl36ERzMg6xAwOODNYRMG5oS563jb
	 0YIekhggmaz3uu1mphGG2PGmX8z6WBaUqntjle9aPijgvWX6SvlPJEASQJWiYaP7Pu
	 Ga6CxOzCCsGTfMXPht4EcWdkKz4sSmKyZImk/5XE=
Date: Sat, 24 Oct 2026 02:00:58 -0700
To: mm-commits@vger.kernel.org,sj@kernel.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch removed from -mm tree
Message-Id: <20261024090058.7F4E31F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/ops-common: fix age_in_sec overflow on 32-bit
has been removed from the -mm tree.  Its filename was
     mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: mm/damon/ops-common: fix age_in_sec overflow on 32-bit
Date: Mon,  5 Oct 2026 23:52:05 -0700

Patch series "mm/damon: fix a minor bug, clean code, and add a test".

Patch 1 from Jaeyeon Lee fixes a minor overflow issue in DAMOS.  Patch 2
from Gregory Price (Meta) cleans up the code for handling of hugetlb
pages.  Patch 3 from Liew Rui Yan adds a kunit test for a recently fixed
bug.


This patch (of 3):

damon_hot_score() calculates the age of a region by multiplying r->age and
the aggregation interval.  On 32-bit architectures, unsigned long is 32
bits, so the multiplication overflows once the age exceeds about 4295
seconds.  Then old regions are scored as if they were young.

Fix it by doing the calculation in 64-bit arithmetic using div_u64(). 
Also make age_in_sec u64, so the result is not truncated back to 32 bits.

The issue was discovered [1] by Sashiko.

Link: https://lore.kernel.org/20261006065209.41507-1-sj@kernel.org
Link: https://lore.kernel.org/20261006065209.41507-2-sj@kernel.org
Link: https://lore.kernel.org/20260623011652.1354-1-sj@kernel.org [1]
Fixes: 198f0f4c58b9 ("mm/damon/vaddr,paddr: support pageout prioritization")
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Assisted-by: LLM
---

 mm/damon/ops-common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/ops-common.c~mm-damon-ops-common-fix-age_in_sec-overflow-on-32-bit
+++ a/mm/damon/ops-common.c
@@ -164,7 +164,7 @@ int damon_hot_score(struct damon_ctx *c,
 			struct damos *s)
 {
 	int freq_subscore;
-	unsigned int age_in_sec;
+	u64 age_in_sec;
 	int age_in_log, age_subscore;
 	unsigned int freq_weight = s->quota.weight_nr_accesses;
 	unsigned int age_weight = s->quota.weight_age;
@@ -174,7 +174,8 @@ int damon_hot_score(struct damon_ctx *c,
 			DAMON_MAX_SUBSCORE,
 			damon_nr_samples_per_aggr(&c->attrs));
 
-	age_in_sec = (unsigned long)r->age * c->attrs.aggr_interval / 1000000;
+	age_in_sec = div_u64((u64)r->age * c->attrs.aggr_interval,
+			     USEC_PER_SEC);
 	if (age_in_sec)
 		age_in_log = min_t(int, ilog2(age_in_sec) + 1,
 				DAMON_MAX_AGE_IN_LOG);
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are


