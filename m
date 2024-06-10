Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B62314B952
	for <mm-commits@vger.kernel.org>; Mon, 10 Jun 2024 17:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718040984; cv=none; b=q52dBaK71Ej62l5mzHWSdrcr458EDN2vVuHN0tVogE98ho34qYMdpNk7blgr5K6+AWG2hsibkzdDn1N04pBvQgjBQEcmjNDHq8zUD6r0g91zAiTmoYH94kVqM0R854XCGsrE5CWmhi+4/LwVdLnEYCqqw4f7sWws+iBwkO/BLHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718040984; c=relaxed/simple;
	bh=044qrhcfMp2370jmQdHVkz0piW+KJIOAheKDOFCHRl8=;
	h=Date:To:From:Subject:Message-Id; b=OQvT7VCiDmGSsO6Uaj4KtLNfNhaKnoZaYrof1/r6EkLhR98b3F/foEohmdO3NYtAe+K5ny77mo+qHiP/ZyDtx2Ovm48GP07NcktJZJPb7zuxpzjRP2ts5xz+Gm9OvxZH81gIULNOcrk+MvOfpuadBKBrS9gvvQ1KlsK0VsfProw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=AXIzbT81; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="AXIzbT81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF14C2BBFC;
	Mon, 10 Jun 2024 17:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718040984;
	bh=044qrhcfMp2370jmQdHVkz0piW+KJIOAheKDOFCHRl8=;
	h=Date:To:From:Subject:From;
	b=AXIzbT81641HK66WTVGPD6P4bjw8o9+6SblBTGTFrJkOggmazMrXDCDOcf5ta83gy
	 LG9k6KGjEtmEIkYixCaLB3N6rBtbcFtiQLz7LEFUQXkP7CEZk6F5pW6VZiQ2DK0ppR
	 IubANsTCkzFgycjN6vzmU5dhnyjpdiaOynJRn0qg=
Date: Mon, 10 Jun 2024 10:36:23 -0700
To: mm-commits@vger.kernel.org,zokeefe@google.com,ziy@nvidia.com,xiehuan09@gmail.com,willy@infradead.org,wangkefeng.wang@huawei.com,songmuchun@bytedance.com,sj@kernel.org,ryan.roberts@arm.com,peterx@redhat.com,minchan@kernel.org,mhocko@suse.com,maskray@google.com,libang.li@antgroup.com,fengwei.yin@intel.com,david@redhat.com,baolin.wang@linux.alibaba.com,ioworker0@gmail.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch added to mm-unstable branch
Message-Id: <20240610173624.0FF14C2BBFC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/rmap: add helper to restart pgtable walk on changes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch

This patch will later appear in the mm-unstable branch at
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
From: Lance Yang <ioworker0@gmail.com>
Subject: mm/rmap: add helper to restart pgtable walk on changes
Date: Mon, 10 Jun 2024 20:02:07 +0800

Introduce the page_vma_mapped_walk_restart() helper to handle scenarios
where the page table walk needs to be restarted due to changes in the page
table, such as when a PMD is split.  It releases the PTL held during the
previous walk and resets the state, allowing a new walk to start at the
current address stored in pvmw->address.

Link: https://lkml.kernel.org/r/20240610120209.66311-3-ioworker0@gmail.com
Signed-off-by: Lance Yang <ioworker0@gmail.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Cc: Bang Li <libang.li@antgroup.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Jeff Xie <xiehuan09@gmail.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Yin Fengwei <fengwei.yin@intel.com>
Cc: Zach O'Keefe <zokeefe@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/rmap.h |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/include/linux/rmap.h~mm-rmap-add-helper-to-restart-pgtable-walk-on-changes
+++ a/include/linux/rmap.h
@@ -703,6 +703,28 @@ static inline void page_vma_mapped_walk_
 		spin_unlock(pvmw->ptl);
 }
 
+/**
+ * page_vma_mapped_walk_restart - Restart the page table walk.
+ * @pvmw: Pointer to struct page_vma_mapped_walk.
+ *
+ * It restarts the page table walk when changes occur in the page
+ * table, such as splitting a PMD. Ensures that the PTL held during
+ * the previous walk is released and resets the state to allow for
+ * a new walk starting at the current address stored in pvmw->address.
+ */
+static inline void
+page_vma_mapped_walk_restart(struct page_vma_mapped_walk *pvmw)
+{
+	WARN_ON_ONCE(!pvmw->pmd);
+	WARN_ON_ONCE(!pvmw->ptl);
+
+	if (pvmw->ptl)
+		spin_unlock(pvmw->ptl);
+
+	pvmw->ptl = NULL;
+	pvmw->pmd = NULL;
+}
+
 bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw);
 
 /*
_

Patches currently in -mm which might be from ioworker0@gmail.com are

mm-rmap-remove-duplicated-exit-code-in-pagewalk-loop.patch
mm-rmap-add-helper-to-restart-pgtable-walk-on-changes.patch
mm-rmap-integrate-pmd-mapped-folio-splitting-into-pagewalk-loop.patch
mm-vmscan-avoid-split-lazyfree-thp-during-shrink_folio_list.patch

