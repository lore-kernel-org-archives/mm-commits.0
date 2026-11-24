Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563248;
	b=BlPy300DqSdC2wk6hEEhjZ9DQqpZ9WY1Byzsup2mJ+KHd3M1b9HYseraXA1xCeIlK5a8
	 ijyrjzoQCV4cdALoSGwsFez3mKiNn+bIUJcc9vZMwwM/xAqf32+FXl/J450XQF++s+tdI
	 JNuTCx0IUAcjbfcLctkaVtn6r38aPpNUY74MwvF69h0h0xfE/4LHyvwXRWhP7FKuU52yf
	 wf3ud13E2A9WS5/OkVKk9D0RTN5hWmFWTf4x95w6XM6ZsvsxnSpcO7kA1fE1xMGqbhcLT
	 mSXgBq9iLVDp065l/WoN3qh0pX/ECAUE4mP2GAxZ7jz747UrV38YPluXGgQqK8KN7Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563248;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=MBWQ6a8p94SYQlBcvzYJUwmyw6cHdyiUCNfkIB21NvQ=;
	b=25K4wZxx/A2EIykboZ/XpLkxT9FlH9XO9sS6yMbx8gU48TqnXojZ7iSc16pkTglO0pKq
	 aPEaxujCYHMslYH3DoFkw40Or55w/y5opH7EYK+lVLJjVNKWrDSdr6cL0uXoPEc3gn0dU
	 b+xE/52biwSxCkiN5qsaNMS1Tc6iWkR9qk7gL1QqodmDAVF6z+kDlyIcRcrNm4R/cHqLl
	 ZmdM3x6yu+Z1a8Qek9nq9UFr2KekJZ6xDEtrOY14tEwUrt4eMJ3/UdJ83vDy3ozBVPQf2
	 U2mXR4SeXfDwvmtg/CWroHOkapgdBEfW6AVVO7mKoOCQ2H494SNa1SIIl4jdXcixfcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qT9kJzdb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1481E606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 23:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=qT9kJzdb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80CE51F000C6;
	Tue, 24 Nov 2026 23:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795563247;
	bh=MBWQ6a8p94SYQlBcvzYJUwmyw6cHdyiUCNfkIB21NvQ=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=qT9kJzdbuZ+Ejq33ICzT8XF1hN9X3qSgT6994Ka5xkkjhfwzfRfOiAVIjVgcrUmr2
	 7v1n9hEOg3CVEozWzJLNb7HSKJ7cLGvlUBr8TwqPIy5VXtUfYccXCJtVa/saKwpq7H
	 VHHb0QWl1tK7BUKTUfgKIqgW/Zu0mxAo9q2hn2jQ=
Date: Tue, 24 Nov 2026 15:34:07 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,
	mhocko@suse.com,lokeshgidra@google.com,ljs@kernel.org,liam@infradead.org,
	david@kernel.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122082020.1255434-3-kaleshsingh@google.com>
References: <20261122082020.1255434-3-kaleshsingh@google.com>
Subject: + selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type.patch added to mm-new branch
Message-Id: <20261124233407.80CE51F000C6@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: uffd-unit-tests: filter required features per memory type
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type.patch

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
From: Kalesh Singh <kaleshsingh@google.com>
Subject: selftests/mm: uffd-unit-tests: filter required features per memory type
Date: Sun, 22 Nov 2026 08:20:18 +0000

CONFIG_PTE_MARKER_UFFD_WP defaults to y but can be turned off, and
userfaultfd write protection then works only on anonymous memory.  The
kernel still reports UFFD_FEATURE_PAGEFAULT_FLAG_WP but no longer
UFFD_FEATURE_WP_HUGETLBFS_SHMEM.

uffd-unit-tests checks a test's whole feature mask for every memory type,
so the tests that run on all memory types and require
UFFD_FEATURE_WP_HUGETLBFS_SHMEM (register-ioctls, the wp-fork tests,
rwp-wp-exclusive, sigbus-wp and events-wp) skip their anonymous runs too. 
Check and request only the features that apply to the memory type under
test, and make minor-wp require UFFD_FEATURE_WP_HUGETLBFS_SHMEM, as it
write-protects shmem and hugetlbfs.

Link: https://patch.msgid.link/20261122082020.1255434-3-kaleshsingh@google.com
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Liam R. Howlett (Google) <liam@infradead.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>

 tools/testing/selftests/mm/uffd-unit-tests.c |   42 ++++++++++++++---
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -176,15 +176,44 @@ out:
 }
 
 
-static bool uffd_feature_supported(uffd_test_case_t *test)
+/*
+ * Filter test->uffd_feature_required down to the features needed for @mem_type.
+ * For example, UFFD_FEATURE_WP_HUGETLBFS_SHMEM (gated on
+ * CONFIG_PTE_MARKER_UFFD_WP) only applies to shmem and hugetlbfs, so anonymous
+ * subtests should still run when it is absent.
+ */
+static uint64_t uffd_test_features(const uffd_test_case_t *test,
+				   const mem_type_t *mem_type)
+{
+	const uint64_t shmem = UFFD_FEATURE_MISSING_SHMEM |
+			       UFFD_FEATURE_MINOR_SHMEM;
+	const uint64_t hugetlb = UFFD_FEATURE_MISSING_HUGETLBFS |
+				 UFFD_FEATURE_MINOR_HUGETLBFS;
+	uint64_t features = test->uffd_feature_required;
+
+	switch (mem_type->mem_flag) {
+	case MEM_ANON:
+		return features & ~(shmem | hugetlb |
+				    UFFD_FEATURE_WP_HUGETLBFS_SHMEM);
+	case MEM_SHMEM:
+	case MEM_SHMEM_PRIVATE:
+		return features & ~hugetlb;
+	case MEM_HUGETLB:
+	case MEM_HUGETLB_PRIVATE:
+		return features & ~shmem;
+	default:
+		return features;
+	}
+}
+
+static bool uffd_feature_supported(uint64_t required)
 {
 	uint64_t features;
 
 	if (uffd_get_features(&features))
 		return false;
 
-	return (features & test->uffd_feature_required) ==
-	    test->uffd_feature_required;
+	return (features & required) == required;
 }
 
 static int pagemap_open(void)
@@ -2742,6 +2771,7 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required =
 		UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM |
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP |
+		UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
 		/*
 		 * HACK: here we leveraged WP_UNPOPULATED to detect whether
 		 * minor mode supports wr-protect.  There's no feature flag
@@ -2961,6 +2991,7 @@ int main(int argc, char *argv[])
 	mem_type_t *mem_type;
 	uffd_test_args_t args;
 	const char *errmsg;
+	uint64_t features;
 	int i, j, opt;
 
 	while ((opt = getopt(argc, argv, "f:hl")) != -1) {
@@ -3036,11 +3067,12 @@ int main(int argc, char *argv[])
 			/* Initialize test arguments */
 			args.mem_type = mem_type;
 
-			if (!uffd_feature_supported(test)) {
+			features = uffd_test_features(test, mem_type);
+			if (!uffd_feature_supported(features)) {
 				uffd_test_skip("feature missing");
 				continue;
 			}
-			if (uffd_test_ctx_init(&gopts, test->uffd_feature_required, &errmsg)) {
+			if (uffd_test_ctx_init(&gopts, features, &errmsg)) {
 				uffd_test_skip(errmsg);
 				continue;
 			}
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-swap-make-swap_header-badpages-a-flexible-array.patch
selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases.patch
selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type.patch

