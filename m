Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BDBA1741D4
	for <mm-commits@vger.kernel.org>; Tue, 18 Jun 2024 21:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718744928; cv=none; b=Sxs/bjyuG5IWWK/Jj7le+G/31zi9/gpPA5MfmDnkhDscvUYJBNhXhpi1pnsTrMBakSVXVHFuRXtKBr/9iRLON2zgBYuFAahiOLbGUIp7CAzVv187WpKTOgKVnP2aOj+04u4zRIQUScoMsI8o9lOCiC4J8k8CLDiT7JVqwcfZvko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718744928; c=relaxed/simple;
	bh=6xPzg2EYi1pbWHDakXc3SaPrTujT7vCQ2zHmbXmYW0g=;
	h=Date:To:From:Subject:Message-Id; b=DWenJYwASg5IEQcxEkek7mSn+0Z85ykPslkUeO9CJ5Oa6GZj16eKGfOEZ1ekzpmlfqbAjDC6vjX6NRURV55cLtCK2+4jJNwN2mi2+CQb2OVpL3id1gkJt9uvexcJyAasi/rGVx3tP59/GEqKDN6peim+9rOVYSWduxZsAJcznuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=pCUwwIPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="pCUwwIPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8C8EC3277B;
	Tue, 18 Jun 2024 21:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718744927;
	bh=6xPzg2EYi1pbWHDakXc3SaPrTujT7vCQ2zHmbXmYW0g=;
	h=Date:To:From:Subject:From;
	b=pCUwwIPcJNsXFNYInKH4/qUPXsg+hM8D4WIJh01wbFshbr0VJHY2aevawDmODJdoE
	 Z/Rr+2ELCM7et8o6nGutuiEDH0JQYUvDDfdTpqo65eG4PcW/8km0bvzr4LRCO2Ukxo
	 /LKLExWJ9zZ1uiZcly1lO/ru46jlkMt7JhPbaZ90=
Date: Tue, 18 Jun 2024 14:08:47 -0700
To: mm-commits@vger.kernel.org,yuzhao@google.com,yuanshuai@oppo.com,yosryahmed@google.com,ying.huang@intel.com,willy@infradead.org,v-songbaohua@oppo.com,surenb@google.com,shy828301@gmail.com,ryan.roberts@arm.com,mhocko@suse.com,david@redhat.com,chrisl@kernel.org,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch added to mm-unstable branch
Message-Id: <20240618210847.C8C8EC3277B@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
Date: Tue Jun 18 02:03:56 PM PDT 2024

cleanup and constifications per David and akpm

Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuai Yuan <yuanshuai@oppo.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Yosry Ahmed <yosryahmed@google.com>
Cc: Yu Zhao <yuzhao@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix
+++ a/mm/rmap.c
@@ -1411,9 +1411,9 @@ void folio_add_anon_rmap_pmd(struct foli
 void folio_add_new_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 		unsigned long address, rmap_t flags)
 {
-	int nr = folio_nr_pages(folio);
+	const int nr = folio_nr_pages(folio);
+	const bool exclusive = flags & RMAP_EXCLUSIVE;
 	int nr_pmdmapped = 0;
-	bool exclusive = flags & RMAP_EXCLUSIVE;
 
 	VM_WARN_ON_FOLIO(folio_test_hugetlb(folio), folio);
 	VM_BUG_ON_VMA(address < vma->vm_start ||
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

writeback-factor-out-balance_wb_limits-to-remove-repeated-code-v3-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-fix.patch
mm-extend-rmap-flags-arguments-for-folio_add_new_anon_rmap-fix.patch
mm-use-folio_add_new_anon_rmap-if-folio_test_anonfolio==false-fix.patch

