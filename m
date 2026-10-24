Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832319;
	b=TqnASE3/zNiaRDwiG94tqw2G9i/cDOVULPztK2/DPw1Y3whhunq4JvZpt0kJM8asllty
	 RdeusZzvM0ly6C5vmlH9TgE0qNMPN6Ny2vJvu3GBCqvSjpd95/3+pBOWsoekaA8pNidKG
	 w+h4x6QR1XAAA+7PhvkzpczSZaOJjXIU0AA26EMugq34lVJakewndOZN7DzvpUCBcLirL
	 063Y6+a862VmwoFFKUnsH4js8EVGOORrd+6WUg2oB7NP+GoPF+j6YoyHyiNcIvAmpJfPW
	 jxKnkGGgqDwo7eQa7TLsjyXjS2FGz82ujqD+Ogf0+F5lDUnEdt/7Ynp2aqPylTiwRyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832319;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=1odf5lfQgfiL0tZz4hvhGSGBeWhxv/gLOHziCInL3os=;
	b=QjpSLQvKFOoobNM7CKGtUhv+xHDZtzLsHt0pnNnKp7RQTMhZFfOAASiIkxnL8acrtSnl
	 SoVF2ouA9B76LbGIuw0lOEfS5xbc5j80BMXnDk4xhVGn8OQybJMOCFtSGnSwZGxAtUf/L
	 yPqNZGZN1bgU/ksfU3XjZGo41zsyWssxVDSLAv/doCL/cJFGx1WwNnN2Sdvq1OunJtEZ6
	 R7P9tDfBWC1iaEB3ddo47jDXUVxapkxDXZcdLU9xKJ6Q6NOrEUgq2PzbtS5COqQtStbH4
	 xcL6yMYg1eC2P5s54YfCBJ8W+O7xZ4QLMnuq4kPzrKRKaYMCo8wW3FkqiHsWYMbmfYg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Sr9NeeXO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA514606A31D
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Sr9NeeXO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B171F01825;
	Sat, 24 Oct 2026 08:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832318;
	bh=1odf5lfQgfiL0tZz4hvhGSGBeWhxv/gLOHziCInL3os=;
	h=Date:To:From:Subject;
	b=Sr9NeeXOb/z6TqbOSWVLDc0ZYxUv5BgLjn5Abit5w/77vAAyy5SETrl5nWKqSufXj
	 wyBesOfNNfqNZoVe1lLJ3Dybf2+N2WmRCiSG4D1QpNKdtkmp7rZnQgZGT136RmZJUm
	 KiwnYGIQ2oCKuDmoL4YExesashnuDtiKy3YrHxGQ=
Date: Sat, 24 Oct 2026 01:58:38 -0700
To: mm-commits@vger.kernel.org,davidgow@davidgow.net,brendan.higgins@linux.dev,sj@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch removed from -mm tree
Message-Id: <20261024085838.84B171F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: test quota_goal->complement commit
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-test-quota_goal-complement-commit.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SJ Park <sj@kernel.org>
Subject: mm/damon/tests/core-kunit: test quota_goal->complement commit
Date: Tue, 29 Sep 2026 01:01:07 -0700

Extend existing DAMOS quota goal commit unit test to test the complement
flag.  Set the source complement flag and confirm the destination is
updated to the given input.

Link: https://lore.kernel.org/20260929080113.41708-5-sj@kernel.org
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
---

 mm/damon/tests/core-kunit.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-test-quota_goal-complement-commit
+++ a/mm/damon/tests/core-kunit.h
@@ -861,6 +861,7 @@ static void damos_test_commit_quota_goal
 	damos_commit_quota_goal(dst, src);
 
 	KUNIT_EXPECT_EQ(test, dst->metric, src->metric);
+	KUNIT_EXPECT_EQ(test, dst->complement, src->complement);
 	KUNIT_EXPECT_EQ(test, dst->target_value, src->target_value);
 	if (src->metric == DAMOS_QUOTA_USER_INPUT)
 		KUNIT_EXPECT_EQ(test, dst->current_value, src->current_value);
@@ -904,6 +905,7 @@ static void damos_test_commit_quota_goal
 	damos_test_commit_quota_goal_for(test, &dst,
 			&(struct damos_quota_goal){
 			.metric = DAMOS_QUOTA_USER_INPUT,
+			.complement = true,
 			.target_value = 789,
 			.current_value = 12});
 	damos_test_commit_quota_goal_for(test, &dst,
_

Patches currently in -mm which might be from sj@kernel.org are


