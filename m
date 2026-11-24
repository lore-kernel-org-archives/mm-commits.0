Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795563245;
	b=APJVHg6dxJAs7jsQGbAQahZmkLMTis1dTd40gvBzCkleDtpwE2Z98fH51hEKpaiM+iZT
	 W7FmwpFYaUii6zfUSeyT1cAm2a12nUj6kgLSOw3b1xt4vOA4BdhWJ6oZKwkG4b57avZJi
	 /M0fnpYfcQc7bykSAOOsHoI0S54AgHhz5BXcNxEvWhlMTjACEedt1Cm1aKrpNAzM/8HGK
	 fAkLeEIKM82rt5Yap6kPz7/9bg7kqKpWsHBq3eBWRk4XvB2/2ePSBtj8lrc/At5kbH/0j
	 AEKf7AnX2LRQYL79QQ4X//lUjFfPsm+9o1ZH8gdDJFSf3FUqP7j8AiVkD0LA1lDubmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795563245;
	h=Received:DKIM-Signature:Date:To:From:In-Reply-To:References:Subject:
	 Message-Id;
	bh=LoX4e9LB5wW7p8QXBM30MIPyUrixWQHAyI+jO6IxGYo=;
	b=xVjBHQoTTXXQHuUrg44rBD8FotUdHtKWJmvVgMHspgja1VT3GwRVAoQkbIbQ2rEgiRSe
	 zKrBPM5gnvvASXFT3v0f4loobDHaVlowCnnDH4sB4g62mknPuC0oNntOLcdavMztGwio+
	 07Dwp8/LzmQqWM3MN+LD/OvA2R65awj9jXwJEm2QX0TffOrDMLC3z5SJJtr91T+DIYk1g
	 F39fAt50a51qpq+937PuYqk9rwmWizUSc/x8rONW4op75IjlkC2G+NP68bIhdm5AD7Wt3
	 UvKVVZPhirZTClKprsGjYcA4H/bRhsGJz0bBFDKF2CjWWhfX5UHXQ1nB+OPcynUOCOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b="Ss6sZ/aD";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64E60606A31E
	for <mm-commits@vger.kernel.org>; Tue, 24 Nov 2026 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=Ss6sZ/aD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 103281F000CA;
	Tue, 24 Nov 2026 23:34:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795563245;
	bh=LoX4e9LB5wW7p8QXBM30MIPyUrixWQHAyI+jO6IxGYo=;
	h=Date:To:From:In-Reply-To:References:Subject;
	b=Ss6sZ/aDJFeKEyoDqwPwLKHL9zGIkiNAN1dlJD0UPTEzb5TjW84U9xYUAdkqEt262
	 UrrGKAelXOGS7i5Dn79I3qW9wQuJsS6FhLQxWETDCErKOg6UMTua4gbeBdETDU03Xs
	 WAF2nO6cqEMR5t1d/mrv4jNoU7/UFZQ+GvNSUef0=
Date: Tue, 24 Nov 2026 15:34:04 -0800
To: mm-commits@vger.kernel.org,vbabka@kernel.org,surenb@google.com,
	shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,peterx@redhat.com,
	mhocko@suse.com,lokeshgidra@google.com,ljs@kernel.org,liam@infradead.org,
	david@kernel.org,kaleshsingh@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20261122082020.1255434-2-kaleshsingh@google.com>
References: <20261122082020.1255434-2-kaleshsingh@google.com>
Subject: + selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases.patch added to mm-new branch
Message-Id: <20261124233405.103281F000CA@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The patch titled
     Subject: selftests/mm: uffd-wp-mremap: skip unsupported shmem and hugetlb cases
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases.patch

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
Subject: selftests/mm: uffd-wp-mremap: skip unsupported shmem and hugetlb cases
Date: Sun, 22 Nov 2026 08:20:17 +0000

Patch series "selftests/mm: fix userfaultfd tests with
CONFIG_PTE_MARKER_UFFD_WP=n".

With CONFIG_PTE_MARKER_UFFD_WP=n, userfaultfd write protection only works
on anonymous memory.  uffd-wp-mremap then fails its shmem and hugetlb
cases, and uffd-unit-tests skips anonymous runs that would pass.  Patch 1
skips the unsupported uffd-wp-mremap cases and patch 2 filters
uffd-unit-tests' required features per memory type.

Tested on arm64 device: with CONFIG_PTE_MARKER_UFFD_WP=n,
uffd-wp-mremap goes from 26 failures to none and uffd-unit-tests
passes 78 tests instead of 70; with =y, the results are unchanged.


This patch (of 2):

uffd-wp-mremap checks only for UFFD_FEATURE_PAGEFAULT_FLAG_WP before it
runs. With CONFIG_PTE_MARKER_UFFD_WP=n the kernel keeps that feature
but supports write protection on anonymous memory only, so the shmem
and hugetlb cases fail with EINVAL from UFFDIO_REGISTER instead of
skipping. Skip them when UFFD_FEATURE_WP_HUGETLBFS_SHMEM is missing.

Link: https://lore.kernel.org/20261122082020.1255434-1-kaleshsingh@google.com
Link: https://patch.msgid.link/20261122082020.1255434-2-kaleshsingh@google.com
Fixes: b2466bb3b495 ("selftests/mm: introduce uffd-wp-mremap regression test")
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

 tools/testing/selftests/mm/uffd-wp-mremap.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/mm/uffd-wp-mremap.c~selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases
+++ a/tools/testing/selftests/mm/uffd-wp-mremap.c
@@ -18,15 +18,14 @@ static int nr_thpsizes;
 static unsigned long thpsizes[20];
 static int nr_hugetlbsizes;
 static unsigned long hugetlbsizes[10];
+static uint64_t uffd_features;
 
 static void check_uffd_wp_feature_supported(void)
 {
-	uint64_t features = 0;
-
-	if (uffd_get_features(&features))
+	if (uffd_get_features(&uffd_features))
 		ksft_exit_skip("failed to get available features (%d)\n", errno);
 
-	if (!(features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
+	if (!(uffd_features & UFFD_FEATURE_PAGEFAULT_FLAG_WP))
 		ksft_exit_skip("uffd-wp feature not supported\n");
 }
 
@@ -180,6 +179,12 @@ static void test_one_folio(uffd_global_t
 				swapout ? "true" : "false",
 				hugetlb ? "true" : "false");
 
+	if ((!private || hugetlb) &&
+	    !(uffd_features & UFFD_FEATURE_WP_HUGETLBFS_SHMEM)) {
+		ksft_test_result_skip("uffd-wp on shmem and hugetlbfs is not supported\n");
+		return;
+	}
+
 	/* Allocate a folio of required size and type. */
 	mem = alloc_one_folio(size, private, hugetlb);
 	if (!mem) {
_

Patches currently in -mm which might be from kaleshsingh@google.com are

mm-swap-make-swap_header-badpages-a-flexible-array.patch
selftests-mm-uffd-wp-mremap-skip-unsupported-shmem-and-hugetlb-cases.patch
selftests-mm-uffd-unit-tests-filter-required-features-per-memory-type.patch

