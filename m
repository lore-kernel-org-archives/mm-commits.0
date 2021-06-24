Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A26DCC49EA5
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:08:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8184A613D6
	for <mm-commits@archiver.kernel.org>; Thu, 24 Jun 2021 20:08:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhFXUKl (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 16:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232370AbhFXUKl (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 16:10:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 96706613B1;
        Thu, 24 Jun 2021 20:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624565300;
        bh=Dw2VHMI7UmPTGaW2tUfd1H0IVrBJ9ChRcnm1PuiSBZ4=;
        h=Date:From:To:Subject:From;
        b=Xb0gD5IM0WZDeLeh627FVtkpJSTzFUNHqMM4nAsI6TCehemn4RoWe22eq5UkxJz7r
         MtaJA/zfwTiND/2n4mHHHJdQ/2+MMo0jRlP4yCR9MkCmmLurn3Ib77lIK5S9UADR6n
         W1/VpFEkQoJWNRxxnZhbPMlDvP+083goTFuonSdA=
Date:   Thu, 24 Jun 2021 13:08:20 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  [failures]
 virtio_balloon-specify-page-reporting-order-if-needed.patch removed from
 -mm tree
Message-ID: <20210624200820.eev6J19pC%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon: specify page reporting order if needed
has been removed from the -mm tree.  Its filename was
     virtio_balloon-specify-page-reporting-order-if-needed.patch

This patch was dropped because it had testing failures

------------------------------------------------------
From: Gavin Shan <gshan@redhat.com>
Subject: virtio_balloon: specify page reporting order if needed

The page reporting won't be triggered if the freeing page can't come up
with a free area, whose size is equal or bigger than the threshold (page
reporting order).  The default page reporting order, equal to
@pageblock_order, is too huge on some architectures to trigger page
reporting.  One example is ARM64 when 64KB base page size is used.

      PAGE_SIZE:          64KB
      pageblock_order:    13       (512MB)
      MAX_ORDER:          14

This specifies the page reporting order to 5 (2MB) for this specific case
so that page reporting can be triggered.

Link: https://lkml.kernel.org/r/20210623023418.350616-5-gshan@redhat.com
Signed-off-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/virtio/virtio_balloon.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/virtio/virtio_balloon.c~virtio_balloon-specify-page-reporting-order-if-needed
+++ a/drivers/virtio/virtio_balloon.c
@@ -993,6 +993,23 @@ static int virtballoon_probe(struct virt
 			goto out_unregister_oom;
 		}
 
+		/*
+		 * The default page reporting order is @pageblock_order, which
+		 * corresponds to 512MB in size on ARM64 when 64KB base page
+		 * size is used. The page reporting won't be triggered if the
+		 * freeing page can't come up with a free area like that huge.
+		 * So we specify the page reporting order to 5, corresponding
+		 * to 2MB. It helps to avoid THP splitting if 4KB base page
+		 * size is used by host.
+		 *
+		 * Ideally, the page reporting order is selected based on the
+		 * host's base page size. However, it needs more work to report
+		 * that value. The hard-coded order would be fine currently.
+		 */
+#if defined(CONFIG_ARM64) && defined(CONFIG_ARM64_64K_PAGES)
+		vb->pr_dev_info.order = 5;
+#endif
+
 		err = page_reporting_register(&vb->pr_dev_info);
 		if (err)
 			goto out_unregister_oom;
_

Patches currently in -mm which might be from gshan@redhat.com are

mm-page_reporting-fix-code-style-in-__page_reporting_request.patch

