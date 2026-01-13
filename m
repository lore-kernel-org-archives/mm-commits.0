Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE97B1632E7
	for <mm-commits@vger.kernel.org>; Tue, 13 Jan 2026 23:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768345547; cv=none; b=FfxNTVBpFpRg17scr4NYrr2rUX39efePERvxc2Fae06T6kddBwrEIagk8gAE+wxG67aZ4wG0Wr3c66tqfNPqrv5FJROLDeWzPMDOD+wKQHxEfpeV/TIKixbwQk/MOJMi0rY6AR+mTA1vK6raaogGr5LKxg2QeBEq5sACAm9qYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768345547; c=relaxed/simple;
	bh=Lxzi4fUj8W3uupLXA2Dmr9M053tT+SHjYx7WpdX4QDI=;
	h=Date:To:From:Subject:Message-Id; b=F7/QPrcT53bJhQ30NzQ8P893HpZmB3ZwlTcladm3AsJ+WbhOViGcCyB9tMrnVLybHID1QaH2Y+dsp5fq/GOwVz5VCgaDKT7HRjK+a4wtbRF18xE63b3TW8/aDawfe2auce+s2EgtYUPbM1XZnxCEsfMW1ytx3MDDA6daqMExUdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=U9ckmXi8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="U9ckmXi8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9B4C116C6;
	Tue, 13 Jan 2026 23:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768345547;
	bh=Lxzi4fUj8W3uupLXA2Dmr9M053tT+SHjYx7WpdX4QDI=;
	h=Date:To:From:Subject:From;
	b=U9ckmXi8nGjVqgHsNd2FhjPLe3FCIvAUiC+AJ7SR15X4hqmtEJXRhr7fuEvVk8Uo8
	 uhTpLgTkZesy4UYNjgOG8Ux8L9YIgNlAwuw2sBMvjQsjwEtGlOSrnk9iIDtKz13pu2
	 XyLXDjj6FqoAM45InhYd/e6cfdjn/u5n5+ib6TiI=
Date: Tue, 13 Jan 2026 15:05:46 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmsan-add-test_uninit_page.patch added to mm-new branch
Message-Id: <20260113230547.7A9B4C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: kmsan: add test_uninit_page
has been added to the -mm mm-new branch.  Its filename is
     mm-kmsan-add-test_uninit_page.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmsan-add-test_uninit_page.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

The mm-new branch of mm.git is not included in linux-next

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
From: Alexander Potapenko <glider@google.com>
Subject: mm: kmsan: add test_uninit_page
Date: Tue, 13 Jan 2026 10:11:51 +0100

Test that pages allocated with alloc_page() are uninitialized by default.

Link: https://lkml.kernel.org/r/20260113091151.4035013-2-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/kmsan_test.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/mm/kmsan/kmsan_test.c~mm-kmsan-add-test_uninit_page
+++ a/mm/kmsan/kmsan_test.c
@@ -378,6 +378,20 @@ static void test_uaf(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static void test_uninit_page(struct kunit *test)
+{
+	EXPECTATION_UNINIT_VALUE(expect);
+	struct page *page;
+	int *ptr;
+
+	kunit_info(test, "uninitialized page allocation (UMR report)\n");
+	page = alloc_pages(GFP_KERNEL, 0);
+	ptr = page_address(page);
+	USE(*ptr);
+	__free_pages(page, 0);
+	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
+}
+
 static volatile char *test_uaf_pages_helper(int order, int offset)
 {
 	struct page *page;
@@ -727,6 +741,7 @@ static struct kunit_case kmsan_test_case
 	KUNIT_CASE(test_uninit_kmsan_check_memory),
 	KUNIT_CASE(test_init_kmsan_vmap_vunmap),
 	KUNIT_CASE(test_init_vmalloc),
+	KUNIT_CASE(test_uninit_page),
 	KUNIT_CASE(test_uaf),
 	KUNIT_CASE(test_uaf_pages),
 	KUNIT_CASE(test_uaf_high_order_pages),
_

Patches currently in -mm which might be from glider@google.com are

mm-kmsan-add-tests-for-high-order-page-freeing.patch
mm-kmsan-add-test_uninit_page.patch

