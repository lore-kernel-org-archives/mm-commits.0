Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 453F1C433EF
	for <mm-commits@archiver.kernel.org>; Fri,  4 Mar 2022 03:55:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbiCDDzw (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Mar 2022 22:55:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiCDDzw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 3 Mar 2022 22:55:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6400717F69B
        for <mm-commits@vger.kernel.org>; Thu,  3 Mar 2022 19:55:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D64B161AAD
        for <mm-commits@vger.kernel.org>; Fri,  4 Mar 2022 03:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C39CC340E9;
        Fri,  4 Mar 2022 03:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646366104;
        bh=nZ5p6HXB5UZjKOcQ5Jg3vpuwb6NDHz+a3KGxsMIGqnw=;
        h=Date:To:From:Subject:From;
        b=QX3q8yRiX9YqhfbeHiWInr9rdoXX5DKAjrBltS5okJNaKDQ4qSX6JrMH+TMNX82L1
         2e2zchfmPphKefc5MhRbzSZS4R1DRs6iQm90sFaMwZkVBr1JP9Fp/hPmlFTMCAREtR
         Loe56xe5/E3hryvINzYFVwOq00VCDOwOy4PCwogE=
Date:   Thu, 03 Mar 2022 19:55:03 -0800
To:     mm-commits@vger.kernel.org, shy828301@gmail.com,
        kirill.shutemov@linux.intel.com, hughd@google.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch added to -mm tree
Message-Id: <20220304035504.3C39CC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: ClearPageDoubleMap in first page_add_file_rmap()
has been added to the -mm tree.  Its filename is
     mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm/thp: ClearPageDoubleMap in first page_add_file_rmap()

PageDoubleMap is maintained differently for anon and for shmem+file: the
shmem+file one was never cleared, because a safe place to do so could not
be found; so it would blight future use of the cached hugepage until
evicted.

See https://lore.kernel.org/lkml/1571938066-29031-1-git-send-email-yang.shi@linux.alibaba.com/

But page_add_file_rmap() does provide a safe place to do so (though later
than one might wish): allowing testing to return to an initial state
without a damaging drop_caches.

Link: https://lkml.kernel.org/r/61c5cf99-a962-9a25-597a-53ab1bd8fbc0@google.com
Fixes: 9a73f61bdb8a ("thp, mlock: do not mlock PTE-mapped file huge pages")
Signed-off-by: Hugh Dickins <hughd@google.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/mm/rmap.c~mm-thp-clearpagedoublemap-in-first-page_add_file_rmap
+++ a/mm/rmap.c
@@ -1252,6 +1252,17 @@ void page_add_file_rmap(struct page *pag
 		}
 		if (!atomic_inc_and_test(compound_mapcount_ptr(page)))
 			goto out;
+
+		/*
+		 * It is racy to ClearPageDoubleMap in page_remove_file_rmap();
+		 * but page lock is held by all page_add_file_rmap() compound
+		 * callers, and SetPageDoubleMap below warns if !PageLocked:
+		 * so here is a place that DoubleMap can be safely cleared.
+		 */
+		VM_WARN_ON_ONCE(!PageLocked(page));
+		if (nr == nr_pages && PageDoubleMap(page))
+			ClearPageDoubleMap(page);
+
 		if (PageSwapBacked(page))
 			__mod_lruvec_page_state(page, NR_SHMEM_PMDMAPPED,
 						nr_pages);
_

Patches currently in -mm which might be from hughd@google.com are

memfd-fix-f_seal_write-after-shmem-huge-page-allocated.patch
tmpfs-support-for-file-creation-time-fix.patch
mm-thp-clearpagedoublemap-in-first-page_add_file_rmap.patch

