Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED05BC433FE
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:03:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEAF060200
	for <mm-commits@archiver.kernel.org>; Wed, 13 Oct 2021 23:03:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbhJMXFH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 13 Oct 2021 19:05:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57934 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229575AbhJMXFH (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 13 Oct 2021 19:05:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 13BD6610E5;
        Wed, 13 Oct 2021 23:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634166183;
        bh=dYnEgMitgdaZb/HpsNpF8OiQeCM2Gf4wO7SKdvk9wbk=;
        h=Date:From:To:Subject:From;
        b=XKlVB7PlM3wcj+5RSYjj+VEVX470ImjctvcGAOT9rvxjBVdrtIlERu2h6WF14Q9qq
         T1Gae/FqoVMZE/R3OR3lvkoNystbZdFQE3oHIO7xqithOfXezK+CcIo5bp+OCDXJLE
         dsjHo9XIbTdpM3uYEtfjpP0MEpogfdw+o41H8sRI=
Date:   Wed, 13 Oct 2021 16:03:02 -0700
From:   akpm@linux-foundation.org
To:     hannes@cmpxchg.org, hdanton@sina.com, hughd@google.com,
        kirill.shutemov@linux.intel.com, m.szyprowski@samsung.com,
        mm-commits@vger.kernel.org, oleg@redhat.com, riel@surriel.com,
        sfoon.kim@samsung.com, shy828301@gmail.com, songliubraving@fb.com,
        william.kucharski@oracle.com, willy@infradead.org
Subject:  +
 mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch added to -mm
 tree
Message-ID: <20211013230302.SPHEPRxSs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/thp: decrease nr_thps in file's mapping on THP split
has been added to the -mm tree.  Its filename is
     mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: mm/thp: decrease nr_thps in file's mapping on THP split

Decrease nr_thps counter in file's mapping to ensure that the page cache
won't be dropped excessively on file write access if page has been
already splitted.

I've tried a test scenario, where one runs a big binary, kernel remaps it
with THPs, then one forces THP split with
/sys/kernel/debug/split_huge_pages.  During any further open of that
binary with O_RDWR or O_WRITEONLY kernel drops page cache for it, because
of non-zero thps counter.

Link: https://lkml.kernel.org/r/20211012120237.2600-1-m.szyprowski@samsung.com
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Fixes: 09d91cda0e82 ("mm,thp: avoid writes to file with THP in pagecache")
Fixes: 06d3eff62d9d ("mm/thp: fix node page state in split_huge_page_to_list()")
Acked-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: <sfoon.kim@samsung.com>
Cc: Song Liu <songliubraving@fb.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hillf Danton <hdanton@sina.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: William Kucharski <william.kucharski@oracle.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/huge_memory.c~mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split
+++ a/mm/huge_memory.c
@@ -2700,12 +2700,14 @@ int split_huge_page_to_list(struct page
 		if (mapping) {
 			int nr = thp_nr_pages(head);
 
-			if (PageSwapBacked(head))
+			if (PageSwapBacked(head)) {
 				__mod_lruvec_page_state(head, NR_SHMEM_THPS,
 							-nr);
-			else
+			} else {
 				__mod_lruvec_page_state(head, NR_FILE_THPS,
 							-nr);
+				filemap_nr_thps_dec(mapping);
+			}
 		}
 
 		__split_huge_page(page, list, end);
_

Patches currently in -mm which might be from m.szyprowski@samsung.com are

mm-thp-decrease-nr_thps-in-files-mapping-on-thp-split.patch

