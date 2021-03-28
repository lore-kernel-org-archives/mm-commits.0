Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB98C433EB
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E969B619CF
	for <mm-commits@archiver.kernel.org>; Sun, 28 Mar 2021 19:12:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231511AbhC1TLq (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 28 Mar 2021 15:11:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231543AbhC1TLj (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sun, 28 Mar 2021 15:11:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 085476197E;
        Sun, 28 Mar 2021 19:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616958699;
        bh=Z+RfrSByiSX2um4VIAbIF3kI1JnDYecJX2SZQahNmKE=;
        h=Date:From:To:Subject:From;
        b=BOQKojdpFCIyAPSMBZn78rljX7YITI0X7suqfw1lv0H3JBq76hmhyo8mKznmUTA8i
         oMuzOCLzu4HYVfo64vO1lWxJIMYbB7zTtDecMfXNyWBigFSfZrwwaChs1Bv4QcFp1Q
         Yhk1X4YIW4lPCGNXjvRWg/J15AOMHbeHO0P0l4YQ=
Date:   Sun, 28 Mar 2021 12:11:37 -0700
From:   akpm@linux-foundation.org
To:     chris@chris-wilson.co.uk, daniel.vetter@ffwll.ch, hch@lst.de,
        jani.nikula@linux.intel.com, joonas.lahtinen@linux.intel.com,
        mm-commits@vger.kernel.org, peterz@infradead.org,
        rodrigo.vivi@intel.com
Subject:  + mm-add-a-io_mapping_map_user-helper.patch added to -mm
 tree
Message-ID: <20210328191137.CitFdqw92%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: add a io_mapping_map_user helper
has been added to the -mm tree.  Its filename is
     mm-add-a-io_mapping_map_user-helper.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-add-a-io_mapping_map_user-helper.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-add-a-io_mapping_map_user-helper.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -872,4 +872,7 @@ config MAPPING_DIRTY_HELPERS
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

mm-add-remap_pfn_range_notrack.patch
mm-add-a-io_mapping_map_user-helper.patch
i915-use-io_mapping_map_user.patch
i915-fix-remap_io_sg-to-verify-the-pgprot.patch
samples-vfio-mdev-mdpy-use-remap_vmalloc_range.patch
mm-unexport-remap_vmalloc_range_partial.patch

