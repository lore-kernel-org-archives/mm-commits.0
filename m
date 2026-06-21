Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537DF2F3632
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067140; cv=none; b=DNu8x2vaq7B1Ozi4vALps6SnUsMmAvZQQCN8H7o7+mVBgo40lxLUoupk5+gPLVq7CwZrC4LXZozy3Tg2ibnHPADhZP23rOy2/hPESJaK3oSEUTAr8HvWK/pcLjZEhAdPb1xYXxJLj57G1T++hi2vYMu1W4carpZe+i89N2wR7y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067140; c=relaxed/simple;
	bh=JN5bhdv8/W90TX1ipWNU8Kl+Bsm+ajTLcR9jUeAfr7M=;
	h=Date:To:From:Subject:Message-Id; b=Ig35P41wwrK4RPY+c0K16HqNPbDWC+xgtvOUBBmQCL3fwTeDKRSiozFS/xVwmV+BSi+lDxh0BF5KgIozPma5GDgLPfHp8vgpQ8ykFhlcOXDUL3aIcgY2Ui6Ary0ChOde8xouYbPVfXFlC8ZO7vTUxgSmrJ4dO5a+fkO44orn/S8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BHWsB8/a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BHWsB8/a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6A11F00A3A;
	Sun, 21 Jun 2026 18:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067139;
	bh=IN9CfFtnhOqm2pk+2eVAQgEPKofG+7gKjPlGXLEEp0E=;
	h=Date:To:From:Subject;
	b=BHWsB8/alcXUmUyn1SNWaaqIBhvlmV46V7RGmZILybrukxgWY/xSLESToamwaVDhP
	 49bXbr5cLuYIti3fRUX3naHTFhzC2UO8jTYjrOvGYg95EnL2mKhFPFw3xfpJ9eElKR
	 Ek75hfByImPqzk6B2cdoKGzXa8tlulK9+PPKguEw=
Date: Sun, 21 Jun 2026 11:38:58 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-protection_keys-use-kselftest-framework.patch removed from -mm tree
Message-Id: <20260621183859.2B6A11F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: protection_keys: use kselftest framework
has been removed from the -mm tree.  Its filename was
     selftests-mm-protection_keys-use-kselftest-framework.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: protection_keys: use kselftest framework
Date: Mon, 11 May 2026 19:28:01 +0300

Convert protection_keys test to use kselftest framework for reporting and
tracking successful and failing runs.

Adjust dprintf0() printouts to use "#" in the beginning of the line for
TAP compatibility.

Link: https://lore.kernel.org/20260511162840.375890-18-rppt@kernel.org
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Li Wang <li.wang@linux.dev>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/pkey-helpers.h    |   15 +++++----
 tools/testing/selftests/mm/protection_keys.c |   26 +++++++++--------
 2 files changed, 23 insertions(+), 18 deletions(-)

--- a/tools/testing/selftests/mm/pkey-helpers.h~selftests-mm-protection_keys-use-kselftest-framework
+++ a/tools/testing/selftests/mm/pkey-helpers.h
@@ -71,13 +71,14 @@ static inline void sigsafe_printf(const
 extern void abort_hooks(void);
 #define pkey_assert(condition) do {		\
 	if (!(condition)) {			\
-		dprintf0("assert() at %s::%d test_nr: %d iteration: %d\n", \
-				__FILE__, __LINE__,	\
-				test_nr, iteration_nr);	\
-		dprintf0("errno at assert: %d", errno);	\
-		abort_hooks();			\
-		exit(__LINE__);			\
-	}					\
+		dprintf0("# assert() at %s::%d test_nr: %d iteration: %d\n", \
+			 __FILE__, __LINE__,				\
+			 test_nr, iteration_nr);			\
+		dprintf0("# errno at assert: %d\n", errno);		\
+		abort_hooks();						\
+		ksft_exit_fail_msg("test %d (iteration %d)\n",		\
+				   test_nr, iteration_nr);		\
+	}								\
 } while (0)
 
 #define barrier() __asm__ __volatile__("": : :"memory")
--- a/tools/testing/selftests/mm/protection_keys.c~selftests-mm-protection_keys-use-kselftest-framework
+++ a/tools/testing/selftests/mm/protection_keys.c
@@ -136,6 +136,7 @@ static void tracing_off(void)
 
 void abort_hooks(void)
 {
+	fflush(stdout);
 	fprintf(stderr, "running %s()...\n", __func__);
 	tracing_off();
 #ifdef SLEEP_ON_ABORT
@@ -370,8 +371,8 @@ static void signal_handler(int signum, s
 	if ((si->si_code == SEGV_MAPERR) ||
 	    (si->si_code == SEGV_ACCERR) ||
 	    (si->si_code == SEGV_BNDERR)) {
-		printf("non-PK si_code, exiting...\n");
-		exit(4);
+		dprintf0("# non-PK si_code: %d, exiting...\n", si->si_code);
+		exit(1);
 	}
 
 	si_pkey_ptr = siginfo_get_pkey_ptr(si);
@@ -719,7 +720,7 @@ static void setup_hugetlbfs(void)
 	long hpagesz_mb;
 
 	if (geteuid() != 0) {
-		fprintf(stderr, "WARNING: not run as root, can not do hugetlb test\n");
+		ksft_print_msg("WARNING: not run as root, can not do hugetlb test\n");
 		return;
 	}
 
@@ -855,7 +856,7 @@ void expected_pkey_fault(int pkey)
 
 #define do_not_expect_pkey_fault(msg)	do {			\
 	if (last_pkey_faults != pkey_faults)			\
-		dprintf0("unexpected PKey fault: %s\n", msg);	\
+		dprintf0("# unexpected PKey fault: %s\n", msg);	\
 	pkey_assert(last_pkey_faults == pkey_faults);		\
 } while (0)
 
@@ -1753,7 +1754,7 @@ static void run_tests_once(void)
 		tracing_off();
 		close_test_fds();
 
-		printf("test %s PASSED (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
+		ksft_test_result_pass("test %s (iteration %d)\n", pkey_tests[test_nr].name, iteration_nr);
 		dprintf1("======================\n\n");
 	}
 	iteration_nr++;
@@ -1773,27 +1774,30 @@ int main(void)
 
 	setup_handlers();
 
-	printf("has pkeys: %d\n", pkeys_supported);
+	ksft_print_header();
 
 	if (!pkeys_supported) {
 		int size = PAGE_SIZE;
 		int *ptr;
 
-		printf("running PKEY tests for unsupported CPU/OS\n");
+		ksft_set_plan(1);
+		ksft_print_msg("running PKEY tests for unsupported CPU/OS\n");
 
 		ptr  = mmap(NULL, size, PROT_NONE, MAP_ANONYMOUS|MAP_PRIVATE, -1, 0);
 		assert(ptr != (void *)-1);
 		test_mprotect_pkey_on_unsupported_cpu(ptr, 1);
-		exit(0);
+		ksft_test_result_pass("pkey on unsupported CPU/OS\n");
+		ksft_finished();
 	}
 
+	ksft_set_plan(ARRAY_SIZE(pkey_tests) * nr_iterations);
+
 	pkey_setup_shadow();
-	printf("startup pkey_reg: %016llx\n", read_pkey_reg());
+	ksft_print_msg("startup pkey_reg: %016llx\n", read_pkey_reg());
 	setup_hugetlbfs();
 
 	while (nr_iterations-- > 0)
 		run_tests_once();
 
-	printf("done (all tests OK)\n");
-	return 0;
+	ksft_finished();
 }
_

Patches currently in -mm which might be from rppt@kernel.org are


