Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D14C484897
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866017; cv=none; b=Agt9rTSdVGGp+e0FgaTW7aaFV9k64sPkDQdiFTGbyG3QaDzUR92BUH4Ty6S3BOGKeQNIkKQJCp9J0b9uNXFec1zlZCd1dJOet61dFz83qSdZF4ofzh9Mx+gnSgdyjBs3TXSAw6n6uqg6JwiuvrKOoLoV7HFGTC56FW0AdxsaJis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866017; c=relaxed/simple;
	bh=6g5j7fGahHqXhTCyaDzuUAvaA1UHS/X0yg7xjtBkcgQ=;
	h=Date:To:From:Subject:Message-Id; b=eVTD93C98ZKleRgxPaqdQa/Lni7fcIeCJTXx+YBd5rstWxePInzYV163lB8u36WnxVxpKtMkVG7Zi3dDmjrTsHdXtaFWLRQ3SKlIoPLqlXOOwjcgpBwLpmKk71RUgo6+VEyBJZjElv3+/OkTEL2syMpn4aOuqsONmr0LLDt4HqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=EQgHGAd6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="EQgHGAd6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CB5C1F000FF;
	Tue, 13 Oct 2026 04:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866015;
	bh=dncegHrZMgef5zwIA2x3DKpC4Lqn1LXhyp1EsLmzwN0=;
	h=Date:To:From:Subject;
	b=EQgHGAd6eJD5RWa/Ly3QWKIuXv+nSHN+Et3F1Ut+IDHA4b7LSi2MQmbRZrh0H6gag
	 4A7eUY2veoJ9ZyY9uFy6qNgnhrTePOUadE2HvO+tdCLzZ6iKSSvgRmIYi6IcvoQXql
	 dGdtAKZvrbSHi4M9v25iXe2+opMKPFqsJZf1ab5s=
Date: Mon, 12 Oct 2026 21:33:34 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-raise-the-khugepaged-test-case-cap.patch removed from -mm tree
Message-Id: <20261013043335.0CB5C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: raise the khugepaged test-case cap
has been removed from the -mm tree.  Its filename was
     selftests-mm-raise-the-khugepaged-test-case-cap.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: raise the khugepaged test-case cap
Date: Sat, 19 Sep 2026 01:24:31 +0100

Patch series "selftests/mm: improve khugepaged coverage", v6.

khugepaged collapses to mTHP orders since 7.2, and 7.3 added three
selftest cases for it: the generic collapse cases run at one order named
by -c, with the result detected by counting folios of that order.

That leaves the collapse path largely untested.  The suite does not run
where a PMD is 512M.  A folio count cannot say where a collapse landed. 
Fixed sleeps cannot tell "not collapsed" from "not scanned yet".  And
nothing exercises collapse under contention.

Close those gaps in order:

 - Make the suite run at a 512M PMD: scale the collapse wait with the PMD
   size, skip what such a PMD cannot serve, make the swapout the swap
   cases depend on deterministic, and keep khugepaged out of the
   MADV_COLLAPSE cases.

 - Detect results per window rather than by count, with folio-order
   helpers in vm_util that are checked against the kernel before any
   collapse test trusts them.

 - Drive khugepaged deterministically: a completion barrier that wakes the
   daemon and waits for a full pass, and a check that one pass yields one
   attributed collapse.

 - Cover collapse at every supported order by default: which window
   collapses, occupancy at both limits, sources that are already large
   folios, and a fork-shared source under concurrent writes.

 - Race collapse against everything that can touch its sources, at both
   occupancy limits and over whole-table zaps, checked by content and by
   the kernel's own assertions.

Everything passes on an unmodified kernel.


This patch (of 19):

TEST() ends the run with "MAX_TEST_CASES is too small" when the table
fills, and the table holds 64.  A full invocation already registers 63, so
the next case added anywhere aborts the whole suite before a single test
runs.

Raise the cap to 256.  The table is a static array of small structs, so
the room costs nothing worth counting.

Link: https://lore.kernel.org/20260919002451.496763-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260919002451.496763-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-raise-the-khugepaged-test-case-cap
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -1290,7 +1290,7 @@ struct test_case {
 	test_fn fn;
 };
 
-#define MAX_TEST_CASES 64
+#define MAX_TEST_CASES 256
 static struct test_case test_cases[MAX_TEST_CASES];
 static int nr_test_cases;
 
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

