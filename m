Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED4DBC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 21 Apr 2022 18:42:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391497AbiDUSpk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:45:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391465AbiDUSpk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 21 Apr 2022 14:45:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A81F4BFE8
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 11:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 903A86165E
        for <mm-commits@vger.kernel.org>; Thu, 21 Apr 2022 18:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E95B5C385A1;
        Thu, 21 Apr 2022 18:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1650566568;
        bh=I55BdMJ2LCV4vAH+yttZkRgr0MlnMQJZziDyWrkK9Lc=;
        h=Date:To:From:Subject:From;
        b=MyIqceGX8lE4V2SGRKe+2tOuALHIjuVtatyrItR4z+DWPcxkVL+kuxbdkn0Z4iAGG
         entEyDXyuZn7hnIe+9a9wQxPk8uQ9M1+Iv8IXrW0MeJ/sw9aPa7hknvsGltncNthjv
         jCer8RqIdLbHVaP9gZxMv6bZbjr5ECwgWlOR+VxI=
Date:   Thu, 21 Apr 2022 11:42:47 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        tglx@linutronix.de, rppt@linux.ibm.com, peterz@infradead.org,
        ira.weiny@intel.com, corbet@lwn.net, fmdefrancesco@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch added to -mm tree
Message-Id: <20220421184247.E95B5C385A1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/highmem: fix kernel-doc warnings in highmem*.h
has been added to the -mm tree.  Its filename is
     mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: mm/highmem: fix kernel-doc warnings in highmem*.h

Patch series "Extend and reorganize Highmem's documentation".

This series has the purpose to extend and reorganize Highmem's
documentation.

This is still a work in progress, because some information should still be
moved from highmem.rst to highmem.h and highmem-internal.h.  Specifically
I'm talking about moving the "how to" information to the relevant headers,
as it as been suggested by Ira Weiny (Intel).


This patch (of 4):

`scripts/kernel-doc -v -none include/linux/highmem*` reports the following
warnings:

include/linux/highmem.h:160: warning: expecting prototype for kunmap_atomic(). Prototype was for nr_free_highpages() instead
include/linux/highmem.h:204: warning: No description found for return value of 'alloc_zeroed_user_highpage_movable'
include/linux/highmem-internal.h:256: warning: Function parameter or member '__addr' not described in 'kunmap_atomic'
include/linux/highmem-internal.h:256: warning: Excess function parameter 'addr' description in 'kunmap_atomic'

Fix these warnings by (1) moving the kernel-doc comments from highmem.h to
highmem-internal.h (which is the file were the kunmap_atomic() macro is
actually defined), (2) extending and merging it with the comment which was
already in highmem-internal.h, and (3) using correct parameter names.

Link: https://lkml.kernel.org/r/20220421180200.16901-1-fmdefrancesco@gmail.com
Link: https://lkml.kernel.org/r/20220421180200.16901-2-fmdefrancesco@gmail.com
Signed-off-by: Fabio M. De Francesco <fmdefrancesco@gmail.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: Mike Rapoport <rppt@linux.ibm.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/highmem-internal.h |   14 +++++++++++---
 include/linux/highmem.h          |   15 +++------------
 2 files changed, 14 insertions(+), 15 deletions(-)

--- a/include/linux/highmem.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem.h
@@ -37,7 +37,7 @@ static inline void *kmap(struct page *pa
 
 /**
  * kunmap - Unmap the virtual address mapped by kmap()
- * @addr:	Virtual address to be unmapped
+ * @page:	Virtual address to be unmapped
  *
  * Counterpart to kmap(). A NOOP for CONFIG_HIGHMEM=n and for mappings of
  * pages in the low memory area.
@@ -145,17 +145,6 @@ static inline void *kmap_local_folio(str
  */
 static inline void *kmap_atomic(struct page *page);
 
-/**
- * kunmap_atomic - Unmap the virtual address mapped by kmap_atomic()
- * @addr:	Virtual address to be unmapped
- *
- * Counterpart to kmap_atomic().
- *
- * Effectively a wrapper around kunmap_local() which additionally undoes
- * the side effects of kmap_atomic(), i.e. reenabling pagefaults and
- * preemption.
- */
-
 /* Highmem related interfaces for management code */
 static inline unsigned int nr_free_highpages(void);
 static inline unsigned long totalhigh_pages(void);
@@ -191,6 +180,8 @@ static inline void clear_user_highpage(s
  * @vma: The VMA the page is to be allocated for
  * @vaddr: The virtual address the page will be inserted into
  *
+ * Returns: The allocated and zeroed HIGHMEM page
+ *
  * This function will allocate a page for a VMA that the caller knows will
  * be able to migrate in the future using move_pages() or reclaimed
  *
--- a/include/linux/highmem-internal.h~mm-highmem-fix-kernel-doc-warnings-in-highmemh
+++ a/include/linux/highmem-internal.h
@@ -236,9 +236,17 @@ static inline unsigned long totalhigh_pa
 
 #endif /* CONFIG_HIGHMEM */
 
-/*
- * Prevent people trying to call kunmap_atomic() as if it were kunmap()
- * kunmap_atomic() should get the return value of kmap_atomic, not the page.
+/**
+ * kunmap_atomic - Unmap the virtual address mapped by kmap_atomic()
+ * @__addr:       Virtual address to be unmapped
+ *
+ * Unmap an address previously mapped by kmap_atomic() and re-enables
+ * pagefaults and preemption. Mappings should be unmapped in the reverse
+ * order that they were mapped. See kmap_local_page() for details.
+ * @__addr can be any address within the mapped page, so there is no need
+ * to subtract any offset that has been added. In contrast to kunmap(),
+ * this function takes the address returned from kmap_atomic(), not the
+ * page passed to it. The compiler will warn you if you pass the page.
  */
 #define kunmap_atomic(__addr)					\
 do {								\
_

Patches currently in -mm which might be from fmdefrancesco@gmail.com are

mm-highmem-fix-kernel-doc-warnings-in-highmemh.patch
documentation-vm-include-kdocs-from-highmemh-into-highmemrst.patch
documentation-vm-remove-using-kmap-atomic-from-highmemrst.patch
documentation-vm-rework-temporary-virtual-mappings.patch

