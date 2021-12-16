Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8658BC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:30:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbhLPWaY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:30:24 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48418 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbhLPWaX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:30:23 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80B6F61F55
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7258C36AE2;
        Thu, 16 Dec 2021 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639693822;
        bh=RnAwLkhxZedaa8gMIXyp3azxsL2o7wMbqiKT5dpqvLA=;
        h=Date:From:To:Subject:From;
        b=UifO7AxjQHRpGFY/eGnQBRoCndXL24OYQsT123x1/p/O1MILyBpJcT6ZyViac4Rkm
         HJ0zZ9FGAF9gTnaSddLJgSybrquzHl3ADJwWBl1y0LlayI9pLSslZhWOAnkQ5zvaZ/
         W0sniN4rCt9VzT6XwzCdBrio9PZt7whlDRA1zU60=
Date:   Thu, 16 Dec 2021 14:30:22 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, david@redhat.com,
        anshuman.khandual@arm.com
Subject:  +
 mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch added
 to -mm tree
Message-ID: <20211216223022.CDCL5%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: modify the comment section for alloc_contig_pages()
has been added to the -mm tree.  Its filename is
     mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: mm/page_alloc.c: modify the comment section for alloc_contig_pages()

Clarify that the alloc_contig_pages() allocated range will always be
aligned to the requested nr_pages.

Link: https://lkml.kernel.org/r/1639545478-12160-1-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c~mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages
+++ a/mm/page_alloc.c
@@ -9264,8 +9264,8 @@ static bool zone_spans_last_pfn(const st
  * for allocation requests which can not be fulfilled with the buddy allocator.
  *
  * The allocated memory is always aligned to a page boundary. If nr_pages is a
- * power of two then the alignment is guaranteed to be to the given nr_pages
- * (e.g. 1GB request would be aligned to 1GB).
+ * power of two, then allocated range is also guaranteed to be aligned to same
+ * nr_pages (e.g. 1GB request would be aligned to 1GB).
  *
  * Allocated pages can be freed with free_contig_range() or by manually calling
  * __free_page() on each allocated page.
_

Patches currently in -mm which might be from anshuman.khandual@arm.com are

mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch

