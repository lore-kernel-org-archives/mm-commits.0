From: akpm@linux-foundation.org
Subject: + cma-use-unsigned-type-for-count-argument-fix.patch added to -mm tree
Date: Thu, 20 Dec 2012 15:37:07 -0800
Message-ID: <20121220233708.1A1B882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:52870 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352Ab2LTXhJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 20 Dec 2012 18:37:09 -0500
Received: by mail-vc0-f201.google.com with SMTP id p1so426158vcq.0
        for <mm-commits@vger.kernel.org>; Thu, 20 Dec 2012 15:37:08 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, mina86@mina86.com, rientjes@google.com, rmk@arm.linux.org.uk


The patch titled
     Subject: cma-use-unsigned-type-for-count-argument-fix
has been added to the -mm tree.  Its filename is
     cma-use-unsigned-type-for-count-argument-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: cma-use-unsigned-type-for-count-argument-fix

rename `i' to `idx', small cleanups

Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Russell King <rmk@arm.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arm/mm/dma-mapping.c |   43 ++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff -puN arch/arm/mm/dma-mapping.c~cma-use-unsigned-type-for-count-argument-fix arch/arm/mm/dma-mapping.c
--- a/arch/arm/mm/dma-mapping.c~cma-use-unsigned-type-for-count-argument-fix
+++ a/arch/arm/mm/dma-mapping.c
@@ -1040,7 +1040,7 @@ static struct page **__iommu_alloc_buffe
 	struct page **pages;
 	unsigned int count = size >> PAGE_SHIFT;
 	unsigned int array_size = count * sizeof(struct page *);
-	unsigned int i = 0;
+	unsigned int idx = 0;
 
 	if (array_size <= PAGE_SIZE)
 		pages = kzalloc(array_size, gfp);
@@ -1049,8 +1049,7 @@ static struct page **__iommu_alloc_buffe
 	if (!pages)
 		return NULL;
 
-	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs))
-	{
+	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
 		unsigned long order = get_order(size);
 		struct page *page;
 
@@ -1060,38 +1059,39 @@ static struct page **__iommu_alloc_buffe
 
 		__dma_clear_buffer(page, size);
 
-		for (i = 0; i < count; i++)
-			pages[i] = page + i;
+		for (idx = 0; idx < count; idx++)
+			pages[i] = page + idx;
 
 		return pages;
 	}
 
 	while (count) {
-		int j, order = __fls(count);
+		unsigned int j;
+		unnsigned int order = __fls(count);
 
-		pages[i] = alloc_pages(gfp | __GFP_NOWARN, order);
-		while (!pages[i] && order)
-			pages[i] = alloc_pages(gfp | __GFP_NOWARN, --order);
-		if (!pages[i])
+		pages[idx] = alloc_pages(gfp | __GFP_NOWARN, order);
+		while (!pages[idx] && order)
+			pages[idx] = alloc_pages(gfp | __GFP_NOWARN, --order);
+		if (!pages[idx])
 			goto error;
 
 		if (order) {
-			split_page(pages[i], order);
+			split_page(pages[idx], order);
 			j = 1 << order;
 			while (--j)
-				pages[i + j] = pages[i] + j;
+				pages[idx + j] = pages[idx] + j;
 		}
 
-		__dma_clear_buffer(pages[i], PAGE_SIZE << order);
-		i += 1 << order;
+		__dma_clear_buffer(pages[idx], PAGE_SIZE << order);
+		idx += 1 << order;
 		count -= 1 << order;
 	}
 
 	return pages;
 error:
-	while (i--)
-		if (pages[i])
-			__free_pages(pages[i], 0);
+	while (idx--)
+		if (pages[idx])
+			__free_pages(pages[idx], 0);
 	if (array_size <= PAGE_SIZE)
 		kfree(pages);
 	else
@@ -1104,14 +1104,15 @@ static int __iommu_free_buffer(struct de
 {
 	unsigned int count = size >> PAGE_SHIFT;
 	unsigned int array_size = count * sizeof(struct page *);
-	unsigned int i;
 
 	if (dma_get_attr(DMA_ATTR_FORCE_CONTIGUOUS, attrs)) {
 		dma_release_from_contiguous(dev, pages[0], count);
 	} else {
-		for (i = 0; i < count; i++)
-			if (pages[i])
-				__free_pages(pages[i], 0);
+		unsigned int idx;
+
+		for (idx = 0; idx < count; idx++)
+			if (pages[idx])
+				__free_pages(pages[idx], 0);
 	}
 
 	if (array_size <= PAGE_SIZE)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
compaction-fix-build-error-in-cma-compaction.patch
drivers-firmware-dmi_scanc-check-dmi-version-when-get-system-uuid.patch
drivers-firmware-dmi_scanc-fetch-dmi-version-from-smbios-if-it-exists.patch
hfsplus-rework-processing-of-hfs_btree_write-returned-error.patch
revert-rtc-recycle-id-when-unloading-a-rtc-driver.patch
sgi-xp-handle-non-fatal-traps.patch
sendfile-allows-bypassing-of-notifier-events.patch
linux-next.patch
linux-next-git-rejects.patch
make-my-i386-build-work.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
arch-x86-tools-insn_sanityc-identify-source-of-messages.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix.patch
fb-rework-locking-to-fix-lock-ordering-on-takeover-fix-2.patch
mm.patch
mm-memcontrolc-convert-printkkern_foo-to-pr_foo.patch
mm-hugetlbc-convert-to-pr_foo.patch
cma-make-putback_lru_pages-call-conditional-fix.patch
mm-vmscan-clean-up-get_scan_count-fix.patch
mm-vmscan-compaction-works-against-zones-not-lruvecs-fix.patch
mm-page_allocc-__setup_per_zone_wmarks-make-min_pages-unsigned-long.patch
mm-vmscanc-__zone_reclaim-replace-max_t-with-max.patch
cma-use-unsigned-type-for-count-argument-fix.patch
drop_caches-add-some-documentation-and-info-messsge.patch
memcg-debugging-facility-to-access-dangling-memcgs-fix.patch
scripts-pnmtologo-fix-for-plain-pbm-checkpatch-fixes.patch
backlight-add-lms501kf03-lcd-driver-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
rtc-ds1307-long-block-operations-bugfix-fix.patch
rtc-max77686-add-maxim-77686-driver-fix.patch
rtc-pcf8523-add-low-battery-voltage-support-fix.patch
hfsplus-add-osx-prefix-for-handling-namespace-of-mac-os-x-extended-attributes.patch
ipc-add-sysctl-to-specify-desired-next-object-id.patch
ipc-message-queue-receive-cleanup.patch
ipc-convert-prepare_copy-from-macro-to-function.patch
drivers-char-miscc-misc_register-do-not-loop-on-misc_list-unconditionally-fix.patch
dma-debug-new-interfaces-to-debug-dma-mapping-errors-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

