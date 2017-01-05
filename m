From: akpm@linux-foundation.org
Subject: + mm-dont-dereference-struct-page-fields-of-invalid-pages.patch
 added to -mm tree
Date: Thu, 05 Jan 2017 15:34:17 -0800
Message-ID: <586ed7f9.dYeYGusbcJVYPeb0%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1162114AbdAEXll (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2017 18:41:41 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hanjun.guo@linaro.org, james.morse@arm.com, rrichter@cavium.com, will.deacon@arm.com, xieyisheng1@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: don't dereference struct page fields of invalid pages
has been added to the -mm tree.  Its filename is
     mm-dont-dereference-struct-page-fields-of-invalid-pages.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-dont-dereference-struct-page-fields-of-invalid-pages.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-dont-dereference-struct-page-fields-of-invalid-pages.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: mm: don't dereference struct page fields of invalid pages

The VM_BUG_ON() check in move_freepages() checks whether the node id of a
page matches the node id of its zone.  However, it does this before having
checked whether the struct page pointer refers to a valid struct page to
begin with.  This is guaranteed in most cases, but may not be the case if
CONFIG_HOLES_IN_ZONE=y.

So reorder the VM_BUG_ON() with the pfn_valid_within() check.

Link: http://lkml.kernel.org/r/1481706707-6211-2-git-send-email-ard.biesheuvel@linaro.org
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Robert Richter <rrichter@cavium.com>
Cc: James Morse <james.morse@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN mm/page_alloc.c~mm-dont-dereference-struct-page-fields-of-invalid-pages mm/page_alloc.c
--- a/mm/page_alloc.c~mm-dont-dereference-struct-page-fields-of-invalid-pages
+++ a/mm/page_alloc.c
@@ -1864,14 +1864,14 @@ int move_freepages(struct zone *zone,
 #endif
 
 	for (page = start_page; page <= end_page;) {
-		/* Make sure we are not inadvertently changing nodes */
-		VM_BUG_ON_PAGE(page_to_nid(page) != zone_to_nid(zone), page);
