Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8BCC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 20 Jan 2022 21:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377853AbiATV0g (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Jan 2022 16:26:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347710AbiATV0f (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 20 Jan 2022 16:26:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BC25C061574
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 13:26:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F3456B81E68
        for <mm-commits@vger.kernel.org>; Thu, 20 Jan 2022 21:26:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DC7C340E0;
        Thu, 20 Jan 2022 21:26:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642713992;
        bh=XlquPzoEv8eRUDFuAcipUNNSjty1ef+0aJtE+Z212gI=;
        h=Date:From:To:Subject:From;
        b=dGKjFHe4SxIkarjt7jV9Qw0Uo832/2I/B8FAJ2k7MuUO6UQX2V9HNbaKGaWcbzemt
         qqeACDauoL2/aC5GOWZl1fLWeaaTAOVzVnpOJGy1xfig3YHGheN+d+mmIjaY8PZcxC
         bHLw7pr0vMYMipehI/WXsvZi/hZ9Ko7PpYagwgW8=
Date:   Thu, 20 Jan 2022 13:26:32 -0800
From:   akpm@linux-foundation.org
To:     anshuman.khandual@arm.com, david@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch
 removed from -mm tree
Message-ID: <20220120212632.aWdG-yYpS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: modify the comment section for alloc_contig_pages()
has been removed from the -mm tree.  Its filename was
     mm-page_alloc-modify-the-comment-section-for-alloc_contig_pages.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -9272,8 +9272,8 @@ static bool zone_spans_last_pfn(const st
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


