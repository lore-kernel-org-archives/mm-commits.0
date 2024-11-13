Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE70F186E40
	for <mm-commits@vger.kernel.org>; Wed, 13 Nov 2024 07:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731481331; cv=none; b=XGjVeJehQiraM/Y+lucSZXyXx7Ch2sOUwxQTbkk7Qes41UfXMaQardYyKAcgfF0BCmXo5SUC+VJVn2ClfAqK/aLH9bX+6CN1DFT24hwVC+AYObpC0udATUBwTiEsiK3DnfrNHLY0jNTh+MbMAEyUxFoenWLqNrTthKiy+frCpm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731481331; c=relaxed/simple;
	bh=RSq1JM0hm+sKLdsh0FwzXn0nTqeARTsaO8FcRZJugpE=;
	h=Date:To:From:Subject:Message-Id; b=qltSXiM0xh46fiY6wUPefC4L1MOghgeQPBc4PJlJ7i+6CrLN9/WjrU+XvjFkWHbeqJ3atvW8DM1mH4Zn4Blxmu/sFwALCoc1yA0s6GDvdVNaF9N/MwSn+vfsJACZ+FM5ezwmGPrXlkbBgZPke1vzUC5RSicxbIzZ9PKwjB4KVMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=YBUJfVQE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="YBUJfVQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A89C4CECD;
	Wed, 13 Nov 2024 07:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1731481331;
	bh=RSq1JM0hm+sKLdsh0FwzXn0nTqeARTsaO8FcRZJugpE=;
	h=Date:To:From:Subject:From;
	b=YBUJfVQENZlZKzMi23WMCIf8erB2twKZRDB/sF2ClArHwaJ3DFhA4xrJPVWIuGhow
	 Jk3IrndzokyJ9Bys7Rc1YsHeosk2LDXkbJZlHaErKzFE/pnkUCsuRL+o+p7AqIsuOz
	 Okc4E09s+QNPY93Zl1SJJ9dONEUV3Il1aTjHd1Zs=
Date: Tue, 12 Nov 2024 23:02:10 -0800
To: mm-commits@vger.kernel.org,ritesh.list@gmail.com,glider@google.com,elver@google.com,dvyukov@google.com,nirjhar@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch added to mm-unstable branch
Message-Id: <20241113070211.33A89C4CECD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/kfence: add a new kunit test test_use_after_free_read_nofault()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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

mm-kfence-add-a-new-kunit-test-test_use_after_free_read_nofault.patch

