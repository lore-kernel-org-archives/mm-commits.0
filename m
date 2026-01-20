Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5051C34B678;
	Tue, 20 Jan 2026 17:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768930605; cv=none; b=C/fgFo7uQolwa3Cl7Nnnxaqp4TPhVwH4PG3Bxx8NM1aT6fCefq0xPY06o/pz6ryapxUecFvqK/Tc6GXhSTAR881L1iTF5Qi65qfVlAzC5p3TgTDGlAIDEXnto1wDDYEZNQfQ9eZOPo4/l9V/Ly2xow18t2sv2tRfiy8AWdJZ/1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768930605; c=relaxed/simple;
	bh=j2DsBhWZixGtDRhNsk7hgkQ02Tv5S/MskezpBDyC9p0=;
	h=Date:To:From:Subject:Message-Id; b=NW3R7PjdOKyGSbx6juMuYGRasksiGj9Dlw+M4k8FWXClzf67wJaInY/PsFW7bRc3m2emKbgbh14QdaFfveITZWf5iXDWRrje6rrvWgXSUQY0lAiXzBy4+4Wmn0m+xfWzOqNETn6611fCEwRASyJCDoiCy+pzugjWl8Z7FiVmMPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=q13IvRoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="q13IvRoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6FDC16AAE;
	Tue, 20 Jan 2026 17:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768930604;
	bh=j2DsBhWZixGtDRhNsk7hgkQ02Tv5S/MskezpBDyC9p0=;
	h=Date:To:From:Subject:From;
	b=q13IvRoHD+3DAgelnreplETcwWVpSemipJwx0jm4XiR2hVlQ0i33goLkXBhfSvAzz
	 P/1/YRAMmwekY1XgrZPm2WO1oW9AOULxghXnqm+aMnVWe6M5qXWMk4fQHVXrzx0Mh9
	 NDoHbO6J8cN/foIYKn9Y92/TMng2Jc3Djc5hoSak=
Date: Tue, 20 Jan 2026 09:36:44 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20260120173644.9F6FDC16AAE@smtp.kernel.org>
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
alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch

