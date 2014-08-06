From: akpm@linux-foundation.org
Subject: [folded-merged]
 mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch removed from -mm
 tree
Date: Wed, 06 Aug 2014 15:47:48 -0700
Message-ID: <53e2b094.r7v4QLENsjJLnezx%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f73.google.com ([209.85.216.73]:55897 "EHLO
	mail-qa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaHFWrt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Aug 2014 18:47:49 -0400
Received: by mail-qa0-f73.google.com with SMTP id s7so439672qap.0
        for <mm-commits@vger.kernel.org>; Wed, 06 Aug 2014 15:47:49 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, kirill.shutemov@linux.intel.com, lcapitulino@redhat.com, n-horiguchi@ah.jp.nec.com, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-hugetlb-generalize-writes-to-nr_hugepages-fix
has been removed from the -mm tree.  Its filename was
     mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch

This patch was dropped because it was folded into mm-hugetlb-generalize-writes-to-nr_hugepages.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-hugetlb-generalize-writes-to-nr_hugepages-fix

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Luiz Capitulino <lcapitulino@redhat.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/hugetlb.c |    3 +++
 1 file changed, 3 insertions(+)

diff -puN mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages-fix mm/hugetlb.c
--- a/mm/hugetlb.c~mm-hugetlb-generalize-writes-to-nr_hugepages-fix
+++ a/mm/hugetlb.c
@@ -2260,6 +2260,9 @@ static int hugetlb_sysctl_handler_common
 	unsigned long tmp = h->max_huge_pages;
 	int ret;
 
+	if (!hugepages_supported())
+		return -ENOTSUPP;
+
 	table->data = &tmp;
 	table->maxlen = sizeof(unsigned long);
 	ret = proc_doulongvec_minmax(table, write, buffer, length, ppos);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
fsnotify-rename-event-handling-functions.patch
kbuild-explain-stack-protector-strong-config-logic.patch
slub-use-new-node-functions.patch
slab-use-get_node-and-kmem_cache_node-functions.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow.patch
mm-hugetlb-generalize-writes-to-nr_hugepages.patch
mm-oom-ensure-memoryless-node-zonelist-always-includes-zones-fix.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch

