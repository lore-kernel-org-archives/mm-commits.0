From: akpm@linux-foundation.org
Subject: + mm-use-vm_fault-error-code-directly.patch added to -mm
 tree
Date: Mon, 23 Mar 2020 19:35:31 -0700
Message-ID: <20200324023531.NyucyM_L_%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:33390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbgCXCfe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 23 Mar 2020 22:35:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, willy@infradead.org


The patch titled
     Subject: mm/filemap.c: use vm_fault error code directly
has been added to the -mm tree.  Its filename is
     mm-use-vm_fault-error-code-directly.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-use-vm_fault-error-code-directly.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-use-vm_fault-error-code-directly.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: mm/filemap.c: use vm_fault error code directly

Use VM_FAULT_OOM instead of indirecting through vmf_error(-ENOMEM).

Link: http://lkml.kernel.org/r/20200318140253.6141-2-willy@infradead.org
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Cc: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/filemap.c~mm-use-vm_fault-error-code-directly
+++ a/mm/filemap.c
@@ -2502,7 +2502,7 @@ retry_find:
 		if (!page) {
 			if (fpin)
 				goto out_retry;
-			return vmf_error(-ENOMEM);
+			return VM_FAULT_OOM;
 		}
 	}
 
_

Patches currently in -mm which might be from willy@infradead.org are

mm-improve-dump_page-for-compound-pages.patch
mm-add-pagemaph-to-the-fine-documentation.patch
mm-use-vm_fault-error-code-directly.patch
mm-rename-arguments-to-find_subpage.patch
mm-check-pagetail-in-hpage_nr_pages-even-when-thp.patch
mm-optimise-find_subpage-for-thp.patch
mm-remove-config_transparent_huge_pagecache.patch
mm-use-vm_bug_on_page-in-clear_page_dirty_for_io.patch
mm-unexport-find_get_entry.patch
mm-rewrite-pagecache_get_page-documentation.patch
proc-inline-vma_stop-into-m_stop.patch
proc-remove-m_cache_vma.patch
proc-use-ppos-instead-of-m-version.patch
seq_file-remove-m-version.patch
proc-inline-m_next_vma-into-m_next.patch
