Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156C823816C
	for <mm-commits@vger.kernel.org>; Tue,  7 Oct 2025 21:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759872987; cv=none; b=Y+2/CLWR7EG9k+WCjboZFhNJIIZu7L//yR5rpw39BgzaKjFbXnyxMm9rkMtJiY6fxnq6puzqCYdWQuXVjBHRJyG+PkvMM4Ixk6QnrIWGD/2m5FCZTYvWEKjO12yeszH+JCXbWSzub2/L7n2TEzWwlhRGZb5N5wDQ3tx8FKt4eiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759872987; c=relaxed/simple;
	bh=Y8ZsxhMQciQNBJnZgu2YceBEJYTZsqZkUXl0bb2O42c=;
	h=Date:To:From:Subject:Message-Id; b=jfJScCUKWqKvgxOW5epq6kmWA75BJ6gmvJsqfeaUv6YxFW+7wAu+WrREkQqTzQg3RSNRktIjnlT0D1vslxuE8OUwKteS/0knWJZfoXNsxp2882WRc26HVwOL4YqITLYxI6VPow7P/oUT4oc0J6PxwZSH1KqEidz1Jg/zJQHDnk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Ve+mFWjA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Ve+mFWjA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85371C4CEF1;
	Tue,  7 Oct 2025 21:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759872986;
	bh=Y8ZsxhMQciQNBJnZgu2YceBEJYTZsqZkUXl0bb2O42c=;
	h=Date:To:From:Subject:From;
	b=Ve+mFWjAVbMeG2pjBN/QaD/9dULMbfMjU+LSQREOY++4xg/GJp/YRmHOPVUU2oMW/
	 1Hkyji9NeqnRTJnIYVI90pG3MkyKnxNWyF3BU/QMbxKUKFkg9COuSgNJWG8treKWWC
	 95Ht4qAXkAesq8ffcBHMPDV/6F+Twl/X41C1jUBo=
Date: Tue, 07 Oct 2025 14:36:25 -0700
To: mm-commits@vger.kernel.org,ryabinin.a.a@gmail.com,mhocko@suse.com,mhocko@kernel.org,glider@google.com,elver@google.com,bhe@redhat.com,urezki@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-test_vmalloc-add-no_block_alloc_test-case.patch added to mm-new branch
Message-Id: <20251007213626.85371C4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: lib/test_vmalloc: add no_block_alloc_test case
has been added to the -mm mm-new branch.  Its filename is
     lib-test_vmalloc-add-no_block_alloc_test-case.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-test_vmalloc-add-no_block_alloc_test-case.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Subject: lib/test_vmalloc: add no_block_alloc_test case
Date: Tue, 7 Oct 2025 14:20:26 +0200

Patch series "__vmalloc()/kvmalloc() and no-block support", v4.


This patch (of 10):

Introduce a new test case "no_block_alloc_test" that verifies non-blocking
allocations using __vmalloc() with GFP_ATOMIC and GFP_NOWAIT flags.

It is recommended to build kernel with CONFIG_DEBUG_ATOMIC_SLEEP enabled
to help catch "sleeping while atomic" issues.  This test ensures that
memory allocation logic under atomic constraints does not inadvertently
sleep.

Link: https://lkml.kernel.org/r/20251007122035.56347-2-urezki@gmail.com
Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Marco Elver <elver@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/test_vmalloc.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/lib/test_vmalloc.c~lib-test_vmalloc-add-no_block_alloc_test-case
+++ a/lib/test_vmalloc.c
@@ -54,6 +54,7 @@ __param(int, run_test_mask, 7,
 		"\t\tid: 256,  name: kvfree_rcu_1_arg_vmalloc_test\n"
 		"\t\tid: 512,  name: kvfree_rcu_2_arg_vmalloc_test\n"
 		"\t\tid: 1024, name: vm_map_ram_test\n"
+		"\t\tid: 2048, name: no_block_alloc_test\n"
 		/* Add a new test case description here. */
 );
 
@@ -283,6 +284,30 @@ static int fix_size_alloc_test(void)
 	return 0;
 }
 
+static int no_block_alloc_test(void)
+{
+	void *ptr;
+	int i;
+
+	for (i = 0; i < test_loop_count; i++) {
+		bool use_atomic = !!(get_random_u8() % 2);
+		gfp_t gfp = use_atomic ? GFP_ATOMIC : GFP_NOWAIT;
+		unsigned long size = (nr_pages > 0 ? nr_pages : 1) * PAGE_SIZE;
+
+		preempt_disable();
+		ptr = __vmalloc(size, gfp);
+		preempt_enable();
+
+		if (!ptr)
+			return -1;
+
+		*((__u8 *)ptr) = 0;
+		vfree(ptr);
+	}
+
+	return 0;
+}
+
 static int
 pcpu_alloc_test(void)
 {
@@ -411,6 +436,7 @@ static struct test_case_desc test_case_a
 	{ "kvfree_rcu_1_arg_vmalloc_test", kvfree_rcu_1_arg_vmalloc_test, },
 	{ "kvfree_rcu_2_arg_vmalloc_test", kvfree_rcu_2_arg_vmalloc_test, },
 	{ "vm_map_ram_test", vm_map_ram_test, },
+	{ "no_block_alloc_test", no_block_alloc_test, true },
 	/* Add a new test case here. */
 };
 
_

Patches currently in -mm which might be from urezki@gmail.com are

lib-test_vmalloc-add-no_block_alloc_test-case.patch
lib-test_vmalloc-remove-xfail-condition-check.patch
mm-vmalloc-support-non-blocking-gfp-flags-in-alloc_vmap_area.patch
mm-vmalloc-defer-freeing-partly-initialized-vm_struct.patch
mm-vmalloc-handle-non-blocking-gfp-in-__vmalloc_area_node.patch
mm-kasan-support-non-blocking-gfp-in-kasan_populate_vmalloc.patch
kmsan-remove-hard-coded-gfp_kernel-flags.patch
mm-skip-might_alloc-warnings-when-pf_memalloc-is-set.patch
mm-vmalloc-update-__vmalloc_node_range-documentation.patch
mm-kvmalloc-add-non-blocking-support-for-vmalloc.patch

