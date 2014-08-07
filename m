From: akpm@linux-foundation.org
Subject: [merged] mm-slub-mark-resiliency_test-as-init-text.patch removed
 from -mm tree
Date: Thu, 07 Aug 2014 13:02:59 -0700
Message-ID: <53e3db73.hhTdHbslIYjsN2wr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qg0-f73.google.com ([209.85.192.73]:42395 "EHLO
	mail-qg0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755191AbaHGUDA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Aug 2014 16:03:00 -0400
Received: by mail-qg0-f73.google.com with SMTP id q107so610783qgd.2
        for <mm-commits@vger.kernel.org>; Thu, 07 Aug 2014 13:02:59 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rientjes@google.com, cl@linux.com, iamjoonsoo.kim@lge.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm, slub: mark resiliency_test as init text
has been removed from the -mm tree.  Its filename was
     mm-slub-mark-resiliency_test-as-init-text.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: David Rientjes <rientjes@google.com>
Subject: mm, slub: mark resiliency_test as init text

resiliency_test() is only called for bootstrap, so it may be moved to
init.text and freed after boot.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~mm-slub-mark-resiliency_test-as-init-text mm/slub.c
--- a/mm/slub.c~mm-slub-mark-resiliency_test-as-init-text
+++ a/mm/slub.c
@@ -4187,7 +4187,7 @@ static int list_locations(struct kmem_ca
 #endif
 
 #ifdef SLUB_RESILIENCY_TEST
-static void resiliency_test(void)
+static void __init resiliency_test(void)
 {
 	u8 *p;
 
_

Patches currently in -mm which might be from rientjes@google.com are

origin.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function.patch
x86-numa-setup_node_data-drop-dead-code-and-rename-function-v2.patch
mm-hugetlb-take-refcount-under-page-table-lock-in-follow_huge_pmd.patch
mm-hugetlb-use-get_page_unless_zero-in-hugetlb_fault.patch
mm-hugetlb-add-migration-entry-check-in-hugetlb_change_protection.patch
mm-hugetlb-remove-unused-argument-of-follow_huge_pmdpud.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
mm-utilc-add-kstrimdup.patch
fs-proc-kcorec-use-page_align-instead-of-alignpage_size.patch
fork-exec-cleanup-mm-initialization.patch
fork-reset-mm-pinned_vm.patch
fork-copy-mms-vm-usage-counters-under-mmap_sem.patch
linux-next.patch

