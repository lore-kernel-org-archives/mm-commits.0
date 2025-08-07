Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801F436D;
	Thu,  7 Aug 2025 00:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754525279; cv=none; b=cpxARsusiSz37lJU4SSR/T8X/7/tQzp10oS0OZnNPyIidLku6ZJjsrgX6GuSFkvABIrILmnZFIidxCc+HpkT1QjSVo1/HX795+f6ItkVly2JXTX+DgFVJVuE3Gbsb/TeTAnF62uUvwPaGFzmXCRe7Rlxd1f1gFp7Cic8ooW1VQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754525279; c=relaxed/simple;
	bh=6722RNmp1KTSH9ayP/zoR6IR9Rd4c+WTwMB2VLKwA4s=;
	h=Date:To:From:Subject:Message-Id; b=el0JXvfaMYQtbNguzVI8zmnsUBh/WaW6pbNJ0UBf85iu1A+AES1jdlm/avxHJdqBK/RfDHUhXBZMGhe3CjQiFpghKAxiBqaSUD1WuLJz43HjnMvYE8Otnaf6CCcvvw8eex9rs62I9q3mcXEQLgeBBx7fU9SSpI5e+KmrQ/weLoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=OmcLF2ma; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="OmcLF2ma"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7A7BC4CEE7;
	Thu,  7 Aug 2025 00:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1754525278;
	bh=6722RNmp1KTSH9ayP/zoR6IR9Rd4c+WTwMB2VLKwA4s=;
	h=Date:To:From:Subject:From;
	b=OmcLF2magUZhruFVh49EBR46BzZ3sGOa09XJVljzN0ZD6DX1Q0Sfc6KdvZBwAsWj/
	 oLzx6Op5NKQj5vrPJTdxAE+jeLBm4wYtelucpS7Y7TK6aL2yUOhC3nHSzhCbaz/htu
	 UJEdkOJQqgTTmW6SA7P7lEtr3Xg9umf1EvLGOF74=
Date: Wed, 06 Aug 2025 17:07:58 -0700
To: mm-commits@vger.kernel.org,stable@vger.kernel.org,souravpanda@google.com,rientjes@google.com,pasha.tatashin@soleen.com,hca@linux.ibm.com,gor@linux.ibm.com,gerald.schaefer@linux.ibm.com,david@redhat.com,agordeev@linux.ibm.com,sumanthk@linux.ibm.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-fix-accounting-of-memmap-pages-for-early-sections.patch added to mm-hotfixes-unstable branch
Message-Id: <20250807000758.D7A7BC4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: mm: fix accounting of memmap pages for early sections
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-fix-accounting-of-memmap-pages-for-early-sections.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-fix-accounting-of-memmap-pages-for-early-sections.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
From: Sumanth Korikkar <sumanthk@linux.ibm.com>
Subject: mm: fix accounting of memmap pages for early sections
Date: Mon, 4 Aug 2025 10:40:15 +0200

memmap pages can be allocated either from the memblock (boot) allocator
during early boot or from the buddy allocator.

When these memmap pages are removed via arch_remove_memory(), the
deallocation path depends on their source:

* For pages from the buddy allocator, depopulate_section_memmap() is
  called, which also decrements the count of nr_memmap_pages.

* For pages from the boot allocator, free_map_bootmem() is called. But
  it currently does not adjust the nr_memmap_boot_pages.

To fix this inconsistency, update free_map_bootmem() to also decrement the
nr_memmap_boot_pages count by invoking memmap_boot_pages_add(), mirroring
how free_vmemmap_page() handles this for boot-allocated pages.

This ensures correct tracking of memmap pages regardless of allocation
source.

Link: https://lkml.kernel.org/r/20250804084015.270570-1-sumanthk@linux.ibm.com
Fixes: 15995a352474 ("mm: report per-page metadata information")
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Sourav Panda <souravpanda@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/sparse.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/sparse.c~mm-fix-accounting-of-memmap-pages-for-early-sections
+++ a/mm/sparse.c
@@ -688,6 +688,7 @@ static void free_map_bootmem(struct page
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(end - start, PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
_

Patches currently in -mm which might be from sumanthk@linux.ibm.com are

mm-fix-accounting-of-memmap-pages-for-early-sections.patch

