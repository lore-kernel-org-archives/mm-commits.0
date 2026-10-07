Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C107C2CCB5
	for <mm-commits@vger.kernel.org>; Wed,  7 Oct 2026 18:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791398916; cv=none; b=QFGhrWnD49u1ypL5pdZYlzzC7o4dJP5Jsv1g7qhI/G6SWiyE4dc8zmQk3lC1tUnwMlKx97Cs+NSn9yEP3LtyBD4BaEJF4OtpSqHUU51deLj5/mcu9w4a2xMVUclmrWgXbgcx2Kzu+vBAgphriGw6jq/x0CuNtXwM+LYQejTaeWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791398916; c=relaxed/simple;
	bh=QaRrWPA6t5VVFutF1FQhPaK04dm3PS56dO6opAVQWAE=;
	h=Date:To:From:Subject:Message-Id; b=GXfwFFsaT6n+0vq1XhgSTbB2EeqSW/BW27adQjV6u+l9Uj3eSHa4Y7f4yg9WdKLBtH3ZDgRH+/DwIwlQVb6v2Y15B2qNvMn5TTXDRV9ovdBjIBG+7LtBpltnomvQ/fkx+tItsCDj85drJBKkCL8ZfJ9CGWHQGn+vaY4i4crbwG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=X9e6onJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="X9e6onJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8CC1F000FF;
	Wed,  7 Oct 2026 18:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791398915;
	bh=a7lCku/gMMOYyYAV8c3Zr18nNetVecrDe1e0zDgbFjE=;
	h=Date:To:From:Subject;
	b=X9e6onJlh/fEnB4qKE3wQHOYx5q2WcIluGGhZRoTd/5PuKXAePtlpynl/GCgxVmCu
	 BPb4TGicLEhEcpqNhVPhn7vICJ9cDIyLboDF9kLiGe6VyAb+AFae/wR/A6woNNj+hR
	 5OvpgTNZJyRRYhyuKIB1Pm2ouRgmxSkteZiW0i4g=
Date: Wed, 07 Oct 2026 11:48:34 -0700
To: mm-commits@vger.kernel.org,vasant.hegde@amd.com,osalvador@suse.de,muchun.song@linux.dev,david@kernel.org,dave@stgolabs.net,bharata@amd.com,dheerajkumar.srivastava@amd.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch added to mm-unstable branch
Message-Id: <20261007184835.3A8CC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
has been added to the -mm mm-unstable branch.  Its filename is
     mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
From: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Subject: mm/hugetlb: use kvmalloc_objs for hugetlb_fault_mutex_table
Date: Tue, 6 Oct 2026 21:31:28 +0530

On systems/VMs with a large number of CPUs (e.g.  4096), hugetlb_init()
computes num_fault_mutexes = roundup_pow_of_two(8 * num_possible_cpus()) =
32768.  The subsequent kmalloc for the mutex table can exceed
MAX_PAGE_ORDER when struct mutex is enlarged by debug options like
CONFIG_DEBUG_MUTEXES and CONFIG_DEBUG_LOCK_ALLOC, resulting in:

  WARNING: at __alloc_frozen_pages_noprof (order > MAX_PAGE_ORDER)
  kernel BUG at mm/hugetlb.c (BUG_ON(!hugetlb_fault_mutex_table))
  Kernel panic - not syncing: Fatal exception

Switch to kvmalloc_objs() so the allocation falls back to vmalloc when the
contiguous physical allocation is too large.  The table is only accessed
by index, so virtual contiguity is sufficient.

Link: https://lore.kernel.org/20261006160128.31447-1-dheerajkumar.srivastava@amd.com
Fixes: 8382d914ebf7 ("mm, hugetlb: improve page-fault scalability")
Signed-off-by: Dheeraj Kumar Srivastava <dheerajkumar.srivastava@amd.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: David Hildenbrand <david@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Bharata B Rao <bharata@amd.com>
---

 mm/hugetlb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/hugetlb.c~mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table
+++ a/mm/hugetlb.c
@@ -4242,7 +4242,7 @@ static int __init hugetlb_init(void)
 	num_fault_mutexes = 1;
 #endif
 	hugetlb_fault_mutex_table =
-		kmalloc_objs(struct mutex, num_fault_mutexes);
+		kvmalloc_objs(struct mutex, num_fault_mutexes);
 	BUG_ON(!hugetlb_fault_mutex_table);
 
 	for (i = 0; i < num_fault_mutexes; i++)
_

Patches currently in -mm which might be from dheerajkumar.srivastava@amd.com are

mm-hugetlb-use-kvmalloc_objs-for-hugetlb_fault_mutex_table.patch

