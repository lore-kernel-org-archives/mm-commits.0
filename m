Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792832260;
	b=ekp1rSM0gEOsOKfhkZuXxwS6wOAkOQNaoH2zrTPq4+5TsXTzX1K9QzaBwKjtHRb4zTze
	 Nk/lQ3m/7cfBqo26UHargk+Y3ncdbrEz32AgIoE/H4gjiOP8YJD505tW26z7cqpdPEtY/
	 2vKr5T4jEOXVvbBuRqbSHvxbBKO2eiZaqqkq1P0+Jjh5/4lVc+3FcewGLO59u1o3qvW4F
	 SV+KX2up2tMFldCN7WfK7iUJ9Pm8TFYNCEty6cPZ4zNUh9fIpEuNRF0scc4N6WUZHB1es
	 EAVmX908VorZZahuPabLdMtACelz0lr4zupUmZxxv0qFzlmyTKGX8YiFPlnsV4lsDkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792832260;
	h=Received:DKIM-Signature:Date:To:From:Subject:Message-Id;
	bh=honFJTmTlpa5gUEYSKpCar1pl/HGzkRN5bpW6wAglrw=;
	b=B7eoIqo/oJoGPH9Yf/JIN9EtMkzTbUR/KncN/boiK2S+uZERpXMLvfz1iUqE/hK405Lz
	 8J4a7Wn6H2v2tistW4a9QutH6IHWKnCJW7oHGlP3XryBNCJgJbJRRNNPdAGNfiJFl/bp5
	 2hodJPs6NdmZyeScJ76xGWuVw3VZcy5dWNqyvlwyft8qB3JdViohpL9jQtAzu4DkWk6hy
	 +jag5EpNqsyZygDVBkC2mf5dpVtgI/tLa3HQgXpdMRBu0+2G/0DgvqF8Jf6mwVEWt29JR
	 +ObqMes7BL40xOSDu4luug4ikAYQpSRNu+F05bmF7x29KfE7FTL9jjVo0XrfQylWpGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JvBYwoew;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3FB9606A31A
	for <mm-commits@vger.kernel.org>; Sat, 24 Oct 2026 08:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=JvBYwoew
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0D0D1F01825;
	Sat, 24 Oct 2026 08:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792832259;
	bh=honFJTmTlpa5gUEYSKpCar1pl/HGzkRN5bpW6wAglrw=;
	h=Date:To:From:Subject;
	b=JvBYwoewU/97boMYXfKG7NCeji054REgqI7/jYM+kTAvpz9hCVRr3aqcNrxF38JP6
	 pNLXrC2vI6U3Pap/MTVvrHGJRKjM9gXMxOksvO6kQHk3QLUxgw+vrSf8LHrhatlHfK
	 ACnBaIwEEmEL1vsEUnWk+T695S3tJyJyrrSQ0Zfo=
Date: Sat, 24 Oct 2026 01:57:39 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,gourry@gourry.net,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,yeoreum.yun@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch removed from -mm tree
Message-Id: <20261024085739.B0D0D1F01825@smtp.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Post: <mailto:mm-commits@vger.kernel.org>
List-Help: <mailto:mm-commits+help@vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>
List-Owner: <mailto:mm-commits+owner@vger.kernel.org>
Precedence: list


The quilt patch titled
     Subject: kselftest: mm: return fail when child test result is fail in khugepaged
has been removed from the -mm tree.  Its filename was
     kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Yeoreum Yun <yeoreum.yun@arm.com>
Subject: kselftest: mm: return fail when child test result is fail in khugepaged
Date: Tue, 29 Sep 2026 11:33:18 +0100

Patch series "kselftest: mm: fix intermittent failure khugepaged test", v4.

There are intermittent failures in collapse_max_ptes_swap() and
collapse_max_ptes_shared() when using the khugepaged_context:

  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0

  # Run test: collapse_max_ptes_swap (khugepaged:anon)
  # Swapout 257 of 2048 pages... OK
  # Maybe collapse with max_ptes_swap exceeded.... OK
  # Swapout 256 of 2048 pages... OK
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 17)
  # Totals: pass:17 fail:0 xfail:0 xpass:0 skip:0 error:0

This happens because khugepaged may collapse the pages before
wait_for_scan() is called, causing a sanity check that expects uncollapsed
pages to fail.

For example, in collapse_max_ptes_swap(), after faulting the pages back in
and paging out up to max_ptes_swap pages, khugepaged may collapse them
again before c->collapse() is called.

To prevent this, mark the VMA with MADV_NOHUGEPAGE after it has been
collapsed by wait_for_scan() for anon.  This prevents khugepaged from
collapsing it again before c->collapse() is called.

Also, fix false-positive results when a child process fails in tests such
as collapse_fork*() or collapse_max_ptes_shared():

  # -------------------------
  # running ./khugepaged -s 2
  # -------------------------
  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

This failure was observed on NVIDIA Spark with 16KB page.


This patch (of 2):

Although the child process in collapse_fork*() or
collapse_max_ptes_shared() reports `KSFT_FAIL`, the result is ignored
because the test only checks whether the parent's page was collapsed into
a huge page.

As a result, the test is considered successful whenever the parent's page
is a huge page, even if the child test fails, as shown below:

  #
  # Run test: collapse_max_ptes_shared (khugepaged:anon)
  # Allocate huge page... OK
  # Share huge page over fork()... OK
  # Trigger CoW on page 1023 of 2048... OK
  # Maybe collapse with max_ptes_shared exceeded.... OK
  # Trigger CoW on page 1024 of 2048... Fail
  Bail out! Unexpected huge page
  # Planned tests != run tests (26 != 23)
  # Totals: pass:23 fail:0 xfail:0 xpass:0 skip:0 error:0  // child failed.
  # Check if parent still has huge page... OK              // parent hpage success
  ok 24 collapse_max_ptes_shared                           // considered as success
  ...
  # Totals: pass:26 fail:0 xfail:0 xpass:0 skip:0 error:0

To address this, propagate the child's failure and skip the subsequent
check in the parent.

Link: https://lore.kernel.org/20260929-fix_khugepagd_fail-v4-0-2169c18f2576@arm.com
Link: https://lore.kernel.org/20260929-fix_khugepagd_fail-v4-1-2169c18f2576@arm.com
Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
---

 tools/testing/selftests/mm/khugepaged.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/mm/khugepaged.c~kselftest-mm-return-fail-when-child-test-result-is-fail-in-khugepaged
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1053,6 +1053,8 @@ static void collapse_fork(struct collaps
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has small page...");
 	if (ops->check_huge(p, hpage_pmd_size, 0, hpage_pmd_size))
@@ -1060,6 +1062,7 @@ static void collapse_fork(struct collaps
 	else
 		fail("Fail");
 	validate_memory(p, 0, page_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1100,6 +1103,8 @@ static void collapse_fork_compound(struc
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1107,6 +1112,7 @@ static void collapse_fork_compound(struc
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
@@ -1158,6 +1164,8 @@ static void collapse_max_ptes_shared(str
 
 	wait(&wstatus);
 	exit_status = WEXITSTATUS(wstatus);
+	if (exit_status == KSFT_FAIL)
+		goto out;
 
 	ksft_print_msg("Check if parent still has huge page...");
 	if (ops->check_huge(p, hpage_pmd_size, 1, hpage_pmd_size))
@@ -1165,6 +1173,7 @@ static void collapse_max_ptes_shared(str
 	else
 		fail("Fail");
 	validate_memory(p, 0, hpage_pmd_size);
+out:
 	ops->cleanup_area(p, hpage_pmd_size);
 	ksft_test_result_report(exit_status, "%s\n", __func__);
 }
_

Patches currently in -mm which might be from yeoreum.yun@arm.com are


