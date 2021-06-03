Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3043C47096
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 23:33:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B86DD6140A
	for <mm-commits@archiver.kernel.org>; Thu,  3 Jun 2021 23:33:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFCXfE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Jun 2021 19:35:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:55352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229576AbhFCXfE (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Jun 2021 19:35:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF4A3613EC;
        Thu,  3 Jun 2021 23:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622763198;
        bh=So/Sf7/cZhEArag08ooBK1hP2tN8nJTb7kgTgxq8+K0=;
        h=Date:From:To:Subject:From;
        b=iKNwfcc9gWSsuEennaF08nFxFDDPVGQ5UAclYzcKs8BN3rcGQ3nQCoWkLhzjd2CIa
         yLpnCZo/4B65ctNZ51tG7j6JnX61Y1VvbOy3gxdfCkwKKecBUtj+RVBLp5hDH7yUPM
         QBq9LjTHqpqSleICVdXyg+soKc5cRpTMLMb1MVTU=
Date:   Thu, 03 Jun 2021 16:33:18 -0700
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, hughd@google.com, mm-commits@vger.kernel.org,
        peterx@redhat.com
Subject:  +
 mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch
 added to -mm tree
Message-ID: <20210603233318.Nn-3UFmQf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare
has been added to the -mm tree.  Its filename is
     mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch

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
Subject: mm/swap: fix pte_same_as_swp() not removing uffd-wp bit when compare

I found it by pure code review, that pte_same_as_swp() of unuse_vma()
didn't take uffd-wp bit into account when comparing ptes. 
pte_same_as_swp() returning false negative could cause failure to swapoff
swap ptes that was wr-protected by userfaultfd.

Link: https://lkml.kernel.org/r/20210603180546.9083-1-peterx@redhat.com
Signed-off-by: Peter Xu <peterx@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/swapops.h |   15 +++++++++++----
 mm/swapfile.c           |    2 +-
 2 files changed, 12 insertions(+), 5 deletions(-)

--- a/include/linux/swapops.h~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/include/linux/swapops.h
@@ -23,6 +23,16 @@
 #define SWP_TYPE_SHIFT	(BITS_PER_XA_VALUE - MAX_SWAPFILES_SHIFT)
 #define SWP_OFFSET_MASK	((1UL << SWP_TYPE_SHIFT) - 1)
 
+/* Clear all flags but only keep swp_entry_t related information */
+static inline pte_t pte_swp_clear_flags(pte_t pte)
+{
+	if (pte_swp_soft_dirty(pte))
+		pte = pte_swp_clear_soft_dirty(pte);
+	if (pte_swp_uffd_wp(pte))
+		pte = pte_swp_clear_uffd_wp(pte);
+	return pte;
+}
+
 /*
  * Store a type+offset into a swp_entry_t in an arch-independent format
  */
@@ -66,10 +76,7 @@ static inline swp_entry_t pte_to_swp_ent
 {
 	swp_entry_t arch_entry;
 
-	if (pte_swp_soft_dirty(pte))
-		pte = pte_swp_clear_soft_dirty(pte);
-	if (pte_swp_uffd_wp(pte))
-		pte = pte_swp_clear_uffd_wp(pte);
+	pte = pte_swp_clear_flags(pte);
 	arch_entry = __pte_to_swp_entry(pte);
 	return swp_entry(__swp_type(arch_entry), __swp_offset(arch_entry));
 }
--- a/mm/swapfile.c~mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare
+++ a/mm/swapfile.c
@@ -1887,7 +1887,7 @@ unsigned int count_swap_pages(int type,
 
 static inline int pte_same_as_swp(pte_t pte, pte_t swp_pte)
 {
-	return pte_same(pte_swp_clear_soft_dirty(pte), swp_pte);
+	return pte_same(pte_swp_clear_flags(pte), swp_pte);
 }
 
 /*
_

Patches currently in -mm which might be from peterx@redhat.com are

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
userfaultfd-selftests-reinitialize-test-context-in-each-test-fix.patch
mm-swap-fix-pte_same_as_swp-not-removing-uffd-wp-bit-when-compare.patch

