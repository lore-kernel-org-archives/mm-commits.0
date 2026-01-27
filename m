Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6EE031A563
	for <mm-commits@vger.kernel.org>; Tue, 27 Jan 2026 04:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769486725; cv=none; b=hwIY9dmS0JzX7KVA+uu92ym5xVri0NeW++VnjohGkWzp1FaduM/J3Fd4zeu5y6bZs4H0ltdyh4TXTvF4ekSROkMlpNVeaL/BQNbamtjsj8K6QQny1/NSGyIqQCJUSplwl4Kw2v6nJJymCG+hWge3opNXguf/RnlwnHxqVMgEJDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769486725; c=relaxed/simple;
	bh=zCC2IA0AFLLdSxVoHRI+ADFyPOf3aryfqyiAkklr614=;
	h=Date:To:From:Subject:Message-Id; b=VNcstj6N4EJKQ6r1i4aznvbwdrMFZZu5VE7p4zSqHZbQVHmH7pJw6i6DDzDLQNmdIFewC22utTQ0xGaAY4x358bh1pV/VrQ39OIyCcg+KcuaODHd9TmMb6NC1sitoeP3FKM8CsurbxYG3I7fTEcLorus8NIb41uThiISf1BJ1/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=giFh1vth; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="giFh1vth"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E001C116C6;
	Tue, 27 Jan 2026 04:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769486725;
	bh=zCC2IA0AFLLdSxVoHRI+ADFyPOf3aryfqyiAkklr614=;
	h=Date:To:From:Subject:From;
	b=giFh1vthH8W4YDkqoV98vXKqfSWxsQm1LBiwYuoIjG+1Lnx/K8fC8P9rljjRP+5DS
	 H64V9sHoY4pR2iDc/PRuD8IudDLqOiPOHXVqGzCJ/R/0OL9OEmZN7E1uM1NkzTYqhh
	 9ochtAly0rQr3ut+dUNMpWYLFbNxgormif+92qC4=
Date: Mon, 26 Jan 2026 20:05:25 -0800
To: mm-commits@vger.kernel.org,ryan.roberts@arm.com,elver@google.com,dvyukov@google.com,glider@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kmsan-add-test_uninit_page.patch removed from -mm tree
Message-Id: <20260127040525.9E001C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm: kmsan: add test_uninit_page
has been removed from the -mm tree.  Its filename was
     mm-kmsan-add-test_uninit_page.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


