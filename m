Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C11813BE64A;
	Tue, 10 Mar 2026 16:56:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773161791; cv=none; b=f7NPiZmf1bZ9+WKV1sZAJjPnfkFonWlKnHP3TPUbl86z98iJ7KwjLUqRSXse24/QlCUwJFXsVcN8SNWu4dIPctqUYomE+4O95mEAu048ErYFeNAQZkvFSG0C0RbjKDPAzp+eAy335khNiuFz55bcacYPaUU8W0gbA3KbSTiMr1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773161791; c=relaxed/simple;
	bh=2yyLA1eqQVjSIg1EbJ1Vg5k8O6YyDi6rLlAA/FqS8s8=;
	h=Date:To:From:Subject:Message-Id; b=R6bUN92xsXc70eSlC3kbJIhlCMDBYNNyEcSWrnO8Iq9Ex5qzpwoILLrzsw761rsMPrgIQG7aSmCVL21dZHNO3Oy5Tv+aUt72KyQuTHimkJu6FQBZGtx46GvhBhSn/lrJKGcnWEBKQgPu9jMVkoW1BbUb1YS2jWutBY8Ucs/62g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=k6JJXqQl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="k6JJXqQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AE1AC19423;
	Tue, 10 Mar 2026 16:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773161791;
	bh=2yyLA1eqQVjSIg1EbJ1Vg5k8O6YyDi6rLlAA/FqS8s8=;
	h=Date:To:From:Subject:From;
	b=k6JJXqQlNgh+480yUDKPdEEf3S7NgMjkEhqYqGBHLmLaoKMO/aH/ux1ywcPjjFcOU
	 2m4KHErbBc1VO1i56dtPSFQusFIGkT/eExNgUeyOh6y1kkLYEto/GBa9RZLgmB/AHU
	 Roh2QvBuYFpzKLF8Lt19C1TOZAZwDZ/YmO3oYxtI=
Date: Tue, 10 Mar 2026 09:56:30 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,sidhartha.kumar@oracle.com,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,mike.kravetz@oracle.com,JonasZhou@zhaoxin.com,hughd@google.com,david@kernel.org,aarcange@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch added to mm-new branch
Message-Id: <20260310165631.4AE1AC19423@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
has been added to the -mm mm-new branch.  Its filename is
     mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

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
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Tue, 10 Mar 2026 19:05:26 +0800

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units.  This mismatch means that different
addresses within the same huge page can produce different hash values,
leading to the use of different mutexes for the same huge page.  This can
cause races between faulting threads, which can corrupt the reservation
map and trigger the BUG_ON in resv_map_release().

Fix this by introducing hugetlb_linear_page_index(), which returns the
page index in huge page granularity, and using it in place of
linear_page_index().

Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   17 +++++++++++++++++
 mm/userfaultfd.c        |    2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

--- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/include/linux/hugetlb.h
@@ -792,6 +792,23 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+/**
+ * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
+ *				 page size granularity.
+ * @vma: the hugetlb VMA
+ * @address: the virtual address within the VMA
+ *
+ * Return: the page offset within the mapping in huge page units.
+ */
+static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	struct hstate *h = hstate_vma(vma);
+
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
--- a/mm/userfaultfd.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/mm/userfaultfd.c
@@ -769,7 +769,7 @@ retry:
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
_

Patches currently in -mm which might be from jianhuizzzzz@gmail.com are

mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

