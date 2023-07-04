Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A4CDEB64D9
	for <mm-commits@archiver.kernel.org>; Tue,  4 Jul 2023 16:38:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbjGDQic (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 4 Jul 2023 12:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbjGDQib (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 4 Jul 2023 12:38:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B28110CF
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 09:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7A13612A1
        for <mm-commits@vger.kernel.org>; Tue,  4 Jul 2023 16:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B34C433C7;
        Tue,  4 Jul 2023 16:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1688488709;
        bh=+3P4oJxBQBpO2bi/vh7qrlPMEXFC2Th7jPX39yNffvY=;
        h=Date:To:From:Subject:From;
        b=zXzIVgJcyykLl3jAFuEOCsgwwc8F5nRIvgW4VK6bxdCd7orjjcUjfP4K/RAJKGQyH
         Is6D+DPEQYR+pZXa6M+mzQBZW3MmDuz1iZ0CFtvDXFv0GLEttcmHjce3tOKnGmQ4oU
         OWBqK87a5yNqQHUBdJ4O72TJsiRrxF14MlWS0mMk=
Date:   Tue, 04 Jul 2023 09:38:28 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-page_alloc-avoid-false-page-outside-zone-error-info.patch added to mm-unstable branch
Message-Id: <20230704163829.25B34C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_alloc: avoid false page outside zone error info
has been added to the -mm mm-unstable branch.  Its filename is
     mm-page_alloc-avoid-false-page-outside-zone-error-info.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-page_alloc-avoid-false-page-outside-zone-error-info.patch

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
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm: page_alloc: avoid false page outside zone error info
Date: Tue, 4 Jul 2023 19:18:23 +0800

If pfn is outside zone boundaries in the first round, ret will be set to
1.  But if pfn is changed to inside the zone boundaries in zone span
seqretry path, ret is still set to 1 leading to false page outside zone
error info.

This is from code inspection.  The race window should be really small thus
hard to trigger in real world.

Link: https://lkml.kernel.org/r/20230704111823.940331-1-linmiaohe@huawei.com
Fixes: bdc8cb984576 ("[PATCH] memory hotplug locking: zone span seqlock")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-avoid-false-page-outside-zone-error-info
+++ a/mm/page_alloc.c
@@ -459,7 +459,7 @@ void set_pageblock_migratetype(struct pa
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
-	int ret = 0;
+	int ret;
 	unsigned seq;
 	unsigned long pfn = page_to_pfn(page);
 	unsigned long sp, start_pfn;
@@ -470,6 +470,8 @@ static int page_outside_zone_boundaries(
 		sp = zone->spanned_pages;
 		if (!zone_spans_pfn(zone, pfn))
 			ret = 1;
+		else
+			ret = 0;
 	} while (zone_span_seqretry(zone, seq));
 
 	if (ret)
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-mm_initc-update-obsolete-comment-in-get_pfn_range_for_nid.patch
mm-memory-failure-fix-unexpected-return-value-in-soft_offline_page.patch
mm-memory-failure-fix-potential-page-refcnt-leak-in-memory_failure.patch
mm-memory-failure-remove-unneeded-page-state-check-in-shake_page.patch
memory-tier-use-helper-function-destroy_memory_type.patch
mm-memory-failure-remove-unneeded-inline-annotation.patch
mm-mm_initc-remove-obsolete-macro-hash_small.patch
mm-page_alloc-avoid-false-page-outside-zone-error-info.patch

