From: akpm@linux-foundation.org
Subject: [patch 17/27] mm: don't dereference struct page fields of invalid pages
Date: Tue, 10 Jan 2017 16:58:00 -0800
Message-ID: <58758318.2BvI2UN5B455vl3J%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33456 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759933AbdAKA6C (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 Jan 2017 19:58:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, hanjun.guo@linaro.org, james.morse@arm.com, rrichter@cavium.com, will.deacon@arm.com, xieyisheng1@huawei.com

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
Acked-by: Will Deacon <will.deacon@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Robert Richter <rrichter@cavium.com>
Cc: James Morse <james.morse@arm.com>
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
