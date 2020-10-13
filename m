Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41CBDC43467
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04A6622200
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633204;
	bh=pQ/fx9SwOVZ3UpfdSvTg6Va21OAz6g0thpuxuObBGaA=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=0XbKdg/m06DzLRlHbgGn6ld8BJT6GQTVOjNLzXpzhOUPgqTmarSMYFSjDMDus6ZdT
	 Mzvqm8NKlwZEmJj477cxZT4QLFgcXADNRHz8u3wb6CTjjep+QOBxirdAmRghXqYFR5
	 v8RIkIgZDoJI2620x0zVeKBaFwpXrjzm/QCItdCo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730087AbgJMXxX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:53:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730085AbgJMXwe (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:52:34 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E04921D7B;
        Tue, 13 Oct 2020 23:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633153;
        bh=pQ/fx9SwOVZ3UpfdSvTg6Va21OAz6g0thpuxuObBGaA=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=F20R9S98eoCZIJq01/qtdYC94j6y4NEchGEgljbFmjlhyAaS/L+N8bmmCR5ceo+TD
         /SBb0fJyH/i8IXGP6DeeRJ41VwynfS0ZApIaPWY34pwJk9ILNZeZYJNw2RQiXhjxuP
         YOuw+1i3wJ8HYGk9AF3BBtVTtFZSNvMoq0z0O79I=
Date:   Tue, 13 Oct 2020 16:52:33 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, dan.j.williams@intel.com,
        ira.weiny@intel.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        vishal.l.verma@intel.com, william.kucharski@oracle.com
Subject:  [patch 077/181] mm/memremap.c: convert devmap static
 branch to {inc,dec}
Message-ID: <20201013235233.t-QL6UOhs%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Ira Weiny <ira.weiny@intel.com>
Subject: mm/memremap.c: convert devmap static branch to {inc,dec}

While reviewing Protection Key Supervisor support it was pointed out that
using a counter to track static branch enable was an anti-pattern which
was better solved using the provided static_branch_{inc,dec} functions.[1]

Fix up devmap_managed_key to work the same way.  Also this should be safer
because there is a very small (very unlikely) race when multiple callers
try to enable at the same time.

[1] https://lore.kernel.org/lkml/20200714194031.GI5523@worktop.programming.kicks-ass.net/

Link: https://lkml.kernel.org/r/20200810235319.2796597-1-ira.weiny@intel.com
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: William Kucharski <william.kucharski@oracle.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memremap.c |    7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

--- a/mm/memremap.c~memremap-convert-devmap-static-branch-to-incdec
+++ a/mm/memremap.c
@@ -40,12 +40,10 @@ EXPORT_SYMBOL_GPL(memremap_compat_align)
 #ifdef CONFIG_DEV_PAGEMAP_OPS
 DEFINE_STATIC_KEY_FALSE(devmap_managed_key);
 EXPORT_SYMBOL(devmap_managed_key);
-static atomic_t devmap_managed_enable;
 
 static void devmap_managed_enable_put(void)
 {
-	if (atomic_dec_and_test(&devmap_managed_enable))
-		static_branch_disable(&devmap_managed_key);
+	static_branch_dec(&devmap_managed_key);
 }
 
 static int devmap_managed_enable_get(struct dev_pagemap *pgmap)
@@ -56,8 +54,7 @@ static int devmap_managed_enable_get(str
 		return -EINVAL;
 	}
 
-	if (atomic_inc_return(&devmap_managed_enable) == 1)
-		static_branch_enable(&devmap_managed_key);
+	static_branch_inc(&devmap_managed_key);
 	return 0;
 }
 #else
_
