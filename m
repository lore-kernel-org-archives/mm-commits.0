Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E0625A2A2
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 00:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791334289; cv=none; b=P36orR1AFiE1VOqMu+V8lvjObst4FHMqtm2VacVZklsfFxvgGFABiUPW+7F5i1k2uLgCXqawANs9Dh5QlPFuLhWQMuw3Ub9lEP0bnquoV8WwUt5rvurtWgmzVk4jr9FyQAm9/2fAYicYCl8iXoO9mP7fh/1uAbUzK0a8zng8IIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791334289; c=relaxed/simple;
	bh=b9x7DhekIYKLjpeIvDpex3V60yLj3DglHWGAGDuxxWA=;
	h=Date:To:From:Subject:Message-Id; b=h9xeR+oEGr+WkfMpGRT46uDfNemuEJuTHq+4wwBNoOjVB5m8FOeRowCwrmDxvMDZU/mxyAszhfaONJ9HjlFJo2W9wG0SrzAG6aioYsF6U9BF5MRHXhUI5txmS+iLe1zzYHMQ6od+SgfLFWAl+lGW8i0J7S+n4+fuu09KtBvWHQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=dtvtSywU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="dtvtSywU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9561F0089C;
	Wed,  7 Oct 2026 00:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791334288;
	bh=m+twLOgPcHZJOBmCu1KbW15wyuLi1shCZuv9l5XCchM=;
	h=Date:To:From:Subject;
	b=dtvtSywUQ/e6txBSz3ybTBXn+wuKKbbYWZBeKbqc4coMH1OEMQ1qeSEVoBAJn9jgK
	 k93BWVwTX61y03sSUfq/ra3DaF8qyj2qB6CY9Z91tgOX98t4pB9BxSqNws+m3gnX9x
	 w7gf7Zm+NGqGCtsz+vJ2lJDvKOmC0c6AiYgpvd3Y=
Date: Tue, 06 Oct 2026 17:51:27 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,harimishal1@gmail.com,gregkh@linuxfoundation.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch removed from -mm tree
Message-Id: <20261007005128.4C9561F0089C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests: use scoped_guard() for damon_test_ops_registration
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Subject: mm/damon/tests: use scoped_guard() for damon_test_ops_registration
Date: Mon, 31 Aug 2026 07:26:07 -0700

Replace manual mutex_lock() and mutex_unlock() calls with the
scoped_guard() macro.  This simplifies the code, improves readability, and
ensures that the lock is automatically released when the scope ends,
preventing potential lock leaks in the future.

Link: https://lore.kernel.org/20260831142611.77572-6-sj@kernel.org
Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
---

 mm/damon/tests/core-kunit.h |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration
+++ a/mm/damon/tests/core-kunit.h
@@ -441,17 +441,17 @@ static void damon_test_ops_registration(
 	KUNIT_EXPECT_EQ(test, damon_select_ops(c, NR_DAMON_OPS), -EINVAL);
 
 	/* Registration should success after unregistration */
-	mutex_lock(&damon_ops_lock);
-	bak = damon_registered_ops[DAMON_OPS_VADDR];
-	damon_registered_ops[DAMON_OPS_VADDR] = (struct damon_operations){};
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock) {
+		bak = damon_registered_ops[DAMON_OPS_VADDR];
+		damon_registered_ops[DAMON_OPS_VADDR] =
+			(struct damon_operations){};
+	}
 
 	ops.id = DAMON_OPS_VADDR;
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), 0);
 
-	mutex_lock(&damon_ops_lock);
-	damon_registered_ops[DAMON_OPS_VADDR] = bak;
-	mutex_unlock(&damon_ops_lock);
+	scoped_guard(mutex, &damon_ops_lock)
+		damon_registered_ops[DAMON_OPS_VADDR] = bak;
 
 	/* Check double-registration failure again */
 	KUNIT_EXPECT_EQ(test, damon_register_ops(&ops), -EINVAL);
@@ -459,10 +459,9 @@ static void damon_test_ops_registration(
 	damon_destroy_ctx(c);
 
 	if (need_cleanup) {
-		mutex_lock(&damon_ops_lock);
-		damon_registered_ops[DAMON_OPS_VADDR] =
-			(struct damon_operations){};
-		mutex_unlock(&damon_ops_lock);
+		scoped_guard(mutex, &damon_ops_lock)
+			damon_registered_ops[DAMON_OPS_VADDR] =
+				(struct damon_operations){};
 	}
 }
 
_

Patches currently in -mm which might be from jaeyeon.lee.dev@gmail.com are

selftests-mm-skip-khugepaged-file-tests-if-mkfsxfs-is-unavailable.patch
selftests-mm-hugetlb-read-hwpoison-add-setup-of-hugetlb-pages.patch
selftests-mm-hugetlb_madv_vs_map-fix-tap-plan-mismatches.patch

