Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006D21E7C1C
	for <mm-commits@vger.kernel.org>; Sat,  2 Aug 2025 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754160851; cv=none; b=LpP+krnuIZr+8vyBmiHPX+HfP4cq3UdD0KZZirqDpzylt/IFcEz+Y7qsriKSiY5UFkqKwpAbYVPy026039xZUbUuG5ffi1HuS+EH7UY0C3I56la1gClTl5nC0ChdJpcSudTzGtUJMM9uIWe5u53wg7dRjHpAGvoBYME9DhprGS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754160851; c=relaxed/simple;
	bh=LlfgiBlGx4Rtj+MYeJ6zqFbw0/QqKBlskUWOips0WcA=;
	h=Date:To:From:Subject:Message-Id; b=oy2jGNLVKltIOyVCj9RXn5sWJTKraJaF0RJ8mpnmjd+xLWuxeI1N08FEdaTqSz55Zsz9ZAehzMZ+bqFngjzEgA3aC92Sxmlb2lr+UIaov0zD7I7ufQCMJo21s0wMovpABGU7Vggzatxz6pX5z9ptf8EpXx6mFhVvFRDFMKjKts8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=QVpCvwdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="QVpCvwdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7978BC4CEEF;
	Sat,  2 Aug 2025 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754160850;
	bh=LlfgiBlGx4Rtj+MYeJ6zqFbw0/QqKBlskUWOips0WcA=;
	h=Date:To:From:Subject:From;
	b=QVpCvwdSZ9SfVdIDh7uJr04Hgl0xt/7j5fuWIK/gZaNx84eENMeO7yFYRhlenFs5z
	 IPc11dHk2dFnPvUcxdwgwvW9SFwBliUOCiup0Nl4Mgh6wspQqMdVZCCV+FaEb8eyUL
	 Dsryq/RTP6yy44o3UGWUDh3au9WdnByBLUOHt+RE=
Date: Sat, 02 Aug 2025 11:54:09 -0700
To: mm-commits@vger.kernel.org,wangkefeng.wang@huawei.com,thiago.bauermann@linaro.org,ryan.roberts@arm.com,rientjes@google.com,mhocko@suse.com,lorenzo.stoakes@oracle.com,joern@logfs.org,hughd@google.com,dev.jain@arm.com,david@redhat.com,christophe.leroy@csgroup.eu,catalin.marinas@arm.com,brahmajit.xyz@gmail.com,baolin.wang@linux.alibaba.com,avagin@gmail.com,andrii@kernel.org,tujinjiang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch removed from -mm tree
Message-Id: <20250802185410.7978BC4CEEF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/memory-failure: hold PTL in hwpoison_hugetlb_range
has been removed from the -mm tree.  Its filename was
     mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Jinjiang Tu <tujinjiang@huawei.com>
Subject: mm/memory-failure: hold PTL in hwpoison_hugetlb_range
Date: Fri, 25 Jul 2025 11:31:12 +0800

Hold PTL in hwpoison_hugetlb_range() to avoid operating on stale page, as
hwpoison_pte_range() have done.

This change is not known to address any issues which users have
experienced.

Link: https://lkml.kernel.org/r/20250725033112.2690158-1-tujinjiang@huawei.com
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

 mm/memory-failure.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failure-hold-ptl-in-hwpoison_hugetlb_range
+++ a/mm/memory-failure.c
@@ -837,11 +837,17 @@ static int hwpoison_hugetlb_range(pte_t
 			    struct mm_walk *walk)
 {
 	struct hwpoison_walk *hwp = walk->private;
-	pte_t pte = huge_ptep_get(walk->mm, addr, ptep);
 	struct hstate *h = hstate_vma(walk->vma);
+	spinlock_t *ptl;
+	pte_t pte;
+	int ret;
 
-	return check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
-				      hwp->pfn, &hwp->tk);
+	ptl = huge_pte_lock(h, walk->mm, ptep);
+	pte = huge_ptep_get(walk->mm, addr, ptep);
+	ret = check_hwpoisoned_entry(pte, addr, huge_page_shift(h),
+					hwp->pfn, &hwp->tk);
+	spin_unlock(ptl);
+	return ret;
 }
 #else
 #define hwpoison_hugetlb_range	NULL
_

Patches currently in -mm which might be from tujinjiang@huawei.com are

mm-memory_hotplug-fix-hwpoisoned-large-folio-handling-in-do_migrate_range.patch
mm-smaps-fix-race-between-smaps_hugetlb_range-and-migration.patch
fs-proc-task_mmu-hold-ptl-in-pagemap_hugetlb_range-and-gather_hugetlb_stats.patch

