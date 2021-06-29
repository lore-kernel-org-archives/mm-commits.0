Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BC0EC11F65
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0AF61CF4
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 00:20:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232014AbhF2AXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 20:23:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:59244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231996AbhF2AXC (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 20:23:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 99BB161CF4;
        Tue, 29 Jun 2021 00:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624926036;
        bh=h8RSGeskF9ACqjgVe/kCz4tMELVPAt2+UOy8XYkL4wY=;
        h=Date:From:To:Subject:From;
        b=yd6AYMZyNlPk/mYrhKB58/xmOgQG3lHyVhutl9YnAEGQlq4PCFJRytElNA/MvFWhr
         LmRduD74dhEU3TBvnlSR/mRh7SGxVkWureSdO5nzPSL7J2yViOxV6eBLq5M3rKsY/B
         OHyIAh8xCu7OX5xQ+W7v6YsxoynZINyRaOIfLkJg=
Date:   Mon, 28 Jun 2021 17:20:36 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, peterx@redhat.com
Subject:  [folded-merged]
 mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch removed from -mm tree
Message-ID: <20210629002036.TrCR-MdfM%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fixup! mm: gup: pack has_pinned in MMF_HAS_PINNED
has been removed from the -mm tree.  Its filename was
     mm-gup-pack-has_pinned-in-mmf_has_pinned-fix.patch

This patch was dropped because it was folded into mm-gup-pack-has_pinned-in-mmf_has_pinned.patch

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
@@ -420,6 +420,17 @@ void unpin_user_pages(struct page **page
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
@@ -1299,17 +1310,6 @@ retry:
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

mm-gup_benchmark-support-threading.patch
mm-gup-pack-has_pinned-in-mmf_has_pinned.patch
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
userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch

