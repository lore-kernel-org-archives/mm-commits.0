From: akpm@linux-foundation.org
Subject: + mm-cleanup-ifdef-guards-for-vmem_altmap.patch added to -mm tree
Date: Wed, 13 Jul 2016 12:58:21 -0700
Message-ID: <57869d5d.NtLffHey9dkSG9qs%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbcGMT6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 13 Jul 2016 15:58:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dan.j.williams@intel.com, jmoyer@redhat.com, sandeen@redhat.com, vbabka@suse.cz, mm-commits@vger.kernel.org


The patch titled
     From: Dan Williams <dan.j.williams@intel.com>
has been added to the -mm tree.  Its filename is
     mm-cleanup-ifdef-guards-for-vmem_altmap.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cleanup-ifdef-guards-for-vmem_altmap.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cleanup-ifdef-guards-for-vmem_altmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dan Williams <dan.j.williams@intel.com>
Subject: mm: cleanup ifdef guards for vmem_altmap

Now that ZONE_DEVICE depends on SPARSEMEM_VMEMMAP we can simplify some
ifdef guards to just ZONE_DEVICE.

Link: http://lkml.kernel.org/r/146687646788.39261.8020536391978771940.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Reported-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Eric Sandeen <sandeen@redhat.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memremap.h |    2 +-
 kernel/memremap.c        |    8 --------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff -puN include/linux/memremap.h~mm-cleanup-ifdef-guards-for-vmem_altmap include/linux/memremap.h
--- a/include/linux/memremap.h~mm-cleanup-ifdef-guards-for-vmem_altmap
+++ a/include/linux/memremap.h
@@ -26,7 +26,7 @@ struct vmem_altmap {
 unsigned long vmem_altmap_offset(struct vmem_altmap *altmap);
 void vmem_altmap_free(struct vmem_altmap *altmap, unsigned long nr_pfns);
 
-#if defined(CONFIG_SPARSEMEM_VMEMMAP) && defined(CONFIG_ZONE_DEVICE)
+#ifdef CONFIG_ZONE_DEVICE
 struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start);
 #else
 static inline struct vmem_altmap *to_vmem_altmap(unsigned long memmap_start)
diff -puN kernel/memremap.c~mm-cleanup-ifdef-guards-for-vmem_altmap kernel/memremap.c
--- a/kernel/memremap.c~mm-cleanup-ifdef-guards-for-vmem_altmap
+++ a/kernel/memremap.c
@@ -308,12 +308,6 @@ void *devm_memremap_pages(struct device
 	if (is_ram == REGION_INTERSECTS)
 		return __va(res->start);
 
-	if (altmap && !IS_ENABLED(CONFIG_SPARSEMEM_VMEMMAP)) {
-		dev_err(dev, "%s: altmap requires CONFIG_SPARSEMEM_VMEMMAP=y\n",
-				__func__);
-		return ERR_PTR(-ENXIO);
-	}
