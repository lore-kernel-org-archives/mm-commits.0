Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3C7C433F5
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:16:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9212C611EF
	for <mm-commits@archiver.kernel.org>; Wed, 20 Oct 2021 22:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhJTWTE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 20 Oct 2021 18:19:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:33808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229695AbhJTWTE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 20 Oct 2021 18:19:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2728C611CB;
        Wed, 20 Oct 2021 22:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634768209;
        bh=lXz/d0rlq/Jt586D9lHg7yr1iiJBgcy5JBCkVfLVXhw=;
        h=Date:From:To:Subject:From;
        b=L5X/AO4s0QZsPXVH2KYZ+nroCR+h88bkUK+8M7if36f8M4Gt09Hg7EGK1PXLBzm2e
         OWsaiZ2HjNNTWUMB+tIJ/WKCec16lZ9NVa/w7ocKRGOFbToy5OqG7oSFZBn2eHQbFA
         OucHtis7HSrkSDF9sAjZhgijEbOYl4R+7rvgHpmw=
Date:   Wed, 20 Oct 2021 15:16:48 -0700
From:   akpm@linux-foundation.org
To:     hughd@google.com, kirill.shutemov@linux.intel.com,
        mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        osalvador@suse.de, peterx@redhat.com, shy828301@gmail.com,
        willy@infradead.org
Subject:  +
 mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch added to -mm tree
Message-ID: <20211020221648.b02k9A3Nh%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: filemap: coding style cleanup for filemap_map_pmd()
has been added to the -mm tree.  Its filename is
     mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Shi <shy828301@gmail.com>
Subject: mm: filemap: coding style cleanup for filemap_map_pmd()

Patch series "Solve silent data loss caused by poisoned page cache (shmem/tmpfs)", v5.

When discussing the patch that splits page cache THP in order to offline
the poisoned page, Noaya mentioned there is a bigger problem [1] that
prevents this from working since the page cache page will be truncated if
uncorrectable errors happen.  By looking this deeper it turns out this
approach (truncating poisoned page) may incur silent data loss for all
non-readonly filesystems if the page is dirty.  It may be worse for
in-memory filesystem, e.g.  shmem/tmpfs since the data blocks are actually
gone.

To solve this problem we could keep the poisoned dirty page in page cache
then notify the users on any later access, e.g.  page fault, read/write,
etc.  The clean page could be truncated as is since they can be reread
from disk later on.

The consequence is the filesystems may find poisoned page and manipulate
it as healthy page since all the filesystems actually don't check if the
page is poisoned or not in all the relevant paths except page fault.  In
general, we need make the filesystems be aware of poisoned page before we
could keep the poisoned page in page cache in order to solve the data loss
problem.

To make filesystems be aware of poisoned page we should consider:
- The page should be not written back: clearing dirty flag could prevent from
  writeback.
- The page should not be dropped (it shows as a clean page) by drop caches or
  other callers: the refcount pin from hwpoison could prevent from invalidating
  (called by cache drop, inode cache shrinking, etc), but it doesn't avoid
  invalidation in DIO path.
- The page should be able to get truncated/hole punched/unlinked: it works as it
  is.
- Notify users when the page is accessed, e.g. read/write, page fault and other
  paths (compression, encryption, etc).

The scope of the last one is huge since almost all filesystems need do it
once a page is returned from page cache lookup.  There are a couple of
options to do it:

1. Check hwpoison flag for every path, the most straightforward way.
2. Return NULL for poisoned page from page cache lookup, the most callsites
   check if NULL is returned, this should have least work I think.  But the
   error handling in filesystems just return -ENOMEM, the error code will incur
   confusion to the users obviously.
3. To improve #2, we could return error pointer, e.g. ERR_PTR(-EIO), but this
   will involve significant amount of code change as well since all the paths
   need check if the pointer is ERR or not just like option #1.

I did prototype for both #1 and #3, but it seems #3 may require more
changes than #1.  For #3 ERR_PTR will be returned so all the callers need
to check the return value otherwise invalid pointer may be dereferenced,
but not all callers really care about the content of the page, for
example, partial truncate which just sets the truncated range in one page
to 0.  So for such paths it needs additional modification if ERR_PTR is
returned.  And if the callers have their own way to handle the problematic
pages we need to add a new FGP flag to tell FGP functions to return the
pointer to the page.

It may happen very rarely, but once it happens the consequence (data
corruption) could be very bad and it is very hard to debug.  It seems this
problem had been slightly discussed before, but seems no action was taken
at that time.  [2]

As the aforementioned investigation, it needs huge amount of work to solve
the potential data loss for all filesystems.  But it is much easier for
in-memory filesystems and such filesystems actually suffer more than
others since even the data blocks are gone due to truncating.  So this
patchset starts from shmem/tmpfs by taking option #1.

TODO:
* The unpoison has been broken since commit 0ed950d1f281 ("mm,hwpoison: make
  get_hwpoison_page() call get_any_page()"), and this patch series make
  refcount check for unpoisoning shmem page fail.
* Expand to other filesystems.  But I haven't heard feedback from filesystem
  developers yet.

Patch breakdown:
Patch #1: cleanup, depended by patch #2
Patch #2: fix THP with hwpoisoned subpage(s) PMD map bug
Patch #3: coding style cleanup
Patch #4: refactor and preparation.
Patch #5: keep the poisoned page in page cache and handle such case for all
          the paths.
Patch #6: the previous patches unblock page cache THP split, so this patch
          add page cache THP split support.


This patch (of 4):

A minor cleanup to the indent.

Link: https://lkml.kernel.org/r/20211020210755.23964-1-shy828301@gmail.com
Link: https://lkml.kernel.org/r/20211020210755.23964-4-shy828301@gmail.com
Signed-off-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/filemap.c~mm-filemap-coding-style-cleanup-for-filemap_map_pmd
+++ a/mm/filemap.c
@@ -3202,12 +3202,12 @@ static bool filemap_map_pmd(struct vm_fa
 	}
 
 	if (pmd_none(*vmf->pmd) && PageTransHuge(page)) {
-	    vm_fault_t ret = do_set_pmd(vmf, page);
-	    if (!ret) {
-		    /* The page is mapped successfully, reference consumed. */
-		    unlock_page(page);
-		    return true;
-	    }
+		vm_fault_t ret = do_set_pmd(vmf, page);
+		if (!ret) {
+			/* The page is mapped successfully, reference consumed. */
+			unlock_page(page);
+			return true;
+		}
 	}
 
 	if (pmd_none(*vmf->pmd))
_

Patches currently in -mm which might be from shy828301@gmail.com are

mm-hwpoison-remove-the-unnecessary-thp-check.patch
mm-filemap-check-if-thp-has-hwpoisoned-subpage-for-pmd-page-fault.patch
mm-filemap-coding-style-cleanup-for-filemap_map_pmd.patch
mm-hwpoison-refactor-refcount-check-handling.patch
mm-shmem-dont-truncate-page-if-memory-failure-happens.patch
mm-hwpoison-handle-non-anonymous-thp-correctly.patch
mm-migrate-make-demotion-knob-depend-on-migration.patch

