Return-Path: <SRS0=lrFz=DV=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 503B7C433E7
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E9492206CB
	for <mm-commits@archiver.kernel.org>; Wed, 14 Oct 2020 21:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602709370;
	bh=gNskEvs8wYSZ2tqOXWxjzqoSYGaIawHOcdRLJ0Ft8Ng=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=rQLVM3BeDKmg2X2nZSAO3+Fl8dJGOsEjmWnEJtdIRx8+NFZ0I5AdhhUSAWfbBcPS5
	 LNHrC5dDCJ/hekT6VK5ZEPh6Sdd+6TUChMEdWBFwQEgz2HLhntEyJlLg0NUlzngU2x
	 772LGanDmRFmpWZIrTu5bP9/yWRXUDl+TPbK+vLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730721AbgJNVCt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 14 Oct 2020 17:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgJNVCt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 14 Oct 2020 17:02:49 -0400
Received: from localhost.localdomain (c-71-198-47-131.hsd1.ca.comcast.net [71.198.47.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C83B206B2;
        Wed, 14 Oct 2020 21:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602709368;
        bh=gNskEvs8wYSZ2tqOXWxjzqoSYGaIawHOcdRLJ0Ft8Ng=;
        h=Date:From:To:Subject:From;
        b=I1Cpt+XjGCr4vcNq6S9KBnToIrIoNTcZ1u1bh+hjAGKQRNZN8x+t9Iz23Ggho/0bq
         cPPjxz82VAeXNAFRo+YmkosfJmFTCRYlh4nvSS/ibOYXcbBp5jy1lTCrypra75bwJk
         pSyi9iQINbJ/eN+wqf8IGhHmfd7ubJA+jI8nAQEE=
Date:   Wed, 14 Oct 2020 14:02:48 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, mateusznosek0@gmail.com,
        mm-commits@vger.kernel.org
Subject:  [merged]
 mm-page_allocc-fix-early-params-garbage-value-accesses.patch removed from
 -mm tree
Message-ID: <20201014210248.a0y4ckt_z%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/page_alloc.c: fix early params garbage value accesses
has been removed from the -mm tree.  Its filename was
     mm-page_allocc-fix-early-params-garbage-value-accesses.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mateusz Nosek <mateusznosek0@gmail.com>
Subject: mm/page_alloc.c: fix early params garbage value accesses

Previously in '__init early_init_on_alloc' and '__init early_init_on_free'
the return values from 'kstrtobool' were not handled properly.  That
caused potential garbage value read from variable 'bool_result'. 
Introduced patch fixes error handling.

Link: https://lkml.kernel.org/r/20200916214125.28271-1-mateusznosek0@gmail.com
Signed-off-by: Mateusz Nosek <mateusznosek0@gmail.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/mm/page_alloc.c~mm-page_allocc-fix-early-params-garbage-value-accesses
+++ a/mm/page_alloc.c
@@ -156,16 +156,16 @@ static int __init early_init_on_alloc(ch
 	int ret;
 	bool bool_result;
 
-	if (!buf)
-		return -EINVAL;
 	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
 	if (bool_result && page_poisoning_enabled())
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_alloc\n");
 	if (bool_result)
 		static_branch_enable(&init_on_alloc);
 	else
 		static_branch_disable(&init_on_alloc);
-	return ret;
+	return 0;
 }
 early_param("init_on_alloc", early_init_on_alloc);
 
@@ -174,16 +174,16 @@ static int __init early_init_on_free(cha
 	int ret;
 	bool bool_result;
 
-	if (!buf)
-		return -EINVAL;
 	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
 	if (bool_result && page_poisoning_enabled())
 		pr_info("mem auto-init: CONFIG_PAGE_POISONING is on, will take precedence over init_on_free\n");
 	if (bool_result)
 		static_branch_enable(&init_on_free);
 	else
 		static_branch_disable(&init_on_free);
-	return ret;
+	return 0;
 }
 early_param("init_on_free", early_init_on_free);
 
_

Patches currently in -mm which might be from mateusznosek0@gmail.com are

mm-page_poisonc-replace-bool-variable-with-static-key.patch

