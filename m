From: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch 033/155] mm/filemap.c: use vm_fault error code
 directly
Date: Wed, 01 Apr 2020 21:04:53 -0700
Message-ID: <20200402040453.LLldD6IuA%akpm@linux-foundation.org>
References: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:51250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgDBEEz (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 2 Apr 2020 00:04:55 -0400
In-Reply-To: <20200401210155.09e3b9742e1c6e732f5a7250@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, hch@lst.de, kirill.shutemov@linux.intel.com, linux-mm@kvack.org, mm-commits@vger.kernel.org, pankaj.gupta.linux@gmail.com, torvalds@linux-foundation.org, willy@infradead.org

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
@@ -2490,7 +2490,7 @@ retry_find:
 		if (!page) {
 			if (fpin)
 				goto out_retry;
-			return vmf_error(-ENOMEM);
+			return VM_FAULT_OOM;
 		}
 	}
 
_
