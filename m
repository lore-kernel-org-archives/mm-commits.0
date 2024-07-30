Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88CD9945A
	for <mm-commits@vger.kernel.org>; Tue, 30 Jul 2024 01:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722302517; cv=none; b=Nyt/n6dhPunrB/5MAJ/0x2oYygNSscVA4D+8XH0Fmq12Xrw4weE60oy9UMLN/O+OsmabZPLmYnEqiGUolVyySgMTL0ZyRZJm3pMPBoFOKr2O3f3mJNQABoXlCA6W4BheGyaOMe1LOpIpP5vieaefHVuR3130K0Z/KDgUeKZIbAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722302517; c=relaxed/simple;
	bh=Om4iADi2EmMZYTdXIcS+uDaxCW2AaGU2at+YDGFGuUk=;
	h=Date:To:From:Subject:Message-Id; b=fJDVPV6zs1WJWPZngRmF3QpjGG/npsuShnAsfF1i4YR8lSy7HPYBPKzgOBkaydnZlVD+zdeGU+bPGA7kSub/VuQ4mRqfpQxwPCO4if9ElAi+urDPKoBjUQIa7VCqgPxFclZ2FWqMPicE+SFFNTo72tP6dRtpZrQ+aJ2NGPROBms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=sq5eddD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="sq5eddD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05456C4AF0C;
	Tue, 30 Jul 2024 01:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1722302517;
	bh=Om4iADi2EmMZYTdXIcS+uDaxCW2AaGU2at+YDGFGuUk=;
	h=Date:To:From:Subject:From;
	b=sq5eddD0z44DuvI7Xy9s1GhXmzH5FF40fgJSGO6jZAx7fYntJth5xuUgJFQbXg5rc
	 nAvpHruZqd0t9Sj+o7ZMZ9EDrxZOWarVIwln87mQXHGyleNkjd6qPdCGdH9puXg64u
	 V3iN4EWIKVI6Er8BBIuaiwb8TbtP+ackhRQW45lc=
Date: Mon, 29 Jul 2024 18:21:56 -0700
To: mm-commits@vger.kernel.org,zhengqi.arch@bytedance.com,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch added to mm-hotfixes-unstable branch
Message-Id: <20240730012157.05456C4AF0C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: David Hildenbrand <david@redhat.com>
Subject: mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
Date: Mon, 29 Jul 2024 10:43:34 +0200

Let's adjust the comment, passing a pte to pte_lockptr() and dropping
a detail about changed *pmd, which no longer applies.

Link: https://lkml.kernel.org/r/498c936f-fa30-4670-9bbc-4cd8b7995091@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/pgtable-generic.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/mm/pgtable-generic.c~mm-let-pte_lockptr-consume-a-pte_t-pointer-fix
+++ a/mm/pgtable-generic.c
@@ -350,11 +350,11 @@ pte_t *pte_offset_map_nolock(struct mm_s
  * pte_offset_map_nolock(mm, pmd, addr, ptlp), above, is like pte_offset_map();
  * but when successful, it also outputs a pointer to the spinlock in ptlp - as
  * pte_offset_map_lock() does, but in this case without locking it.  This helps
- * the caller to avoid a later pte_lockptr(mm, *pmd), which might by that time
- * act on a changed *pmd: pte_offset_map_nolock() provides the correct spinlock
- * pointer for the page table that it returns.  In principle, the caller should
- * recheck *pmd once the lock is taken; in practice, no callsite needs that -
- * either the mmap_lock for write, or pte_same() check on contents, is enough.
+ * the caller to avoid a later pte_lockptr(mm, pte): pte_offset_map_nolock()
+ * provides the correct spinlock pointer for the page table that it returns.
+ * In principle, the caller should recheck *pmd once the lock is taken; in
+ * practice, no callsite needs that - either the mmap_lock for write, or
+ * pte_same() check on contents, is enough.
  *
  * Note that free_pgtables(), used after unmapping detached vmas, or when
  * exiting the whole mm, does not take page table lock before freeing a page
_

Patches currently in -mm which might be from david@redhat.com are

mm-let-pte_lockptr-consume-a-pte_t-pointer.patch
mm-let-pte_lockptr-consume-a-pte_t-pointer-fix.patch
mm-hugetlb-fix-hugetlb-vs-core-mm-pt-locking.patch
mm-turn-use_split_pte_ptlocks-use_split_pte_ptlocks-into-kconfig-options.patch
mm-hugetlb-enforce-that-pmd-pt-sharing-has-split-pmd-pt-locks.patch
powerpc-8xx-document-and-enforce-that-split-pt-locks-are-not-used.patch
mm-simplify-arch_make_folio_accessible.patch
mm-gup-convert-to-arch_make_folio_accessible.patch
s390-uv-drop-arch_make_page_accessible.patch

