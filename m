Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E863C278B
	for <mm-commits@vger.kernel.org>; Tue,  2 Jun 2026 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780439126; cv=none; b=qJQfQWVEb43bN3RhD/Ot3ZDVofwcI4LEJk17fHUOXAb87iE7wM5nlpTBOcGCWswNLcrN6JGdBcrHcKcmPTA5UtMhhqtUXIHjof3cgBOrqOPXSsZPEZyShMeAccR5uFCVWoGxK8cWqRClbmt8XiQkqnbHpZSLvZihv905k4zKUVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780439126; c=relaxed/simple;
	bh=dSetQ3fAvcasHE88J2xt3JCu675kwNng7z5Hd8J6f5I=;
	h=Date:To:From:Subject:Message-Id; b=qgECBnJyVfs4Oid3JMyarqIEqmDBRyK6a+xge6WU7Xw7Ruz36IUOwaLXGICBpEbizgOfPBL5DLheFgg8RDwAYFkftAhJTLM1ACZcrg6nJzNJlHQ3UOw6CELrqkOCqi1m/UpRcEJIaWpk2mFWZDJUKFHOqd5Pwk/+dcICV//SlzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=ZBHQcqVD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="ZBHQcqVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD89C1F00893;
	Tue,  2 Jun 2026 22:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1780439124;
	bh=o5uyKnh/FZDUVI5jyQ9KMZ7EHcKJPJDLKLhO/czEIRQ=;
	h=Date:To:From:Subject;
	b=ZBHQcqVDPg1PfC+K6YeohVFeyCaI5/qzDrgow1ha9HwlqqG13Es0r5D6Sgd2bQ1XS
	 lJkBKsS2bg6Atycx+53SuW/lKO8uxYeeaSOPwvUizlo3o73IRGKpdY0zHw9VUN78+D
	 P2Z7Y7FVNGtv23UcBqQbpl/yABSSOJnaHatBXvh4=
Date: Tue, 02 Jun 2026 15:25:24 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] lib-test_vmalloc-add-vrealloc-test-case.patch removed from -mm tree
Message-Id: <20260602222524.BD89C1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: lib/test_vmalloc: add vrealloc test case
has been removed from the -mm tree.  Its filename was
     lib-test_vmalloc-add-vrealloc-test-case.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Shivam Kalra <shivamkalra98@zohomail.in>
Subject: lib/test_vmalloc: add vrealloc test case
Date: Tue, 19 May 2026 17:42:18 +0530

Introduce a new test case "vrealloc_test" that exercises the vrealloc()
shrink and in-place grow paths:

  - Grow beyond allocated pages (triggers full reallocation).
  - Shrink crossing a page boundary (frees tail pages).
  - Shrink within the same page (no page freeing).
  - Grow within the already allocated page count (in-place).

Data integrity is validated after each realloc step by checking that the
first byte of the original allocation is preserved.

The test is gated behind run_test_mask bit 12 (id 4096).

Link: https://lore.kernel.org/20260519-vmalloc-shrink-v14-5-70b96ee3e9c9@zohomail.in
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   62 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

--- a/lib/test_vmalloc.c~lib-test_vmalloc-add-vrealloc-test-case
+++ a/lib/test_vmalloc.c
@@ -55,6 +55,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
 		"\t\tid: 2048, name: no_block_alloc_test\n"
+		"\t\tid: 4096, name: vrealloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -421,6 +422,66 @@ cleanup:
 	return nr_allocated != map_nr_pages;
 }
 
+static int vrealloc_test(void)
+{
+	void *ptr, *tmp;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		int err = -1;
+
+		ptr = vrealloc(NULL, PAGE_SIZE, GFP_KERNEL);
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 'a';
+
+		/* Grow: beyond allocated pages, triggers full realloc. */
+		tmp = vrealloc(ptr, 4 * PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: crosses page boundary, frees tail pages. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Shrink: within same page, no page freeing. */
+		tmp = vrealloc(ptr, PAGE_SIZE / 2, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		/* Grow: within allocated page, in-place, no realloc. */
+		tmp = vrealloc(ptr, PAGE_SIZE, GFP_KERNEL);
+		if (!tmp)
+			goto error;
+		ptr = tmp;
+
+		if (*((__u8 *)ptr) != 'a')
+			goto error;
+
+		err = 0;
+error:
+		vfree(ptr);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 struct test_case_desc {
 	const char *test_name;
 	int (*test_func)(void);
@@ -440,6 +501,7 @@ static struct test_case_desc test_case_a
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
 	{ "no_block_alloc_test", no_block_alloc_test, true },
+	{ "vrealloc_test", vrealloc_test, },
 	/* Add a new test case here. */
 };
 
_

Patches currently in -mm which might be from shivamkalra98@zohomail.in are


