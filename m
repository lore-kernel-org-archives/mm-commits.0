Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F9853B27E8
	for <mm-commits@vger.kernel.org>; Sun,  4 Oct 2026 20:04:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144269; cv=none; b=Rxmo+KQVyKvP7LFL6qB/l7YSTVhIGo6bz0nnVxJLSBLbXSokdNOr9/kIKMlzWqMNr0VDFllhaFy/LsdG+r+moI/xc3uo3rvp7HyyVfifFEYCuwxq3LLU7LNn1bt1PUw+dTaUhNEG211uKucakAwDcT6PAeyfyIIN2UmCSxtQnRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144269; c=relaxed/simple;
	bh=u3SsbQrq7bzyd6bqB0m1JPYtl5QELqXcJF1U8H85aks=;
	h=Date:To:From:Subject:Message-Id; b=Nd0QGQ74DZKu0AZQRWBE+0ZcnsA9L4DLemJzN70lvNLMe1olS1lU6EgkX4NlKAZnHq35YsDxbblHrRXIOWJZYeIZ0cqlNBlDBvURb7mfS7fITEnUbAdfa1eaOjvxOI4E+op7WFBZog0qRtNENPeAlQeLSIfs9Xp4i30ecFj/7Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=bQAiwFgk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="bQAiwFgk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31A41F00893;
	Sun,  4 Oct 2026 20:04:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791144265;
	bh=jlFjxGXS+9zl7AK3AeSLvWELXp6TkNPsqxdrxeKoDtY=;
	h=Date:To:From:Subject;
	b=bQAiwFgkhblcsKKkK+e8nvuZHwpGZ/Bhz8XF+EdYJ+sfrZArFC9YI5PORYQrjOVwr
	 0KUWU/gKEFrrQXp9yLfK4gzsvSZrXC9XrjFbd3mrFIwIxJCno24NizSzXXbWEMg8R3
	 wL84LR9dy6dTnMjIH0srPfWe84lQ1XEGCYe1w0UM=
Date: Sun, 04 Oct 2026 13:04:25 -0700
To: mm-commits@vger.kernel.org,donggeunyoo.kernel@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry.patch removed from -mm tree
Message-Id: <20261004200425.C31A41F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
has been removed from the -mm tree.  Its filename was
     selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Subject: selftests/mm: add tests for UFFDIO_MOVE of a uffd-protected swap entry
Date: Sat, 26 Sep 2026 21:41:45 +0900

Move a swapped-out page out of a write-protected or RWP-protected area
into a destination registered for missing faults only, and read pagemap
bit 57 at the destination.  The destination was never protected, so the
bit must be clear.

Link: https://lore.kernel.org/20260926124145.2878520-3-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Kiryl Shutsemau <kas@kernel.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   84 +++++++++++++++++
 1 file changed, 84 insertions(+)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-add-tests-for-uffdio_move-of-a-uffd-protected-swap-entry
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2037,6 +2037,75 @@ static void uffd_move_pmd_split_test(uff
 			      uffd_move_pmd_handle_fault);
 }
 
+/*
+ * Moving a swapped-out page out of a write-protected or RWP-protected area
+ * must not carry the uffd bit into a destination registered for missing
+ * faults only: such a bit is never cleared afterwards, so pagemap keeps
+ * reporting the page as uffd-tracked.
+ *
+ * Needs a swap device; skipped if MADV_PAGEOUT cannot evict the page.
+ */
+static void uffd_move_swap_test_common(uffd_global_test_opts_t *gopts,
+				       bool rwp)
+{
+	unsigned long page_size = gopts->page_size;
+	struct uffdio_move move = { };
+	int pagemap_fd;
+
+	if (rwp) {
+		if (uffd_register_rwp(gopts->uffd, gopts->area_src, page_size))
+			err("register src failure");
+	} else if (uffd_register(gopts->uffd, gopts->area_src, page_size,
+				 false, true, false)) {
+		err("register src failure");
+	}
+	if (uffd_register(gopts->uffd, gopts->area_dst, page_size,
+			  true, false, false))
+		err("register dst failure");
+
+	if (rwp)
+		rwprotect_range(gopts->uffd, (unsigned long)gopts->area_src,
+				page_size, true);
+	else
+		wp_range(gopts->uffd, (unsigned long)gopts->area_src,
+			 page_size, true);
+
+	pagemap_fd = pagemap_open();
+	if (madvise(gopts->area_src, page_size, MADV_PAGEOUT))
+		err("MADV_PAGEOUT");
+	if (!pagemap_is_swapped(pagemap_fd, gopts->area_src)) {
+		uffd_test_skip("MADV_PAGEOUT did not swap the page; is swap enabled?");
+		goto out;
+	}
+
+	move.dst = (unsigned long)gopts->area_dst;
+	move.src = (unsigned long)gopts->area_src;
+	move.len = page_size;
+	if (ioctl(gopts->uffd, UFFDIO_MOVE, &move))
+		err("UFFDIO_MOVE");
+
+	if (pagemap_get_entry(pagemap_fd, gopts->area_dst) & PM_UFFD_WP)
+		uffd_test_fail("uffd bit moved into an area registered for missing faults only");
+	else
+		uffd_test_pass();
+out:
+	close(pagemap_fd);
+	uffd_unregister(gopts->uffd, gopts->area_src, page_size);
+	uffd_unregister(gopts->uffd, gopts->area_dst, page_size);
+}
+
+static void uffd_move_swap_wp_test(uffd_global_test_opts_t *gopts,
+				   uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, false);
+}
+
+static void uffd_move_swap_rwp_test(uffd_global_test_opts_t *gopts,
+				    uffd_test_args_t *targs)
+{
+	uffd_move_swap_test_common(gopts, true);
+}
+
 static bool
 uffdio_verify_results(const char *name, int ret, int error, long result)
 {
@@ -2360,6 +2429,21 @@ uffd_test_case_t uffd_tests[] = {
 		.test_case_ops = &uffd_move_test_pmd_case_ops,
 	},
 	{
+		.name = "move-swap-wp",
+		.uffd_fn = uffd_move_swap_wp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE |
+		UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
+	{
+		.name = "move-swap-rwp",
+		.uffd_fn = uffd_move_swap_rwp_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_MOVE | UFFD_FEATURE_RWP,
+		.test_case_ops = &uffd_move_test_case_ops,
+	},
+	{
 		.name = "wp-fork",
 		.uffd_fn = uffd_wp_fork_test,
 		.mem_targets = MEM_ALL,
_

Patches currently in -mm which might be from donggeunyoo.kernel@gmail.com are

mm-damon-core-charge-only-the-part-of-a-region-the-filter-left.patch
mm-damon-tests-core-kunit-test-the-size-charged-for-a-filter-trimmed-region.patch
mm-damon-core-prevent-size-quota-overflow-in-the-temporal-goal-tuner.patch
mm-damon-tests-core-kunit-test-the-temporal-tuners-size-quota-conversion.patch

