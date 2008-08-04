From: akpm@linux-foundation.org
Subject: + introduce-generic-iommu_num_pages-function.patch added to -mm tree
Date: Mon, 04 Aug 2008 14:22:06 -0700
Message-ID: <200808042122.m74LM68x031525@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758175AbYHDVXO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Aug 2008 17:23:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: joerg.roedel@amd.com, airlied@linux.ie, benh@kernel.crashing.org, davem@davemloft.net, fujita.tomonori@lab.ntt.co.jp, ink@jurassic.park.msu.ru, mingo@elte.hu, muli@il.ibm.com, paulus@samba.org, rth@twiddle.net, tglx@linutronix.de


The patch titled
     introduce generic iommu_num_pages function
has been added to the -mm tree.  Its filename is
     introduce-generic-iommu_num_pages-function.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

 include/linux/iommu-helper.h |    2 ++
 lib/iommu-helper.c           |    9 +++++++++
 2 files changed, 11 insertions(+)

diff -puN include/linux/iommu-helper.h~introduce-generic-iommu_num_pages-function include/linux/iommu-helper.h
--- a/include/linux/iommu-helper.h~introduce-generic-iommu_num_pages-function
+++ a/include/linux/iommu-helper.h
@@ -8,3 +8,5 @@ extern unsigned long iommu_area_alloc(un
 				      unsigned long align_mask);
 extern void iommu_area_free(unsigned long *map, unsigned long start,
 			    unsigned int nr);
+extern unsigned long iommu_num_pages(unsigned long addr, unsigned long len,
+				     unsigned long io_page_size);
diff -puN lib/iommu-helper.c~introduce-generic-iommu_num_pages-function lib/iommu-helper.c
--- a/lib/iommu-helper.c~introduce-generic-iommu_num_pages-function
+++ a/lib/iommu-helper.c
@@ -80,3 +80,12 @@ void iommu_area_free(unsigned long *map,
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
linux-next.patch
x86-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
sparc64-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
powerpc-rename-iommu_num_pages-function-to-iommu_nr_pages.patch
introduce-generic-iommu_num_pages-function.patch
x86-convert-gart-driver-to-generic-iommu_num_pages-function.patch
x86-amd-iommu-convert-driver-to-generic-iommu_num_pages-function.patch
x86-convert-calgary-iommu-driver-to-generic-iommu_num_pages-function.patch
powerpc-use-iommu_num_pages-function-in-iommu-code.patch
alpha-use-iommu_num_pages-function-in-iommu-code.patch
sparc64-use-iommu_num_pages-function-in-iommu-code.patch

