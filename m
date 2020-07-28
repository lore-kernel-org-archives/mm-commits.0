Return-Path: <SRS0=nZXm=BH=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293C0C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:53:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01E0920714
	for <mm-commits@archiver.kernel.org>; Tue, 28 Jul 2020 20:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595969607;
	bh=ug2Pok+TAyEnNyP2Xk/8bQXnjz/s1oC0oBv9GVCcKbw=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=OFEN8qJS2oUWGOUpKTm2DcxjQ+S0c/klbMNiG+dx53ieXMwK6YC2fgYmwLoCxkcc3
	 QvBOlHG7NHe6s3oRXQJdi2CzpfPtpP/b2Nn3QPtoj971egrbbv9HOQ8O1VinzacPZe
	 ccRi0aBw3zAfugb6b+gkz21GmZifiRKq8nMq7q4M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728625AbgG1Ux0 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 28 Jul 2020 16:53:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728202AbgG1Ux0 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 28 Jul 2020 16:53:26 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93DDF206D8;
        Tue, 28 Jul 2020 20:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595969605;
        bh=ug2Pok+TAyEnNyP2Xk/8bQXnjz/s1oC0oBv9GVCcKbw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=oec/7qzbdzXYxa0JZtXkfjfQfc9NYgVPxImZC2bz+BoVGt4wn1VMobfe3h6HQYZhG
         svtITsT8GYAqXF/fZM4/sdjUCqGObqhwqWPN2pr3lEjZcJaMO4OMxwsSw2vf2IbjEN
         ysdoduw1wmgUHKfKJVYjARPlkSsNVBJ7JQUwjJtE=
Date:   Tue, 28 Jul 2020 13:53:25 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     jgg@nvidia.com, krzk@kernel.org, mm-commits@vger.kernel.org
Subject:  + mm-mmu_notifier-fix-and-extend-kerneldoc.patch added to
 -mm tree
Message-ID: <20200728205325.wr6YAAtQ5%akpm@linux-foundation.org>
In-Reply-To: <20200723211432.b31831a0df3bc2cbdae31b40@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: mmu_notifier: fix and extend kerneldoc
has been added to the -mm tree.  Its filename is
     mm-mmu_notifier-fix-and-extend-kerneldoc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifier-fix-and-extend-kerneldoc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifier-fix-and-extend-kerneldoc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Krzysztof Kozlowski <krzk@kernel.org>
Subject: mm: mmu_notifier: fix and extend kerneldoc

Fix W=1 compile warnings (invalid kerneldoc):

    mm/mmu_notifier.c:187: warning: Function parameter or member 'interval_sub' not described in 'mmu_interval_read_bgin'
    mm/mmu_notifier.c:708: warning: Function parameter or member 'subscription' not described in 'mmu_notifier_registr'
    mm/mmu_notifier.c:708: warning: Excess function parameter 'mn' description in 'mmu_notifier_register'
    mm/mmu_notifier.c:880: warning: Function parameter or member 'subscription' not described in 'mmu_notifier_put'
    mm/mmu_notifier.c:880: warning: Excess function parameter 'mn' description in 'mmu_notifier_put'
    mm/mmu_notifier.c:982: warning: Function parameter or member 'ops' not described in 'mmu_interval_notifier_insert'

Link: http://lkml.kernel.org/r/20200728171109.28687-4-krzk@kernel.org
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mmu_notifier.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/mm/mmu_notifier.c~mm-mmu_notifier-fix-and-extend-kerneldoc
+++ a/mm/mmu_notifier.c
@@ -166,7 +166,7 @@ static void mn_itree_inv_end(struct mmu_
 /**
  * mmu_interval_read_begin - Begin a read side critical section against a VA
  *                           range
- * interval_sub: The interval subscription
+ * @interval_sub: The interval subscription
  *
  * mmu_iterval_read_begin()/mmu_iterval_read_retry() implement a
  * collision-retry scheme similar to seqcount for the VA range under
@@ -686,7 +686,7 @@ EXPORT_SYMBOL_GPL(__mmu_notifier_registe
 
 /**
  * mmu_notifier_register - Register a notifier on a mm
- * @mn: The notifier to attach
+ * @subscription: The notifier to attach
  * @mm: The mm to attach the notifier to
  *
  * Must not hold mmap_lock nor any other VM related lock when calling
@@ -856,7 +856,7 @@ static void mmu_notifier_free_rcu(struct
 
 /**
  * mmu_notifier_put - Release the reference on the notifier
- * @mn: The notifier to act on
+ * @subscription: The notifier to act on
  *
  * This function must be paired with each mmu_notifier_get(), it releases the
  * reference obtained by the get. If this is the last reference then process
@@ -965,7 +965,8 @@ static int __mmu_interval_notifier_inser
  * @interval_sub: Interval subscription to register
  * @start: Starting virtual address to monitor
  * @length: Length of the range to monitor
- * @mm : mm_struct to attach to
+ * @mm: mm_struct to attach to
+ * @ops: Interval notifier operations to be called on matching events
  *
  * This function subscribes the interval notifier for notifications from the
  * mm.  Upon return the ops related to mmu_interval_notifier will be called
_

Patches currently in -mm which might be from krzk@kernel.org are

mm-swap-fix-kerneldoc-of-swap_vma_readahead.patch
mm-mempolicy-fix-kerneldoc-of-numa_map_to_online_node.patch
mm-mmu_notifier-fix-and-extend-kerneldoc.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
iomap-constify-ioreadx-iomem-argument-as-in-generic-implementation-fix.patch
rtl818x-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
ntb-intel-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch
virtio-pci-constify-ioreadx-iomem-argument-as-in-generic-implementation.patch

