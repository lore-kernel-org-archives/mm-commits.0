Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9D236CE0E;
	Fri,  6 Mar 2026 17:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772817646; cv=none; b=cyoksLXRTohLqh1UwooGn4PnNuS/65Pmi3+vip9edMezAIqDE+AmgLN+matvcVBp5aGDOqddxBSEuTyTeeU38A+t+VUAQTnhsrz5Ur5q6aPzX29U4zpmEUt4JZ1MWLqZiNibKZbslwdNjmu6B9sIa8hOA6rhm9NfVWActpnvU6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772817646; c=relaxed/simple;
	bh=qPdJe4Z47VypuH7RvMq+bzweb9b+eflRKiFyyrJPYZM=;
	h=Date:To:From:Subject:Message-Id; b=DBRaaS7WO/EaKMAFRPML1GPlH9APTTGF27Qt9WbSiSSe2tbG7u8e7BQ5RkpUJvu1qi31kIX/Tpsj/YkFgc559II8kPa7u55uqjdnzBRgY1OQZTKBUORQ5bhZ94Kr9/Mug/CHAUrNuE0fSK27QFD58nieOuUwbWhvIpvb2/vtK4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=v+ssIZeN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="v+ssIZeN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B195BC4CEF7;
	Fri,  6 Mar 2026 17:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772817645;
	bh=qPdJe4Z47VypuH7RvMq+bzweb9b+eflRKiFyyrJPYZM=;
	h=Date:To:From:Subject:From;
	b=v+ssIZeNMoI3Ei826nxlS6X+GWXbuWHGcgvaKvD+COt4AaKgGwfFMHLOdASt+FNtH
	 +9jDpjldhU4fkVwPzvlHZ23OU7a5bebNQnmchfMcn+w6YidJJtVVcVuZ7I+OsXX91t
	 pqjPU2NMOv4LknRzpKnuPkKQ3o9ocF5U1ZaKA5E0=
Date: Fri, 06 Mar 2026 09:20:45 -0800
To: mm-commits@vger.kernel.org,xemul@parallels.com,stable@vger.kernel.org,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,ljs@kernel.org,JonasZhou@zhaoxin.com,hillf.zj@alibaba-inc.com,dgilbert@redhat.com,david@redhat.com,david@kernel.org,aarcange@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch added to mm-hotfixes-unstable branch
Message-Id: <20260306172045.B195BC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Jianhui Zhou <jianhuizzzzz@gmail.com>
Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Fri, 6 Mar 2026 21:59:26 +0800

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units (as calculated by
vma_hugecache_offset()).  This mismatch means that different addresses
within the same huge page can produce different hash values, leading to
the use of different mutexes for the same huge page.  This can cause races
between faulting threads, which can corrupt the reservation map and
trigger the BUG_ON in resv_map_release().

Fix this by replacing linear_page_index() with vma_hugecache_offset() and
applying huge_page_mask() to align the address properly.  To make
vma_hugecache_offset() available outside of mm/hugetlb.c, move it to
include/linux/hugetlb.h as a static inline function.

Link: https://lkml.kernel.org/r/tencent_F70AFD1D8067E3D2409764BC1A199DA6AF0A@qq.com
Fixes: 60d4d2d2b40e ("userfaultfd: hugetlbfs: add __mcopy_atomic_hugetlb for huge page UFFDIO_COPY")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/hugetlb.h |   17 +++++++++++++++++
 mm/hugetlb.c            |   11 -----------
 mm/userfaultfd.c        |    5 ++++-
 3 files changed, 21 insertions(+), 12 deletions(-)

--- a/include/linux/hugetlb.h~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/include/linux/hugetlb.h
@@ -796,6 +796,17 @@ static inline unsigned huge_page_shift(s
 	return h->order + PAGE_SHIFT;
 }
 
+/*
+ * Convert the address within this vma to the page offset within
+ * the mapping, huge page units here.
+ */
+static inline pgoff_t vma_hugecache_offset(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool order_is_gigantic(unsigned int order)
 {
 	return order > MAX_PAGE_ORDER;
@@ -1197,6 +1208,12 @@ static inline unsigned int huge_page_shi
 	return PAGE_SHIFT;
 }
 
+static inline pgoff_t vma_hugecache_offset(struct hstate *h,
+		struct vm_area_struct *vma, unsigned long address)
+{
+	return linear_page_index(vma, address);
+}
+
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
 	return false;
--- a/mm/hugetlb.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/mm/hugetlb.c
@@ -1006,17 +1006,6 @@ static long region_count(struct resv_map
 	return chg;
 }
 
-/*
- * Convert the address within this vma to the page offset within
- * the mapping, huge page units here.
- */
-static pgoff_t vma_hugecache_offset(struct hstate *h,
-			struct vm_area_struct *vma, unsigned long address)
-{
-	return ((address - vma->vm_start) >> huge_page_shift(h)) +
-			(vma->vm_pgoff >> huge_page_order(h));
-}
-
 /**
  * vma_kernel_pagesize - Page size granularity for this VMA.
  * @vma: The user mapping.
--- a/mm/userfaultfd.c~mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation
+++ a/mm/userfaultfd.c
@@ -507,6 +507,7 @@ static __always_inline ssize_t mfill_ato
 	pgoff_t idx;
 	u32 hash;
 	struct address_space *mapping;
+	struct hstate *h;
 
 	/*
 	 * There is no default zero huge page for all huge page sizes as
@@ -564,6 +565,8 @@ retry:
 			goto out_unlock;
 	}
 
+	h = hstate_vma(dst_vma);
+
 	while (src_addr < src_start + len) {
 		VM_WARN_ON_ONCE(dst_addr >= dst_start + len);
 
@@ -573,7 +576,7 @@ retry:
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = vma_hugecache_offset(h, dst_vma, dst_addr & huge_page_mask(h));
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
_

Patches currently in -mm which might be from jianhuizzzzz@gmail.com are

mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

