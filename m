Return-Path: <SRS0=kBw3=D5=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10BE5C388F7
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACC5D24650
	for <mm-commits@archiver.kernel.org>; Thu, 22 Oct 2020 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603408213;
	bh=oYNNLkR5pFfhOhBsL5On32/IBxDVNxKZCeIyB0a1qAE=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=cs//iyW5QsxLxQ1MqChZoUg51VoimpMMou8mUPCyT9hgYVTyXpVDwt5OWWMJqNzF7
	 X6MJBzErMdJU1MvlZHFipUKyrrfvzeOlbvp6tKhkH5AvwQhPl3eMy9hP3O4BMwpL5e
	 Rdqq4cd2HyEZ/XBXtDDwCvseh5XiX2YgP2APFs7E=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373260AbgJVXKN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 22 Oct 2020 19:10:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S373254AbgJVXKM (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 22 Oct 2020 19:10:12 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E67D824641;
        Thu, 22 Oct 2020 23:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603408211;
        bh=oYNNLkR5pFfhOhBsL5On32/IBxDVNxKZCeIyB0a1qAE=;
        h=Date:From:To:Subject:From;
        b=G0Ui7XqrpSB9GhNY5ga9w3vKm/m5COFqp5RofOCZ+RjWVJOS53+vcU18OrGh/mXhA
         gtCjs/r2iIdeInIazsXUlAzOjgG3xVTx50BKKWPTNYOlAI+KJsTEEgAP9k+9afP7Fp
         JSvBqwmQbT031KTa13ad3DrK5YAcUSAcNKeT6ODg=
Date:   Thu, 22 Oct 2020 16:10:10 -0700
From:   akpm@linux-foundation.org
To:     boris.ostrovsky@oracle.com, chris@chris-wilson.co.uk, hch@lst.de,
        jani.nikula@linux.intel.com, jgross@suse.com,
        joonas.lahtinen@linux.intel.com, matthew.auld@intel.com,
        minchan@kernel.org, mm-commits@vger.kernel.org, ngupta@vflare.org,
        peterz@infradead.org, rodrigo.vivi@intel.com,
        sstabellini@kernel.org, tvrtko.ursulin@intel.com, urezki@gmail.com,
        willy@infradead.org
Subject:  [merged]
 zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch removed from -mm
 tree
Message-ID: <20201022231010.WFFT4VIHf%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: zsmalloc: switch from alloc_vm_area to get_vm_area
has been removed from the -mm tree.  Its filename was
     zsmalloc-switch-from-alloc_vm_area-to-get_vm_area.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from hch@lst.de are


