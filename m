Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC6F213A86C;
	Wed, 14 Jan 2026 00:15:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768349714; cv=none; b=FDwrxT1zHMc00lFtJXamD0ab+91A5Oh9S7f4wU1lq5zJBg7O+9vtBWcdFRUqCa+8+gqz/7yA0VPUktu3NQhviW8RUjBlyl+QAP00PzcGx5ME/C4H1cgPvI6FoRu7F0E7GobnWUYkZILCMVfpie8PLYEMawl2JZW4CE6PzK9XYgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768349714; c=relaxed/simple;
	bh=3EvefWsLoxPlogKPQ2X10cKF3OlYgoQwf3eHHgy7cF0=;
	h=Date:To:From:Subject:Message-Id; b=oZI+twu8HkL7hS5DuH09tPj4V58HL+85jGtoOH3j/Mwkia86Asti8mpQXFz8TydpgofvaTtcOtaCk8/3McLaeKsJQRXe8gJlJqj9xJ1sKxtEgtKuPV08MdBFCgeTzryPcIVbIKt1SHXwphyhxjkI5J4Q40k6pejGS2R1J9RWkG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=h6WIfwr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="h6WIfwr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D563C116C6;
	Wed, 14 Jan 2026 00:15:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768349713;
	bh=3EvefWsLoxPlogKPQ2X10cKF3OlYgoQwf3eHHgy7cF0=;
	h=Date:To:From:Subject:From;
	b=h6WIfwr3+ShW5Q6YZRn1iPWqhn75TsMD7VxLcN69+WKzdG0emI4TBBCTq7U0A14Iz
	 JOlZV+nL035lLOVYNO1J4VXzWWBInHudeBjMw2No4GSDDWDqN2nWiSS9MmFYosWY+4
	 pzfWU648kbSs0IU0Ktg553DojZ5e/pPnCMSrDCpQ=
Date: Tue, 13 Jan 2026 16:15:12 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20260114001513.7D563C116C6@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: init alloc tags when restoring pages from reserved memory
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch

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
From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Subject: kho: init alloc tags when restoring pages from reserved memory
Date: Fri, 9 Jan 2026 10:42:51 +0000

Memblock pages (including reserved memory) should have their allocation
tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
released to the page allocator.  When kho restores pages through
kho_restore_page(), missing this call causes mismatched
allocation/deallocation tracking and below warning message:

alloc_tag was not set
WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
RIP: 0010:___free_pages+0xb8/0x260
 kho_restore_vmalloc+0x187/0x2e0
 kho_test_init+0x3c4/0xa30
 do_one_initcall+0x62/0x2b0
 kernel_init_freeable+0x25b/0x480
 kernel_init+0x1a/0x1c0
 ret_from_fork+0x2d1/0x360

Add missing clear_page_tag_ref() annotation in kho_restore_page() to
fix this.

Link: https://lkml.kernel.org/r/20260113033403.161869-1-ranxiaokai627@163.com
Link: https://lkml.kernel.org/r/20260109104251.157767-1-ranxiaokai627@163.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-init-alloc-tags-when-restoring-pages-from-reserved-memory
+++ a/kernel/liveupdate/kexec_handover.c
@@ -255,6 +255,7 @@ static struct page *kho_restore_page(phy
 	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
+	clear_page_tag_ref(page);
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch

