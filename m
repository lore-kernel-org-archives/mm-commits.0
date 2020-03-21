From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
 added to -mm tree
Date: Fri, 20 Mar 2020 19:42:16 -0700
Message-ID: <20200321024216.wqit5IY95%akpm@linux-foundation.org>
References: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgCUCmR (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 20 Mar 2020 22:42:17 -0400
In-Reply-To: <20200305222751.6d781a3f2802d79510941e4e@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mike.kravetz@oracle.com, mm-commits@vger.kernel.org, rdunlap@infradead.org


The patch titled
     Subject: mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix
has been added to the -mm tree.  Its filename is
     mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -5608,8 +5608,8 @@ void __init hugetlb_cma_reserve(int orde
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

memcg-fix-null-pointer-dereference-in-__mem_cgroup_usage_unregister_event-fix.patch
mm-hotplug-fix-hot-remove-failure-in-sparsememvmemmap-case-fix.patch
mm.patch
mm-gup-track-foll_pin-pages-fix-2-fix.patch
mm-swap-make-page_evictable-inline-fix.patch
memcg-optimize-memorynuma_stat-like-memorystat-fix.patch
selftest-add-mremap_dontunmap-selftest-fix.patch
selftest-add-mremap_dontunmap-selftest-v7-checkpatch-fixes.patch
hugetlb_cgroup-add-reservation-accounting-for-private-mappings-fix.patch
hugetlb_cgroup-add-accounting-for-shared-mappings-fix.patch
mm-hugetlbc-fix-printk-format-warning-for-32-bit-phys_addr_t-fix.patch
mm-migratec-migrate-pg_readahead-flag-fix.patch
hv_balloon-dont-check-for-memhp_auto_online-manually-fix.patch
proc-faster-open-read-close-with-permanent-files-checkpatch-fixes.patch
linux-next-rejects.patch
linux-next-fix.patch
mm-add-vm_insert_pages-fix.patch
net-zerocopy-use-vm_insert_pages-for-tcp-rcv-zerocopy-fix.patch
seq_read-info-message-about-buggy-next-functions-fix.patch
drivers-tty-serial-sh-scic-suppress-warning.patch
kernel-forkc-export-kernel_thread-to-modules.patch
