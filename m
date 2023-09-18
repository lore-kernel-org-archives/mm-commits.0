Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32466C46CA1
	for <mm-commits@archiver.kernel.org>; Mon, 18 Sep 2023 15:35:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229611AbjIRPe4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 18 Sep 2023 11:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbjIRPeo (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 18 Sep 2023 11:34:44 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E61F1FC2
        for <mm-commits@vger.kernel.org>; Mon, 18 Sep 2023 08:30:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A1F4C32796;
        Mon, 18 Sep 2023 15:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1695050249;
        bh=aZd3gOeZKRhuLQcor9k0Sbl5MuhHKt0JxeYdLqTTIPU=;
        h=Date:To:From:Subject:From;
        b=v6UITojoQelYrGX/kYObQxe1+2O8xqEaIbBIN+z42Ia7PPXryVIpqnzd+xdpYtdpv
         9pd/imC9SE0RaOzUfMxuOzJe83WbcxtrusZOBbwtcxV3BPdx4T0jw34pdnXvrcyHGm
         oohiYad9PrPzh4iK1QmcTxepPWloVnziVYXQrNRA=
Date:   Mon, 18 Sep 2023 08:17:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        muchun.song@linux.dev, mike.kravetz@oracle.com, david@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch added to mm-unstable branch
Message-Id: <20230918151729.5A1F4C32796@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch

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
From: David Hildenbrand <david@redhat.com>
Subject: mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
Date: Mon, 18 Sep 2023 11:16:57 +0200

While PTE-mapping a THP, we temporarily have an exclusive page of a THP
mapped by both, a PMD and a PTE at the same time.  Update our check to
allow for that combination.

Link: https://lkml.kernel.org/r/d8e5a093-2e22-c14b-7e64-6da280398d9f@redhat.com
Signed-off-by: David Hildenbrand <david@redhat.com>
Reported-by: syzbot+6e4f59235036c3c2e296@syzkaller.appspotmail.com
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/rmap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/rmap.c~mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix
+++ a/mm/rmap.c
@@ -1249,8 +1249,10 @@ void page_add_anon_rmap(struct page *pag
 	}
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(page);
-	VM_WARN_ON_FOLIO(page_mapcount(page) > 1 && PageAnonExclusive(page),
-			 folio);
+	/* While PTE-mapping a THP we have a PMD and a PTE mapping. */
+	VM_WARN_ON_FOLIO((atomic_read(&page->_mapcount) > 0 ||
+			  (folio_test_large(folio) && folio_entire_mapcount(folio) > 1)) &&
+			 PageAnonExclusive(page), folio);
 
 	mlock_vma_folio(folio, vma, compound);
 }
_

Patches currently in -mm which might be from david@redhat.com are

mm-rmap-drop-stale-comment-in-page_add_anon_rmap-and-hugepage_add_anon_rmap.patch
mm-rmap-move-setpageanonexclusive-out-of-__page_set_anon_rmap.patch
mm-rmap-move-folio_test_anon-check-out-of-__folio_set_anon.patch
mm-rmap-warn-on-new-pte-mapped-folios-in-page_add_anon_rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap.patch
mm-rmap-simplify-pageanonexclusive-sanity-checks-when-adding-anon-rmap-fix.patch
mm-rmap-pass-folio-to-hugepage_add_anon_rmap.patch

