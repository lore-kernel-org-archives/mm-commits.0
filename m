Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886A735CBC9;
	Wed, 12 Nov 2025 18:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762973887; cv=none; b=UfcAEau394cwKVmvEdkDTnbIHxtB2EM+SIuyYRPco0BQm/3XU4ez8CHfwfJnPviWXG0AFDth22I0XI8/YDH2qijAG4cxiJWl+WadITxr1df/V/2xSqCek/n4xyaJ8kP6rpVmSvrBDN2WebLdXVdwzTTe8J4bS8mx33/qm1U+ZTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762973887; c=relaxed/simple;
	bh=1FJjIirT7Sw6zks9hSZuy2eEhwmaKWExUY5BlnQBc0M=;
	h=Date:To:From:Subject:Message-Id; b=IvtQUxDphm+Mt45Gvt/JTMIS6MjjOMpbVXN11P9+l9T64dRYJp/31WwR0ywMtvAwAPEYgKWtycGmyghJIaxFz1dwys4oXE7apDIrNS4/WL1SZwUS0yaTFO3txL9wtFq6tEHt4hPSecYN+qFRogM0oz9t+wQauEm+T5d2kCpspL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=FkI6ySGl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="FkI6ySGl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CD20C19421;
	Wed, 12 Nov 2025 18:58:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762973887;
	bh=1FJjIirT7Sw6zks9hSZuy2eEhwmaKWExUY5BlnQBc0M=;
	h=Date:To:From:Subject:From;
	b=FkI6ySGlTZ0JtLqihHw+17UCsodJ3LuZhG31h7dCDqTk1ANLeK5y/1MbICBFUAO9h
	 RepAUjE/Ygi3jO7OnWCi/gSuod2hL6doiFMpzYweAszYmV+scilmA56Q/GdKjlN6d8
	 5cBS/BUH9BkdvP6sJlFLfv/wwcfH+4pfO1RsJ/Rs=
Date: Wed, 12 Nov 2025 10:58:06 -0800
To: mm-commits@vger.kernel.org,vivek.kasireddy@intel.com,stable@vger.kernel.org,osalvador@suse.de,kraxel@redhat.com,jgg@nvidia.com,hch@lst.de,david@redhat.com,airlied@redhat.com,kartikey406@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memfd-fix-information-leak-in-hugetlb-folios.patch added to mm-hotfixes-unstable branch
Message-Id: <20251112185807.0CD20C19421@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/memfd: fix information leak in hugetlb folios
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-memfd-fix-information-leak-in-hugetlb-folios.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memfd-fix-information-leak-in-hugetlb-folios.patch

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
From: Deepanshu Kartikey <kartikey406@gmail.com>
Subject: mm/memfd: fix information leak in hugetlb folios
Date: Wed, 12 Nov 2025 20:20:34 +0530

When allocating hugetlb folios for memfd, three initialization steps are
missing:

1. Folios are not zeroed, leading to kernel memory disclosure to userspace
2. Folios are not marked uptodate before adding to page cache
3. hugetlb_fault_mutex is not taken before hugetlb_add_to_page_cache()

The memfd allocation path bypasses the normal page fault handler
(hugetlb_no_page) which would handle all of these initialization steps. 
This is problematic especially for udmabuf use cases where folios are
pinned and directly accessed by userspace via DMA.

Fix by matching the initialization pattern used in hugetlb_no_page():
- Zero the folio using folio_zero_user() which is optimized for huge pages
- Mark it uptodate with folio_mark_uptodate()
- Take hugetlb_fault_mutex before adding to page cache to prevent races

The folio_zero_user() change also fixes a potential security issue where
uninitialized kernel memory could be disclosed to userspace through read()
or mmap() operations on the memfd.

Link: https://lkml.kernel.org/r/20251112145034.2320452-1-kartikey406@gmail.com
Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Reported-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/20251112031631.2315651-1-kartikey406@gmail.com/ [v1]
Closes: https://syzkaller.appspot.com/bug?extid=f64019ba229e3a5c411b
Suggested-by: Oscar Salvador <osalvador@suse.de>
Suggested-by: David Hildenbrand <david@redhat.com>
Tested-by: syzbot+f64019ba229e3a5c411b@syzkaller.appspotmail.com
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com> (v2)
Cc: Christoph Hellwig <hch@lst.de> (v6)
Cc: Dave Airlie <airlied@redhat.com>
Cc: Gerd Hoffmann <kraxel@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memfd.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

--- a/mm/memfd.c~mm-memfd-fix-information-leak-in-hugetlb-folios
+++ a/mm/memfd.c
@@ -96,9 +96,36 @@ struct folio *memfd_alloc_folio(struct f
 						    NULL,
 						    gfp_mask);
 		if (folio) {
+			u32 hash;
+
+			/*
+			 * Zero the folio to prevent information leaks to userspace.
+			 * Use folio_zero_user() which is optimized for huge/gigantic
+			 * pages. Pass 0 as addr_hint since this is not a faulting path
+			 *  and we don't have a user virtual address yet.
+			 */
+			folio_zero_user(folio, 0);
+
+			/*
+			 * Mark the folio uptodate before adding to page cache,
+			 * as required by filemap.c and other hugetlb paths.
+			 */
+			__folio_mark_uptodate(folio);
+
+			/*
+			 * Serialize hugepage allocation and instantiation to prevent
+			 * races with concurrent allocations, as required by all other
+			 * callers of hugetlb_add_to_page_cache().
+			 */
+			hash = hugetlb_fault_mutex_hash(memfd->f_mapping, idx);
+			mutex_lock(&hugetlb_fault_mutex_table[hash]);
+
 			err = hugetlb_add_to_page_cache(folio,
 							memfd->f_mapping,
 							idx);
+
+			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
+
 			if (err) {
 				folio_put(folio);
 				goto err_unresv;
_

Patches currently in -mm which might be from kartikey406@gmail.com are

mm-memfd-fix-information-leak-in-hugetlb-folios.patch
ocfs2-validate-cl_bpc-in-allocator-inodes-to-prevent-divide-by-zero.patch

