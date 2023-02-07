Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 061CAC05027
	for <mm-commits@archiver.kernel.org>; Tue,  7 Feb 2023 01:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbjBGBaI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 6 Feb 2023 20:30:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230283AbjBGB35 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2023 20:29:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F9CE2ED66
        for <mm-commits@vger.kernel.org>; Mon,  6 Feb 2023 17:29:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF49A61122
        for <mm-commits@vger.kernel.org>; Tue,  7 Feb 2023 01:29:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D803C433D2;
        Tue,  7 Feb 2023 01:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675733391;
        bh=zeev8zHvs8rHDI/BgJVC/VgxRh06LCWysNyrp9udcPM=;
        h=Date:To:From:Subject:From;
        b=0sb0HF9lX6kuy5JyZZ7yjV42eTpSQ3swIjdNB4N7SU2DflIQcw0/hB6GEVvnuCc2D
         /HkSsM3Y7kzSQD0EUZWQTQOkG796s28RKTr9F+7d6qTF93jl1olkqmtAJT3jtWKWn8
         34fqcoi3kXEKwS58WySNhzla8IetWE2mbmyshWB4=
Date:   Mon, 06 Feb 2023 17:29:50 -0800
To:     mm-commits@vger.kernel.org, rppt@kernel.org, jhubbard@nvidia.com,
        imbrenda@linux.ibm.com, hch@infradead.org, dhowells@redhat.com,
        david@redhat.com, apopple@nvidia.com, jgg@nvidia.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-gup-move-private-gup-foll_-flags-to-internalh.patch added to mm-unstable branch
Message-Id: <20230207012951.4D803C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: move private gup FOLL_ flags to internal.h
has been added to the -mm mm-unstable branch.  Its filename is
     mm-gup-move-private-gup-foll_-flags-to-internalh.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-gup-move-private-gup-foll_-flags-to-internalh.patch

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
From: Jason Gunthorpe <jgg@nvidia.com>
Subject: mm/gup: move private gup FOLL_ flags to internal.h
Date: Tue, 24 Jan 2023 16:34:34 -0400

Move the flags that should not/are not used outside gup.c and related into
mm/internal.h to discourage driver abuse.

To make this more maintainable going forward compact the two FOLL ranges
with new bit numbers from 0 to 11 and 16 to 21, using shifts so it is
explict.

Switch to an enum so the whole thing is easier to read.

Link: https://lkml.kernel.org/r/13-v2-987e91b59705+36b-gup_tidy_jgg@nvidia.com
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/include/linux/mm_types.h~mm-gup-move-private-gup-foll_-flags-to-internalh
+++ a/include/linux/mm_types.h
@@ -1045,9 +1045,6 @@ typedef unsigned int __bitwise zap_flags
  * FOLL_PIN and FOLL_LONGTERM may be used in various combinations with each
  * other. Here is what they mean, and how to use them:
  *
- * FOLL_LONGTERM indicates that the page will be held for an indefinite time
- * period _often_ under userspace control.  This is in contrast to
- * iov_iter_get_pages(), whose usages are transient.
  *
  * FIXME: For pages which are part of a filesystem, mappings are subject to the
  * lifetime enforced by the filesystem and we need guarantees that longterm
@@ -1091,24 +1088,40 @@ typedef unsigned int __bitwise zap_flags
  * Please see Documentation/core-api/pin_user_pages.rst for more information.
  */
 
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
-#define FOLL_UNLOCKABLE	0x400000 /* allow unlocking the mmap lock (internal only) */
+enum {
+	/* check pte is writable */
+	FOLL_WRITE = 1 << 0,
+	/* do get_page on page */
+	FOLL_GET = 1 << 1,
+	/* give error on hole if it would be zero */
+	FOLL_DUMP = 1 << 2,
+	/* get_user_pages read/write w/o permission */
+	FOLL_FORCE = 1 << 3,
+	/*
+	 * if a disk transfer is needed, start the IO and return without waiting
+	 * upon it
+	 */
+	FOLL_NOWAIT = 1 << 4,
+	/* do not fault in pages */
+	FOLL_NOFAULT = 1 << 5,
+	/* check page is hwpoisoned */
+	FOLL_HWPOISON = 1 << 6,
+	/* don't do file mappings */
+	FOLL_ANON = 1 << 7,
+	/*
+	 * FOLL_LONGTERM indicates that the page will be held for an indefinite
+	 * time period _often_ under userspace control.  This is in contrast to
+	 * iov_iter_get_pages(), whose usages are transient.
+	 */
+	FOLL_LONGTERM = 1 << 8,
+	/* split huge pmd before returning */
+	FOLL_SPLIT_PMD = 1 << 9,
+	/* allow returning PCI P2PDMA pages */
+	FOLL_PCI_P2PDMA = 1 << 10,
+	/* allow interrupts from generic signals */
+	FOLL_INTERRUPTIBLE = 1 << 11,
+
+	/* See also internal only FOLL flags in mm/internal.h */
+};
 
 #endif /* _LINUX_MM_TYPES_H */
--- a/mm/internal.h~mm-gup-move-private-gup-foll_-flags-to-internalh
+++ a/mm/internal.h
@@ -858,6 +858,21 @@ int migrate_device_coherent_page(struct
 struct folio *try_grab_folio(struct page *page, int refs, unsigned int flags);
 int __must_check try_grab_page(struct page *page, unsigned int flags);
 
+enum {
+	/* mark page accessed */
+	FOLL_TOUCH = 1 << 16,
+	/* a retry, previous pass started an IO */
+	FOLL_TRIED = 1 << 17,
+	/* we are working on non-current tsk/mm */
+	FOLL_REMOTE = 1 << 18,
+	/* pages must be released via unpin_user_page */
+	FOLL_PIN = 1 << 19,
+	/* gup_fast: prevent fall-back to slow gup */
+	FOLL_FAST_ONLY = 1 << 20,
+	/* allow unlocking the mmap lock */
+	FOLL_UNLOCKABLE = 1 << 21,
+};
+
 /*
  * Indicates for which pages that are write-protected in the page table,
  * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
_

Patches currently in -mm which might be from jgg@nvidia.com are

mm-gup-have-internal-functions-get-the-mmap_read_lock.patch
mm-gup-remove-obsolete-foll_longterm-comment.patch
mm-gup-dont-call-__gup_longterm_locked-if-foll_longterm-cannot-be-set.patch
mm-gup-move-try_grab_page-to-mm-internalh.patch
mm-gup-simplify-the-external-interface-functions-and-consolidate-invariants.patch
mm-gup-add-an-assertion-that-the-mmap-lock-is-locked.patch
mm-gup-remove-locked-being-null-from-faultin_vma_page_range.patch
mm-gup-add-foll_unlockable.patch
mm-gup-make-locked-never-null-in-the-internal-gup-functions.patch
mm-gup-remove-pin_user_pages_fast_only.patch
mm-gup-make-get_user_pages_fast_only-return-the-common-return-value.patch
mm-gup-move-gup_must_unshare-to-mm-internalh.patch
mm-gup-move-private-gup-foll_-flags-to-internalh.patch

