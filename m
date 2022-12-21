Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AFD1C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 21 Dec 2022 21:50:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiLUVua (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Dec 2022 16:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiLUVu3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Dec 2022 16:50:29 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B0F2248E1
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 13:50:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 85C57CE1813
        for <mm-commits@vger.kernel.org>; Wed, 21 Dec 2022 21:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C300C433EF;
        Wed, 21 Dec 2022 21:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1671659424;
        bh=DtDLnBLBPzjercE+Cgf8B7NyhJBFyjJK/lvYv7jR5s4=;
        h=Date:To:From:Subject:From;
        b=ZUKwD5bvHOh3YmO0aaVOofQHIoF1ev3HWSCEXGVvsXR3xjG6spgY9yccPD/akGVwa
         5sbEYv/igCitukwdo6B1mWBnrNCmnBsi16c4hT89kC7IEDWe3qeNOW/q4PPGVh8y1F
         4NVNujljXlBoKLo3uLpkDNAmAITtesYb8kSvN6nI=
Date:   Wed, 21 Dec 2022 13:50:23 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        viro@zeniv.linux.org.uk, jhubbard@nvidia.com, hch@lst.de,
        dhowells@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-move-foll_-defs-to-mm_typesh.patch added to mm-unstable branch
Message-Id: <20221221215024.9C300C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: move FOLL_* defs to mm_types.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-move-foll_-defs-to-mm_typesh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-move-foll_-defs-to-mm_typesh.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: David Howells <dhowells@redhat.com>
Subject: mm: move FOLL_* defs to mm_types.h
Date: Wed, 21 Dec 2022 21:24:54 +0000

Move FOLL_* definitions to linux/mm_types.h to make them more accessible
without having to drag in all of linux/mm.h and everything that drags in
too[1].

Link: https://lkml.kernel.org/r/2161258.1671657894@warthog.procyon.org.uk
Signed-off-by: David Howells <dhowells@redhat.com>
Suggested-by: Matthew Wilcox <willy@infradead.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mm.h       |   75 -------------------------------------
 include/linux/mm_types.h |   75 +++++++++++++++++++++++++++++++++++++
 2 files changed, 75 insertions(+), 75 deletions(-)

--- a/include/linux/mm.h~mm-move-foll_-defs-to-mm_typesh
+++ a/include/linux/mm.h
@@ -3057,81 +3057,6 @@ static inline vm_fault_t vmf_error(int e
 struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 			 unsigned int foll_flags);
 
-#define FOLL_WRITE	0x01	/* check pte is writable */
-#define FOLL_TOUCH	0x02	/* mark page accessed */
-#define FOLL_GET	0x04	/* do get_page on page */
-#define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
-#define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
-#define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
-				 * and return without waiting upon it */
-#define FOLL_NOFAULT	0x80	/* do not fault in pages */
-#define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
-#define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
-#define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
-#define FOLL_ANON	0x8000	/* don't do file mappings */
-#define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
-#define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
-#define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
-#define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
-#define FOLL_PCI_P2PDMA	0x100000 /* allow returning PCI P2PDMA pages */
-#define FOLL_INTERRUPTIBLE  0x200000 /* allow interrupts from generic signals */
-
-/*
- * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
- * other. Here is what they mean, and how to use them:
- *
- * FOLL_LONGTERM indicates that the page will be held for an indefinite time
- * period _often_ under userspace control.  This is in contrast to
- * iov_iter_get_pages(), whose usages are transient.
- *
- * FIXME: For pages which are part of a filesystem, mappings are subject to the
- * lifetime enforced by the filesystem and we need guarantees that longterm
- * users like RDMA and V4L2 only establish mappings which coordinate usage with
- * the filesystem.  Ideas for this coordination include revoking the longterm
- * pin, delaying writeback, bounce buffer page writeback, etc.  As FS DAX was
- * added after the problem with filesystems was found FS DAX VMAs are
- * specifically failed.  Filesystem pages are still subject to bugs and use of
- * FOLL_LONGTERM should be avoided on those pages.
- *
- * FIXME: Also NOTE that FOLL_LONGTERM is not supported in every GUP call.
- * Currently only get_user_pages() and get_user_pages_fast() support this flag
- * and calls to get_user_pages_[un]locked are specifically not allowed.  This
- * is due to an incompatibility with the FS DAX check and
- * FAULT_FLAG_ALLOW_RETRY.
- *
- * In the CMA case: long term pins in a CMA region would unnecessarily fragment
- * that region.  And so, CMA attempts to migrate the page before pinning, when
- * FOLL_LONGTERM is specified.
- *
- * FOLL_PIN indicates that a special kind of tracking (not just page->_refcount,
- * but an additional pin counting system) will be invoked. This is intended for
- * anything that gets a page reference and then touches page data (for example,
- * Direct IO). This lets the filesystem know that some non-file-system entity is
- * potentially changing the pages' data. In contrast to FOLL_GET (whose pages
- * are released via put_page()), FOLL_PIN pages must be released, ultimately, by
- * a call to unpin_user_page().
- *
- * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use different
- * and separate refcounting mechanisms, however, and that means that each has
- * its own acquire and release mechanisms:
- *
- *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
- *
- *     FOLL_PIN: pin_user_pages*() to acquire, and unpin_user_pages to release.
- *
- * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
- * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-based
- * calls applied to them, and that's perfectly OK. This is a constraint on the
- * callers, not on the pages.)
- *
- * FOLL_PIN should be set internally by the pin_user_pages*() APIs, never
- * directly by the caller. That's in order to help avoid mismatches when
- * releasing pages: get_user_pages*() pages must be released via put_page(),
- * while pin_user_pages*() pages must be released via unpin_user_page().
- *
- * Please see Documentation/core-api/pin_user_pages.rst for more information.
- */
-
 static inline int vm_fault_to_errno(vm_fault_t vm_fault, int foll_flags)
 {
 	if (vm_fault & VM_FAULT_OOM)
--- a/include/linux/mm_types.h~mm-move-foll_-defs-to-mm_typesh
+++ a/include/linux/mm_types.h
@@ -1085,4 +1085,79 @@ enum fault_flag {
 
 typedef unsigned int __bitwise zap_flags_t;
 
+/*
+ * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
+ * other. Here is what they mean, and how to use them:
+ *
+ * FOLL_LONGTERM indicates that the page will be held for an indefinite time
+ * period _often_ under userspace control.  This is in contrast to
+ * iov_iter_get_pages(), whose usages are transient.
+ *
+ * FIXME: For pages which are part of a filesystem, mappings are subject to the
+ * lifetime enforced by the filesystem and we need guarantees that longterm
+ * users like RDMA and V4L2 only establish mappings which coordinate usage with
+ * the filesystem.  Ideas for this coordination include revoking the longterm
+ * pin, delaying writeback, bounce buffer page writeback, etc.  As FS DAX was
+ * added after the problem with filesystems was found FS DAX VMAs are
+ * specifically failed.  Filesystem pages are still subject to bugs and use of
+ * FOLL_LONGTERM should be avoided on those pages.
+ *
+ * FIXME: Also NOTE that FOLL_LONGTERM is not supported in every GUP call.
+ * Currently only get_user_pages() and get_user_pages_fast() support this flag
+ * and calls to get_user_pages_[un]locked are specifically not allowed.  This
+ * is due to an incompatibility with the FS DAX check and
+ * FAULT_FLAG_ALLOW_RETRY.
+ *
+ * In the CMA case: long term pins in a CMA region would unnecessarily fragment
+ * that region.  And so, CMA attempts to migrate the page before pinning, when
+ * FOLL_LONGTERM is specified.
+ *
+ * FOLL_PIN indicates that a special kind of tracking (not just page->_refcount,
+ * but an additional pin counting system) will be invoked. This is intended for
+ * anything that gets a page reference and then touches page data (for example,
+ * Direct IO). This lets the filesystem know that some non-file-system entity is
+ * potentially changing the pages' data. In contrast to FOLL_GET (whose pages
+ * are released via put_page()), FOLL_PIN pages must be released, ultimately, by
+ * a call to unpin_user_page().
+ *
+ * FOLL_PIN is similar to FOLL_GET: both of these pin pages. They use different
+ * and separate refcounting mechanisms, however, and that means that each has
+ * its own acquire and release mechanisms:
+ *
+ *     FOLL_GET: get_user_pages*() to acquire, and put_page() to release.
+ *
+ *     FOLL_PIN: pin_user_pages*() to acquire, and unpin_user_pages to release.
+ *
+ * FOLL_PIN and FOLL_GET are mutually exclusive for a given function call.
+ * (The underlying pages may experience both FOLL_GET-based and FOLL_PIN-based
+ * calls applied to them, and that's perfectly OK. This is a constraint on the
+ * callers, not on the pages.)
+ *
+ * FOLL_PIN should be set internally by the pin_user_pages*() APIs, never
+ * directly by the caller. That's in order to help avoid mismatches when
+ * releasing pages: get_user_pages*() pages must be released via put_page(),
+ * while pin_user_pages*() pages must be released via unpin_user_page().
+ *
+ * Please see Documentation/core-api/pin_user_pages.rst for more information.
+ */
+
+#define FOLL_WRITE	0x01	/* check pte is writable */
+#define FOLL_TOUCH	0x02	/* mark page accessed */
+#define FOLL_GET	0x04	/* do get_page on page */
+#define FOLL_DUMP	0x08	/* give error on hole if it would be zero */
+#define FOLL_FORCE	0x10	/* get_user_pages read/write w/o permission */
+#define FOLL_NOWAIT	0x20	/* if a disk transfer is needed, start the IO
+				 * and return without waiting upon it */
+#define FOLL_NOFAULT	0x80	/* do not fault in pages */
+#define FOLL_HWPOISON	0x100	/* check page is hwpoisoned */
+#define FOLL_TRIED	0x800	/* a retry, previous pass started an IO */
+#define FOLL_REMOTE	0x2000	/* we are working on non-current tsk/mm */
+#define FOLL_ANON	0x8000	/* don't do file mappings */
+#define FOLL_LONGTERM	0x10000	/* mapping lifetime is indefinite: see below */
+#define FOLL_SPLIT_PMD	0x20000	/* split huge pmd before returning */
+#define FOLL_PIN	0x40000	/* pages must be released via unpin_user_page */
+#define FOLL_FAST_ONLY	0x80000	/* gup_fast: prevent fall-back to slow gup */
+#define FOLL_PCI_P2PDMA	0x100000 /* allow returning PCI P2PDMA pages */
+#define FOLL_INTERRUPTIBLE  0x200000 /* allow interrupts from generic signals */
+
 #endif /* _LINUX_MM_TYPES_H */
_

Patches currently in -mm which might be from dhowells@redhat.com are

mm-move-foll_-defs-to-mm_typesh.patch

