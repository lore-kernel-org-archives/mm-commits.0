Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB71552FD
	for <mm-commits@vger.kernel.org>; Sun, 11 Jan 2026 00:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768091412; cv=none; b=n4KT1U0ONLAqyYmwbV0UD23qO4Ene6vegLawUY1JxKpg8OMEjtGEyTdB9QJPS3OcHI8dRzNRn7ljR3Lwh2Goa01evfv2pL35CEejP5a9kM+zSy2ShvBAeFi3/4T+qTCjVjBIc55/R8MXzyEcPoe0Jmx6MUdL4lqqDR5Fs0rpzcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768091412; c=relaxed/simple;
	bh=31w67hxV5QEgl/VSxfNcNDCcEEvEPDBwA2YfGBnBGtI=;
	h=Date:To:From:Subject:Message-Id; b=WIBZUKNIqqOC2QVpvNdWj1pZMk7IYvUUsjQAGRsINDUbnQ9aBIg4qRegbxkC3blCoNf2HcpzkSrVSmWsxtJv4bz21eXXKJmyc2VqPDj+y2PXPKcoEqN2kAZjcHpPY2fREKy2hXI0qN3daKw1Wvnt8RUNwc2y1znpXSDWBB+9Pzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=jNYDHa9y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="jNYDHa9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772F0C4CEF1;
	Sun, 11 Jan 2026 00:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768091412;
	bh=31w67hxV5QEgl/VSxfNcNDCcEEvEPDBwA2YfGBnBGtI=;
	h=Date:To:From:Subject:From;
	b=jNYDHa9yOul/eitNeGXDEAvClbyZts62yFn+B96GaxFYvS23EysvcOEY7PcUDBDyq
	 6r9U5sN3FsjNtYj/e5QkAYvA0b5x+/ffzjfEU9o30FFInMk+YmNoLc1lihBJZhy7Hm
	 HHh50HCkLUJMku/L1Q+86VtgtEyGl0wLXYFnFQxQ=
Date: Sat, 10 Jan 2026 16:30:11 -0800
To: mm-commits@vger.kernel.org,surenb@google.com,rppt@kernel.org,pratyush@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,ran.xiaokai@zte.com.cn,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-init-alloc-tags-when-restoring-pages-from-reserved-memory.patch added to mm-hotfixes-unstable branch
Message-Id: <20260111003012.772F0C4CEF1@smtp.kernel.org>
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
allocation/deallocation tracking and warning message: alloc_tag was not
set.

Add missing clear_page_tag_ref() annotation in kho_restore_page() to
fix this.

Link: https://lkml.kernel.org/r/20260109104251.157767-1-ranxiaokai627@163.com
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Cc: Alexander Graf <graf@amazon.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
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

