Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DFF449E131;
	Thu, 10 Sep 2026 23:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789082737; cv=none; b=XJi2EZJj/N+dDiqPpm+PfDzY2fACW2Cbs6Qr7m8sf3nnsWfOpVBoVemlcurHvJncqeCAzHYIBjz6/ZOztpuCBCW6IBM5p+pc/Cj9ixm5llKZBt5VxvlrYsh+hRcWodY4OnsJMHPOx3GdnxmiwfeLKXsD5lkrK1nTwooCHFHO2WY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789082737; c=relaxed/simple;
	bh=iWCBqKcJfc3Jzl0BvWR40d7MkbKyoZ7lZ4n5MUvfXOc=;
	h=Date:To:From:Subject:Message-Id; b=OB/tEbBzXHKZwzws+jcQ7zcn/YJ6xwk6iNHVf194l0AtVbX4bAwrq5/6lmBYp59h9J+zr0Ce3FyPFWNSSGfgqbqoirfnY4yuE3YwAoJobX/cAo/snk2cvzyE833ld3rYBvcNDzX53Rs94jWHdmE3N6yiMAXeuemwvhUax62jBWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=MTLIgPJU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="MTLIgPJU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CC4D1F000FF;
	Thu, 10 Sep 2026 23:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789082736;
	bh=l7vuHELdWMdt9EAwrrKi++BI3jHEefVOn3wga04MkcY=;
	h=Date:To:From:Subject;
	b=MTLIgPJU+kOBDEXLFEt60c50gJXslNKVZ3WveeNln6baVZOlcYASbKL9zAKtnxMcj
	 0p3hFU7VvOqDlwhr9e08Pcr3CJfvTXiZs5bqVwvuSTdKFnjQmOO+PPKFzx7fIVMFur
	 X0mVQXZkioYOa68vzv7D6bE9uwX0NqVGHoAHTqi0=
Date: Thu, 10 Sep 2026 16:25:35 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,stable@vger.kernel.org,shy828301@gmail.com,ryan.roberts@arm.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,kas@kernel.org,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,jthoughton@google.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch removed from -mm tree
Message-Id: <20260910232536.2CC4D1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm/khugepaged: don't install PMDs in uffd-minor-registered VMAs
has been removed from the -mm tree.  Its filename was
     mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas.patch

This patch was dropped because an updated version will be issued

------------------------------------------------------
From: James Houghton <jthoughton@google.com>
Subject: mm/khugepaged: don't install PMDs in uffd-minor-registered VMAs
Date: Fri, 28 Aug 2026 22:26:40 +0000

Userfaultfd minor faults provides userspace with the ability to manually
install PTEs with UFFDIO_CONTINUE.  Right now, khugepaged collapse can map
holes in the VMA when a naturally-aligned THP is present without explicit
action from userspace.

This is a problem, as it bypasses userfaultfd minor faults that userspace
is expecting to handle.

If userspace implements post-copy live migration using userfaultfd minor
faults, this situation is currently possible:
1. The VMA for guest memory is userfaultfd-minor-registered and nothing
   is mapped in the page tables.
2. A stale copy of a page is present in a naturally-aligned THP (from
   pre-copy live migration).
3. khugepaged collapses the mapping of the THP, installs a PMD.
4. The VM now has access to the stale contents => VM is broken.
5. After installing the correct contents, userspace attempts to map the
   page with UFFDIO_CONTINUE; it gets EEXIST, indicating that something
   unexpectedly mapped the page.

The naturally-aligned THP case is the only case where this is a problem. 
khugepaged otherwise requires all PTEs to be present for
userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is correct. 
This check is essentially bypassed for naturally-aligned THPs.

No changes are needed for file_backed_vma_is_retractable(), as zapping
PTEs is safe.  Userspace must already handle cases where PTEs are zapped
without explicit action (e.g.  due to reclaim).

A reproducer for this issue is at
https://gist.github.com/48ca/d399bf534158e80241fb4937ef1ff664

Link: https://lore.kernel.org/20260828222640.1638457-1-jthoughton@google.com
Fixes: 58ac9a8993a1 ("mm/khugepaged: attempt to map file/shmem-backed pte-mapped THPs by pmds")
Signed-off-by: James Houghton <jthoughton@google.com>
Suggested-by: Lance Yang <lance.yang@linux.dev>
Tested-by: Lance Yang <lance.yang@linux.dev>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org> # 6.1
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/khugepaged.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/mm/khugepaged.c~mm-khugepaged-dont-install-pmds-in-uffd-minor-registered-vmas
+++ a/mm/khugepaged.c
@@ -1902,6 +1902,13 @@ static enum scan_result try_collapse_pte
 	if (userfaultfd_protected(vma))
 		return SCAN_PTE_UFFD;
 
+	/*
+	 * Userfaultfd-minor-registered VMAs should not be collapsed, as
+	 * userspace is expecting to explicitly install PTEs.
+	 */
+	if (userfaultfd_minor(vma))
+		return SCAN_PTE_UFFD;
+
 	folio = filemap_lock_folio(vma->vm_file->f_mapping,
 			       linear_page_index(vma, haddr));
 	if (IS_ERR(folio))
_

Patches currently in -mm which might be from jthoughton@google.com are

mm-khugepaged-never-install-pmds-in-uffd-minor-registered-vmas.patch
mm-selftests-adjust-the-madv_collapse-uffd-minor-selftests.patch

