Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0F2C2D0E4
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:36:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B3FF20709
	for <mm-commits@archiver.kernel.org>; Fri, 13 Nov 2020 00:36:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="R6b2DFDx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725972AbgKMAgd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 19:36:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:46724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAgb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 19:36:31 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF8AD206CA;
        Fri, 13 Nov 2020 00:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605227791;
        bh=/bfo6cNlyP7B2ltk1vKAzEZRTyvzKNhvMZ+zAovxyGQ=;
        h=Date:From:To:Subject:From;
        b=R6b2DFDxcLMv7DwKOHQiyM50+IujMNGOcRqXsB+CrIWlmEiu1/+2MfNjHe4qnh5dH
         6fH43IjaXvNq2yKWxC6Efw5pCVrSP6m3NtbHyhC6gL4MXmnRJti7+BjXxef1hwvzim
         Fy6HACiv5qKx+dUGMpDgOC37D9Lltn4JL1+v2NzY=
Date:   Thu, 12 Nov 2020 16:36:30 -0800
From:   akpm@linux-foundation.org
To:     jlayton@kernel.org, mm-commits@vger.kernel.org, willy@infradead.org
Subject:  + mm-remove-pagevec_lookup_range_nr_tag.patch added to
 -mm tree
Message-ID: <20201113003630.wBjXpQeJv%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: remove pagevec_lookup_range_nr_tag()
has been added to the -mm tree.  Its filename is
     mm-remove-pagevec_lookup_range_nr_tag.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-remove-pagevec_lookup_range_nr_tag.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-remove-pagevec_lookup_range_nr_tag.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Jeff Layton <jlayton@kernel.org>
Subject: mm: remove pagevec_lookup_range_nr_tag()

With the merge of 2e1692966034 ("ceph: have ceph_writepages_start call
pagevec_lookup_range_tag"), nothing calls this anymore.

Link: https://lkml.kernel.org/r/20201021193926.101474-1-jlayton@kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/pagevec.h |    3 ---
 mm/swap.c               |    9 ---------
 2 files changed, 12 deletions(-)

--- a/include/linux/pagevec.h~mm-remove-pagevec_lookup_range_nr_tag
+++ a/include/linux/pagevec.h
@@ -43,9 +43,6 @@ static inline unsigned pagevec_lookup(st
 unsigned pagevec_lookup_range_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, pgoff_t end,
 		xa_mark_t tag);
-unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag, unsigned max_pages);
 static inline unsigned pagevec_lookup_tag(struct pagevec *pvec,
 		struct address_space *mapping, pgoff_t *index, xa_mark_t tag)
 {
--- a/mm/swap.c~mm-remove-pagevec_lookup_range_nr_tag
+++ a/mm/swap.c
@@ -1167,15 +1167,6 @@ unsigned pagevec_lookup_range_tag(struct
 }
 EXPORT_SYMBOL(pagevec_lookup_range_tag);
 
-unsigned pagevec_lookup_range_nr_tag(struct pagevec *pvec,
-		struct address_space *mapping, pgoff_t *index, pgoff_t end,
-		xa_mark_t tag, unsigned max_pages)
-{
-	pvec->nr = find_get_pages_range_tag(mapping, index, end, tag,
-		min_t(unsigned int, max_pages, PAGEVEC_SIZE), pvec->pages);
-	return pagevec_count(pvec);
-}
-EXPORT_SYMBOL(pagevec_lookup_range_nr_tag);
 /*
  * Perform any setup for the swap system
  */
_

Patches currently in -mm which might be from jlayton@kernel.org are

mm-remove-pagevec_lookup_range_nr_tag.patch

