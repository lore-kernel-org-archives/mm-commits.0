Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93EDEC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 707EC6162A
	for <mm-commits@archiver.kernel.org>; Tue, 11 May 2021 22:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhEKWBh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 May 2021 18:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:32962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230118AbhEKWBh (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 May 2021 18:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C9E1A616EA;
        Tue, 11 May 2021 22:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620770430;
        bh=xdbdCCYlzKezqXT/ZvDlYf+DnBra1mQfR8a8knSfMWQ=;
        h=Date:From:To:Subject:From;
        b=ucoz86USb8O9PHajQ2i1JmRd3qyL2NWf5nxeixl78nX9FuiJfGI7UdOpmQbKYC2r9
         lewZ30Q1B+8aTfpgjHAk+Q46BATz+NQWReTbEDNyGe7z2ot3BaITutkNcgOAEw4KWk
         DTkGY2alImMfWCikID7L+2V2Rm0/RGPn2SyE38og=
Date:   Tue, 11 May 2021 15:00:29 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  + mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
 added to -mm tree
Message-ID: <20210511220029.m6tGcxUIw%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm: gup: pack has_pinned in MMF_HAS_PINNED
has been added to the -mm tree.  Its filename is
     mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Peter Xu <peterx@redhat.com>
Subject: fixup! mm: gup: pack has_pinned in MMF_HAS_PINNED

This fixes build issue with !CONFIG_MMU.

Link: https://lkml.kernel.org/r/YJqWESqyxa8OZA+2@t490s
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/mm/gup.c~mm-gup-pack-has_pinned-in-mmf_has_pinned-fix
+++ a/mm/gup.c
@@ -392,6 +392,17 @@ void unpin_user_pages(struct page **page
 }
 EXPORT_SYMBOL(unpin_user_pages);
 
+/*
+ * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
+ * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
+ * cache bouncing on large SMP machines for concurrent pinned gups.
+ */
+static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
+{
+	if (!test_bit(MMF_HAS_PINNED, mm_flags))
+		set_bit(MMF_HAS_PINNED, mm_flags);
+}
+
 #ifdef CONFIG_MMU
 static struct page *no_page_table(struct vm_area_struct *vma,
 		unsigned int flags)
@@ -1271,17 +1282,6 @@ retry:
 EXPORT_SYMBOL_GPL(fixup_user_fault);
 
 /*
- * Set the MMF_HAS_PINNED if not set yet; after set it'll be there for the mm's
- * lifecycle.  Avoid setting the bit unless necessary, or it might cause write
- * cache bouncing on large SMP machines for concurrent pinned gups.
- */
-static inline void mm_set_has_pinned_flag(unsigned long *mm_flags)
-{
-	if (!test_bit(MMF_HAS_PINNED, mm_flags))
-		set_bit(MMF_HAS_PINNED, mm_flags);
-}
-
-/*
  * Please note that this function, unlike __get_user_pages will not
  * return 0 for nr_pages > 0 without FOLL_NOWAIT
  */
_

Patches currently in -mm which might be from peterx@redhat.com are

mm-hugetlb-fix-f_seal_future_write.patch
mm-hugetlb-fix-cow-where-page-writtable-in-child.patch
mm-gup_benchmark-support-threading.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch
userfaultfd-selftests-use-user-mode-only.patch
userfaultfd-selftests-remove-the-time-check-on-delayed-uffd.patch
userfaultfd-selftests-dropping-verify-check-in-locking_thread.patch
userfaultfd-selftests-only-dump-counts-if-mode-enabled.patch
userfaultfd-selftests-unify-error-handling.patch
mm-thp-simplify-copying-of-huge-zero-page-pmd-when-fork.patch
mm-userfaultfd-fix-uffd-wp-special-cases-for-fork.patch
mm-userfaultfd-fix-a-few-thp-pmd-missing-uffd-wp-bit.patch
mm-userfaultfd-fail-uffd-wp-registeration-if-not-supported.patch
mm-pagemap-export-uffd-wp-protection-information.patch
userfaultfd-selftests-add-pagemap-uffd-wp-test.patch

