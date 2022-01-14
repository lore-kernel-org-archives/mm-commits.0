Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA19DC433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbiANWHi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:07:38 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59654 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230202AbiANWHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:07:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C1CEB825F5
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA01C36AE5;
        Fri, 14 Jan 2022 22:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642198054;
        bh=WDobod/aoY5bdGeRdkcta3oKakA6AJ5+WGq6wRljvQo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=UXT6Pnn+zO0rf0Ts96NiNt2tgid21g2QNJDKLObDJ+89D9thmjPln87OBfmoyx4Y6
         SuMy8plvtSibxrRVpn3K9TqSCsoVP8LPA0YIInFnWh9e0ehmhCWDylXfiHf8qKmYdA
         /LweWUWN6/qQffMGQPh/6Vyf6WjLSbLj+nLYtntI=
Date:   Fri, 14 Jan 2022 14:07:33 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, anshuman.khandual@arm.com,
        david@redhat.com, linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 084/146] mm/page_alloc.c: modify the comment
 section for alloc_contig_pages()
Message-ID: <20220114220733.mDKSUOxi2%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
