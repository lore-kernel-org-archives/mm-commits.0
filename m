From: akpm@linux-foundation.org
Subject: [merged] kexec-update-vmcoreinfo-for-compound_order-dtor.patch
 removed from -mm tree
Date: Fri, 29 Apr 2016 15:05:09 -0700
Message-ID: <5723da95.ZpVxIhiIQUA3WA4y%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45378 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015AbcD2WFK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 29 Apr 2016 18:05:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ats-kumagai@wm.jp.nec.com, dyoung@redhat.com, ebiederm@xmission.com, vgoyal@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kexec: update VMCOREINFO for compound_order/dtor
has been removed from the -mm tree.  Its filename was
     kexec-update-vmcoreinfo-for-compound_order-dtor.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Subject: kexec: update VMCOREINFO for compound_order/dtor

makedumpfile refers page.lru.next to get the order of compound pages for
page filtering.  However, now the order is stored in page.compound_order,
hence VMCOREINFO should be updated to export the offset of
page.compound_order.

The fact is, page.compound_order was introduced already in kernel 4.0, but
the offset of it was the same as page.lru.next until kernel 4.3, so this
was not actual problem.

The above can be said also for page.lru.prev and page.compound_dtor, it's
necessary to detect hugetlbfs pages.  Further, the content was changed
from direct address to the ID which means dtor.

The problem is that unnecessary hugepages won't be removed from a dump
file in kernels 4.4.x and later.  This means that extra disk space would
be consumed.  It's a problem, but not critical.

Signed-off-by: Atsushi Kumagai <ats-kumagai@wm.jp.nec.com>
Acked-by: Dave Young <dyoung@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kexec_core.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff -puN kernel/kexec_core.c~kexec-update-vmcoreinfo-for-compound_order-dtor kernel/kexec_core.c
--- a/kernel/kexec_core.c~kexec-update-vmcoreinfo-for-compound_order-dtor
+++ a/kernel/kexec_core.c
@@ -1415,6 +1415,8 @@ static int __init crash_save_vmcoreinfo_
 	VMCOREINFO_OFFSET(page, lru);
 	VMCOREINFO_OFFSET(page, _mapcount);
 	VMCOREINFO_OFFSET(page, private);
+	VMCOREINFO_OFFSET(page, compound_dtor);
+	VMCOREINFO_OFFSET(page, compound_order);
 	VMCOREINFO_OFFSET(pglist_data, node_zones);
 	VMCOREINFO_OFFSET(pglist_data, nr_zones);
 #ifdef CONFIG_FLAT_NODE_MEM_MAP
@@ -1447,8 +1449,8 @@ static int __init crash_save_vmcoreinfo_
 #ifdef CONFIG_X86
 	VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
 #endif
-#ifdef CONFIG_HUGETLBFS
-	VMCOREINFO_SYMBOL(free_huge_page);
+#ifdef CONFIG_HUGETLB_PAGE
+	VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
 #endif
 
 	arch_crash_save_vmcoreinfo();
_

Patches currently in -mm which might be from ats-kumagai@wm.jp.nec.com are


