Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F1E4A6CCB
	for <mm-commits@vger.kernel.org>; Tue,  8 Sep 2026 19:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788897004; cv=none; b=P369iXJevhizWFxzb7PQCUzSb/vvov7ExzDApgSckn+aZDFhjdFJ5lw8Z3jTbPXJiH/iipkaSIBeX/9V6o0cvvWkPs71Z6uJVfT+ceJvSB+Sqk6jYk3LS1JCqXanTjmqArnSfjt3ZjYOTb/Be4rGmDpH/oPiNUq+yLfL3atOScg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788897004; c=relaxed/simple;
	bh=hrjW6+WZxzTWgj0iWtRFe6q0TQE91IsF7quouksDW30=;
	h=Date:To:From:Subject:Message-Id; b=i9CcEKmP6QfVEA4eX2F03xOe9oKVlYmN0oNHwB42BBWDfbf/g9xP3EeKRazgKXms8tgwf71kj/hWBJOx7b5KxpDt1zWn6CPM0yCnTITF/V8NsbL07LdaiQTlxp3QENZLmhe1XXvKatKzyFUhpQfBTcAFqvQEP0fltiHXHfbKrVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KG0YNtQS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KG0YNtQS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C9F61F00A3A;
	Tue,  8 Sep 2026 19:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788897002;
	bh=IyC23B6pG1xrK1ZUDfbx1hUWRoFcFANWubLNYNDjee4=;
	h=Date:To:From:Subject;
	b=KG0YNtQSDQnxRBQB+A00Uhs9C4OP/kdjRVCl5MsLHdevr7MDimI0h9nJmJYO+WMX+
	 70PzM4u2Dv2ixb8BZ9o31dmbugPdpFSlwIQwnn1g1rE3QHsyFv6FxpIJ5MWdH/msxi
	 DebrAhNPasl5sRyJRd+9l8il+4cTjCYUxln8cO+Y=
Date: Tue, 08 Sep 2026 12:50:01 -0700
To: mm-commits@vger.kernel.org,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-raise-the-khugepaged-test-case-cap.patch added to mm-new branch
Message-Id: <20260908195002.4C9F61F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm: raise the khugepaged test-case cap
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-raise-the-khugepaged-test-case-cap.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-raise-the-khugepaged-test-case-cap.patch

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
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: raise the khugepaged test-case cap
Date: Tue, 8 Sep 2026 13:50:47 +0100

Patch series "selftests/mm: improve khugepaged coverage", v5.

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

Assisted-by: LLM
Link: https://lore.kernel.org/20260908125105.1510704-1-kirill@shutemov.name
Link: https://lore.kernel.org/20260908125105.1510704-2-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
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

mm-huge_memory-do-not-touch-frozen-folios-in-deferred_split_isolate.patch
mm-huge_memory-dequeue-the-deferred-split-after-the-split-freeze.patch
selftests-mm-raise-the-khugepaged-test-case-cap.patch
selftests-mm-skip-collapse_compound_extreme-where-the-pmd-is-too-large.patch
selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch
selftests-mm-skip-khugepaged-page-cache-cases-without-a-pmd-folio.patch
selftests-mm-make-the-swap-cases-swapout-reliable.patch
selftests-mm-stop-khugepaged-during-the-madv_collapse-cases.patch
selftests-mm-move-is_backed_by_folio-into-vm_util.patch
selftests-mm-add-folio-order-check-for-address-ranges.patch
selftests-mm-add-folio-order-detection-self-check.patch
selftests-mm-add-khugepaged-completion-barrier-helper.patch
selftests-mm-add-order-parameterized-khugepaged-collapse-cases.patch
selftests-mm-parameterize-the-mixed-source-collapse-case-by-source-order.patch
selftests-mm-cover-a-shared-source-collapse-write-race.patch
selftests-mm-run-every-supported-collapse-order-by-default.patch
selftests-mm-check-that-one-khugepaged-pass-collapses-one-window.patch
selftests-mm-add-khugepaged-race-harness.patch
selftests-mm-race-the-collapse-of-windows-with-holes.patch
selftests-mm-add-memory-pressure-threads-to-the-khugepaged-race-harness.patch
selftests-mm-zap-whole-pte-tables-in-the-khugepaged-race-harness.patch

