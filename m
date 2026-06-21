Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B17BB36F8EB
	for <mm-commits@vger.kernel.org>; Sun, 21 Jun 2026 18:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782067183; cv=none; b=h8EXfD2DYq+fbXtZwfvzkt3FhSU8GUb+a3Dn9g2emh2DmSiInEP+u77Gov2WNbRxmCKtcg5b/2kdNjR1+lXLzdRK3epK0XIz4MbAwAppMOjUP1AlW1T0U+98rUfkn05Nwzr5RpxcX0Mig/o/9ZVpKSPbNn1hEt3G6izRlBkasPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782067183; c=relaxed/simple;
	bh=FyID5aUyZoGgWvTWKnFqLyxTArgTOFkY9ZA+FngrXVw=;
	h=Date:To:From:Subject:Message-Id; b=GBHNQa9fpMCAARWiRUwTbjIh2n4lVN/OEmpzMur9coT5Fo2oLZOilvpGkDr4IsErjBV40LGXL3dE91Rr+2/btUEQ/lSBaA64R7oz9aG3UK/T6S6IN3GEH3yGq0BuBknJa6itFIG6ywV1DME83qmSlxdieU+fSFKPwTr7hwzswro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=L+rpU4CW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="L+rpU4CW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF161F00A3A;
	Sun, 21 Jun 2026 18:39:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782067182;
	bh=+qJCmXv3p/NfoSVWYx82gt+qKCOBY7KfMxCvf+h5gPY=;
	h=Date:To:From:Subject;
	b=L+rpU4CWxGDWQsYrQvn6VI1LWyv1AO+rQ0BRqBIdZXI/EaIG9QsCc/L2ZiPcj7hQs
	 d4/7bX4eiyjNRCAHprApeUFC9VYpYTysmm+L50h5JyeqV74NJkp+J8YH/iWS96VzC2
	 SXM42NC9J9zlfpTl2npKjHv/3/Z5Uy4WfIbUCKk4=
Date: Sun, 21 Jun 2026 11:39:42 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,surenb@google.com,shuah@kernel.org,sarthak.sharma@arm.com,ryan.roberts@arm.com,peterx@redhat.com,npache@redhat.com,mhocko@suse.com,luizcap@redhat.com,ljs@kernel.org,li.wang@linux.dev,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,jhubbard@nvidia.com,jgg@ziepe.ca,donettom@linux.ibm.com,dev.jain@arm.com,david@kernel.org,broonie@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,rppt@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch removed from -mm tree
Message-Id: <20260621183942.8AF161F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
has been removed from the -mm tree.  Its filename was
     selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Subject: selftests/mm: uffd-unit-tests: add setup of HugeTLB pages
Date: Mon, 11 May 2026 19:28:34 +0300

uffd-unit-tests skips HugeTLB tests if there are no free huge pages
prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Replace exit() calls with _exit() to avoid restoring HugeTLB settings in
the middle of test.

Link: https://lore.kernel.org/20260511162840.375890-51-rppt@kernel.org
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

 tools/testing/selftests/mm/uffd-unit-tests.c |   33 ++++++++++++++---
 1 file changed, 28 insertions(+), 5 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-uffd-unit-tests-add-setup-of-hugetlb-pages
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -299,7 +299,7 @@ static int pagemap_test_fork(uffd_global
 		if (test_pin)
 			unpin_pages(&args);
 		/* Succeed */
-		exit(0);
+		_exit(0);
 	}
 	waitpid(child, &result, 0);
 
@@ -767,7 +767,7 @@ static void uffd_sigbus_test_common(uffd
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 2, wp));
+		_exit(faulting_process(gopts, 2, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -821,7 +821,7 @@ static void uffd_events_test_common(uffd
 		err("fork");
 
 	if (!pid)
-		exit(faulting_process(gopts, 0, wp));
+		_exit(faulting_process(gopts, 0, wp));
 
 	waitpid(pid, &err, 0);
 	if (err)
@@ -1700,11 +1700,32 @@ static int uffd_count_tests(int n_tests,
 	return count;
 }
 
+static unsigned long uffd_setup_hugetlb(void)
+{
+	unsigned long nr_hugepages, hp_size;
+
+	hugetlb_save_settings();
+	hp_size = default_huge_page_size();
+
+	if (!hp_size)
+		return 0;
+
+	/* need twice UFFD_TEST_MEM_SIZE, one for src area and one for dst */
+	nr_hugepages = 2 * MAX(UFFD_TEST_MEM_SIZE, hp_size * 2) / hp_size;
+	hugetlb_set_nr_default_pages(nr_hugepages);
+
+	if (hugetlb_free_default_pages() < nr_hugepages)
+		return 0;
+
+	return hp_size;
+}
+
 int main(int argc, char *argv[])
 {
 	int n_tests = sizeof(uffd_tests) / sizeof(uffd_test_case_t);
 	int n_mems = sizeof(mem_types) / sizeof(mem_type_t);
 	const char *test_filter = NULL;
+	unsigned long hugepage_size;
 	bool list_only = false;
 	uffd_test_case_t *test;
 	mem_type_t *mem_type;
@@ -1738,6 +1759,8 @@ int main(int argc, char *argv[])
 		return KSFT_PASS;
 	}
 
+	hugepage_size = uffd_setup_hugetlb();
+
 	ksft_print_header();
 	ksft_set_plan(uffd_count_tests(n_tests, n_mems, test_filter));
 
@@ -1765,9 +1788,9 @@ int main(int argc, char *argv[])
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
 			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
-				gopts.page_size = default_huge_page_size();
+				gopts.page_size = hugepage_size;
 				if (gopts.page_size == 0) {
-					uffd_test_skip("huge page size is 0, feature missing?");
+					uffd_test_skip("not enough HugeTLB pages");
 					continue;
 				}
 			} else {
_

Patches currently in -mm which might be from rppt@kernel.org are


