Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD9248592A
	for <mm-commits@vger.kernel.org>; Tue, 13 Oct 2026 04:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791866027; cv=none; b=C3s6+RQu2XWmCc8kiDo5ZX78t2ZqAgu3jp3YXcMHvJL+0vODcGL5DQfl3f5cL1xakoFkDG5R8Kk4d96rMHERu1fBcxj3Yk3N4RK/duTCI4MUzKO0zR4DhCKHuy+FdEwy1K/RVuIHDKD0/m9KOhjd2Bfpb2uePWfjLXBw0ugb0kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791866027; c=relaxed/simple;
	bh=G3d7nT4TA1F8QphLY4C67JXDXHdYCft+Mp+gZGrbJ3Y=;
	h=Date:To:From:Subject:Message-Id; b=eIyr68fz918CWaUdXbrCDRncFX6IAAracH2z1veoPG5+S7ATM4ZwngLlwUH73AgRaXEWMPrvCOSJrR19ysU4Ra3+zJ0v464crXOUbbOPwD72vpwhePS23/pRKEY0LfPLtNsZlwgsHHBsoxyO9eA8erYT1PlrRZCMP8wSNeUvWa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rv4Lxgw8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rv4Lxgw8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D531F1F000FF;
	Tue, 13 Oct 2026 04:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791866017;
	bh=VGq3Cj7Yxpg+CMUQQckzJk7J9pCNWDyWEHx/KHu3thI=;
	h=Date:To:From:Subject;
	b=rv4Lxgw8zkglOuqdeeODX4G2+FCDsm8VNGx4YoMDaiE7y6+GLFETvOhghYLffLY5i
	 4LDbQViQFj27LgOR1FnEwn8Yzi/8aqVFwiJu4Mvxzq+Rv35qbqtgqoxFIJoqGf5/MP
	 Rl8O9FvEkwxln4oUV4UxlwCPxBQwlj6h96GYER4s=
Date: Mon, 12 Oct 2026 21:33:37 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,usama.arif@linux.dev,usama.anjum@arm.com,surenb@google.com,shuah@kernel.org,ryan.roberts@arm.com,rppt@kernel.org,nico.pache@linux.dev,mhocko@suse.com,ljs@kernel.org,liam@infradead.org,leon@kernel.org,lance.yang@linux.dev,kernel-team@meta.com,jgg@ziepe.ca,hughd@google.com,dev.jain@arm.com,david@kernel.org,baolin.wang@linux.alibaba.com,baohua@kernel.org,agordeev@linux.ibm.com,kas@kernel.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch removed from -mm tree
Message-Id: <20261013043337.D531F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: selftests/mm: scale khugepaged's collapse wait with the PMD size
has been removed from the -mm tree.  Its filename was
     selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: selftests/mm: scale khugepaged's collapse wait with the PMD size
Date: Sat, 19 Sep 2026 01:24:33 +0100

wait_for_scan() gives every case the same three seconds, whatever the huge
page costs to build.  collapse_full() asks for four of them: 8M at a 2M
PMD, but 2G at a 512M PMD -- arm64 with 64K base pages.  Three seconds is
thin at that size, and the case has reported a failure for a collapse that
was still going.

The timeout is a ceiling on a poll loop, not a sleep: the loop stops as
soon as ops->check_huge() sees the collapse, or as soon as full_scans has
advanced by two.  Raising it costs a passing case nothing.  Across 80 runs
of collapse_full() on arm64 with 64K pages the wait was half a second in
73 of them, with a tail to two seconds.

Keep three seconds as the floor and add a second per 128M collapsed.  A 2M
PMD is unchanged, so x86-64 is too; a 512M PMD gets 19 seconds.

On arm64 with 64K pages a passing ./khugepaged all:anon takes 49 seconds
under TCG before and after this change.

Link: https://lore.kernel.org/20260919002451.496763-4-kirill@shutemov.name
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Assisted-by: LLM
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (arm)" <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickens <hughd@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: kernel-team@meta.com
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Liam Howlett <liam@infradead.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nico Pache (Red Hat) <nico.pache@linux.dev>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan (Samsung OSG) <shuah@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Usama Arif <usama.arif@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
---

 tools/testing/selftests/mm/khugepaged.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/mm/khugepaged.c~selftests-mm-scale-khugepageds-collapse-wait-with-the-pmd-size
+++ a/tools/testing/selftests/mm/khugepaged.c
@@ -561,8 +561,11 @@ static bool wait_for_scan(const char *ms
 		int nr_hpages, int collap_order, struct mem_ops *ops)
 {
 	unsigned long hpage_size = page_size << collap_order;
-	int full_scans;
-	int timeout = 6; /* 3 seconds */
+	unsigned long bytes = (unsigned long)nr_hpages * hpage_size;
+	int timeout, full_scans;
+
+	/* Half-second ticks: three seconds floor, plus a second per 128M */
+	timeout = 6 + 2 * (bytes / (128UL << 20));
 
 	/* Sanity check */
 	if (!ops->check_huge(p, len, 0, hpage_size))
_

Patches currently in -mm which might be from kas@kernel.org are

mm-page_alloc-make-defrag_mode-retries-follow-the-promoted-order.patch
mm-khugepaged-drop-redundant-mm_struct-pin-in-madvise_collapse.patch
mm-khugepaged-count-collapses-where-khugepaged-makes-them.patch
mm-khugepaged-rename-mthp_present_ptes-bitmap-to-eligible_ptes.patch
mm-collapse-add-collapseh-for-the-collapse-interface.patch
mm-collapse-state-what-a-collapse-may-do-in-the-policy.patch
mm-collapse-drop-the-collapse_possible-wrapper.patch
mm-collapse-name-the-per-table-scan-reset-for-what-it-resets.patch
mm-collapse-call-collapse_file-from-collapse_single_pmd.patch
mm-collapse-separate-scanning-a-pte-table-from-collapsing-it.patch
mm-collapse-open-code-collapse_single_pmd-in-its-two-callers.patch
mm-collapse-work-out-the-orders-a-vma-allows-once-per-vma.patch
mm-collapse-declare-the-collapse-interface-in-collapseh.patch
mm-collapse-implement-madv_collapse-in-madvisec.patch

