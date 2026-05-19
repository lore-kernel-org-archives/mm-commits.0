Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 261A9328631
	for <mm-commits@vger.kernel.org>; Tue, 19 May 2026 18:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779214094; cv=none; b=TQczNlcPoSj8SeuCDxNkVd78IQKHzP9WsNrTdo8xU9a9i7oCd85+sJrpAq4kMItbBTDrdU1UwL0Q6m6UDPrD/GdHuEceWbGRkoL188RZMWsNyJVU8FCpCh+qmPBmQVwXP8L7MNjYYGrVbsGmTKH0j7AgxYaMnyF5unxrLOubZ4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779214094; c=relaxed/simple;
	bh=9fRTWRpX3/lpCo9YizEc7X5vmd0/C67K8gsDAr4emvk=;
	h=Date:To:From:Subject:Message-Id; b=S1nqH+KHSIiN44LsyPLvjN75kyI/b2EIBx8VmeC17J3jSGHCQqD+kxDjzwng1ttt09zeMFqo1yA018Lm59RTi5BkVNNbaS4ylCn6vFaV71vSSG4KsEj9wXZhgOpq3fnNWEmFxkdW4oQtnJqlzz4JIEWPavMu7hP8bpH2sjadMuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tUOZgPJt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tUOZgPJt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EE0C2BCB8;
	Tue, 19 May 2026 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779214093;
	bh=9fRTWRpX3/lpCo9YizEc7X5vmd0/C67K8gsDAr4emvk=;
	h=Date:To:From:Subject:From;
	b=tUOZgPJtQQMMe7hLOI3p5zUSknJhkc9yV+jQ7mOYsNXufdaSYxto/8MJPceL8Pv7t
	 aei3SpWWvDL03Tho5YdPr/KknbU88676HTBY8hMyz/1plaJRrFGKpFSEwXX8M13oAd
	 3R8sqxmr4iGMwVtgCZ034pJ4D9O+PR8hR5tJWLqA=
Date: Tue, 19 May 2026 11:08:13 -0700
To: mm-commits@vger.kernel.org,urezki@gmail.com,dakr@kernel.org,aliceryhl@google.com,shivamkalra98@zohomail.in,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmalloc-add-vrealloc-test-case.patch added to mm-new branch
Message-Id: <20260519180813.C3EE0C2BCB8@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc: add vrealloc test case
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmalloc-add-vrealloc-test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmalloc-add-vrealloc-test-case.patch

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

mm-vmalloc-extract-vm_area_free_pages-helper-from-vfree.patch
mm-vmalloc-use-physical-page-count-for-vrealloc-grow-in-place-check.patch
mm-vmalloc-use-physical-page-count-in-vread_iter-for-vm_alloc-areas.patch
mm-vmalloc-free-unused-pages-on-vrealloc-shrink.patch
lib-test_vmalloc-add-vrealloc-test-case.patch

