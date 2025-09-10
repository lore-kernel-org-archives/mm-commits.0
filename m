Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FD65257844
	for <mm-commits@vger.kernel.org>; Wed, 10 Sep 2025 05:20:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757481614; cv=none; b=APOTy+wDcIh2jmLWVUchz3rpvJPq4F9zJ9RuhdODVtBOOGnsIiSC2yCacz794mMwkVe/M0Z9i3lfuCqBSb26WvWUU0ngoX8K0aaVAQYC1JUUKLgMa1anfvoRiPpKbt99monrSJVXwih2ZgM2Y/lyZ6SEasody3dzJVM2U8mhKh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757481614; c=relaxed/simple;
	bh=Uh/Cj7Xf1IMlnBeLvY0LVSJTKPwceyXSr5URxbSelkg=;
	h=Date:To:From:Subject:Message-Id; b=QIaTyRkOk4ard0IWxbrBGV5d0G+6+Mdwc1SsJeW/bwaKSx64spQ1wUsDPTYt2mlb4pm/GBPrpECMVTPzYUlnvIrE72PcCY45Fk3DjI3x1Mk1DtGl6B8wV/zIIzlfOeJg2hr7IQkzxigMjGtl0rZ4ymesolh9GrB/tEa+gBYjEBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KMdOXJpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KMdOXJpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12628C4CEF0;
	Wed, 10 Sep 2025 05:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757481614;
	bh=Uh/Cj7Xf1IMlnBeLvY0LVSJTKPwceyXSr5URxbSelkg=;
	h=Date:To:From:Subject:From;
	b=KMdOXJpq7bqKuBZPdI56Y0j2kXBIJ+NzsknjI1KgQ7UWIfkZ90jmox3Y37DfKZ/aC
	 lacwsYZ+EPY+SXK9Vo3hWCFJeNNquPX9iKoyqqZeVa/OS/okWBy9zyLv1CfNca3uSY
	 Z46LAUpmR40Kqm36gLL6hC6Ay9TZVEOpz76/8Xb4=
Date: Tue, 09 Sep 2025 22:20:13 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch added to mm-unstable branch
Message-Id: <20250910052014.12628C4CEF0@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd-stress: make test operate on less hugetlb memory
has been added to the -mm mm-unstable branch.  Its filename is
     selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch

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
From: Dev Jain <dev.jain@arm.com>
Subject: selftests/mm/uffd-stress: make test operate on less hugetlb memory
Date: Tue, 9 Sep 2025 11:45:29 +0530

Patch series "selftests/mm: uffd-stress fixes", v2.

This patchset ensures that the number of hugepages is correctly set in the
system so that the uffd-stress test does not fail due to the racy nature
of the test.  Patch 1 changes the hugepage constraint in the
run_vmtests.sh script, whereas patch 2 changes the constraint in the test
itself.


This patch (of 2):

We observed uffd-stress selftest failure on arm64 and intermittent
failures on x86 too:

running ./uffd-stress hugetlb-private 128 32

bounces: 17, mode: rnd read, ERROR: UFFDIO_COPY error: -12 (errno=12, @uffd-common.c:617) [FAIL]
not ok 18 uffd-stress hugetlb-private 128 32 # exit=1

For this particular case, the number of free hugepages from run_vmtests.sh
will be 128, and the test will allocate 64 hugepages in the source
location.  The stress() function will start spawning threads which will
operate on the destination location, triggering uffd-operations like
UFFDIO_COPY from src to dst, which means that we will require 64 more
hugepages for the dst location.

Let us observe the locking_thread() function.  It will lock the mutex kept
at dst, triggering uffd-copy.  Suppose that 127 (64 for src and 63 for
dst) hugepages have been reserved.  In case of BOUNCE_RANDOM, it may
happen that two threads trying to lock the mutex at dst, try to do so at
the same hugepage number.  If one thread succeeds in reserving the last
hugepage, then the other thread may fail in alloc_hugetlb_folio(),
returning -ENOMEM.  I can confirm that this is indeed the case by this
hacky patch:

:--- a/mm/hugetlb.c
; +++ b/mm/hugetlb.c
; @@ -6929,6 +6929,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
; 
;  		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
;  		if (IS_ERR(folio)) {
; +			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
; +			if (actual_pte) {
; +				ret = -EEXIST;
; +				goto out;
; +			}
;  			ret = -ENOMEM;
;  			goto out;
;  		}

This code path gets triggered indicating that the PMD at which one thread
is trying to map a hugepage, gets filled by a racing thread.

Therefore, instead of using freepgs to compute the amount of memory, use
freepgs - (min(32, nr_cpus) - 1), so that the test still has some extra
hugepages to use.  The adjustment is a function of min(32, nr_cpus) - the
value of nr_parallel in the test - because in the worst case, nr_parallel
number of threads will try to map a hugepage on the same PMD, one will win
the allocation race, and the other nr_parallel - 1 threads will fail, so
we need extra nr_parallel - 1 hugepages to satisfy this request.  Note
that, in case the adjusted value underflows, there is a check for the
number of free hugepages in the test itself, which will fail:
get_free_hugepages() < bytes / page_size A negative value will be passed
on to bytes which is of type size_t, thus the RHS will become a large
value and the check will fail, so we are safe.

Link: https://lkml.kernel.org/r/20250909061531.57272-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250909061531.57272-2-dev.jain@arm.com
Signed-off-by: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mariano Pache <npache@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c                              |    5 +++++
 tools/testing/selftests/mm/run_vmtests.sh |   10 +++++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

--- a/mm/hugetlb.c~selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory
+++ a/mm/hugetlb.c
@@ -6930,6 +6930,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 
 		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
 		if (IS_ERR(folio)) {
+			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
+			if (actual_pte) {
+				ret = -EEXIST;
+				goto out;
+			}
 			ret = -ENOMEM;
 			goto out;
 		}
--- a/tools/testing/selftests/mm/run_vmtests.sh~selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory
+++ a/tools/testing/selftests/mm/run_vmtests.sh
@@ -324,11 +324,15 @@ CATEGORY="gup_test" run_test ./gup_longt
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
-# Hugetlb tests require source and destination huge pages. Pass in half
-# the size of the free pages we have, which is used for *each*.
+# Hugetlb tests require source and destination huge pages. Pass in almost half
+# the size of the free pages we have, which is used for *each*. An adjustment
+# of (nr_parallel - 1) is done (see nr_parallel in uffd-stress.c) to have some
+# extra hugepages - this is done to prevent the test from failing by racily
+# reserving more hugepages than strictly required.
 # uffd-stress expects a region expressed in MiB, so we adjust
 # half_ufd_size_MB accordingly.
-half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
+adjustment=$(( (31 < (nr_cpus - 1)) ? 31 : (nr_cpus - 1) ))
+half_ufd_size_MB=$((((freepgs - adjustment) * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch
selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-needed-before-the-test.patch
mm-enable-khugepaged-anonymous-collapse-on-non-writable-regions.patch
mm-drop-all-references-of-writable-and-scan_page_ro.patch

