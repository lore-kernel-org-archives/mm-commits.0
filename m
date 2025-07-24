Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5961FFE
	for <mm-commits@vger.kernel.org>; Thu, 24 Jul 2025 22:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753394538; cv=none; b=UrI4XQzuCkp/0FA3w/Wd36WeupFrsKvlZPTN8mOqBf5wPkWFzd9cRw3FuSMHshF2/L3xNvZkXTvknpXyLgBBuoGMAbO4HLhDsmUgxySH1JS1fzWNsGkjCtfSmvZ7eusau58JnPxm4VM+lAabZxPFGxyvxEJ7Zb2KeFbsQnL6hHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753394538; c=relaxed/simple;
	bh=UqLgjQOGA8+vprXsU5GhweeWRjxZnYBSDHky0ibN7PA=;
	h=Date:To:From:Subject:Message-Id; b=fLSoxzN3zSyAFS7H8l2w2F1c4DCkACu0Q1krK29Y/5QGZ9R1u0zh7eVsrTj33Se19AE7CAkQgMmjL0l23y29kfrK6mNIwRSvFkdQ5G4XdJXN0+GrMQ7ZQkrxYVEAiNKGu00IZ3y4wL/zJeGs3UdJnVa0XhmnHGGuNkH/kuqqpxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QLeWmmGE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QLeWmmGE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D849DC4CEED;
	Thu, 24 Jul 2025 22:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1753394536;
	bh=UqLgjQOGA8+vprXsU5GhweeWRjxZnYBSDHky0ibN7PA=;
	h=Date:To:From:Subject:From;
	b=QLeWmmGEAcZp4y9apKIgO3Wvj7T2V5DWwUt91diR7Z8gFppxRrkfgg7KVvDeK04YS
	 YiWVx+5E8JxpHdZoZSWFCGBqHwAJc9cTY1rcMlAywAw6BTHAQD6BSjsUF58jm8tQdo
	 jfHU3JMbdHoFjxVeBUJDLhU1BlaccP9NJAe15C20=
Date: Thu, 24 Jul 2025 15:02:16 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-hold-ptl-in-mincore_hugetlb.patch added to mm-new branch
Message-Id: <20250724220216.D849DC4CEED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/mincore: hold PTL in mincore_hugetlb
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-hold-ptl-in-mincore_hugetlb.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-hold-ptl-in-mincore_hugetlb.patch

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
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/mincore: hold PTL in mincore_hugetlb
Date: Thu, 24 Jul 2025 17:09:58 +0800

Hold PTL in mincore_hugetlb() to avoid operating on stale page, as
mincore_pte_range() have done.

Link: https://lkml.kernel.org/r/20250724090958.455887-4-tujinjiang@huawei.com
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Brahmajit Das <brahmajit.xyz@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: David Rientjes <rientjes@google.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joern Engel <joern@logfs.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Thiago Jung Bauermann <thiago.bauermann@linaro.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/mincore.c~mm-mincore-hold-ptl-in-mincore_hugetlb
+++ a/mm/mincore.c
@@ -29,7 +29,9 @@ static int mincore_hugetlb(pte_t *pte, u
 #ifdef CONFIG_HUGETLB_PAGE
 	unsigned char present;
 	unsigned char *vec = walk->private;
+	spinlock_t *ptl;
 
+	ptl = huge_pte_lock(hstate_vma(walk->vma), walk->mm, pte);
 	/*
 	 * Hugepages under user process are always in RAM and never
 	 * swapped out, but theoretically it needs to be checked.
@@ -38,6 +40,7 @@ static int mincore_hugetlb(pte_t *pte, u
 	for (; addr != end; vec++, addr += PAGE_SIZE)
 		*vec = present;
 	walk->private = vec;
+	spin_unlock(ptl);
 #else
 	BUG();
 #endif
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch
fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch
mm-mincore-hold-ptl-in-mincore_hugetlb.patch

