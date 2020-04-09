From: Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated]
 mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
 removed from -mm tree
Date: Wed, 08 Apr 2020 17:58:53 -0700
Message-ID: <20200409005853.He-5Nqhtg%akpm@linux-foundation.org>
References: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:44596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726549AbgDIA6x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 8 Apr 2020 20:58:53 -0400
In-Reply-To: <20200406200254.a69ebd9e08c4074e41ddebaf@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix

add newline and use __func__, per Joe

Cc: Joe Perches <joe@perches.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/hugetlb.c~mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix
+++ a/mm/hugetlb.c
@@ -5602,8 +5602,8 @@ void __init hugetlb_cma_reserve(int orde
 		if (res) {
 			phys_addr_t begpa = PFN_PHYS(min_pfn);
 			phys_addr_t endpa = PFN_PHYS(max_pfn);
-			pr_warn("hugetlb_cma: reservation failed: err %d, node %d, [%pap, %pap)",
-				res, nid, &begpa, &endpa);
+			pr_warn("%s: reservation failed: err %d, node %d, [%pap, %pap)\n",
+				__func__, res, nid, &begpa, &endpa);
 			break;
 		}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

drivers-tty-serial-sh-scic-suppress-uninitialized-var-warning.patch
mm.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
mm-clarify-__gfp_memalloc-usage-checkpatch-fixes.patch
linux-next-fix.patch
linux-next-git-rejects.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
