Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4143F2EEE84
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791865912; cv=none; b=d8FEX1PfLYGm15zusa2bf5cfRjRw4aUHhVyjf4LgitI3+8Duo8pCQs36Jqa8eZbJmF2GZkf7nEUpEFJIj6yTOeZvgIXNU8+Z+d7TxncMrpZ0zLQ5zE71Pb1H8jtKd2pMqyrrQw1tad+kvXIok8HkLjVqXdd+RMjw+g6dZ7eV8dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791865912; c=relaxed/simple;
	bh=lD/4m3oTc7VMGFQISrxEc+viyWJ4BdQwnIMxDCdr17M=;
	h=Date:To:From:Subject:Message-Id; b=C+1NwKH9/dJYrrRZ2cwqHOE6zW2HbcPJKJafIJDmv5YNvaOkbEi1StAEcltJR6uh5Kt6BuAyQlUkSnXygKqsY284S5IXQBbUNUMLrvvLchm5072n3qTIfvlWW0eA3cGOehOpqVlcg8AfOeRMgJyq/pYpTd4n1mcZlwOGLuAeHhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d+FCKuLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d+FCKuLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18CFF1F00893;
	Tue, 13 Oct 2026 04:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791865911;
	bh=k/oPt/v68NuzhoRAmtqvoxyldI2bob3rFql2g+d8wgE=;
	h=Date:To:From:Subject;
	b=d+FCKuLxBBdvN0L4bEqpX7Z4kItaDEk22XDL2iJXnf8V43uvOJVFL0Nb+KhS0YuM1
	 GGkWe++xPDRet1n0LzU555pVqqxzlFkQYWOzLWm8D9rxuGBLgXbvEZONXHxIpLVfLq
	 rFjGV8W3K4mEeYz/LK55I70KSTZRQ17S7Lyk+G0g=
Date: Mon, 12 Oct 2026 21:31:50 -0700
To: mm-commits@vger.kernel.org,zenghui.yu@linux.dev,vbabka@kernel.org,surenb@google.com,sj@kernel.org,shuah@kernel.org,rppt@kernel.org,rdunlap@infradead.org,mhocko@suse.com,ljs@kernel.org,lianux.mm@gmail.com,liam@infradead.org,eva.kurchatova@virtuozzo.com,david@kernel.org,davidgow@davidgow.net,corbet@lwn.net,brendan.higgins@linux.dev,aethernet65535@gmail.com,kunwu.chan@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch removed from -mm tree
Message-Id: <20261013043151.18CFF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
has been removed from the -mm tree.  Its filename was
     mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kunwu Chan <kunwu.chan@gmail.com>
Subject: mm/damon/tests/core-kunit: improve nr_samples_per_aggr test isolation
Date: Mon, 14 Sep 2026 07:19:49 -0700

Test the zero sample interval case with a non-zero aggregation interval,
and keep the zero/zero case to cover the zero-result fallback.

Also make the overflow case use an explicit sample interval so that it
does not depend on the zero sample interval fallback.

Link: https://lore.kernel.org/20260914141952.91465-5-sj@kernel.org
Signed-off-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Lian Wang <lianux.mm@gmail.com>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@davidgow.net>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eva Kurchatova <eva.kurchatova@virtuozzo.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
---

 mm/damon/tests/core-kunit.h |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/mm/damon/tests/core-kunit.h~mm-damon-tests-core-kunit-improve-nr_samples_per_aggr-test-isolation
+++ a/mm/damon/tests/core-kunit.h
@@ -627,12 +627,20 @@ static void damon_test_set_regions(struc
 
 static void damon_test_nr_samples_per_aggr(struct kunit *test)
 {
-	struct damon_attrs attrs = {
+	struct damon_attrs attrs;
+
+	/* Zero sample interval is treated as one. */
+	attrs = (struct damon_attrs){
 		.sample_interval = 0,
-		.aggr_interval = 0,
+		.aggr_interval = 5000,
 	};
+	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 5000);
 
-	/* Zero aggregation interval doesn't cause division by zero */
+	/* Zero sample and aggregation intervals cover the zero-result fallback. */
+	attrs = (struct damon_attrs){
+		.sample_interval = 0,
+		.aggr_interval = 0,
+	};
 	KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs), 1);
 
 	/*
@@ -640,7 +648,10 @@ static void damon_test_nr_samples_per_ag
 	 * overflow
 	 */
 	if (ULONG_MAX > UINT_MAX) {
-		attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+		attrs = (struct damon_attrs){
+			.sample_interval = 1,
+			.aggr_interval = (unsigned long)UINT_MAX + 1,
+		};
 		KUNIT_EXPECT_EQ(test, damon_nr_samples_per_aggr(&attrs),
 				UINT_MAX);
 	}
_

Patches currently in -mm which might be from kunwu.chan@gmail.com are


