Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA79A33120E;
	Thu, 22 Jan 2026 16:36:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099808; cv=none; b=MpF8vOr7JToGCPaGj0Lq9Bwte0fwUuNDXqt08p3sbMD7WmoxrePJvmR4FTfjupV4QE7YyV7YcNrhQof38eBTxbXMIPCSsgMXC1S7IN1nHkJ6jo/3ULYBCcvyswtJ9etzsATF32dlcTerrmTmQIJ/ZVkqWSJIe4vMJwu7YUsD6Tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099808; c=relaxed/simple;
	bh=B4+XK6wdyDcXYR3k+N4y+ZRY8LBbV67m2XbC1ttE4eU=;
	h=Date:To:From:Subject:Message-Id; b=BbeHtCX+cBJBA2OX5wZDjRmYTWgZFxijFhes3rnr42BMafwaOL9rDi6zrGY+9t74iOHJZqPAz1D7LXuwZxzExkaSFJpQXzF2pb2iRG2U/MXv8HlCSCIkWs4HXsSz8nOeZBG2ZisjZFvyFCWO/8jBtk/BCATazoo7SdQyWFYR6nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=b7ZGEgQp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="b7ZGEgQp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28152C116C6;
	Thu, 22 Jan 2026 16:36:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769099805;
	bh=B4+XK6wdyDcXYR3k+N4y+ZRY8LBbV67m2XbC1ttE4eU=;
	h=Date:To:From:Subject:From;
	b=b7ZGEgQpOfPqDbf6EitoPUFVxn3aFldp9PH15//VChD/Ck0ny8YCWiuDVPYlWn8Gt
	 CjOXa5ffsFduBK/8zWuMIsdji+6k3nickkXJ6AVXd/ZM3Ut155YUt/+63IBE/9XSbn
	 G6J62txWk/TIEZjbVLUPiZ2mW2fnqye7Tt5bH/tI=
Date: Thu, 22 Jan 2026 08:36:44 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,stable@vger.kernel.org,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,kent.overstreet@linux.dev,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20260122163645.28152C116C6@smtp.kernel.org>
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
Date: Thu, 22 Jan 2026 13:27:40 +0000

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

Link: https://lkml.kernel.org/r/20260122132740.176468-1-ranxiaokai627@163.com
Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/liveupdate/kexec_handover.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/liveupdate/kexec_handover.c~kho-init-alloc-tags-when-restoring-pages-from-reserved-memory
+++ a/kernel/liveupdate/kexec_handover.c
@@ -255,6 +255,14 @@ static struct page *kho_restore_page(phy
 	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
+	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
+	clear_page_tag_ref(page);
+	if (!is_folio) {
+		/* Also do that for the non-compound tail pages */
+		for (unsigned int i = 1; i < nr_pages; i++)
+			clear_page_tag_ref(page + i);
+	}
+
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
_

Patches currently in -mm which might be from ran.xiaokai@zte.com.cn are

kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch
alloc_tag-fix-rw-permission-issue-when-handling-boot-parameter.patch

