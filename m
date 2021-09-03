Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41AEAC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2B4F6610E5
	for <mm-commits@archiver.kernel.org>; Fri,  3 Sep 2021 20:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235957AbhICU5h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Sep 2021 16:57:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:56478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350164AbhICU5d (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 3 Sep 2021 16:57:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8287560E76;
        Fri,  3 Sep 2021 20:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1630702589;
        bh=oNqjKHZwOHUzlDKNg13N01zFlHRjVU5IclJ8TkqPFGc=;
        h=Date:From:To:Subject:From;
        b=XP56PuSy4W2proCTjH5csA+wJQNQDQINC5jfLzMnx9aZNctnQv0qzX0t5fEW+qhtC
         W8qLYBb4cS6RruQUp37ikHGM2JyyX32t8NxpeZxUDj2RQPe5T6Q6QqRWpyXzkBH7qY
         3ucWi2dVSSRJJeABHONiNXk/3+ap2uz4KnMTrOJ8=
Date:   Fri, 03 Sep 2021 13:56:29 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, gor@linux.ibm.com, hca@linux.ibm.com,
        hch@lst.de, jhubbard@nvidia.com, mm-commits@vger.kernel.org,
        willy@infradead.org
Subject:  [merged]
 mm-gup-documentation-corrections-for-gup-pup.patch removed from -mm tree
Message-ID: <20210903205629.nC6aWQV7B%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/gup: documentation corrections for gup/pup
has been removed from the -mm tree.  Its filename was
     mm-gup-documentation-corrections-for-gup-pup.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: John Hubbard <jhubbard@nvidia.com>
Subject: mm/gup: documentation corrections for gup/pup

Patch series "A few gup refactorings and documentation updates", v3.

While reviewing some of the other things going on around gup.c, I noticed
that the documentation was wrong for a few of the routines that I wrote. 
And then I noticed that there was some significant code duplication too. 
So this fixes those issues.

This is not entirely risk-free, but after looking closely at this, I think
it's actually a useful improvement, getting rid of the code duplication
here.


This patch (of 3):

The documentation for try_grab_compound_head() and try_grab_page() has
fallen a little out of date.  Update and clarify a few points.

Also make it kerneldoc-correct, by adding @args documentation.

Link: https://lkml.kernel.org/r/20210813044133.1536842-1-jhubbard@nvidia.com
Link: https://lkml.kernel.org/r/20210813044133.1536842-2-jhubbard@nvidia.com
Signed-off-by: John Hubbard <jhubbard@nvidia.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/gup.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/mm/gup.c~mm-gup-documentation-corrections-for-gup-pup
+++ a/mm/gup.c
@@ -92,10 +92,17 @@ static inline struct page *try_get_compo
 	return head;
 }
 
-/*
+/**
  * try_grab_compound_head() - attempt to elevate a page's refcount, by a
  * flags-dependent amount.
  *
+ * Even though the name includes "compound_head", this function is still
+ * appropriate for callers that have a non-compound @page to get.
+ *
+ * @page:  pointer to page to be grabbed
+ * @refs:  the value to (effectively) add to the page's refcount
+ * @flags: gup flags: these are the FOLL_* flag values.
+ *
  * "grab" names in this file mean, "look at flags to decide whether to use
  * FOLL_PIN or FOLL_GET behavior, when incrementing the page's refcount.
  *
@@ -103,8 +110,14 @@ static inline struct page *try_get_compo
  * same time. (That's true throughout the get_user_pages*() and
  * pin_user_pages*() APIs.) Cases:
  *
- *    FOLL_GET: page's refcount will be incremented by 1.
- *    FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.
+ *    FOLL_GET: page's refcount will be incremented by @refs.
+ *
+ *    FOLL_PIN on compound pages that are > two pages long: page's refcount will
+ *    be incremented by @refs, and page[2].hpage_pinned_refcount will be
+ *    incremented by @refs * GUP_PIN_COUNTING_BIAS.
+ *
+ *    FOLL_PIN on normal pages, or compound pages that are two pages long:
+ *    page's refcount will be incremented by @refs * GUP_PIN_COUNTING_BIAS.
  *
  * Return: head page (with refcount appropriately incremented) for success, or
  * NULL upon failure. If neither FOLL_GET nor FOLL_PIN was set, that's
@@ -141,6 +154,8 @@ __maybe_unused struct page *try_grab_com
 		 *
 		 * However, be sure to *also* increment the normal page refcount
 		 * field at least once, so that the page really is pinned.
+		 * That's why the refcount from the earlier
+		 * try_get_compound_head() is left intact.
 		 */
 		if (hpage_pincount_available(page))
 			hpage_pincount_add(page, refs);
@@ -184,10 +199,8 @@ static void put_compound_head(struct pag
  * @flags:   gup flags: these are the FOLL_* flag values.
  *
  * Either FOLL_PIN or FOLL_GET (or neither) may be set, but not both at the same
- * time. Cases:
- *
- *    FOLL_GET: page's refcount will be incremented by 1.
- *    FOLL_PIN: page's refcount will be incremented by GUP_PIN_COUNTING_BIAS.
+ * time. Cases: please see the try_grab_compound_head() documentation, with
+ * "refs=1".
  *
  * Return: true for success, or if no action was required (if neither FOLL_PIN
  * nor FOLL_GET was set, nothing is done). False for failure: FOLL_GET or
_

Patches currently in -mm which might be from jhubbard@nvidia.com are


