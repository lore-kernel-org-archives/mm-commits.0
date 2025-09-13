Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7A29E11D
	for <mm-commits@vger.kernel.org>; Sat, 13 Sep 2025 22:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757801226; cv=none; b=WYT07mTHwaAk3kUqj5kyhJIYn35WqKq0Pu7BXgKMINuKIadjR/e87EuvCpBdm/2GbRYt3dgtIN5y2/OkSR6gK5DaLJ1Nlml2mGObJO4pzNEReiZTCFHc58zEInX8fQ1+7QiGtyw7JYi6B/i2TobuvdYY6p5UktC1mIe1FeUL5MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757801226; c=relaxed/simple;
	bh=vGOLTFIdhmtBjc1p+JYqy0kcTr+ajvB5/T4Lxoy7z8M=;
	h=Date:To:From:Subject:Message-Id; b=lE19wzUUqcU7n08fwAV1/Drs5FFiqIaCHg6bnnKOspz8W0TLAKRWm8vPpUhfxBA2hsJh4hQZprXzGSgc5M3DPdGaZ05B6G2uaIgjHt0XlTjx3hAGfgysGxliKbjAG+kPELrLAJp/TAal7Ebkhw7qvmvQXEe2M8kB46f88enHwa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=mZYjr/E8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="mZYjr/E8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DB6C4CEEB;
	Sat, 13 Sep 2025 22:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757801226;
	bh=vGOLTFIdhmtBjc1p+JYqy0kcTr+ajvB5/T4Lxoy7z8M=;
	h=Date:To:From:Subject:From;
	b=mZYjr/E8vueEK/k4NmTqRFQ8hml8tBIFZkXY0vPszVhNyEtO9JDYDt0TT+bb7rbMk
	 yv/3wCeQ1gqitM82TLBpIOkMFZP05y4ZCQBRaoGAEx4DbnRzzxD1BQDDaZXhe8tOKF
	 T5+LJSi1HwfDf+fqYtDgogXGoreXxQL0+4oUhHuE=
Date: Sat, 13 Sep 2025 15:07:05 -0700
To: mm-commits@vger.kernel.org,vincenzo.frascino@arm.com,vbabka@suse.cz,ryabinin.a.a@gmail.com,glider@google.com,dvyukov@google.com,andreyknvl@gmail.com,jannh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch removed from -mm tree
Message-Id: <20250913220706.02DB6C4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
has been removed from the -mm tree.  Its filename was
     kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2.patch

This patch was dropped because it was folded into kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch

------------------------------------------------------
From: Jann Horn <jannh@google.com>
Subject: kasan: add test for SLAB_TYPESAFE_BY_RCU quarantine skipping
Date: Tue, 29 Jul 2025 18:49:40 +0200

- disable migration to ensure that all SLUB operations use the same
  percpu state (vbabka)

- use EXPECT instead of ASSERT for pointer equality check so that
  expectation failure doesn't terminate the test with migration still
  disabled

Link: https://lkml.kernel.org/r/20250729-kasan-tsbrcu-noquarantine-test-v2-1-d16bd99309c9@google.com
Signed-off-by: Jann Horn <jannh@google.com>
Acked-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Vincenzo Frascino <vincenzo.frascino@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/kasan_test_c.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/kasan/kasan_test_c.c~kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v2
+++ a/mm/kasan/kasan_test_c.c
@@ -1088,23 +1088,25 @@ static void kmem_cache_rcu_reuse(struct
 				  NULL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, cache);
 
+	migrate_disable();
 	p = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
-		kmem_cache_destroy(cache);
-		return;
+		goto out;
 	}
 
 	kmem_cache_free(cache, p);
 	p2 = kmem_cache_alloc(cache, GFP_KERNEL);
 	if (!p2) {
 		kunit_err(test, "Allocation failed: %s\n", __func__);
-		kmem_cache_destroy(cache);
-		return;
+		goto out;
 	}
-	KUNIT_ASSERT_PTR_EQ(test, p, p2);
+	KUNIT_EXPECT_PTR_EQ(test, p, p2);
 
 	kmem_cache_free(cache, p2);
+
+out:
+	migrate_enable();
 	kmem_cache_destroy(cache);
 }
 
_

Patches currently in -mm which might be from jannh@google.com are

kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping.patch
kasan-add-test-for-slab_typesafe_by_rcu-quarantine-skipping-v3.patch

