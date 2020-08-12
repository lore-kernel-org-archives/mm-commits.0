Return-Path: <SRS0=McLq=BW=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3179C433E4
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83B1820829
	for <mm-commits@archiver.kernel.org>; Wed, 12 Aug 2020 01:32:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597195931;
	bh=e+27seuMnTrme4v8GgqWjjcVj/3u2w01LyGWJ+OL6xM=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=NfPXvoYc9aeSCE/uzevtQvEmSvwJbBoXyWMqZUg0wmCfETkm1LODb3OiCNs5qC9gs
	 YJRI3ztdGXNCsHHqADcJ3jIkVZerSsjANqPwlwFsLCGsBF9lhYvx+oHp5VIHBQGsPh
	 KuLncYf6LIA2VUL3k5ToI0Sfwk6muLJ/NHXUEy/c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgHLBcL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 11 Aug 2020 21:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:60354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726531AbgHLBcK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 11 Aug 2020 21:32:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 169FE2076C;
        Wed, 12 Aug 2020 01:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597195930;
        bh=e+27seuMnTrme4v8GgqWjjcVj/3u2w01LyGWJ+OL6xM=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=OW9ZI/hoo8g4ZgqRfb+WWlzzoNWObU+5zsI9H4wFqGvJXtcCtG3JR8Vs1KzOxRUOT
         EOhQ4/BS0ULtPrWps+NznFs6RPqnSN1AdaEDLedb3jmDpJGVIoF2djOoWOBV8K3wOb
         qAnDPrOJ/mZTE26BnPyYP/D4QAtiP8c1zhEu8qug=
Date:   Tue, 11 Aug 2020 18:32:09 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, jgg@nvidia.com, krzk@kernel.org,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 036/165] mm: mmu_notifier: fix and extend
 kerneldoc
Message-ID: <20200812013209.hNrqRMQI1%akpm@linux-foundation.org>
In-Reply-To: <20200811182949.e12ae9a472e3b5e27e16ad6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
