Return-Path: <SRS0=Fe7N=DY=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B76C433DF
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8015214DB
	for <mm-commits@archiver.kernel.org>; Sat, 17 Oct 2020 23:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602976520;
	bh=wjTQ5WwxCcfoifS1ViMKtTZCF9uZGnBGRtTwjU53J2I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=H3WejuzKV1WMRP51MZF/UGey3GUsqZehtcCfoCNZ38qmqDSGcAohJHjA9MtaDPu/8
	 uvw23DOoRkBZnLQjzN468IbZSRZXp4Cp7MJheECy35TqPAQjUnYdcMkDVUbpytolid
	 ARZCxGDK4wgOUGqg4GOZKineZJ81ywx04dv36Nqw=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439914AbgJQXPT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 17 Oct 2020 19:15:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439878AbgJQXPS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 17 Oct 2020 19:15:18 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E129B21D41;
        Sat, 17 Oct 2020 23:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602976518;
        bh=wjTQ5WwxCcfoifS1ViMKtTZCF9uZGnBGRtTwjU53J2I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=tJjLCV/GBsrhjinJfqBIus3cZEz9QDzRq2efXukO7I6my+SMH5UQJ3TuAIL8pHk91
         sFDHMNAqXJtLrjOQIOGJztuypXbBVyVVpJ0pyRIDS10wjFdtPGgKSn0llYEXr8f07r
         JOLYzBaMRvDgTlmdx1jD8r8os3DcMT0SBYwK3pVA=
Date:   Sat, 17 Oct 2020 16:15:17 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, boris.ostrovsky@oracle.com,
        chris@chris-wilson.co.uk, hch@lst.de, jani.nikula@linux.intel.com,
        jgross@suse.com, joonas.lahtinen@linux.intel.com,
        linux-mm@kvack.org, matthew.auld@intel.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, torvalds@linux-foundation.org,
        tvrtko.ursulin@intel.com, urezki@gmail.com, willy@infradead.org
Subject:  [patch 31/40] zsmalloc: switch from alloc_vm_area to
 get_vm_area
Message-ID: <20201017231517.RsEnw_-y7%akpm@linux-foundation.org>
In-Reply-To: <20201017161314.88890b87fae7446ccc13c902@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: zsmalloc: switch from alloc_vm_area to get_vm_area

Just manually pre-fault the PTEs using apply_to_page_range.

Link: https://lkml.kernel.org/r/20201002122204.1534411-6-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Co-developed-by: Minchan Kim <minchan@kernel.org>
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

 mm/zsmalloc.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/zsmalloc.c~zsmalloc-switch-from-alloc_vm_area-to-get_vm_area
+++ a/mm/zsmalloc.c
@@ -1122,10 +1122,16 @@ static inline int __zs_cpu_up(struct map
 	 */
 	if (area->vm)
 		return 0;
-	area->vm = alloc_vm_area(PAGE_SIZE * 2, NULL);
+	area->vm = get_vm_area(PAGE_SIZE * 2, 0);
 	if (!area->vm)
 		return -ENOMEM;
-	return 0;
+
+	/*
+	 * Populate ptes in advance to avoid pte allocation with GFP_KERNEL
+	 * in non-preemtible context of zs_map_object.
+	 */
+	return apply_to_page_range(&init_mm, (unsigned long)area->vm->addr,
+			PAGE_SIZE * 2, NULL, NULL);
 }
 
 static inline void __zs_cpu_down(struct mapping_area *area)
_
