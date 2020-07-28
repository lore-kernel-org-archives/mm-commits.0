Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5894C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:06:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0CAA2070A
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 22:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595973991;
	bh=kLDvPh5+ZG9dUTEDQ7H0mEammFKmGlC4VEeXF3s9Hjo=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=CBMEu5DMjWDtwr82rZxPZoHSpkvo+LADtazmUnCG8xhIZuR+Gm5VwJhZpF/sx62t5
	 m+xzG6Cbn+p0SHyR0rQ/ERmzveHhpIM2Z2Q5kNHuG09Ld9yt5C8llrbUFyd+n7d3m5
	 oYJrXha/ALdE4EC7vgCvucXXc9VIp/4bh43M0PL4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729512AbgG1WGb (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 18:06:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729427AbgG1WGb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 18:06:31 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91DF420672;
        Tue, 28 Jul 2020 22:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595973990;
        bh=kLDvPh5+ZG9dUTEDQ7H0mEammFKmGlC4VEeXF3s9Hjo=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=WjvSz9NoI6Uibo5vs1LE+q+WaLV/FgEzQgzPn3h0Y+IWoDuYW1ILmxArKh27m7h6g
         9QDG/V+ZboIDzCwO/LhPkS26zjziV7GQhdSjK1mweh20j/1bzR41j2sGsRxGQh0Wht
         lH9VvF3zickheJ77NURdQcGGjK96edDNrCuGv7kU=
Date:   Tue, 28 Jul 2020 15:06:30 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     alex.shi@linux.alibaba.com, alexander.h.duyck@linux.intel.com,
        mm-commits@vger.kernel.org
Subject:  +
 mm-compaction-correct-the-comments-of-compact_defer_shift.patch added to
 -mm tree
Message-ID: <20200728220630.TWjWwOIAQ%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/compaction: correct the comments of compact_defer_shift
has been added to the -mm tree.  Its filename is
     mm-compaction-correct-the-comments-of-compact_defer_shift.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-compaction-correct-the-comments-of-compact_defer_shift.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-compaction-correct-the-comments-of-compact_defer_shift.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm/compaction: correct the comments of compact_defer_shift

There is no compact_defer_limit. It should be compact_defer_shift in
use. and add compact_order_failed explanation.

Link: http://lkml.kernel.org/r/3bd60e1b-a74e-050d-ade4-6e8f54e00b92@linux.alibaba.com
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmzone.h |    1 +
 mm/compaction.c        |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h~mm-compaction-correct-the-comments-of-compact_defer_shift
+++ a/include/linux/mmzone.h
@@ -536,6 +536,7 @@ struct zone {
 	 * On compaction failure, 1<<compact_defer_shift compactions
 	 * are skipped before trying again. The number attempted since
 	 * last failure is tracked with compact_considered.
+	 * compact_order_failed is the minimum compaction failed order.
 	 */
 	unsigned int		compact_considered;
 	unsigned int		compact_defer_shift;
--- a/mm/compaction.c~mm-compaction-correct-the-comments-of-compact_defer_shift
+++ a/mm/compaction.c
@@ -154,7 +154,7 @@ EXPORT_SYMBOL(__ClearPageMovable);
 
 /*
  * Compaction is deferred when compaction fails to result in a page
- * allocation success. 1 << compact_defer_limit compactions are skipped up
+ * allocation success. 1 << compact_defer_shift, compactions are skipped up
  * to a limit of 1 << COMPACT_MAX_DEFER_SHIFT
  */
 void defer_compaction(struct zone *zone, int order)
_

Patches currently in -mm which might be from alex.shi@linux.alibaba.com are

mm-compaction-correct-the-comments-of-compact_defer_shift.patch

