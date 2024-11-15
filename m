Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46EF153800
	for <mm-commits@vger.kernel.org>; Fri, 15 Nov 2024 06:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653403; cv=none; b=LoXDsG1XJWLnbkD0JbVkJvehvX5yLEzuWnhc40Wu7e3VCxfX778P7unVjJoWP/X+BpBMFonJ8zb7MJ0UfKlHXsUvPkMoyEgR1bTWTdCtB1xC/yYVj+3iIX7yz8ec1TJrIXGGMBmcrBpILBftyVl3Ji53hnY3+rSkXzXUuJN0nrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653403; c=relaxed/simple;
	bh=NiR/5hoEnTl9lO+MoODhCofhAUVaCeQR6AugAFJtoTU=;
	h=Date:To:From:Subject:Message-Id; b=CkNs4VACvgh+TI3DiFrQroiNQXQaMI+rm8qe0Ymwq8Lfdlc2Qh0RvK5/qGM/+YpdqAdE0bjuyxjrPiKIoFu7LyP5uKKobyF8fAmHfbaFGxPPRFye7dWArw5niDbHGUi1o7iPQstYf/OZBiSL6CsOiaj9qyEdsRuk+0UUBU0hTrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=VBMo0yzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="VBMo0yzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C2EFC4CECF;
	Fri, 15 Nov 2024 06:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731653403;
	bh=NiR/5hoEnTl9lO+MoODhCofhAUVaCeQR6AugAFJtoTU=;
	h=Date:To:From:Subject:From;
	b=VBMo0yzI/bZt07o0iJwXEDX8SsNFJ+4jELTHttECAXEzX7ph7n6nlTdTpPok0HY7p
	 qcgWSY0F8NI58zTfVcOLbFigKNuqCsXuTg7yAYWYSHm3Hk1nWssW5st70hVRPKrKmH
	 cjwH3zbsQXw8BT1jZ3xIYcKbpfB0azGFOAA7b1yw=
Date: Thu, 14 Nov 2024 22:49:59 -0800
To: mm-commits@vger.kernel.org,ritesh.list@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,nirjhar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch removed from -mm tree
Message-Id: <20241115065003.1C2EFC4CECF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/kfence: add a new kunit test test_use_after_free_read_nofault()
has been removed from the -mm tree.  Its filename was
     mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Nirjhar Roy <nirjhar@linux.ibm.com>
Subject: mm/kfence: add a new kunit test test_use_after_free_read_nofault()
Date: Fri, 18 Oct 2024 23:16:01 +0530

Faults from copy_from_kernel_nofault() need to be handled by fixup table
and should not be handled by kfence.  Otherwise while reading /proc/kcore
which uses copy_from_kernel_nofault(), kfence can generate false
negatives.  This can happen when /proc/kcore ends up reading an unmapped
address from kfence pool.

Let's add a testcase to cover this case.

Link: https://lkml.kernel.org/r/210e561f7845697a32de44b643393890f180069f.1729272697.git.ritesh.list@gmail.com
Signed-off-by: Nirjhar Roy <nirjhar@linux.ibm.com>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Tested-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/kfence_test.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/mm/kfence/kfence_test.c~mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault
+++ a/mm/kfence/kfence_test.c
@@ -383,6 +383,22 @@ static void test_use_after_free_read(str
 	KUNIT_EXPECT_TRUE(test, report_matches(&expect));
 }
 
+static void test_use_after_free_read_nofault(struct kunit *test)
+{
+	const size_t size = 32;
+	char *addr;
+	char dst;
+	int ret;
+
+	setup_test_cache(test, size, 0, NULL);
+	addr = test_alloc(test, size, GFP_KERNEL, ALLOCATE_ANY);
+	test_free(addr);
+	/* Use after free with *_nofault() */
+	ret = copy_from_kernel_nofault(&dst, addr, 1);
+	KUNIT_EXPECT_EQ(test, ret, -EFAULT);
+	KUNIT_EXPECT_FALSE(test, report_available());
+}
+
 static void test_double_free(struct kunit *test)
 {
 	const size_t size = 32;
@@ -780,6 +796,7 @@ static struct kunit_case kfence_test_cas
 	KFENCE_KUNIT_CASE(test_out_of_bounds_read),
 	KFENCE_KUNIT_CASE(test_out_of_bounds_write),
 	KFENCE_KUNIT_CASE(test_use_after_free_read),
+	KFENCE_KUNIT_CASE(test_use_after_free_read_nofault),
 	KFENCE_KUNIT_CASE(test_double_free),
 	KFENCE_KUNIT_CASE(test_invalid_addr_free),
 	KFENCE_KUNIT_CASE(test_corruption),
_

Patches currently in -mm which might be from nirjhar@linux.ibm.com are


