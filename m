Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BA9158A34
	for <mm-commits@vger.kernel.org>; Thu,  2 May 2024 15:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714663266; cv=none; b=U/ClCAugs9R/rJ/vHLzHBXxNBcd8bzZePdJZPI5RY0UPzn21SNObf5ABPms6+WfeylAX/6R5Pivx5ytFQ/nZiwTdyeuzWy9ZiH8bwjnwqlIAaKIMAxSgqypYMMxSole58J95Ce1DRIWWlXBMTsCI9WS5u2cpJRLxBNFzPq6lr7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714663266; c=relaxed/simple;
	bh=z6DcK0+PRNQvKbbWvtS1Bi0dGSWlacC6T4iwyZRktxw=;
	h=Date:To:From:Subject:Message-Id; b=twD8aLZJ6KSb2V6ODmK1kjSF35CjD8KwE4mkmAT6CIp5Yh9wFX/Lxcy/mEysS89SQDAA0ng2Tfz60O5favlUeYp6ZmBUT97Vd781G1OAmoW7uixAHuNlvDUkJf7dM8ot83UvKrG59UwkAWLENc/8hqdKT49NIuQgGtKcSMo0UYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=J2ytkTYq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="J2ytkTYq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BD6C113CC;
	Thu,  2 May 2024 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1714663266;
	bh=z6DcK0+PRNQvKbbWvtS1Bi0dGSWlacC6T4iwyZRktxw=;
	h=Date:To:From:Subject:From;
	b=J2ytkTYq9B0Djt/KPTm4WGRtQC0fOx8/il2dJ7uxv+evkg5UOmWoaD8niCF/xEymk
	 v/M488JTkHnsHCYdoezJelaWHZqQb7KRJjh83cJ3kxeBoxI6eHCpnj2PkBhQAt8LRV
	 Lt9GLsUnP1zXCO2izdDphB/N6/ZX9YLKMKqhxi74=
Date: Thu, 02 May 2024 08:21:04 -0700
To: mm-commits@vger.kernel.org,shuah@kernel.org,peterx@redhat.com,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch added to mm-unstable branch
Message-Id: <20240502152106.14BD6C113CC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL
Date: Thu, 2 May 2024 10:52:58 +0200

Patch series "selftests: mm: cow: flag vmsplice() hugetlb tests as XFAIL".

The failing hugetlb vmsplice() COW tests keep confusing people, and having
tests that have been failing for years and likely will keep failing for
years to come because nobody cares enough is rather suboptimal.  Let's
mark them as XFAIL and document why fixing them is not that easy as it
would appear at first sight.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/


This patch (of 2):

The vmsplice() hugetlb tests have been failing right from the start, and
we documented that in the introducing commit 7dad331be781 ("selftests/vm:
anon_cow: hugetlb tests"):

	Note that some tests cases still fail. This will, for example, be
	fixed once vmsplice properly uses FOLL_PIN instead of FOLL_GET for
	pinning. With 2 MiB and 1 GiB hugetlb on x86_64, the expected
	failures are:

Until vmsplice() is changed, these tests will likely keep failing: hugetlb
COW reuse logic is harder to change, because using the same COW reuse
logic as we use for !hugetlb could harm other (sane) users when running
out of free hugetlb pages.

More details can be found in [1], especially around how hugetlb pages
cannot really be overcommitted, and why we don't particularly care about
these vmsplice() leaks for hugetlb -- in contrast to ordinary memory.

These (expected) failures keep confusing people, so flag them accordingly.

Before:
	$ ./cow
	[...]
	Bail out! 8 out of 778 tests failed
	# Totals: pass:769 fail:8 xfail:0 xpass:0 skip:1 error:0
	$ echo $?
	1

After:
	$ ./cow
	[...]
	# Totals: pass:769 fail:0 xfail:8 xpass:0 skip:1 error:0
	$ echo $?
	0

[1] https://lore.kernel.org/all/8b42a24d-caf0-46ef-9e15-0f88d47d2f21@redhat.com/

Link: https://lkml.kernel.org/r/20240502085259.103784-1-david@redhat.com
Link: https://lkml.kernel.org/r/20240502085259.103784-2-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/cow.c |  106 +++++++++++++++++++----------
 1 file changed, 71 insertions(+), 35 deletions(-)

--- a/tools/testing/selftests/mm/cow.c~selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail
+++ a/tools/testing/selftests/mm/cow.c
@@ -199,7 +199,7 @@ static int child_vmsplice_memcmp_fn(char
 typedef int (*child_fn)(char *mem, size_t size, struct comm_pipes *comm_pipes);
 
 static void do_test_cow_in_parent(char *mem, size_t size, bool do_mprotect,
-				  child_fn fn)
+		child_fn fn, bool xfail)
 {
 	struct comm_pipes comm_pipes;
 	char buf;
@@ -247,33 +247,47 @@ static void do_test_cow_in_parent(char *
 	else
 		ret = -EINVAL;
 
-	ksft_test_result(!ret, "No leak from parent into child\n");
+	if (!ret) {
+		ksft_test_result_pass("No leak from parent into child\n");
+	} else if (xfail) {
+		/*
+		 * With hugetlb, some vmsplice() tests are currently expected to
+		 * fail because (a) harder to fix and (b) nobody really cares.
+		 * Flag them as expected failure for now.
+		 */
+		ksft_test_result_xfail("Leak from parent into child\n");
+	} else {
+		ksft_test_result_fail("Leak from parent into child\n");
+	}
 close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_cow_in_parent(char *mem, size_t size)
+static void test_cow_in_parent(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, false, child_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_memcmp_fn, false);
 }
 
-static void test_cow_in_parent_mprotect(char *mem, size_t size)
+static void test_cow_in_parent_mprotect(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, true, child_memcmp_fn);
+	do_test_cow_in_parent(mem, size, true, child_memcmp_fn, false);
 }
 
-static void test_vmsplice_in_child(char *mem, size_t size)
+static void test_vmsplice_in_child(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, false, child_vmsplice_memcmp_fn);
+	do_test_cow_in_parent(mem, size, false, child_vmsplice_memcmp_fn,
+			      is_hugetlb);
 }
 
-static void test_vmsplice_in_child_mprotect(char *mem, size_t size)
+static void test_vmsplice_in_child_mprotect(char *mem, size_t size,
+		bool is_hugetlb)
 {
-	do_test_cow_in_parent(mem, size, true, child_vmsplice_memcmp_fn);
+	do_test_cow_in_parent(mem, size, true, child_vmsplice_memcmp_fn,
+			      is_hugetlb);
 }
 
 static void do_test_vmsplice_in_parent(char *mem, size_t size,
-				       bool before_fork)
+				       bool before_fork, bool xfail)
 {
 	struct iovec iov = {
 		.iov_base = mem,
@@ -355,8 +369,18 @@ static void do_test_vmsplice_in_parent(c
 		}
 	}
 
-	ksft_test_result(!memcmp(old, new, transferred),
-			 "No leak from child into parent\n");
+	if (!memcmp(old, new, transferred)) {
+		ksft_test_result_pass("No leak from child into parent\n");
+	} else if (xfail) {
+		/*
+		 * With hugetlb, some vmsplice() tests are currently expected to
+		 * fail because (a) harder to fix and (b) nobody really cares.
+		 * Flag them as expected failure for now.
+		 */
+		ksft_test_result_xfail("Leak from child into parent\n");
+	} else {
+		ksft_test_result_fail("Leak from child into parent\n");
+	}
 close_pipe:
 	close(fds[0]);
 	close(fds[1]);
@@ -367,14 +391,14 @@ free:
 	free(new);
 }
 
-static void test_vmsplice_before_fork(char *mem, size_t size)
+static void test_vmsplice_before_fork(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_vmsplice_in_parent(mem, size, true);
+	do_test_vmsplice_in_parent(mem, size, true, is_hugetlb);
 }
 
-static void test_vmsplice_after_fork(char *mem, size_t size)
+static void test_vmsplice_after_fork(char *mem, size_t size, bool is_hugetlb)
 {
-	do_test_vmsplice_in_parent(mem, size, false);
+	do_test_vmsplice_in_parent(mem, size, false, is_hugetlb);
 }
 
 #ifdef LOCAL_CONFIG_HAVE_LIBURING
@@ -529,12 +553,12 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_iouring_ro(char *mem, size_t size)
+static void test_iouring_ro(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_iouring(mem, size, false);
 }
 
-static void test_iouring_fork(char *mem, size_t size)
+static void test_iouring_fork(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_iouring(mem, size, true);
 }
@@ -678,37 +702,41 @@ free_tmp:
 	free(tmp);
 }
 
-static void test_ro_pin_on_shared(char *mem, size_t size)
+static void test_ro_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_shared(char *mem, size_t size)
+static void test_ro_fast_pin_on_shared(char *mem, size_t size, bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_SHARED, true);
 }
 
-static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size)
+static void test_ro_pin_on_ro_previously_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, false);
 }
 
-static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size)
+static void test_ro_fast_pin_on_ro_previously_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_PREVIOUSLY_SHARED, true);
 }
 
-static void test_ro_pin_on_ro_exclusive(char *mem, size_t size)
+static void test_ro_pin_on_ro_exclusive(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, false);
 }
 
-static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size)
+static void test_ro_fast_pin_on_ro_exclusive(char *mem, size_t size,
+		bool is_hugetlb)
 {
 	do_test_ro_pin(mem, size, RO_PIN_TEST_RO_EXCLUSIVE, true);
 }
 
-typedef void (*test_fn)(char *mem, size_t size);
+typedef void (*test_fn)(char *mem, size_t size, bool hugetlb);
 
 static void do_run_with_base_page(test_fn fn, bool swapout)
 {
@@ -740,7 +768,7 @@ static void do_run_with_base_page(test_f
 		}
 	}
 
-	fn(mem, pagesize);
+	fn(mem, pagesize, false);
 munmap:
 	munmap(mem, pagesize);
 }
@@ -904,7 +932,7 @@ static void do_run_with_thp(test_fn fn,
 		break;
 	}
 
-	fn(mem, size);
+	fn(mem, size, false);
 munmap:
 	munmap(mmap_mem, mmap_size);
 	if (mremap_mem != MAP_FAILED)
@@ -997,7 +1025,7 @@ static void run_with_hugetlb(test_fn fn,
 	}
 	munmap(dummy, hugetlbsize);
 
-	fn(mem, hugetlbsize);
+	fn(mem, hugetlbsize, true);
 munmap:
 	munmap(mem, hugetlbsize);
 }
@@ -1036,7 +1064,7 @@ static const struct test_case anon_test_
 	 */
 	{
 		"vmsplice() + unmap in child",
-		test_vmsplice_in_child
+		test_vmsplice_in_child,
 	},
 	/*
 	 * vmsplice() test, but do an additional mprotect(PROT_READ)+
@@ -1044,7 +1072,7 @@ static const struct test_case anon_test_
 	 */
 	{
 		"vmsplice() + unmap in child with mprotect() optimization",
-		test_vmsplice_in_child_mprotect
+		test_vmsplice_in_child_mprotect,
 	},
 	/*
 	 * vmsplice() [R/O GUP] in parent before fork(), unmap in parent after
@@ -1322,23 +1350,31 @@ close_comm_pipes:
 	close_comm_pipes(&comm_pipes);
 }
 
-static void test_anon_thp_collapse_unshared(char *mem, size_t size)
+static void test_anon_thp_collapse_unshared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UNSHARED);
 }
 
-static void test_anon_thp_collapse_fully_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_fully_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_FULLY_SHARED);
 }
 
-static void test_anon_thp_collapse_lower_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_lower_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_LOWER_SHARED);
 }
 
-static void test_anon_thp_collapse_upper_shared(char *mem, size_t size)
+static void test_anon_thp_collapse_upper_shared(char *mem, size_t size,
+		bool is_hugetlb)
 {
+	assert(!is_hugetlb);
 	do_test_anon_thp_collapse(mem, size, ANON_THP_COLLAPSE_UPPER_SHARED);
 }
 
_

Patches currently in -mm which might be from david@redhat.com are

drivers-virt-acrn-fix-pfnmap-pte-checks-in-acrn_vm_ram_map.patch
mm-pass-vma-instead-of-mm-to-follow_pte.patch
mm-follow_pte-improvements.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again.patch
mm-allow-for-detecting-underflows-with-page_mapcount-again-fix.patch
mm-rmap-always-inline-anon-file-rmap-duplication-of-a-single-pte.patch
mm-rmap-add-fast-path-for-small-folios-when-adding-removing-duplicating.patch
mm-track-mapcount-of-large-folios-in-single-value.patch
mm-improve-folio_likely_mapped_shared-using-the-mapcount-of-large-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios.patch
mm-make-folio_mapcount-return-0-for-small-typed-folios-fix.patch
mm-memory-use-folio_mapcount-in-zap_present_folio_ptes.patch
mm-huge_memory-use-folio_mapcount-in-zap_huge_pmd-sanity-check.patch
mm-memory-failure-use-folio_mapcount-in-hwpoison_user_mappings.patch
mm-page_alloc-use-folio_mapped-in-__alloc_contig_migrate_range.patch
mm-migrate-use-folio_likely_mapped_shared-in-add_page_for_migration.patch
sh-mm-cache-use-folio_mapped-in-copy_from_user_page.patch
mm-filemap-use-folio_mapcount-in-filemap_unaccount_folio.patch
mm-migrate_device-use-folio_mapcount-in-migrate_vma_check_page.patch
trace-events-page_ref-trace-the-raw-page-mapcount-value.patch
xtensa-mm-convert-check_tlb_entry-to-sanity-check-folios.patch
mm-debug-print-only-page-mapcount-excluding-folio-entire-mapcount-in-__dump_folio.patch
documentation-admin-guide-cgroup-v1-memoryrst-dont-reference-page_mapcount.patch
mm-ksm-rename-get_ksm_page_flags-to-ksm_get_folio_flags.patch
mm-ksm-remove-page_mapcount-usage-in-stable_tree_search.patch
fs-proc-task_mmu-convert-pagemap_hugetlb_range-to-work-on-folios.patch
fs-proc-task_mmu-convert-smaps_hugetlb_range-to-work-on-folios.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation.patch
mm-huge_memory-improve-split_huge_page_to_list_to_order-return-value-documentation-v2.patch
mm-khugepaged-replace-page_mapcount-check-by-folio_likely_mapped_shared.patch
selftests-mm-cow-flag-vmsplice-hugetlb-tests-as-xfail.patch
mm-hugetlb-document-why-hugetlb-uses-folio_mapcount-for-cow-reuse-decisions.patch

