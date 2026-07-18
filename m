Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF781862
	for <mm-commits@vger.kernel.org>; Sat, 18 Jul 2026 01:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784337048; cv=none; b=rDWMzPaI2qkb06j+lGu4JxOKFPY+z7iCdYDm4HdcB+wugk0LyToAaD1Eymejqw4XzhCrJwKs47JDMfScQrDA+Xe6BAkK6t57QFSP/mxeuvYI/SSbzMSP6Rq8fuS9PDDikOdUXAk+SQhcB53rxyuBI7Wrwlgt9RX4nnep1Rgug1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784337048; c=relaxed/simple;
	bh=nMhe7ft0S8Rd9TId1KfNQyZmOrLEZNJiKIWGpnoWGWo=;
	h=Date:To:From:Subject:Message-Id; b=NJZgXxhpX45tot3JDYVMkDCQxodlBBeEn2e+uESB3ubbJ0NETVbSH+ShuupivXpbUzcnlic/rj5s/7QGdW7DbV92TmTwp/Y98Crk7MuCXI033reyvur7bKuG18v3vhUDZg4c9L1DTesoNhiFCE1Mgt4ow6mPLT6UkF2ERB0JDNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=nQDQUMoY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="nQDQUMoY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C441F000E9;
	Sat, 18 Jul 2026 01:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784337046;
	bh=HbV8CVcHt8+l7E7wsajOtlaDhCVVUvXIHiUpVtFaPFY=;
	h=Date:To:From:Subject;
	b=nQDQUMoYFvzJ5X/UAObrO0+6zfQ0MXqtv1f+i8seckd5PNrHn9kW9/AOgx0Ct54RF
	 TC8gx/jM5IzNvjhxDfzK9FXfnn+kYiMjL56k1kNj9a/5GYaQNqFMCZY0k3M1an4YIO
	 sCGmucIH5V6Cz0pBZ04KU8zpFH5p+PvxEwy5TrrE=
Date: Fri, 17 Jul 2026 18:10:46 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,vbabka@kernel.org,pfalcato@suse.de,ljs@kernel.org,liam@infradead.org,jannh@google.com,david@kernel.org,wangkefeng.wang@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mincore-replace-__get_free_page-with-kmalloc.patch added to mm-new branch
Message-Id: <20260718011046.B2C441F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: mincore: replace __get_free_page() with kmalloc()
has been added to the -mm mm-new branch.  Its filename is
     mm-mincore-replace-__get_free_page-with-kmalloc.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mincore-replace-__get_free_page-with-kmalloc.patch

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
From: Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: mm: mincore: replace __get_free_page() with kmalloc()
Date: Fri, 17 Jul 2026 17:13:44 +0800

Remove ugly casts by using the more natural kmalloc/kfree allocation, also
replace GFP_USER(pointless here) with GFP_KERNEL.

Link: https://lore.kernel.org/20260717091347.1144789-4-wangkefeng.wang@huawei.com
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mincore.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/mincore.c~mm-mincore-replace-__get_free_page-with-kmalloc
+++ a/mm/mincore.c
@@ -12,6 +12,7 @@
 #include <linux/gfp.h>
 #include <linux/pagewalk.h>
 #include <linux/mman.h>
+#include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -329,7 +330,7 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 	if (!access_ok(vec, pages))
 		return -EFAULT;
 
-	tmp = (void *) __get_free_page(GFP_USER);
+	tmp = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!tmp)
 		return -EAGAIN;
 
@@ -354,6 +355,6 @@ SYSCALL_DEFINE3(mincore, unsigned long,
 		start += retval << PAGE_SHIFT;
 		retval = 0;
 	}
-	free_page((unsigned long) tmp);
+	kfree(tmp);
 	return retval;
 }
_

Patches currently in -mm which might be from wangkefeng.wang@huawei.com are

mm-migrate_device-fix-pte_pfn-pte_dirty-called-on-non-present-pte.patch
mm-remove-pagetranscompound.patch
mm-mincore-use-walk_page_range_vma-in-do_mincore.patch
mm-mprotect-use-walk_page_range_vma-in-mprotect_fixup.patch
mm-mlock-use-walk_page_range_vma-in-mlock_vma_pages_range.patch
mm-migrate_device-use-walk_page_range_vma-in-migrate_vma_collect.patch
mm-introduce-pud_is_huge-helper.patch
mm-mincore-remove-special-handling-for-vm_pfnmap.patch
mm-mincore-replace-__get_free_page-with-kmalloc.patch
mm-mincore-remove-xa_is_value-in-mincore_swap.patch
mm-mincore-improve-mincore_hugetlb.patch
mm-mincore-refactor-mincore_page.patch

