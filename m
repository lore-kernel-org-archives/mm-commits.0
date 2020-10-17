Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B82E7C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8996A21582
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976516;
	bh=LHwdFnkWtSLSOvSabjnALNiw0+W9/t6aQCjsd6fLkvM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=sGX27+KWQ9ZfF76cM+3r0tNSZx7EEPOmtF2aGf/p7QoItH10cIOcuj/5qP1VazhX1
	 kUKHtaEw+CjH2mynrZ16BFjDKeqqjD6lQ3FdYEcOsagu9HRP9lT72toP3XQv0MHD0P
	 KPobcY97G9KYg2OhgJKiJZC6VlTiHSxiXOZoHWZ0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439913AbgJQXPQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPP (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:15 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6D0D221D7F;
        Sat, 17 Oct 2020 23:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976515;
        bh=LHwdFnkWtSLSOvSabjnALNiw0+W9/t6aQCjsd6fLkvM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=n9JGR0rGY7aua+VWubvnVDD+xYEzL9/YmLj2/TSNl990PdI83q/KbiaECnC/bqjlv
         GQ/4BfxAPWheZkslO5LbvBKeYUCkahUpSoOvoS/ZyysqjuriTVohJTzYzOmtitK4pS
         RZSwQDgbR3UxWEwoFr2610poBV75+YrMTuqzp1BE=
Date:   Sat, 17 Oct 2020 16:15:14 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 30/40] mm: allow a NULL fn callback in
 apply_to_page_range
Message-ID: <20201017231514.wi5ZbtIfe%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
