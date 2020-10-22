Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A318C5517A
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1300D24650
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408210;
	bh=kwUtI8diJ9bPNAXHSqOZvUX47mcySpYURPuHJD3sy5A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=pUiOA05/XVNbMivrvhRo+OlDx3pqk6XIMI+lZG40719SRzwdl1n6blkcaIJkpbPHR
	 bLjgFoXngtI1b7lRwkV3SXGGWuzBkwK4VSstJ66Q0sz5AUapxeoixGJsVUxW6D79MA
	 VhthCdvDcfotidizv+zhIAuA7t6gmdPitjW44jlg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373259AbgJVXKJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKJ (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:09 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F37872245F;
        Thu, 22 Oct 2020 23:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408208;
        bh=kwUtI8diJ9bPNAXHSqOZvUX47mcySpYURPuHJD3sy5A=;
        h=Date:From:To:Subject:From;
        b=FeL+SS5UQsbNvDekEuvjsp84/fI9/OFJzzZ7bHHPlzVGiCn3hFHyjbEF7vN6okCZk
         3NDb7xRb3qJWIDD7MDd/sO5poFEs11qFUnfMtM3adOrrXreCMt6TUBV5WxtijEeWLa
         zxsi4aX/6TERP+5j77QUj/kCPyieFfNOBYAPsVKw=
Date:   Thu, 22 Oct 2020 16:10:07 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 mm-allow-a-null-fn-callback-in-apply_to_page_range.patch removed from -mm
 tree
Message-ID: <20201022231007.ptSBZlMAG%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: allow a NULL fn callback in apply_to_page_range
has been removed from the -mm tree.  Its filename was
     mm-allow-a-null-fn-callback-in-apply_to_page_range.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Christoph Hellwig <hch@lst.de>
Subject: mm: allow a NULL fn callback in apply_to_page_range

Besides calling the callback on each page, apply_to_page_range also has
the effect of pre-faulting all PTEs for the range.  To support callers
that only need the pre-faulting, make the callback optional.

Based on a patch from Minchan Kim <minchan@kernel.org>.

Link: https://lkml.kernel.org/r/20201002122204.1534411-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/mm/memory.c~mm-allow-a-null-fn-callback-in-apply_to_page_range
+++ a/mm/memory.c
@@ -2391,13 +2391,15 @@ static int apply_to_pte_range(struct mm_
 
 	arch_enter_lazy_mmu_mode();
 
-	do {
-		if (create || !pte_none(*pte)) {
-			err = fn(pte++, addr, data);
-			if (err)
-				break;
-		}
-	} while (addr += PAGE_SIZE, addr != end);
+	if (fn) {
+		do {
+			if (create || !pte_none(*pte)) {
+				err = fn(pte++, addr, data);
+				if (err)
+					break;
+			}
+		} while (addr += PAGE_SIZE, addr != end);
+	}
 	*mask |= PGTBL_PTE_MODIFIED;
 
 	arch_leave_lazy_mmu_mode();
_

Patches currently in -mm which might be from hch@lst.de are


