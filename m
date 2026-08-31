Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68258403E9D
	for <mm-commits@vger.kernel.org>; Mon, 31 Aug 2026 23:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788219117; cv=none; b=T4hopENA/F5yqC+rpW49khgNz0g+XszrFQIjB+/eNeKzqKubaImlH1bymgIEqIFfXZF7GyUIrkHNmzIOjqwI2vmPJYDaSIZhl5ClgENoXGNQlQ3cZ4a8RLHV9rvXWSJ1vhntgk/H1APmDF9wMIssTwTztYpomxaBWU+mZM76AGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788219117; c=relaxed/simple;
	bh=SUgM0UlAjnWxMoY8JaIsW6+OdU2H/uKInVUgWA/kvBc=;
	h=Date:To:From:Subject:Message-Id; b=XZCl6Pyh/Ps7yxBJtBXJ2/MxMMX0/m9x2ud5370epSiqDcJr8EbgkEQpzxw5dRZ3wPEPIlqKPoViceq55ZlzH79NTMn5Mdk2Y4PSjo6LJ/RTQUtRGajq5Zk8OnKZWCVL6lfRXaNzEN/ts75D52iXxON73gkYNUF2JY95c+FGAHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=TeI9PaLO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="TeI9PaLO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 196881F000E9;
	Mon, 31 Aug 2026 23:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788219116;
	bh=TtVQsNfVl9ssaQAV7iM29o9wwO/l3ZVT1B6144v1RaI=;
	h=Date:To:From:Subject;
	b=TeI9PaLOXrVotdyMfLFuW8/x+hr6wWDuy4pYTFC93xN05lgf5rnhEANMNC4+2LVc1
	 yvX5+YqZ8GFLnlATe234LscXQjO0oOcYI/vEYoll/Yi+zlSzNMC6hvsLxOwzjXiRza
	 g0uAKNFq4goWVSwjNTA+P6KJm2PjSmewJPPV1JVA=
Date: Mon, 31 Aug 2026 16:31:55 -0700
To: mm-commits@vger.kernel.org,zhaozhengzhuo@uniontech.com,zenghui.yu@linux.dev,sj@kernel.org,shuah@kernel.org,liyouhong@kylinos.cn,lienze@kylinos.cn,harimishal1@gmail.com,gregkh@linuxfoundation.org,jaeyeon.lee.dev@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch added to mm-new branch
Message-Id: <20260831233156.196881F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/damon/tests: use scoped_guard() for damon_test_ops_registration
has been added to the -mm mm-new branch.  Its filename is
     mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch

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
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Enze Li <lienze@kylinos.cn>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hari Mishal <harimishal1@gmail.com>
Cc: Li Youhong <liyouhong@kylinos.cn>
Cc: Shuah Khan <shuah@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Cc: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-damon-tests-use-scoped_guard-for-damon_test_ops_registration.patch

