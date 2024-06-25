Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE29F13848A
	for <mm-commits@vger.kernel.org>; Tue, 25 Jun 2024 04:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719289201; cv=none; b=ROIiHNICA+869HKt12muB8yU94TwTYj5pOG2PjUKUnZWmw+K1c50Qr+1eJ27wghopWREhwItZt0bIPBS59/bKdjzpEq87yilzP1darxCF9vgbop5r86lxGlv6ae0vpgFzfHgPwUIVJ5S/ojY83n4k6KoWXze5ml8FEk3t0vsxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719289201; c=relaxed/simple;
	bh=RkKDont3dOLvLdNVQkwCaeipu9k1pkkg8LePBUReK8c=;
	h=Date:To:From:Subject:Message-Id; b=jFgAmVqqpGwE12qUkObL2mvRFbahiKBg/eyzr/T3mnAMz+TfW5gZ1CftsdsVEq5gtwIpkmx+6IyJUUuGqqvQSTpgHLAdgoNschuHJkBS5CZM0rzjFsKEA2Py6lJEZY8qk2BI1bj5VjIxQayAECtGEVrbG07Hm4FOoenRaa/3N3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=tavwWK4n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="tavwWK4n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A30C32782;
	Tue, 25 Jun 2024 04:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1719289200;
	bh=RkKDont3dOLvLdNVQkwCaeipu9k1pkkg8LePBUReK8c=;
	h=Date:To:From:Subject:From;
	b=tavwWK4nOUiMObd8c69dG0maWuzmooGU3LLyZMMKcf1ZuUKZ+h7+5bmOnrYLIQnLh
	 8DcIHpwVxkoIl+noIGK7Pt1XKxnG3h1RRPNToBi2owdYuprCamTgIZ2cF0v9qT4Bg9
	 ElmLSe2tcmCW8oQ+H3yrxZ5RHgX5OVzLS34U9/nA=
Date: Mon, 24 Jun 2024 21:19:59 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch removed from -mm tree
Message-Id: <20240625042000.72A30C32782@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The quilt patch titled
     Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix-fix
has been removed from the -mm tree.  Its filename was
     mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch

This patch was dropped because it was folded into mm-memory-extend-finish_fault-to-support-large-folio.patch

------------------------------------------------------
From: Baolin Wang <baolin.wang@linux.alibaba.com>
Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix-fix
Date: Fri, 14 Jun 2024 12:54:41 +0800

use 'PTRS_PER_PTE' instead of 'PTRS_PER_PTE - 1'

Link: https://lkml.kernel.org/r/e1f5767a-2c9b-4e37-afe6-1de26fe54e41@linux.alibaba.com
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: Daniel Gomez <da.gomez@samsung.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Huang, Ying" <ying.huang@intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Pankaj Raghav <p.raghav@samsung.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Yang Shi <shy828301@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/memory.c~mm-memory-extend-finish_fault-to-support-large-folio-fix-fix
+++ a/mm/memory.c
@@ -4886,7 +4886,7 @@ vm_fault_t finish_fault(struct vm_fault
 		if (unlikely(vma_off < idx ||
 			    vma_off + (nr_pages - idx) > vma_pages(vma) ||
 			    pte_off < idx ||
-			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE - 1)) {
+			    pte_off + (nr_pages - idx)  > PTRS_PER_PTE)) {
 			nr_pages = 1;
 		} else {
 			/* Now we can set mappings for the whole large folio. */
_

Patches currently in -mm which might be from baolin.wang@linux.alibaba.com are

mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix-3.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch
mm-memcontrol-add-vm_bug_on_folio-to-catch-lru-folio-in-mem_cgroup_migrate.patch

