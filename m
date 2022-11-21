Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58D4CC4332F
	for <mm-commits@archiver.kernel.org>; Mon, 21 Nov 2022 20:06:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230416AbiKUUG2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 21 Nov 2022 15:06:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKUUG2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 21 Nov 2022 15:06:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4264626AE1
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 12:06:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8920B80FB3
        for <mm-commits@vger.kernel.org>; Mon, 21 Nov 2022 20:06:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D93C433D6;
        Mon, 21 Nov 2022 20:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669061184;
        bh=RJ6Ysw4T9Nzk50ToUX9dWqMUr9fREqMxFLVXgmZ8/FM=;
        h=Date:To:From:Subject:From;
        b=ervTbmDM8MxG4C3Jpfgc8X+HBBtW2H15e+WdY25CUE/rksRAWmcOrth8TD0RiVyLf
         CmC9O/9KMGinwKzxfXoyo/9sOH2+qr0ieL/uaBLZWbwygln2GpB/dywcgDV0i1k3l4
         lMdWmbBIPwo4GS3fnlILqweUqBpLywgVJYdcVqU0=
Date:   Mon, 21 Nov 2022 12:06:23 -0800
To:     mm-commits@vger.kernel.org, yuzhao@google.com,
        kirill@shutemov.name, hughd@google.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mmthprmap-subpages_mapcount-of-pte-mapped-subpages-fix.patch added to mm-unstable branch
Message-Id: <20221121200624.60D93C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm,thp,rmap: subpages_mapcount of PTE-mapped subpages: fix
has been added to the -mm mm-unstable branch.  Its filename is
     mmthprmap-subpages_mapcount-of-pte-mapped-subpages-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mmthprmap-subpages_mapcount-of-pte-mapped-subpages-fix.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

------------------------------------------------------
From: Hugh Dickins <hughd@google.com>
Subject: mm,thp,rmap: subpages_mapcount of PTE-mapped subpages: fix
Date: Fri, 18 Nov 2022 17:35:05 -0800 (PST)

Yu Zhao reports compiler warning in page_add_anon_rmap():

mm/rmap.c:1236:13: warning: variable 'first' is used uninitialized
whenever 'if' condition is false [-Wsometimes-uninitialized]
        } else if (PageTransHuge(page)) {
                   ^~~~~~~~~~~~~~~~~~~
mm/rmap.c:1248:18: note: uninitialized use occurs here
        VM_BUG_ON_PAGE(!first && (flags & RMAP_EXCLUSIVE), page);
                        ^~~~~

We do need to fix that, even though it's only uninitialized in an
impossible condition: I've chosen to initialize "first" true, to
minimize the BUGs it might then hit; but you could just as well
choose to initialize it false, to maximize the BUGs it might hit.

Link: https://lkml.kernel.org/r/7a4f5e5e-de33-dace-c526-4a3d3cf5f6e0@google.com
Signed-off-by: Hugh Dickins <hughd@google.com>
Reported-by: Yu Zhao <yuzhao@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/rmap.c~mmthprmap-subpages_mapcount-of-pte-mapped-subpages-fix
+++ a/mm/rmap.c
@@ -1281,7 +1281,7 @@ void page_add_anon_rmap(struct page *pag
 	struct compound_mapcounts mapcounts;
 	int nr = 0, nr_pmdmapped = 0;
 	bool compound = flags & RMAP_COMPOUND;
-	bool first;
+	bool first = true;
 
 	if (unlikely(PageKsm(page)))
 		lock_page_memcg(page);
_

Patches currently in -mm which might be from hughd@google.com are

mmhugetlb-use-folio-fields-in-second-tail-page.patch
mmhugetlb-use-folio-fields-in-second-tail-page-fix.patch
mmthprmap-simplify-compound-page-mapcount-handling.patch
mmthprmap-lock_compound_mapcounts-on-thp-mapcounts.patch
mmthprmap-handle-the-normal-pagecompound-case-first.patch
mmthprmap-subpages_mapcount-of-pte-mapped-subpages.patch
mmthprmap-subpages_mapcount-of-pte-mapped-subpages-fix.patch
mmthprmap-subpages_mapcount-compound_mapped-if-pmd-mapped.patch
mmthprmap-clean-up-the-end-of-__split_huge_pmd_locked.patch

