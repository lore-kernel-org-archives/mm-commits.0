Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AE8C2D0E4
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:56:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90E6021D79
	for <mm-commits@archiver.kernel.org>; Thu, 12 Nov 2020 23:56:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="XLTJQxqz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgKLX4h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 Nov 2020 18:56:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:36366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKLX4g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 12 Nov 2020 18:56:36 -0500
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F1BAE20723;
        Thu, 12 Nov 2020 23:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605225396;
        bh=88X30uurAbHvQpsFcJ6s4ZcEfLdxzHVnv4Aj4gLufA0=;
        h=Date:From:To:Subject:From;
        b=XLTJQxqzxNPmNPNq1qRvswDlADncB/5kYTJMmYnD9K2OSGb52lHXzep3uJ5pKg7Ns
         CGqAEP3dQsHQGWsdQJgt+gF13ZIbSgmJ6jZlXRJ7ORBZoEo5RXk+dAYI9+dLlnS8yl
         zKaX/WhcsEaMCznQMHGpbZOojjI/0Yrl/Q/LkUdk=
Date:   Thu, 12 Nov 2020 15:56:35 -0800
From:   akpm@linux-foundation.org
To:     david@redhat.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        osalvador@suse.de, vbabka@suse.cz
Subject:  +
 mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch added to -mm
 tree
Message-ID: <20201112235635.NYeQXfWRS%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-disable-pcplists-during-memory-offline-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm-page_alloc-disable-pcplists-during-memory-offline-fix

add comment, per David

Link: https://lkml.kernel.org/r/527480ef-ed72-e1c1-52a0-1c5b0113df45@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-disable-pcplists-during-memory-offline-fix
+++ a/mm/page_alloc.c
@@ -3024,6 +3024,16 @@ static void drain_local_pages_wq(struct
 	preempt_enable();
 }
 
+/*
+ * The implementation of drain_all_pages(), exposing an extra parameter to
+ * drain on all cpus.
+ *
+ * drain_all_pages() is optimized to only execute on cpus where pcplists are
+ * not empty. The check for non-emptiness can however race with a free to
+ * pcplist that has not yet increased the pcp->count from 0 to 1. Callers
+ * that need the guarantee that every CPU has drained can disable the
+ * optimizing racy check.
+ */
 void __drain_all_pages(struct zone *zone, bool force_all_cpus)
 {
 	int cpu;
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-kmem_cache_debug_flags-in-deactivate_slab.patch
mm-page_alloc-clean-up-pageset-high-and-batch-update.patch
mm-page_alloc-calculate-pageset-high-and-batch-once-per-zone.patch
mm-page_alloc-remove-setup_pageset.patch
mm-page_alloc-simplify-pageset_update.patch
mm-page_alloc-cache-pageset-high-and-batch-in-struct-zone.patch
mm-page_alloc-move-draining-pcplists-to-page-isolation-users.patch
mm-page_alloc-disable-pcplists-during-memory-offline.patch
mm-page_alloc-disable-pcplists-during-memory-offline-fix.patch

