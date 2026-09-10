Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB3749E15F
	for <mm-commits@vger.kernel.org>; Thu, 10 Sep 2026 22:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789078867; cv=none; b=paVO+F8ME5nqp47yKEA4p0rQk8tEr08bia5uSze71OrNtOWtikgbqqLAoj+SABI5rXjKfmmeEZOzDkFudSV5E738/m97Pr/I7cSxY+L/9WzTrG6vT6Ife6EIVAras+fG1/e54uDRMQ3+kLYdFtuAShrH6rVPaf7UQPTgpCSXc8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789078867; c=relaxed/simple;
	bh=gKsDjO+EqlCCUBZWxU5d5bGViSgEMlSBfXzJ/jZXq5g=;
	h=Date:To:From:Subject:Message-Id; b=hvOmArPXGTYFlqhF/Ny3dO4tplhW9WiHldbHhtq+l6gwIx84mp5K7EKCUU81AlKvnwodyLqqYmU5xksLz1rKUmug4I6MRyhfFZzAe6dAYWYjC8mMtrqbvaMH0pnwefwG/Ww/ZLtIiSmqY/vkiCl5PSBY3oFkjesAwYyVNzsWPDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=R/+bQ/B6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="R/+bQ/B6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EF31F000FF;
	Thu, 10 Sep 2026 22:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789078861;
	bh=oFBBMtZb3Av7N1ptsmhhUHWSxFacP0z/1GLc3fCYOgg=;
	h=Date:To:From:Subject;
	b=R/+bQ/B6xRHArP6klf9YAY5IVWeKvFEcY7jM+pbbaZi6ANPLt0uZp08Mr+t7lHVxW
	 kr5HYoHlROmKBUmib9+MAW9VtF+NF9sbie5YutmBmJXqshQQLJLoAL61qP7SrJfY0j
	 coaSCj3gHlVcyY4B4iNXkLXYbtQy6yuofkXwGIws=
Date: Thu, 10 Sep 2026 15:21:01 -0700
To: mm-commits@vger.kernel.org,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,yehuaisheng@open-hieco.net,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-account-for-allowed-nodes-when-gathering-surplus-pages.patch added to mm-new branch
Message-Id: <20260910222101.B1EF31F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: account for allowed nodes when gathering surplus pages
has been added to the -mm mm-new branch.  Its filename is
     mm-hugetlb-account-for-allowed-nodes-when-gathering-surplus-pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-account-for-allowed-nodes-when-gathering-surplus-pages.patch

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
From: Huaisheng Ye <yehuaisheng@open-hieco.net>
Subject: mm/hugetlb: account for allowed nodes when gathering surplus pages
Date: Wed, 9 Sep 2026 15:46:42 +0800

Hugetlb reservations are accounted globally, but hugetlb_acct_memory()
also verifies that the current cpuset and MPOL_BIND policy contain enough
free huge pages to add a new reservation.

gather_surplus_pages() calculates its allocation shortfall from the global
free and reserved counters.  If the global pool has enough free pages, but
those pages reside outside the nodes allowed by the task, it allocates no
surplus pages.  The subsequent allowed_mems_nr() check then rejects the
reservation and mmap() fails with ENOMEM, even when
nr_overcommit_hugepages permits allocating surplus pages on the allowed
nodes.

Calculate both the global shortfall and the shortfall within the allowed
nodes, and allocate the larger of the two.  Include surplus pages
allocated outside hugetlb_lock in both calculations when rechecking after
reacquiring the lock.  These pages are constrained by alloc_nodemask, so
they satisfy both shortages.

Easy way to reproduce this issue with 2+ NUMA nodes system:

  # echo 0 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepage
  # echo 3 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
  # echo 1 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_overcommit_hugepages
  # cd tools/testing/selftests/mm
  # numactl --membind=1 ./hugetlb-mmap 2 21
  TAP version 13
  # [INFO] detected hugetlb page size: 2048 KiB
  # [INFO] detected hugetlb page size: 1048576 KiB
  # 2048 kB hugepages
  1..2
  # Mapping 2 Mbytes
  Bail out! mmap: Cannot allocate memory (12)
  # Planned tests != run tests (2 != 0)
  # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0

This fixes hugetlb mappings when, for example, a task runs with MPOL_BIND
on Node 1 while the existing free huge pages are on Node 0.

Similar issue also could be found in ltp if the free pages of global pool
reside outside the nodes allowed by the application.
  # cd ltp/testcases/kernel/mem/hugetlb/hugemmap/
  # numactl --cpunodebind=0 --membind=1 ./hugemmap10

Link: https://lore.kernel.org/20260909074642.7308-1-yehuaisheng@open-hieco.net
Signed-off-by: Huaisheng Ye <yehuaisheng@open-hieco.net>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlb-account-for-allowed-nodes-when-gathering-surplus-pages
+++ a/mm/hugetlb.c
@@ -125,6 +125,7 @@ struct mutex *hugetlb_fault_mutex_table
 
 /* Forward declaration */
 static int hugetlb_acct_memory(struct hstate *h, long delta);
+static unsigned int allowed_mems_nr(struct hstate *h);
 static void hugetlb_vma_lock_free(struct vm_area_struct *vma);
 static void hugetlb_vma_lock_alloc(struct vm_area_struct *vma);
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
@@ -2253,6 +2254,19 @@ static nodemask_t *policy_mbind_nodemask
 }
 
 /*
+ * Reservations are globally accounted, but they must also be backed by free
+ * pages on nodes allowed by the current cpuset and MPOL_BIND policy.
+ */
+static long surplus_pages_needed(struct hstate *h, long delta, long allocated)
+{
+	long global_free = (long)h->free_huge_pages + allocated;
+	long allowed_free = (long)allowed_mems_nr(h) + allocated;
+
+	return max((long)h->resv_huge_pages + delta - global_free,
+		   delta - allowed_free);
+}
+
+/*
  * Increase the hugetlb pool such that it can accommodate a reservation
  * of size 'delta'.
  */
@@ -2274,7 +2288,7 @@ static int gather_surplus_pages(struct h
 		alloc_nodemask = cpuset_current_mems_allowed;
 
 	lockdep_assert_held(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
+	needed = surplus_pages_needed(h, delta, 0);
 	if (needed <= 0) {
 		h->resv_huge_pages += delta;
 		return 0;
@@ -2305,11 +2319,10 @@ retry:
 
 	/*
 	 * After retaking hugetlb_lock, we need to recalculate 'needed'
-	 * because either resv_huge_pages or free_huge_pages may have changed.
+	 * because either resv_huge_pages or the free page counts may have changed.
 	 */
 	spin_lock_irq(&hugetlb_lock);
-	needed = (h->resv_huge_pages + delta) -
-			(h->free_huge_pages + allocated);
+	needed = surplus_pages_needed(h, delta, allocated);
 	if (needed > 0) {
 		if (alloc_ok)
 			goto retry;
_

Patches currently in -mm which might be from yehuaisheng@open-hieco.net are

mm-hugetlb-account-for-allowed-nodes-when-gathering-surplus-pages.patch

