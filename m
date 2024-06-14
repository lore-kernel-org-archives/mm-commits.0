Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DDC316B751
	for <mm-commits@vger.kernel.org>; Fri, 14 Jun 2024 17:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718385204; cv=none; b=TWJZPysnlvJb4wmPjy033M8jBWhBqNItYRhW6p6onZgvXtdx4s/OX3r079FqnBONITlsEqjSR+SWPsvL+e3lkyqSKqifE4BiGKlBkbTHR1ftVbWtVkfDPypPn8iFXY279AlT8ByaS3sL7PcZe/+eLtC4c/NGHmtmq4L890jG4YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718385204; c=relaxed/simple;
	bh=6cuiAbHCiIPw2WZdHQlfkBra09Z0GpBvuwyXILLb+u4=;
	h=Date:To:From:Subject:Message-Id; b=POivm8sFAQ1N9EjibZOHw5PatJKFtMk3gjZ+S/QQWZ8Bilwy6jSqqZlQWDnaVHuhgr+qGEpe09GPdMkQ8/8Q6wic7r1KsYHSyBufECBXThZNCYFM+PKMAB8FCPp15QKlcnTLwHbZdd6p/9z/BpdoQ7g4LKmUm5006JL72x6EQS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=2kQNOumt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="2kQNOumt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B56C2BD10;
	Fri, 14 Jun 2024 17:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1718385203;
	bh=6cuiAbHCiIPw2WZdHQlfkBra09Z0GpBvuwyXILLb+u4=;
	h=Date:To:From:Subject:From;
	b=2kQNOumtYqYk4C56nj1JCx7wTcJq0Nrka3tdDGIkmx9Wi3r5dQv5fC5yMJGa4VD21
	 Mn30YZgfzsEKPid8/ZJ2AOogEFHBLCD9LZBSwEWoX8I7WRyBEZjn/IYtExbpHUH2Sg
	 Xf+6p7kyUggNQRXTRmBNmWr0/B+uQYohheKt9rno=
Date: Fri, 14 Jun 2024 10:13:23 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,ying.huang@intel.com,wangkefeng.wang@huawei.com,v-songbaohua@oppo.com,shy828301@gmail.com,ryan.roberts@arm.com,p.raghav@samsung.com,ioworker0@gmail.com,hughd@google.com,david@redhat.com,da.gomez@samsung.com,baolin.wang@linux.alibaba.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch added to mm-unstable branch
Message-Id: <20240614171323.C9B56C2BD10@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm-memory-extend-finish_fault-to-support-large-folio-fix-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch

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
@@ -4885,7 +4885,7 @@ vm_fault_t finish_fault(struct vm_fault
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

mm-shmem-fix-getting-incorrect-lruvec-when-replacing-a-shmem-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix.patch
mm-memory-extend-finish_fault-to-support-large-folio-fix-fix.patch
mm-shmem-add-thp-validation-for-pmd-mapped-thp-related-statistics.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem.patch
mm-shmem-add-multi-size-thp-sysfs-interface-for-anonymous-shmem-fix.patch
mm-shmem-add-mthp-support-for-anonymous-shmem.patch
mm-shmem-add-mthp-size-alignment-in-shmem_get_unmapped_area.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem.patch
mm-shmem-add-mthp-counters-for-anonymous-shmem-fix.patch

