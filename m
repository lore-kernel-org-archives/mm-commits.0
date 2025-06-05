Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2786817548
	for <mm-commits@vger.kernel.org>; Thu,  5 Jun 2025 20:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749154402; cv=none; b=TPtDO5HdrInHxbtaF76rwdrh/8Y1XTyBZ2KFCkqXsE68z34g6FIZa869KgooxvUCcfdSkXzSAVXHdVUBmUZp9A034cAxTkcbDmInFhfTAgIDjzld6+0JPLQK8EbkXRQsLSzxaGmg6D89CvXPit4Ro2mS+YvJqeLJLgHk8SCE3tA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749154402; c=relaxed/simple;
	bh=OB3n8UD+qyPRR7qudRb1f1MJ1MnQzhlAi+BOdWgrl5s=;
	h=Date:To:From:Subject:Message-Id; b=F4JhA5XxnxIHYLA1wK/nrJ9e54uyXjCfj4zhXEXNaWnYHD8/sI0BbMCjMNX2J3axtspFTK61e0MI8PafJoHMFvjS/aILFvZ+EniPaxn3ggB39H9mZ9CvNLjVR6d52+VcwYStoUw4F9w9HnfDPqi5Jgf7HN1QrFa5xsMIi/aPP7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hLlOQ9sL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hLlOQ9sL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85C27C4CEE7;
	Thu,  5 Jun 2025 20:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1749154401;
	bh=OB3n8UD+qyPRR7qudRb1f1MJ1MnQzhlAi+BOdWgrl5s=;
	h=Date:To:From:Subject:From;
	b=hLlOQ9sL0t+xpooLd1OfEnDdNX4HrsMoUKRAlmMsh+7DAs/bpHzefH+O3zdeF4gNx
	 kBLdGAS3ROutfnctNwkr9LrH88UozB89OtzFuyseWq1+UnVtwVBs9/JIzDrQwBMv+3
	 T1Hs9UFVGtVBjZa/PJw0eYvVTgQyva4L6xsUEGFs=
Date: Thu, 05 Jun 2025 13:13:20 -0700
To: mm-commits@vger.kernel.org,rppt@kernel.org,pasha.tatashin@soleen.com,graf@amazon.com,changyuanl@google.com,bhe@redhat.com,ptyadav@amazon.de,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + kho-initialize-tail-pages-for-higher-order-folios-properly.patch added to mm-hotfixes-unstable branch
Message-Id: <20250605201321.85C27C4CEE7@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: kho: initialize tail pages for higher order folios properly
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     kho-initialize-tail-pages-for-higher-order-folios-properly.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kho-initialize-tail-pages-for-higher-order-folios-properly.patch

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
From: Pratyush Yadav <ptyadav@amazon.de>
Subject: kho: initialize tail pages for higher order folios properly
Date: Thu, 5 Jun 2025 19:11:41 +0200

Currently, when restoring higher order folios, kho_restore_folio() only
calls prep_compound_page() on all the pages.  That is not enough to
properly initialize the folios.  The managed page count does not get
updated, the reserved flag does not get dropped, and page count does not
get initialized properly.

Restoring a higher order folio with it results in the following BUG with
CONFIG_DEBUG_VM when attempting to free the folio:

    BUG: Bad page state in process test  pfn:104e2b
    page: refcount:1 mapcount:0 mapping:0000000000000000 index:0xffffffffffffffff pfn:0x104e2b
    flags: 0x2fffff80000000(node=0|zone=2|lastcpupid=0x1fffff)
    raw: 002fffff80000000 0000000000000000 00000000ffffffff 0000000000000000
    raw: ffffffffffffffff 0000000000000000 00000001ffffffff 0000000000000000
    page dumped because: nonzero _refcount
    [...]
    Call Trace:
    <TASK>
    dump_stack_lvl+0x4b/0x70
    bad_page.cold+0x97/0xb2
    __free_frozen_pages+0x616/0x850
    [...]

Combine the path for 0-order and higher order folios, initialize the tail
pages with a count of zero, and call adjust_managed_page_count() to
account for all the pages instead of just missing them.

In addition, since all the KHO-preserved pages get marked with
MEMBLOCK_RSRV_NOINIT by deserialize_bitmap(), the reserved flag is not
actually set (as can also be seen from the flags of the dumped page in the
logs above).  So drop the ClearPageReserved() calls.

Link: https://lkml.kernel.org/r/20250605171143.76963-1-pratyush@kernel.org
Fixes: fc33e4b44b271 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Cc: Alexander Graf <graf@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Changyuan Lyu <changyuanl@google.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_handover.c |   29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

--- a/kernel/kexec_handover.c~kho-initialize-tail-pages-for-higher-order-folios-properly
+++ a/kernel/kexec_handover.c
@@ -164,11 +164,21 @@ static int __kho_preserve_order(struct k
 }
 
 /* almost as free_reserved_page(), just don't free the page */
-static void kho_restore_page(struct page *page)
+static void kho_restore_page(struct page *page, unsigned int order)
 {
-	ClearPageReserved(page);
-	init_page_count(page);
-	adjust_managed_page_count(page, 1);
+	unsigned int i, nr_pages = (1 << order);
+
+	/* Head page gets refcount of 1. */
+	set_page_count(page, 1);
+
+	/* For higher order folios, tail pages get a page count of zero. */
+	for (i = 1; i < nr_pages; i++)
+		set_page_count(page + i, 0);
+
+	if (order > 0)
+		prep_compound_page(page, order);
+
+	adjust_managed_page_count(page, nr_pages);
 }
 
 /**
@@ -186,15 +196,10 @@ struct folio *kho_restore_folio(phys_add
 		return NULL;
 
 	order = page->private;
-	if (order) {
-		if (order > MAX_PAGE_ORDER)
-			return NULL;
-
-		prep_compound_page(page, order);
-	} else {
-		kho_restore_page(page);
-	}
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
 
+	kho_restore_page(page, order);
 	return page_folio(page);
 }
 EXPORT_SYMBOL_GPL(kho_restore_folio);
_

Patches currently in -mm which might be from ptyadav@amazon.de are

kho-initialize-tail-pages-for-higher-order-folios-properly.patch

