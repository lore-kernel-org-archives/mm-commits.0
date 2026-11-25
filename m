Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795573172;
	b=CDXN27noG8mjHCaHUep+0C0yWMfz/8o0ppVWZjauYHj/4u2LJBoiD/JQIFLmWEngN5RR
	 nmUKA2Yeqf8v2ejrKnKp8ckbamGVMDgXaFgBrsENg56uuyYprcEcaz5KPNk85oPCwxOd/
	 oIIt26C5qS0e2TAeIQg7MTfv+8SBNEYiKQDh72BCIzewHfOir8Iw+iCp/iPCGeOXvPqwF
	 +pY7U3WMYoQzEG7tTCM2iJ+S34asNLL8jnuF/D2L3NPAcqO32fg2NQ4VVxESTDd+4VWWX
	 k/lCfVzGyhxZCuQ7xHSt0ILM/hL0Ywwp0NXJSzydUHDAQC33LXsKMmdEFopH5swqqoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795573172;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=8gtZR7492sR9aVANIk1f+SZHG3GwMHkJEHBXdO6Im5U=;
	b=bpdSEZY0osD20cCEQR0rvsjjS4/BKk1Ql1cC+lS8KgzJEVxI4eo+b59uSv3eP7vFnmhf
	 MkxcaMIdpWIRBajK28lmwdkOhI0e9uHgywJDDvxUw3r3cZ/BxgQURmvIenivBmq3SfuOJ
	 jj4Qm5Op6qYqJHre/CR1yZJBJZWFcf7eYV8+VhJqQ4QeovlA6fEDiCvoy3ie7S4NnNA1s
	 wvuhW6P/YCzRPgCZQLPuyDA6mpm5Vs6GXfkJPoqoo/fhxxgUZtbJkoaF0wEbSF/i51o7t
	 4x6J7dB5CO5NU6xFrjTxpdTLF/U+1zE5VFEurqoohd3oLY9Myw8S/eU5euEZV5PEXQg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HZ84y5+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF06E606A32A
	for <mm-commits@vger.kernel.org>; Wed, 25 Nov 2026 02:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=HZ84y5+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E681F000C6;
	Wed, 25 Nov 2026 02:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795573171;
	bh=8gtZR7492sR9aVANIk1f+SZHG3GwMHkJEHBXdO6Im5U=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=HZ84y5+3MN4UtIG5c84dRVZxQ1Sjo+nLYQ3A8y5AEsG3f9pvZqFkggI2xNXdsBuhW
	 c/wpb6wsSi92P2FcakyYmZ8aN4NPR/tjObTiEFl8h/MlW8Z3ata/jGDd8EkoHzGyeC
	 YzFW95iw1EjBcXRVz0jGGHyhdGJ2ojQMzOawmMAo=
Date: Tue, 24 Nov 2026 18:19:31 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,usama.anjum@arm.com,
	surenb@google.com,shuah@kernel.org,rppt@kernel.org,mhocko@suse.com,
	ljs@kernel.org,liam@infradead.org,david@kernel.org,chris@chrisdown.name,
	akpm@linux-foundation.org,matthewsalsamendi@gmail.com
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261118-pagemap-walk-end-v2-2-94cd92d838b3@gmail.com>
References: <20261118-pagemap-walk-end-v2-2-94cd92d838b3@gmail.com>
Subject: + selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry.patch added to mm-new branch
Message-Id: <20261125021931.91E681F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: cover PAGEMAP_SCAN refill and HugeTLB retry
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry.patch

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
From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Subject: selftests/mm: cover PAGEMAP_SCAN refill and HugeTLB retry
Date: Tue, 17 Nov 2026 16:26:17 -0800

Check that scanning 513 disjoint dirty pages returns every range and sets
walk_end to the end of the scan.  For a written HugeTLB page, limit the
scan to one base page, then retry from walk_end and check that the whole
page is returned and write-protected.

Codex assisted with the selftests, validation and this message.

Link: https://patch.msgid.link/20261118-pagemap-walk-end-v2-2-94cd92d838b3@gmail.com
Signed-off-by: Matthew Salsamendi <matthewsalsamendi@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Chris Down <chris@chrisdown.name>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

 tools/testing/selftests/mm/pagemap_ioctl.c |   61 ++++++++++++++++++-
 1 file changed, 60 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -682,6 +682,62 @@ static int sanity_tests_sd(void)
 	return 0;
 }
 
+static void test_walk_end_after_refill(void)
+{
+	/* One more range than the internal buffer holds on x86-64. */
+	struct page_region vec[513];
+	size_t len = 2 * ARRAY_SIZE(vec) * page_size;
+	long ret, walk_end;
+	char *mem;
+	bool ok;
+	size_t i;
+
+	mem = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("mmap: %s\n", strerror(errno));
+	if (madvise(mem, len, MADV_NOHUGEPAGE) && errno != EINVAL)
+		ksft_exit_fail_msg("MADV_NOHUGEPAGE: %s\n", strerror(errno));
+
+	wp_init(mem, len);
+	for (i = 0; i < ARRAY_SIZE(vec); i++)
+		mem[2 * i * page_size] = 1;
+
+	ret = pagemap_ioc(mem, len, vec, ARRAY_SIZE(vec), 0, 0,
+			  PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
+	ok = ret == ARRAY_SIZE(vec) && walk_end == (long)(mem + len);
+	for (i = 0; ok && i < ARRAY_SIZE(vec); i++) {
+		uintptr_t addr = (uintptr_t)(mem + 2 * i * page_size);
+
+		ok = vec[i].start == addr && vec[i].end == addr + page_size;
+	}
+	ksft_test_result(ok, "PAGEMAP_SCAN walk_end after buffer refill\n");
+
+	wp_free(mem, len);
+	munmap(mem, len);
+}
+
+static void test_hugetlb_walk_end(char *mem, size_t len)
+{
+	const int flags = PM_SCAN_WP_MATCHING | PM_SCAN_CHECK_WPASYNC;
+	struct page_region range;
+	long ret, walk_end;
+	bool ok;
+
+	mem[0] = 1;
+	ret = pagemap_ioc(mem, len, &range, 1, flags, 1, PAGE_IS_WRITTEN,
+			  0, 0, PAGE_IS_WRITTEN, &walk_end);
+	ok = ret == 0 && walk_end == (long)mem &&
+	     !(pagemap_get_entry(pagemap_fd, mem) & PM_UFFD_WP);
+	if (ok) {
+		ret = pagemap_ioc((void *)walk_end, len, &range, 1, flags, len / page_size,
+				  PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
+		ok = ret == 1 && walk_end == (long)(mem + len) &&
+		     range.start == (uintptr_t)mem && range.end == (uintptr_t)(mem + len) &&
+		     (pagemap_get_entry(pagemap_fd, mem) & PM_UFFD_WP);
+	}
+	ksft_test_result(ok, "PAGEMAP_SCAN HugeTLB write-protect retry\n");
+}
+
 static int base_tests(char *prefix, char *mem, size_t mem_size, int skip)
 {
 	size_t vec_size;
@@ -1661,7 +1717,7 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(119);
+	ksft_set_plan(121);
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
@@ -1669,6 +1725,7 @@ int main(int __attribute__((unused)) arg
 
 	/* 1. Sanity testing */
 	sanity_tests_sd();
+	test_walk_end_after_refill();
 
 	/* 2. Normal page testing */
 	mem_size = 10 * page_size;
@@ -1730,10 +1787,12 @@ int main(int __attribute__((unused)) arg
 		wp_addr_range(mem, mem_size);
 
 		base_tests("Hugetlb mem testing:", mem, mem_size, 0);
+		test_hugetlb_walk_end(mem, mem_size);
 
 		wp_free(mem, mem_size);
 	} else {
 		base_tests("Hugetlb mem testing:", NULL, 0, 1);
+		ksft_test_result_skip("PAGEMAP_SCAN HugeTLB write-protect retry: no huge page\n");
 	}
 
 	/* 7. File Hugetlb testing */
_

Patches currently in -mm which might be from matthewsalsamendi@gmail.com are

fs-proc-task_mmu-reset-walk_end-before-each-pagemap-walk.patch
selftests-mm-cover-pagemap_scan-refill-and-hugetlb-retry.patch

