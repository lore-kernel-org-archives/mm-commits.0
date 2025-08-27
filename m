Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC832F60B4
	for <mm-commits@vger.kernel.org>; Wed, 27 Aug 2025 03:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756265379; cv=none; b=K4w7y8LliOUY/2R0QiUyxmG4z960AUxUlZEM+xX7y53m5DYLmguZ5UhlstKoNJQViRQOrmtpmqjOsuGGsuQ/or+MD1/gy8rxenBqwb/2UiEmdoANzEq11ePHLWWCt/v8BK5rUIjRNIxs8Xp2d7iX23i/WFPkatjoGty03sAWgLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756265379; c=relaxed/simple;
	bh=jfNB3Xm7z6D7bx3v0hZta90m4f43/icU27WW36kEYkU=;
	h=Date:To:From:Subject:Message-Id; b=iSCwSo0jDMyj8ydRih1x0qAEWdg3DSlkDEWhRkOTs2VSr1cTfNwnz2da38hGiF1Nw9fSO0i0XuFYpYv3xTrUbD8j4sZlD+bGOKPfV5ei05UEJ6l4EDHWa+Umo9UThsi0yqetkrzOwafXR5Eyrj5BFlwTVHNN2Wn0JJOevYgVzvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jsR7aQ5h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jsR7aQ5h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0864DC4CEEB;
	Wed, 27 Aug 2025 03:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756265379;
	bh=jfNB3Xm7z6D7bx3v0hZta90m4f43/icU27WW36kEYkU=;
	h=Date:To:From:Subject:From;
	b=jsR7aQ5h2vRO9gV30VuNWlVaFyCqio/WpJWAHY6nHhdF6uKP4qIAwxETbo/RNzGeI
	 8sjXf3hUFPvBmWmoUaNc6XoKdNmD2zuxB+Ee0hCJJiyWlmpf1qWL2EnPuD5M8GMXJV
	 CF3g9z89CeTrDX3A5OJe0TYfdhRxm7GCsu6XT4R8=
Date: Tue, 26 Aug 2025 20:29:38 -0700
To: mm-commits@vger.kernel.org,vbabka@suse.cz,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,npache@redhat.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,liam.howlett@oracle.com,david@redhat.com,dev.jain@arm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch added to mm-new branch
Message-Id: <20250827032939.0864DC4CEEB@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: selftests/mm/uffd-stress: make test operate on less hugetlb memory
has been added to the -mm mm-new branch.  Its filename is
     selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch

This patch will later appear in the mm-new branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Note, mm-new is a provisional staging ground for work-in-progress
patches, and acceptance into mm-new is a notification for others take
notice and to finish up reviews.  Please do not hesitate to respond to
review feedback and post updated versions to replace or incrementally
fixup patches in mm-new.

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
Date: Tue, 26 Aug 2025 12:37:04 +0530

Patch series "selftests/mm: uffd-stress fixes".

This patchset ensures that the number of hugepages is correctly set in the
system so that the uffd-stress test does not fail due to the racy nature
of the test.  Patch 1 corrects the hugepage constraint in the
run_vmtests.sh script, whereas patch 2 corrects the constraint in the test
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

: --- a/mm/hugetlb.c
: +++ b/mm/hugetlb.c
: @@ -6929,6 +6929,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
: 
:  		folio = alloc_hugetlb_folio(dst_vma, dst_addr, false);
:  		if (IS_ERR(folio)) {
: +			pte_t *actual_pte = hugetlb_walk(dst_vma, dst_addr, PMD_SIZE);
: +			if (actual_pte) {
: +				ret = -EEXIST;
: +				goto out;
: +			}
:  			ret = -ENOMEM;
:  			goto out;
:  		}

This code path gets triggered indicating that the PMD at which one thread
is trying to map a hugepage, gets filled by a racing thread.

Therefore, instead of using freepgs to compute the amount of memory, use
freepgs - 10, so that the test still has some extra hugepages to use. 
Note that, in case this value underflows, there is a check for the number
of free hugepages in the test itself, which will fail, so we are safe.

Link: https://lkml.kernel.org/r/20250826070705.53841-1-dev.jain@arm.com
Link: https://lkml.kernel.org/r/20250826070705.53841-2-dev.jain@arm.com
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
 tools/testing/selftests/mm/run_vmtests.sh |    2 +-
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c~selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory
+++ a/mm/hugetlb.c
@@ -6935,6 +6935,11 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 
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
@@ -328,7 +328,7 @@ CATEGORY="userfaultfd" run_test ${uffd_s
 # the size of the free pages we have, which is used for *each*.
 # uffd-stress expects a region expressed in MiB, so we adjust
 # half_ufd_size_MB accordingly.
-half_ufd_size_MB=$(((freepgs * hpgsize_KB) / 1024 / 2))
+half_ufd_size_MB=$((((freepgs - 10) * hpgsize_KB) / 1024 / 2))
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
_

Patches currently in -mm which might be from dev.jain@arm.com are

selftests-mm-uffd-stress-make-test-operate-on-less-hugetlb-memory.patch
selftests-mm-uffd-stress-stricten-constraint-on-free-hugepages-before-the-test.patch

