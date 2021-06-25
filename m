Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D431BC49EA6
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:11:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA8EE613BA
	for <mm-commits@archiver.kernel.org>; Fri, 25 Jun 2021 00:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232873AbhFYAOJ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Jun 2021 20:14:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:39074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232850AbhFYAOI (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 24 Jun 2021 20:14:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6936023D;
        Fri, 25 Jun 2021 00:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624579909;
        bh=jXy26A9k30IudmUJHUhw2Y8u7JzS40hOzhCtemK83Uw=;
        h=Date:From:To:Subject:From;
        b=bnctGFwRBK9STVMZoCAU22ZJI0ttZ2DB7H+08zmnrqieGbnMv2MXOHtB6nyDVpxfR
         MnA8n44NHGkLVQS4vL861IfoLx5eV9QjmIOcoc2FEIEJJG+r8CkuKx+NbBSNYtWq3p
         /YT9M7/nVCnfE/oTrOuEN+TWV4ms1yfX3ZTc4hhU=
Date:   Thu, 24 Jun 2021 17:11:48 -0700
From:   akpm@linux-foundation.org
To:     alexanderduyck@fb.com, anshuman.khandual@arm.com,
        catalin.marinas@arm.com, david@redhat.com, gshan@redhat.com,
        mm-commits@vger.kernel.org, mst@redhat.com, will@kernel.org
Subject:  +
 virtio_balloon-specify-page-reporting-order-if-needed.patch added to -mm
 tree
Message-ID: <20210625001148.woEnpxOU9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: virtio_balloon: specify page reporting order if needed
has been added to the -mm tree.  Its filename is
     virtio_balloon-specify-page-reporting-order-if-needed.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/virtio_balloon-specify-page-reporting-order-if-needed.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/virtio_balloon-specify-page-reporting-order-if-needed.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

Link: https://lkml.kernel.org/r/20210625014710.42954-5-gshan@redhat.com
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
mm-page_reporting-export-reporting-order-as-module-parameter.patch
mm-page_reporting-allow-driver-to-specify-reporting-order.patch
virtio_balloon-specify-page-reporting-order-if-needed.patch

