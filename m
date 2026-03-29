Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9D9266576;
	Sun, 29 Mar 2026 00:41:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774744901; cv=none; b=HlyL+KRp7pckT1PhL2wTsqm+uzK+SrOOP9h+aCA3LmQJ8rsn3V+Hq3z3gXfbcoKZI1Gdsvj3+6CPurEIjXHc8OrBXqw0CR5F91i3wJJb8ZvQBy8M358TJuomUqiCE3vkAhxzqjTVmEm0AEsOvD8e8iA6VqBVdRQ9l5m4JOyoJZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774744901; c=relaxed/simple;
	bh=X4FNaUJ1Qt2Ppyb8KjUE4F3oY0k054huvDQQNwKFh7I=;
	h=Date:To:From:Subject:Message-Id; b=aHwMKUjgRI8FS5olZ9rGZ967MVFWryaY7/UJz4rhyGIB6H2Cz+QA1bPnfgbTH5O/WH5Q0yKlna5D+CMNtp4iQFMPQiad9mfKZlw12rxTtQx4YpWERxyAVIcppsugkuY1DU6XqJmtURb+5VPBuvSlXfa4k4zDlePkVpLVX7FusfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PtWcl7Yj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PtWcl7Yj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB42CC4CEF7;
	Sun, 29 Mar 2026 00:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774744901;
	bh=X4FNaUJ1Qt2Ppyb8KjUE4F3oY0k054huvDQQNwKFh7I=;
	h=Date:To:From:Subject:From;
	b=PtWcl7YjAhrUzkbzXnwp+ypquZxe7vJPNOHbF5K1dtP1/1i2nxIMU45KTuslrYuId
	 VyMmlDz42TDKMR/QplZJ8mhxshnaezxN9f2nl2vNtF/7sZSPIMib8tjPmP21gDnyTv
	 nf/rud8sDnbf8DViKXvVprFqU/khFtlXXsy6zd5A=
Date: Sat, 28 Mar 2026 17:41:40 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,sj@kernel.org,sidhartha.kumar@oracle.com,rppt@kernel.org,peterx@redhat.com,osalvador@suse.de,muchun.song@linux.dev,JonasZhou@zhaoxin.com,jane.chu@oracle.com,hughd@google.com,david@kernel.org,aarcange@redhat.com,jianhuizzzzz@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch removed from -mm tree
Message-Id: <20260329004140.EB42CC4CEF7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/userfaultfd: fix hugetlb fault mutex hash calculation
has been removed from the -mm tree.  Its filename was
     mm-userfaultfd-fix-hugetlb-fault-mutex-hash-calculation.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
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
@@ -573,7 +573,7 @@ retry:
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


