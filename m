Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BADAFC4338F
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:14:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D72061052
	for <mm-commits@archiver.kernel.org>; Mon,  9 Aug 2021 19:14:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235668AbhHITOV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 9 Aug 2021 15:14:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:44256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235487AbhHITOV (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 9 Aug 2021 15:14:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CD3660E09;
        Mon,  9 Aug 2021 19:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1628536440;
        bh=OqOR/gk1lqFY6qFH7a82sfIac+EQLl7heRg3df9ee4A=;
        h=Date:From:To:Subject:From;
        b=Q7A3R2L7r4kZNTOK3W94dyKqUdUlaKc6fYkmU3twFRJECtVeb5Ob4V9sbukmja0gJ
         MKF6ql35IqKQp/21/a0CwtiN8gIBJa8W1bcq5uZSDOuAUJDq+t2SgVBrWdDWtUsEQG
         Sr30RWqv2TZsZJsCZwsJWRjjqsU1zV8Nk0Io/jCA=
Date:   Mon, 09 Aug 2021 12:14:00 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        rdunlap@infradead.org
Subject:  + mm-workingset-correct-kernel-doc-notations.patch added to
 -mm tree
Message-ID: <20210809191400.yqvWu%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/workingset: correct kernel-doc notations
has been added to the -mm tree.  Its filename is
     mm-workingset-correct-kernel-doc-notations.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-workingset-correct-kernel-doc-notations.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-workingset-correct-kernel-doc-notations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mm/workingset: correct kernel-doc notations

Use the documented kernel-doc format to prevent kernel-doc warnings.

mm/workingset.c:256: warning: No description found for return value of 'workingset_eviction'
mm/workingset.c:285: warning: Function parameter or member 'folio' not described in 'workingset_refault'
mm/workingset.c:285: warning: Excess function parameter 'page' description in 'workingset_refault'

Link: https://lkml.kernel.org/r/20210808203153.10678-1-rdunlap@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/workingset.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/workingset.c~mm-workingset-correct-kernel-doc-notations
+++ a/mm/workingset.c
@@ -249,7 +249,7 @@ void workingset_age_nonresident(struct l
  * @target_memcg: the cgroup that is causing the reclaim
  * @page: the page being evicted
  *
- * Returns a shadow entry to be stored in @page->mapping->i_pages in place
+ * Return: a shadow entry to be stored in @page->mapping->i_pages in place
  * of the evicted @page so that a later refault can be detected.
  */
 void *workingset_eviction(struct page *page, struct mem_cgroup *target_memcg)
@@ -274,7 +274,7 @@ void *workingset_eviction(struct page *p
 
 /**
  * workingset_refault - evaluate the refault of a previously evicted folio
- * @page: the freshly allocated replacement folio
+ * @folio: the freshly allocated replacement folio
  * @shadow: shadow entry of the evicted folio
  *
  * Calculates and evaluates the refault distance of the previously
_

Patches currently in -mm which might be from rdunlap@infradead.org are

alpha-agp-make-empty-macros-use-do-while-0-style.patch
lib-dump_stack-correct-kernel-doc-notation.patch
lib-iov_iterc-fix-kernel-doc-warnings.patch
fs-epoll-use-a-per-cpu-counter-for-users-watches-count-fix.patch
mm-workingset-correct-kernel-doc-notations.patch
scripts-check_extable-fix-typo-in-user-error-message.patch

