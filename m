From: akpm@linux-foundation.org
Subject: - introduce-generic-iommu_num_pages-function.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:12:51 -0700
Message-ID: <200810182312.m9INCppX028065@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36464 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751322AbYJRXNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:13:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joerg.roedel@amd.com, airlied@linux.ie, benh@kernel.crashing.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mingo@elte.hu, muli@il.ibm.com, paulus@


The patch titled
     introduce generic iommu_num_pages function
has been removed from the -mm tree.  Its filename was
     introduce-generic-iommu_num_pages-function.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: introduce generic iommu_num_pages function
From: Joerg Roedel <joerg.roedel@amd.com>

This patch introduces the generic iommu_num_pages function. It can be used by
a given memory area.

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Muli Ben-Yehuda <muli@il.ibm.com>
Cc: Dave Airlie <airlied@linux.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/iommu-helper.h |    3 +++
 lib/iommu-helper.c           |    9 +++++++++
 2 files changed, 12 insertions(+)

diff -puN include/linux/iommu-helper.h~introduce-generic-iommu_num_pages-function include/linux/iommu-helper.h
--- a/include/linux/iommu-helper.h~introduce-generic-iommu_num_pages-function
+++ a/include/linux/iommu-helper.h
@@ -23,4 +23,7 @@ extern unsigned long iommu_area_alloc(un
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
 
+extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
+				     unsigned long io_page_size);
+
 #endif
diff -puN lib/iommu-helper.c~introduce-generic-iommu_num_pages-function lib/iommu-helper.c
--- a/lib/iommu-helper.c~introduce-generic-iommu_num_pages-function
+++ a/lib/iommu-helper.c
@@ -79,3 +79,12 @@ void iommu_area_free(unsigned long *map,
 	}
 }
 EXPORT_SYMBOL(iommu_area_free);
+
+unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
+			      unsigned long io_page_size)
+{
+	unsigned long size = (addr & (io_page_size - 1)) + len;
+
+	return DIV_ROUND_UP(size, io_page_size);
+}
+EXPORT_SYMBOL(iommu_num_pages);
_

Patches currently in -mm which might be from joerg.roedel@amd.com are

origin.patch

