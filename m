Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 448333B7B9A
	for <mm-commits@vger.kernel.org>; Mon, 16 Mar 2026 15:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773676745; cv=none; b=uc9z3yCDIuzJWH+Ct2IXV9e+I0pc2FvpC6q8vS+2JmM89SK6+KG7lOR/v7jQiC+r4gxjBbvgJFHIPZZVOh6fhRkWEaZxY3DlHbgWS8f68L7RbZT0xkeXR/5qyfXKR+6b1aHg1HY6Q+HlV9fu57Ge208YCsFtBDrXd5Trp5aWpsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773676745; c=relaxed/simple;
	bh=wgIKacEQ/fmz39gUy9LhnQ8Lkdjzi4MZ6K2bNaGWXng=;
	h=Date:To:From:Subject:Message-Id; b=nh39/DPnlzK1n+Bs/WcmDSkLBu0d3QwYhp/DEt6p4wT/K2mtO6yqdzt06VHQn+LjPOzR5bM+nJdPKY5kAPSRQf82GTtmWJDbksh7h8dBY8F2vpcQ92M7uU6ILcTbxjBJWF2BuX5YpZq1+n2DvlBeYbD6HGh6gsrxSOvT+erSaKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rfVxv8qt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rfVxv8qt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC41EC19425;
	Mon, 16 Mar 2026 15:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773676745;
	bh=wgIKacEQ/fmz39gUy9LhnQ8Lkdjzi4MZ6K2bNaGWXng=;
	h=Date:To:From:Subject:From;
	b=rfVxv8qtX/7efvr6BNTXnK0QqMimFawrgrEMZs8AO35+Gk/Fe8/2yl2TOkMnY9+J0
	 4Vx7UaLw+iDVuhC/gFHxGiOkKbrE8aI+tNrx3YDYHg33y1MU6hstTL7e645qPo3lau
	 3tZBl/6EXhPvhV9dtfnOoZxzq61CgPb1chzdpLpU=
Date: Mon, 16 Mar 2026 08:59:04 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,willy@infradead.org,viro@zeniv.linux.org.uk,vbabka@suse.cz,tj@kernel.org,sweettea-kernel@dorminy.me,surenb@google.com,sj@kernel.org,shakeel.butt@linux.dev,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,richard.weiyang@gmail.com,paulmck@kernel.org,objecting@objecting.org,mjguzik@gmail.com,mhocko@suse.com,mhiramat@kernel.org,mathieu.desnoyers@efficios.com,lorenzo.stoakes@oracle.com,liumartin@google.com,linmiaohe@huawei.com,liam.howlett@oracle.com,hannes@cmpxchg.org,dennis@kernel.org,david@redhat.com,cl@linux.com,brauner@kernel.org,baolin.wang@linux.alibaba.com,aboorvad@linux.ibm.com,devnexen@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons.patch added to mm-unstable branch
Message-Id: <20260316155904.EC41EC19425@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib: add kunit boundary tests for percpu_counter_tree comparisons
has been added to the -mm mm-unstable branch.  Its filename is
     lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: David Carlier <devnexen@gmail.com>
Subject: lib: add kunit boundary tests for percpu_counter_tree comparisons
Date: Mon, 16 Mar 2026 14:38:05 +0000

Add boundary tests for all four comparison APIs to validate that
the accuracy parameters are correctly applied:

- percpu_counter_tree_approximate_compare_value()
- percpu_counter_tree_precise_compare_value()
- percpu_counter_tree_approximate_compare()
- percpu_counter_tree_precise_compare()

The single-value tests probe the accuracy range boundaries (at,
beyond, and in the asymmetric gap between under and over) to catch
swapped accuracy parameters. The two-counter tests verify the
symmetric combined accuracy boundary for counter-to-counter
comparisons.

Link: https://lkml.kernel.org/r/20260316143805.36805-2-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Reviewed-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Josh Law <objecting@objecting.org>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Martin Liu <liumartin@google.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/tests/percpu_counter_tree_kunit.c |  190 ++++++++++++++++++++++++
 1 file changed, 190 insertions(+)

--- a/lib/tests/percpu_counter_tree_kunit.c~lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons
+++ a/lib/tests/percpu_counter_tree_kunit.c
@@ -86,6 +86,194 @@ static void check_counters(struct kunit
 	KUNIT_EXPECT_EQ(test, 0, percpu_counter_tree_approximate_compare(&counter[0], &counter[1]));
 }
 
+static void hpcc_test_compare_value_boundaries(struct kunit *test)
+{
+	struct percpu_counter_tree pct;
+	struct percpu_counter_tree_level_item *counter_items;
+	unsigned long under = 0, over = 0;
+	int ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size(), GFP_KERNEL);
+	KUNIT_ASSERT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init(&pct, counter_items, 32, GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	percpu_counter_tree_set(&pct, 0);
+	percpu_counter_tree_approximate_accuracy_range(&pct, &under, &over);
+
+	/*
+	 * With approx_sum = precise_sum = 0, from the accuracy invariant:
+	 *   approx_sum - over <= precise_sum <= approx_sum + under
+	 * Positive deltas use 'under' as tolerance, negative use 'over'.
+	 */
+
+	/* --- percpu_counter_tree_approximate_compare_value --- */
+
+	/* At boundary: indeterminate */
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_approximate_compare_value(&pct,
+			(long)under));
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_approximate_compare_value(&pct,
+			-(long)over));
+
+	/* Beyond boundary: definitive */
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_approximate_compare_value(&pct,
+			(long)(under + 1)));
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_approximate_compare_value(&pct,
+			-(long)(over + 1)));
+
+	/* Asymmetric gap: catches swapped accuracy parameters */
+	if (under != over) {
+		if (under > over) {
+			KUNIT_EXPECT_EQ(test, 0,
+				percpu_counter_tree_approximate_compare_value(
+					&pct, (long)(over + 1)));
+			KUNIT_EXPECT_EQ(test, -1,
+				percpu_counter_tree_approximate_compare_value(
+					&pct, -(long)(over + 1)));
+		} else {
+			KUNIT_EXPECT_EQ(test, 1,
+				percpu_counter_tree_approximate_compare_value(
+					&pct, (long)(under + 1)));
+			KUNIT_EXPECT_EQ(test, 0,
+				percpu_counter_tree_approximate_compare_value(
+					&pct, -(long)(under + 1)));
+		}
+	}
+
+	/* --- percpu_counter_tree_precise_compare_value --- */
+
+	/*
+	 * With approx_sum = precise_sum = 0, the precise comparison
+	 * must return the exact result. At boundary values the
+	 * approximate fast-path returns indeterminate, exercising
+	 * the precise sum fallback.
+	 */
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_precise_compare_value(&pct, 0));
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_precise_compare_value(&pct,
+			(long)under));
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_precise_compare_value(&pct,
+			-(long)over));
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_precise_compare_value(&pct,
+			(long)(under + 1)));
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_precise_compare_value(&pct,
+			-(long)(over + 1)));
+
+	if (under != over) {
+		if (under > over) {
+			KUNIT_EXPECT_EQ(test, 1,
+				percpu_counter_tree_precise_compare_value(
+					&pct, (long)(over + 1)));
+			KUNIT_EXPECT_EQ(test, -1,
+				percpu_counter_tree_precise_compare_value(
+					&pct, -(long)(over + 1)));
+		} else {
+			KUNIT_EXPECT_EQ(test, 1,
+				percpu_counter_tree_precise_compare_value(
+					&pct, (long)(under + 1)));
+			KUNIT_EXPECT_EQ(test, -1,
+				percpu_counter_tree_precise_compare_value(
+					&pct, -(long)(under + 1)));
+		}
+	}
+
+	percpu_counter_tree_destroy(&pct);
+	kfree(counter_items);
+}
+
+static void hpcc_test_compare_counter_boundaries(struct kunit *test)
+{
+	struct percpu_counter_tree pct[2];
+	struct percpu_counter_tree_level_item *counter_items;
+	unsigned long under = 0, over = 0;
+	unsigned long combined;
+	int ret;
+
+	counter_items = kzalloc(percpu_counter_tree_items_size() * 2,
+				GFP_KERNEL);
+	KUNIT_ASSERT_PTR_NE(test, counter_items, NULL);
+	ret = percpu_counter_tree_init_many(pct, counter_items, 2, 32,
+					    GFP_KERNEL);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
+	percpu_counter_tree_approximate_accuracy_range(&pct[0],
+						       &under, &over);
+
+	/*
+	 * Both counters have the same configuration. The combined
+	 * accuracy for two-counter comparison is symmetric:
+	 *   accuracy_pos = over + under = under + over = accuracy_neg
+	 */
+	combined = under + over;
+
+	/* --- percpu_counter_tree_approximate_compare --- */
+
+	/* At boundary: indeterminate */
+	percpu_counter_tree_set(&pct[0], (long)combined);
+	percpu_counter_tree_set(&pct[1], 0);
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_approximate_compare(&pct[0], &pct[1]));
+
+	percpu_counter_tree_set(&pct[0], 0);
+	percpu_counter_tree_set(&pct[1], (long)combined);
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_approximate_compare(&pct[0], &pct[1]));
+
+	/* Beyond boundary: definitive */
+	percpu_counter_tree_set(&pct[0], (long)(combined + 1));
+	percpu_counter_tree_set(&pct[1], 0);
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_approximate_compare(&pct[0], &pct[1]));
+
+	percpu_counter_tree_set(&pct[0], 0);
+	percpu_counter_tree_set(&pct[1], (long)(combined + 1));
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_approximate_compare(&pct[0], &pct[1]));
+
+	/* --- percpu_counter_tree_precise_compare --- */
+
+	/* At boundary: precise gives exact result */
+	percpu_counter_tree_set(&pct[0], (long)combined);
+	percpu_counter_tree_set(&pct[1], 0);
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_precise_compare(&pct[0], &pct[1]));
+
+	percpu_counter_tree_set(&pct[0], 0);
+	percpu_counter_tree_set(&pct[1], (long)combined);
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_precise_compare(&pct[0], &pct[1]));
+
+	/* Beyond boundary: definitive */
+	percpu_counter_tree_set(&pct[0], (long)(combined + 1));
+	percpu_counter_tree_set(&pct[1], 0);
+	KUNIT_EXPECT_EQ(test, 1,
+		percpu_counter_tree_precise_compare(&pct[0], &pct[1]));
+
+	percpu_counter_tree_set(&pct[0], 0);
+	percpu_counter_tree_set(&pct[1], (long)(combined + 1));
+	KUNIT_EXPECT_EQ(test, -1,
+		percpu_counter_tree_precise_compare(&pct[0], &pct[1]));
+
+	/* Equal counters */
+	percpu_counter_tree_set(&pct[0], 42);
+	percpu_counter_tree_set(&pct[1], 42);
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_approximate_compare(&pct[0], &pct[1]));
+	KUNIT_EXPECT_EQ(test, 0,
+		percpu_counter_tree_precise_compare(&pct[0], &pct[1]));
+
+	percpu_counter_tree_destroy_many(pct, 2);
+	kfree(counter_items);
+}
+
 static int multi_thread_worker_fn(void *data)
 {
 	struct multi_thread_test_data *td = data;
@@ -383,6 +571,8 @@ static struct kunit_case hpcc_test_cases
 	KUNIT_CASE(hpcc_test_single_thread_random),
 	KUNIT_CASE(hpcc_test_multi_thread_batch_increment),
 	KUNIT_CASE(hpcc_test_multi_thread_random_walk),
+	KUNIT_CASE(hpcc_test_compare_value_boundaries),
+	KUNIT_CASE(hpcc_test_compare_counter_boundaries),
 	KUNIT_CASE(hpcc_test_init_one),
 	KUNIT_CASE(hpcc_test_set),
 	{}
_

Patches currently in -mm which might be from devnexen@gmail.com are

lib-introduce-hierarchical-per-cpu-counters-fix.patch
lib-add-kunit-boundary-tests-for-percpu_counter_tree-comparisons.patch

