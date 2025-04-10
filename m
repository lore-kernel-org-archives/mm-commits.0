Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FD331DED40
	for <mm-commits@vger.kernel.org>; Thu, 10 Apr 2025 23:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744328886; cv=none; b=A8ijMC/w4WfFvqdIS43ApzGeDU/tKd3Cv279ssnZuYn5DJH3UiXFuoiqgYd2XoExdLeSpDhObQ8+0BIoB/hJb2dv/QyFSAIR24hJ0FZDo7RT63W1M6CVQXGUmkjA5TXocuNfLK24tWTa5ih1jYXT9+TfLSXSV+rxEyjU78cmM0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744328886; c=relaxed/simple;
	bh=9eOcidSqDICaWg1ZIZ/iS9qJ1O61NM7LkaCcNA0w6Qw=;
	h=Date:To:From:Subject:Message-Id; b=tL3+xfy4HOgfZjewtT46i1IC3HiZ1RC8Ow3HeBnwubF4PpPBItxnYQ3a6easY8K+Sr2/3pyuebQWD+A1oLoWQwKGuFIERbklUTRbigYNx1AqZ0nBZqiUCRpzUzID4WePGxadwGPzkkcPHGovkbcmZrowd9lqNd5VRJ/UD/UgM6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=xBK4/Aj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="xBK4/Aj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC69C4CEDD;
	Thu, 10 Apr 2025 23:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1744328885;
	bh=9eOcidSqDICaWg1ZIZ/iS9qJ1O61NM7LkaCcNA0w6Qw=;
	h=Date:To:From:Subject:From;
	b=xBK4/Aj3yKxrgnDHXo9Hz6M7fHy7WdPMzxzxXEJk7gMq9vF7nSCO5QQoWQpdsUDZW
	 b5bvgUG3f4+bNJJeBH9oxxX+FvqncRcU0GiYZnBg1RP1BsZ9afg+dKDZc3fK78q6mp
	 U5a4EEVD99Jun+WsWUYXmKGOl2hdVzSxVW6JqpEs=
Date: Thu, 10 Apr 2025 16:48:05 -0700
To: mm-commits@vger.kernel.org,willy@infradead.org,viro@zeniv.linux.org.uk,jack@suse.cz,hch@infradead.org,dan.j.williams@intel.com,brauner@kernel.org,apopple@nvidia.com,alison.schofield@intel.com,david@redhat.com,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch added to mm-hotfixes-unstable branch
Message-Id: <20250410234805.BFC69C4CEDD@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: fs/dax: fix folio splitting issue by resetting old folio order + _nr_pages
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: fs/dax: fix folio splitting issue by resetting old folio order + _nr_pages
Date: Thu, 10 Apr 2025 11:10:20 +0200

Alison reports an issue with fsdax when large extends end up using large
ZONE_DEVICE folios:

[  417.796271] BUG: kernel NULL pointer dereference, address: 0000000000000b00
[  417.796982] #PF: supervisor read access in kernel mode
[  417.797540] #PF: error_code(0x0000) - not-present page
[  417.798123] PGD 2a5c5067 P4D 2a5c5067 PUD 2a5c6067 PMD 0
[  417.798690] Oops: Oops: 0000 [#1] SMP NOPTI
[  417.799178] CPU: 5 UID: 0 PID: 1515 Comm: mmap Tainted: ...
[  417.800150] Tainted: [O]=OOT_MODULE
[  417.800583] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 0.0.0 02/06/2015
[  417.801358] RIP: 0010:__lruvec_stat_mod_folio+0x7e/0x250
[  417.801948] Code: ...
[  417.803662] RSP: 0000:ffffc90002be3a08 EFLAGS: 00010206
[  417.804234] RAX: 0000000000000000 RBX: 0000000000000200 RCX: 0000000000000002
[  417.804984] RDX: ffffffff815652d7 RSI: 0000000000000000 RDI: ffffffff82a2beae
[  417.805689] RBP: ffffc90002be3a28 R08: 0000000000000000 R09: 0000000000000000
[  417.806384] R10: ffffea0007000040 R11: ffff888376ffe000 R12: 0000000000000001
[  417.807099] R13: 0000000000000012 R14: ffff88807fe4ab40 R15: ffff888029210580
[  417.807801] FS:  00007f339fa7a740(0000) GS:ffff8881fa9b9000(0000) knlGS:0000000000000000
[  417.808570] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  417.809193] CR2: 0000000000000b00 CR3: 000000002a4f0004 CR4: 0000000000370ef0
[  417.809925] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  417.810622] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  417.811353] Call Trace:
[  417.811709]  <TASK>
[  417.812038]  folio_add_file_rmap_ptes+0x143/0x230
[  417.812566]  insert_page_into_pte_locked+0x1ee/0x3c0
[  417.813132]  insert_page+0x78/0xf0
[  417.813558]  vmf_insert_page_mkwrite+0x55/0xa0
[  417.814088]  dax_fault_iter+0x484/0x7b0
[  417.814542]  dax_iomap_pte_fault+0x1ca/0x620
[  417.815055]  dax_iomap_fault+0x39/0x40
[  417.815499]  __xfs_write_fault+0x139/0x380
[  417.815995]  ? __handle_mm_fault+0x5e5/0x1a60
[  417.816483]  xfs_write_fault+0x41/0x50
[  417.816966]  xfs_filemap_fault+0x3b/0xe0
[  417.817424]  __do_fault+0x31/0x180
[  417.817859]  __handle_mm_fault+0xee1/0x1a60
[  417.818325]  ? debug_smp_processor_id+0x17/0x20
[  417.818844]  handle_mm_fault+0xe1/0x2b0
[...]

The issue is that when we split a large ZONE_DEVICE folio to order-0 ones,
we don't reset the order/_nr_pages.  As folio->_nr_pages overlays
page[1]->memcg_data, once page[1] is a folio, it suddenly looks like it
has folio->memcg_data set.  And we never manually initialize
folio->memcg_data in fsdax code, because we never expect it to be set at
all.

When __lruvec_stat_mod_folio() then stumbles over such a folio, it tries
to use folio->memcg_data (because it's non-NULL) but it does not actually
point at a memcg, resulting in the problem.

Alison also observed that these folios sometimes have "locked" set, which
is rather concerning (folios locked from the beginning ...).  The reason
is that the order for large folios is stored in page[1]->flags, which
become the folio->flags of a new small folio.

Let's fix it by adding a folio helper to clear order/_nr_pages for
splitting purposes.

Maybe we should reinitialize other large folio flags / folio members as
well when splitting, because they might similarly cause harm once page[1]
becomes a folio?  At least other flags in PAGE_FLAGS_SECOND should not be
set for fsdax, so at least page[1]->flags might be as expected with this
fix.

From a quick glimpse, initializing ->mapping, ->pgmap and ->share should
re-initialize most things from a previous page[1] used by large folios
that fsdax cares about.  For example folio->private might not get
reinitialized, but maybe that's not relevant -- no traces of it's use in
fsdax code.  Needs a closer look.

Another thing that should be considered in the future is performing
similar checks as we perform in free_tail_page_prepare()
-- checking pincount etc.
-- when freeing a large fsdax folio.

Link: https://lkml.kernel.org/r/20250410091020.119116-1-david@redhat.com
Fixes: 4996fc547f5b ("mm: let _folio_nr_pages overlay memcg_data in first tail page")
Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: Alison Schofield <alison.schofield@intel.com>
Closes: https://lkml.kernel.org/r/Z_W9Oeg-D9FhImf3@aschofie-mobl2.lan
Tested-by: Alison Schofield <alison.schofield@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dax.c           |    1 +
 include/linux/mm.h |   17 +++++++++++++++++
 2 files changed, 18 insertions(+)

--- a/fs/dax.c~fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages
+++ a/fs/dax.c
@@ -396,6 +396,7 @@ static inline unsigned long dax_folio_pu
 	order = folio_order(folio);
 	if (!order)
 		return 0;
+	folio_reset_order(folio);
 
 	for (i = 0; i < (1UL << order); i++) {
 		struct dev_pagemap *pgmap = page_pgmap(&folio->page);
--- a/include/linux/mm.h~fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages
+++ a/include/linux/mm.h
@@ -1218,6 +1218,23 @@ static inline unsigned int folio_order(c
 	return folio_large_order(folio);
 }
 
+/**
+ * folio_reset_order - Reset the folio order and derived _nr_pages
+ * @folio: The folio.
+ *
+ * Reset the order and derived _nr_pages to 0. Must only be used in the
+ * process of splitting large folios.
+ */
+static inline void folio_reset_order(struct folio *folio)
+{
+	if (WARN_ON_ONCE(!folio_test_large(folio)))
+		return;
+	folio->_flags_1 &= ~0xffUL;
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+	folio->_nr_pages = 0;
+#endif
+}
+
 #include <linux/huge_mm.h>
 
 /*
_

Patches currently in -mm which might be from david@redhat.com are

x86-mm-pat-untrack_pfn_copy-fix-doc-improvements.patch
fs-dax-fix-folio-splitting-issue-by-resetting-old-folio-order-_nr_pages.patch
kernel-events-uprobes-pass-vma-instead-of-mm-to-remove_breakpoint.patch
kernel-events-uprobes-pass-vma-to-set_swbp-set_orig_insn-and-uprobe_write_opcode.patch
kernel-events-uprobes-uprobe_write_opcode-rewrite.patch

