Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B621A1C
	for <mm-commits@vger.kernel.org>; Fri,  4 Oct 2024 02:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728008780; cv=none; b=oZT0YMvF1ZxoijdS6Ix0gyP5NG4MVMkwSxteGb0HvTuWV/GIvPMBkWeLaDQgA3vN8DGvP9WZOFEGsPDANxat1mGMhoZ/CLvzdbNxj0fAwbnE8W7rk+7wZA2KHqIQLmjLzUiHYsf/CCjJdU2SsjP3YuBivHlTsiGDMgNvotRGMSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728008780; c=relaxed/simple;
	bh=2jQsY3Q242yCTllS2N+zHxDTIN2zEH0vxPjUoeJEHuA=;
	h=Date:To:From:Subject:Message-Id; b=oZ4MqCo+otphsASxi6nvmyJ9jqG/AQjg8HW1U2EUOyy3GjvD/hPv5jNU8yiInlzO/F4XPaLKwoxduy5BxWOhCojLaQfjS5kLgIchf2WIqEDgUdNLhEqUL+XVBBngZJ2F2EsyVdF9ImZ5IqunomlmBsZcpaNrNEXc0N8em4pTL3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pjbOW9Y/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pjbOW9Y/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D1FC4CEC5;
	Fri,  4 Oct 2024 02:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728008779;
	bh=2jQsY3Q242yCTllS2N+zHxDTIN2zEH0vxPjUoeJEHuA=;
	h=Date:To:From:Subject:From;
	b=pjbOW9Y/a1X00rFUepKmkp9Vcvquhwsp4nqsOj37blgjNnvUCSEufbusFVU+6zm0L
	 qHqCysOMf5TZZqOEj6qp0KyiDAbj/zxPyEo65lOccP4DHSpGjP3TYzoDopMId+Eryb
	 f9/RshV0RS+WPXxlDvT1TJJnQg1EIF8vobBVbWMc=
Date: Thu, 03 Oct 2024 19:26:19 -0700
To: mm-commits@vger.kernel.org,peterx@redhat.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-huge_memory-check-pmd_special-only-after-pmd_present.patch removed from -mm tree
Message-Id: <20241004022619.D7D1FC4CEC5@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/huge_memory: check pmd_special() only after pmd_present()
has been removed from the -mm tree.  Its filename was
     mm-huge_memory-check-pmd_special-only-after-pmd_present.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: mm/huge_memory: check pmd_special() only after pmd_present()
Date: Thu, 26 Sep 2024 17:42:34 +0200

We should only check for pmd_special() after we made sure that we have a
present PMD.  For example, if we have a migration PMD, pmd_special() might
indicate that we have a special PMD although we really don't.

This fixes confusing migration entries as PFN mappings, and not doing what
we are supposed to do in the "is_swap_pmd()" case further down in the
function -- including messing up COW, page table handling and accounting.

Link: https://lkml.kernel.org/r/20240926154234.2247217-1-david@redhat.com
Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+bf2c35fa302ebe3c7471@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/lkml/66f15c8d.050a0220.c23dd.000f.GAE@google.com/
Reviewed-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-check-pmd_special-only-after-pmd_present
+++ a/mm/huge_memory.c
@@ -1586,7 +1586,7 @@ int copy_huge_pmd(struct mm_struct *dst_
 	int ret = -ENOMEM;
 
 	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_special(pmd))) {
+	if (unlikely(pmd_present(pmd) && pmd_special(pmd))) {
 		dst_ptl = pmd_lock(dst_mm, dst_pmd);
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
_

Patches currently in -mm which might be from david@redhat.com are

selftests-mm-hugetlb_fault_after_madv-use-default-hguetlb-page-size.patch
selftests-mm-hugetlb_fault_after_madv-improve-test-output.patch

