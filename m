Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED9E2C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AB86206E5
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709363;
	bh=49NiUVg3d+P03n9YS+83omiYOGHzIMT7PjGVftsws7A=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=u4hQC5Unxr/FiXhZlMwJlOXC42W30g8T8L6Ttn1ERpRpEpOy2wqNu40jmxMeiuveg
	 DXoqvuCdC2DGe7apogJD93vItv9cj4bSzu7x7qzQWbSoJGTsKi/8uZcccqVDH9ltlj
	 HhE8jVKV118FD42GPNiLTJInoQ3W1yVBa1cqSQ9k=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730711AbgJNVCn (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:52652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCn (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:43 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85E8E206B2;
        Wed, 14 Oct 2020 21:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709362;
        bh=49NiUVg3d+P03n9YS+83omiYOGHzIMT7PjGVftsws7A=;
        h=Date:From:To:Subject:From;
        b=Tm4ZrkJuNt+rS0mK9/RglEOSMQFvK+w0P/MrZNvWYQvaFyjq6BHiAPDgo6ekLf3qD
         K3afZ5u/lydCaTz1MKdMHviamoAzbotHJDzFbt8+Ji8TQdo9waSzm2/wxskn72dR5N
         s/ISy2Ib7UUj+4yCHFD/M+rn3AR5IW7b939I8344=
Date:   Wed, 14 Oct 2020 14:02:42 -0700
From:   akpm@linux-foundation.org
To:     mateusznosek0@gmail.com, mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch
 removed from -mm tree
Message-ID: <20201014210242.7AS5bJx9O%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: clean code by removing unnecessary initialization
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-clean-code-by-removing-unnecessary-initialization.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: clean code by removing unnecessary initialization

Previously variable 'tmp' was initialized, but was not read later before
reassigning.  So the initialization can be removed.

[akpm@linux-foundation.org: remove `tmp' altogether]
Link: https://lkml.kernel.org/r/20200904132422.17387-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-clean-code-by-removing-unnecessary-initialization
+++ a/mm/page_alloc.c
@@ -5651,7 +5651,6 @@ static int find_next_best_node(int node,
 	int n, val;
 	int min_val = INT_MAX;
 	int best_node = NUMA_NO_NODE;
-	const struct cpumask *tmp = cpumask_of_node(0);
 
 	/* Use the local node if we haven't already */
 	if (!node_isset(node, *used_node_mask)) {
@@ -5672,8 +5671,7 @@ static int find_next_best_node(int node,
 		val += (n < node);
 
 		/* Give preference to headless and unused nodes */
-		tmp = cpumask_of_node(n);
-		if (!cpumask_empty(tmp))
+		if (!cpumask_empty(cpumask_of_node(n)))
 			val += PENALTY_FOR_NODE_WITH_CPUS;
 
 		/* Slight preference for less loaded node */
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_poisonc-replace-bool-variable-with-static-key.patch

