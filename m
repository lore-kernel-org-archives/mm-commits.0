Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B0D2C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 220B661415
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:42:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbhEHWnE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:43:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229552AbhEHWnE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:43:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7735461402;
        Sat,  8 May 2021 22:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620513721;
        bh=UoQwhnAfCsjnr0fBRnILXDs6dveVAiEod5HdFT8jqaU=;
        h=Date:From:To:Subject:From;
        b=hTju6vMXpembC9JOWang4goywtpiQAELa7jgb5AImGMRcLS+DPa0ZNzdxMpVQllVf
         KW6SYbgmIksOv6LRhsFLm44uSsT8ert0oIGgPQocp142JpOGiIjJEX8Pi3TQHedwgI
         OqFC5Pp0+NM7aHbGCC3qR3CQIKNH58NnHTOQS2eM=
Date:   Sat, 08 May 2021 15:42:01 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, hch@lst.de,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com
Subject:  [merged] mm-add-a-io_mapping_map_user-helper.patch
 removed from -mm tree
Message-ID: <20210508224201.Fma6sCd40%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a io_mapping_map_user helper
has been removed from the -mm tree.  Its filename was
     mm-add-a-io_mapping_map_user-helper.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: add a io_mapping_map_user helper

Add a helper that calls remap_pfn_range for an struct io_mapping, relying
on the pgprot pre-validation done when creating the mapping instead of
doing it at runtime.

Link: https://lkml.kernel.org/r/20210326055505.1424432-3-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/io-mapping.h |    3 +++
 mm/Kconfig                 |    3 +++
 mm/Makefile                |    1 +
 mm/io-mapping.c            |   29 +++++++++++++++++++++++++++++
 4 files changed, 36 insertions(+)

--- a/include/linux/io-mapping.h~mm-add-a-io_mapping_map_user-helper
+++ a/include/linux/io-mapping.h
@@ -220,3 +220,6 @@ io_mapping_free(struct io_mapping *iomap
 }
 
 #endif /* _LINUX_IO_MAPPING_H */
+
+int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size);
--- /dev/null
+++ a/mm/io-mapping.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0-only
+
+#include <linux/mm.h>
+#include <linux/io-mapping.h>
+
+/**
+ * io_mapping_map_user - remap an I/O mapping to userspace
+ * @iomap: the source io_mapping
+ * @vma: user vma to map to
+ * @addr: target user address to start at
+ * @pfn: physical address of kernel memory
+ * @size: size of map area
+ *
+ *  Note: this is only safe if the mm semaphore is held when called.
+ */
+int io_mapping_map_user(struct io_mapping *iomap, struct vm_area_struct *vma,
+		unsigned long addr, unsigned long pfn, unsigned long size)
+{
+	vm_flags_t expected_flags = VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP;
+
+	if (WARN_ON_ONCE((vma->vm_flags & expected_flags) != expected_flags))
+		return -EINVAL;
+
+	/* We rely on prevalidation of the io-mapping to skip track_pfn(). */
+	return remap_pfn_range_notrack(vma, addr, pfn, size,
+		__pgprot((pgprot_val(iomap->prot) & _PAGE_CACHE_MASK) |
+			 (pgprot_val(vma->vm_page_prot) & ~_PAGE_CACHE_MASK)));
+}
+EXPORT_SYMBOL_GPL(io_mapping_map_user);
--- a/mm/Kconfig~mm-add-a-io_mapping_map_user-helper
+++ a/mm/Kconfig
@@ -871,4 +871,7 @@ config MAPPING_DIRTY_HELPERS
 config KMAP_LOCAL
 	bool
 
+# struct io_mapping based helper.  Selected by drivers that need them
+config IO_MAPPING
+	bool
 endmenu
--- a/mm/Makefile~mm-add-a-io_mapping_map_user-helper
+++ a/mm/Makefile
@@ -120,3 +120,4 @@ obj-$(CONFIG_MEMFD_CREATE) += memfd.o
 obj-$(CONFIG_MAPPING_DIRTY_HELPERS) += mapping_dirty_helpers.o
 obj-$(CONFIG_PTDUMP_CORE) += ptdump.o
 obj-$(CONFIG_PAGE_REPORTING) += page_reporting.o
+obj-$(CONFIG_IO_MAPPING) += io-mapping.o
_

Patches currently in -mm which might be from hch@lst.de are


