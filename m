Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1CA38D;
	Mon, 24 Nov 2025 22:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764023164; cv=none; b=ug+Ks+51RG/zzWiR2KaiyQ9wHE+dVxDt2ZnlW5nsC/MWC2m6hnSb28KhUyRNaZIOMh9/Wlbri5eiYSXlrr8IHI6uBGTFf7yhrJyXlESkH+ypGcYyJVB1Z4/BnmuF/9g1UUto2AcVIG6OeClQ5DPvwOjpBUXiR+PFSWVTuicAIuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764023164; c=relaxed/simple;
	bh=hN6Na+teHAJQmu25990HSzwDs2ddJM+IlRDJCR9BADo=;
	h=Date:To:From:Subject:Message-Id; b=A1NoXUAydH0goTWb8pci4V+8HP2RwUq3CeWaV3DW2GnCixEPci+wBchZAjTmi3Fll5DWORA4G44SP+y+4/MfUP49PqwtfRyUk3Euy3WjVQW/OKfmPIvxUpujeI+gOfRJfoxOaQhGEs1ReZhgvzbOe6ed823x2fb7u6C4YlDwXFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=eErOaWF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="eErOaWF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B066BC4CEF1;
	Mon, 24 Nov 2025 22:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1764023163;
	bh=hN6Na+teHAJQmu25990HSzwDs2ddJM+IlRDJCR9BADo=;
	h=Date:To:From:Subject:From;
	b=eErOaWF8TVcf0t0YKvFvuuBC39Br+FKx1a8R4j032nutnO/UNDuRH4CW8pjMgyFRn
	 /TjgzGPBJKqSNavNbPJLRJQ5rNCRM84bsu7g+dRymu99+cm+Q0+wrM6Od2cldstj4o
	 iJz5OyvbWs/hMLSUEMhADFbOn2yqKLbTvhXBx0lE=
Date: Mon, 24 Nov 2025 14:26:03 -0800
To: mm-commits@vger.kernel.org,vbabka@suse.cz,ujwal.kundur@gmail.com,surenb@google.com,stable@vger.kernel.org,shuah@kernel.org,rppt@kernel.org,peterx@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,jackmanb@google.com,david@kernel.org,cmllamas@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch removed from -mm tree
Message-Id: <20251124222603.B066BC4CEF1@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: fix division-by-zero in uffd-unit-tests
has been removed from the -mm tree.  Its filename was
     selftests-mm-fix-division-by-zero-in-uffd-unit-tests.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Carlos Llamas <cmllamas@google.com>
Subject: selftests/mm: fix division-by-zero in uffd-unit-tests
Date: Thu, 13 Nov 2025 03:46:22 +0000

Commit 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global
vars into struct") moved some of the operations previously implemented in
uffd_setup_environment() earlier in the main test loop.

The calculation of nr_pages, which involves a division by page_size, now
occurs before checking that default_huge_page_size() returns a non-zero
This leads to a division-by-zero error on systems with !CONFIG_HUGETLB.

Fix this by relocating the non-zero page_size check before the nr_pages
calculation, as it was originally implemented.

Link: https://lkml.kernel.org/r/20251113034623.3127012-1-cmllamas@google.com
Fixes: 4dfd4bba8578 ("selftests/mm/uffd: refactor non-composite global vars into struct")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Ujwal Kundur <ujwal.kundur@gmail.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/testing/selftests/mm/uffd-unit-tests.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-fix-division-by-zero-in-uffd-unit-tests
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1758,10 +1758,15 @@ int main(int argc, char *argv[])
 			uffd_test_ops = mem_type->mem_ops;
 			uffd_test_case_ops = test->test_case_ops;
 
-			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB))
+			if (mem_type->mem_flag & (MEM_HUGETLB_PRIVATE | MEM_HUGETLB)) {
 				gopts.page_size = default_huge_page_size();
-			else
+				if (gopts.page_size == 0) {
+					uffd_test_skip("huge page size is 0, feature missing?");
+					continue;
+				}
+			} else {
 				gopts.page_size = psize();
+			}
 
 			/* Ensure we have at least 2 pages */
 			gopts.nr_pages = MAX(UFFD_TEST_MEM_SIZE, gopts.page_size * 2)
@@ -1776,12 +1781,6 @@ int main(int argc, char *argv[])
 				continue;
 
 			uffd_test_start("%s on %s", test->name, mem_type->name);
-			if ((mem_type->mem_flag == MEM_HUGETLB ||
-			    mem_type->mem_flag == MEM_HUGETLB_PRIVATE) &&
-			    (default_huge_page_size() == 0)) {
-				uffd_test_skip("huge page size is 0, feature missing?");
-				continue;
-			}
 			if (!uffd_feature_supported(test)) {
 				uffd_test_skip("feature missing");
 				continue;
_

Patches currently in -mm which might be from cmllamas@google.com are


