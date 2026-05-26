Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39CC156CA;
	Tue, 26 May 2026 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779821219; cv=none; b=fE+6Kn9KfuwHXahr7PfffIIa2s/08Izt5TMoZF5U1fUDm+HiwTsCF8+qf2YVtp5DJKoBdl05r3rdRG6kjU9ZKq3gyI53fhAEPM8wCIYKd02uz9L2L/BuHZH2QRmj94LZUGcrtrVVOilB+7MDOW8Vsv2u1u5LwBbkuQuXs+5NuYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779821219; c=relaxed/simple;
	bh=b+PFGuxn4oW4UDvhhsh0mxUNZbVnK3ju+oIn7lqT2cQ=;
	h=Date:To:From:Subject:Message-Id; b=u9QLTUSPHZXnvagNjZPlrYr5zrRTJ59cqlsLNQSOlO0M4VOj6M75ErGLmior1adEwHiDudTLef7EXm+hREYf2ub6Pn3Mz2Knu8wtNwZNENpqKL/HPP0BKMPTf32ct+EPzVMm0X4HPZpPfXlcLEXAvP6N9aMpv2AaHFbD8WuGYQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PE/ahD6c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PE/ahD6c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DED71F00A3C;
	Tue, 26 May 2026 18:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779821218;
	bh=t/9ZzDp61s9GPyUsg5pIOn18nUTW7EH47VDxEhT2HcQ=;
	h=Date:To:From:Subject;
	b=PE/ahD6c6cJEBQDbXvJJS3XJGKfv2Q0NKGZeJWIAnPGxxsLmSsnrqpHsJbuU7XZoU
	 nI9YTW9nPkC8tCLPS/BsLwBkMbbP6YA85LFRvPiidjb5EVpp7tGeh6FlYtr4KOUy1x
	 1bg3UASU3AdzjvR5+MBGOlDOIYhZR6kn23pokeHA=
Date: Tue, 26 May 2026 11:46:57 -0700
To: mm-commits@vger.kernel.org,ziy@nvidia.com,wangkefeng.wang@huawei.com,stable@vger.kernel.org,ryan.roberts@arm.com,npache@redhat.com,ljs@kernel.org,liam@infradead.org,lance.yang@linux.dev,dev.jain@arm.com,david@kernel.org,chenjun102@huawei.com,baolin.wang@linux.alibaba.com,baohua@kernel.org,apopple@nvidia.com,yintirui@huawei.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-huge_memory-update-file-pud-counter-before-folio_put.patch added to mm-hotfixes-unstable branch
Message-Id: <20260526184658.2DED71F00A3C@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm/huge_memory: update file PUD counter before folio_put()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-huge_memory-update-file-pud-counter-before-folio_put.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-huge_memory-update-file-pud-counter-before-folio_put.patch

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
From: Yin Tirui <yintirui@huawei.com>
Subject: mm/huge_memory: update file PUD counter before folio_put()
Date: Tue, 26 May 2026 18:13:55 +0800

__split_huge_pud_locked() updates the file/shmem RSS counter after
dropping the PUD mapping's folio reference.  If folio_put() drops the last
reference, mm_counter_file() can later read freed folio state via
folio_test_swapbacked().

Move the counter update before folio_put().

Link: https://lore.kernel.org/20260526101355.1984244-1-yintirui@huawei.com
Fixes: dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
Signed-off-by: Yin Tirui <yintirui@huawei.com>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Acked-by: David Hildenbrand (arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Chen Jun <chenjun102@huawei.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/huge_memory.c~mm-huge_memory-update-file-pud-counter-before-folio_put
+++ a/mm/huge_memory.c
@@ -3015,9 +3015,9 @@ static void __split_huge_pud_locked(stru
 	if (!folio_test_referenced(folio) && pud_young(old_pud))
 		folio_set_referenced(folio);
 	folio_remove_rmap_pud(folio, page, vma);
-	folio_put(folio);
 	add_mm_counter(vma->vm_mm, mm_counter_file(folio),
 		-HPAGE_PUD_NR);
+	folio_put(folio);
 }
 
 void __split_huge_pud(struct vm_area_struct *vma, pud_t *pud,
_

Patches currently in -mm which might be from yintirui@huawei.com are

mm-huge_memory-update-file-pud-counter-before-folio_put.patch

