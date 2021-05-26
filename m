Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CAFDC47088
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:48:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4032A613D2
	for <mm-commits@archiver.kernel.org>; Wed, 26 May 2021 22:48:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbhEZWuW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 26 May 2021 18:50:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:56964 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229799AbhEZWuW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 26 May 2021 18:50:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D134D61073;
        Wed, 26 May 2021 22:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622069329;
        bh=feMvWw44KVXFfPlFJcCQFuf4PwY5nW7oEyLsZzv+8RI=;
        h=Date:From:To:Subject:From;
        b=KpzjRcNaw3stUT+FDZmwLqFxnu367RBdob63gHHHQi29hnKi3H/mLU/aPtnTuQtRZ
         qc14wTNSGIKejimtTZIE7pC0NOHkrduZe+roc/9yHDHQSWF0QMMO9su7jBhOElqx40
         Mglk61r3iifv3w3WpL/u6gTViTJSFZI+uJauduHM=
Date:   Wed, 26 May 2021 15:48:48 -0700
From:   akpm@linux-foundation.org
To:     adobriyan@gmail.com, alex.shi@linux.alibaba.com, david@redhat.com,
        guro@fb.com, haiyangz@microsoft.com, jasowang@redhat.com,
        jbohac@suse.cz, kys@microsoft.com, mhocko@suse.com,
        mike.kravetz@oracle.com, mm-commits@vger.kernel.org,
        mst@redhat.com, naoya.horiguchi@nec.com, osalvador@suse.de,
        rppt@linux.ibm.com, steven.price@arm.com, sthemmin@microsoft.com,
        wei.liu@kernel.org, willy@infradead.org, yaoaili@kingsoft.com
Subject:  [to-be-updated]
 =?US-ASCII?Q?fs-proc-kcore-dont-read-offline-sections-logically-offline-?=
 =?US-ASCII?Q?pages-and-hwpoisoned-pages.patch?= removed from -mm tree
Message-ID: <20210526224848.yG-t0RjMu%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages
has been removed from the -mm tree.  Its filename was
     fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: David Hildenbrand <david@redhat.com>
Subject: fs/proc/kcore: don't read offline sections, logically offline pages and hwpoisoned pages

Let's avoid reading:

1) Offline memory sections: the content of offline memory sections is
   stale as the memory is effectively unused by the kernel.  On s390x with
   standby memory, offline memory sections (belonging to offline storage
   increments) are not accessible.  With virtio-mem and the hyper-v
   balloon, we can have unavailable memory chunks that should not be
   accessed inside offline memory sections.  Last but not least, offline
   memory sections might contain hwpoisoned pages which we can no longer
   identify because the memmap is stale.

2) PG_offline pages: logically offline pages that are documented as
   "The content of these pages is effectively stale.  Such pages should
   not be touched (read/write/dump/save) except by their owner.". 
   Examples include pages inflated in a balloon or unavailble memory
   ranges inside hotplugged memory sections with virtio-mem or the hyper-v
   balloon.

3) PG_hwpoison pages: Reading pages marked as hwpoisoned can be fatal. 
   As documented: "Accessing is not safe since it may cause another
   machine check.  Don't touch!"

Introduce is_page_hwpoison(), adding a comment that it is inherently racy
but best we can really do.

Reading /proc/kcore now performs similar checks as when reading
/proc/vmcore for kdump via makedumpfile: problematic pages are exclude. 
It's also similar to hibernation code, however, we don't skip hwpoisoned
pages when processing pages in kernel/power/snapshot.c:saveable_page()
yet.

Note 1: we can race against memory offlining code, especially memory going
offline and getting unplugged: however, we will properly tear down the
identity mapping and handle faults gracefully when accessing this memory
from kcore code.

Note 2: we can race against drivers setting PageOffline() and turning
memory inaccessible in the hypervisor.  We'll handle this in a follow-up
patch.

Link: https://lkml.kernel.org/r/20210514172247.176750-4-david@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Oscar Salvador <osalvador@suse.de>
Cc: Aili Yao <yaoaili@kingsoft.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Jiri Bohac <jbohac@suse.cz>
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Stephen Hemminger <sthemmin@microsoft.com>
Cc: Steven Price <steven.price@arm.com>
Cc: Wei Liu <wei.liu@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/kcore.c            |   14 +++++++++++++-
 include/linux/page-flags.h |   12 ++++++++++++
 2 files changed, 25 insertions(+), 1 deletion(-)

--- a/fs/proc/kcore.c~fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages
+++ a/fs/proc/kcore.c
@@ -465,6 +465,9 @@ read_kcore(struct file *file, char __use
 
 	m = NULL;
 	while (buflen) {
+		struct page *page;
+		unsigned long pfn;
+
 		/*
 		 * If this is the first iteration or the address is not within
 		 * the previous entry, search for a matching entry.
@@ -503,7 +506,16 @@ read_kcore(struct file *file, char __use
 			}
 			break;
 		case KCORE_RAM:
-			if (!pfn_is_ram(__pa(start) >> PAGE_SHIFT)) {
+			pfn = __pa(start) >> PAGE_SHIFT;
+			page = pfn_to_online_page(pfn);
+
+			/*
+			 * Don't read offline sections, logically offline pages
+			 * (e.g., inflated in a balloon), hwpoisoned pages,
+			 * and explicitly excluded physical ranges.
+			 */
+			if (!page || PageOffline(page) ||
+			    is_page_hwpoison(page) || !pfn_is_ram(pfn)) {
 				if (clear_user(buffer, tsz)) {
 					ret = -EFAULT;
 					goto out;
--- a/include/linux/page-flags.h~fs-proc-kcore-dont-read-offline-sections-logically-offline-pages-and-hwpoisoned-pages
+++ a/include/linux/page-flags.h
@@ -695,6 +695,18 @@ PAGEFLAG_FALSE(DoubleMap)
 #endif
 
 /*
+ * Check if a page is currently marked HWPoisoned. Note that this check is
+ * best effort only and inherently racy: there is no way to synchronize with
+ * failing hardware.
+ */
+static inline bool is_page_hwpoison(struct page *page)
+{
+	if (PageHWPoison(page))
+		return true;
+	return PageHuge(page) && PageHWPoison(compound_head(page));
+}
+
+/*
  * For pages that are never mapped to userspace (and aren't PageSlab),
  * page_type may be used.  Because it is initialised to -1, we invert the
  * sense of the bit, so __SetPageFoo *clears* the bit used for PageFoo, and
_

Patches currently in -mm which might be from david@redhat.com are

perf-map_executable-does-not-indicate-vm_mayexec.patch
binfmt-remove-in-tree-usage-of-map_executable.patch
mm-ignore-map_executable-in-ksys_mmap_pgoff.patch
mm-make-variable-names-for-populate_vma_page_range-consistent.patch
mm-madvise-introduce-madv_populate_readwrite-to-prefault-page-tables.patch
maintainers-add-tools-testing-selftests-vm-to-memory-management.patch
selftests-vm-add-protection_keys_32-protection_keys_64-to-gitignore.patch
selftests-vm-add-test-for-madv_populate_readwrite.patch
memory-hotplugrst-complete-admin-guide-overhaul.patch
mm-introduce-page_offline_beginendfreezethaw-to-synchronize-setting-pageoffline.patch
virtio-mem-use-page_offline_startend-when-setting-pageoffline.patch
fs-proc-kcore-use-page_offline_freezethaw.patch

