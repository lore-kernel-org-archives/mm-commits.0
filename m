Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 257EEC43457
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D30EE2223F
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602633349;
	bh=YK1Z7EQ6EKGJKfunuRxQYkJkYNyndXtSrSWl7+xqio4=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=1oWHLODivSVb5Et4nzJurGg0keFMAThrwNwClfo133cbRx8ohHSqnZ8RLByECawcg
	 Au0JgySxXhfMC48TWgU+i4k0ave8ekJrG3UtMtcRWcGcinxZiz+5W/g++dv/8wqmm7
	 Re6NzjNOSb9G9bSkpw3HU1jiqwgAQZBnsmUTj9fY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388552AbgJMXzt (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:55:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:41346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387742AbgJMXzt (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:55:49 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFD542222E;
        Tue, 13 Oct 2020 23:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602633348;
        bh=YK1Z7EQ6EKGJKfunuRxQYkJkYNyndXtSrSWl7+xqio4=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=JIJk7EV4Vh+mveDf9imLjxwsDz3BxJBM+L2wtRQf2b4WWiHFACkJauaTh5RMYLL0t
         rSjT8CMgKmHTv6MIZEBxSf3AoHdHRfxD1ZH1KcwHhEzY9GJXlLMKb94kuXZsYlOvs6
         4sDPi11gVzwiuw09KN7pDyVagCAqfbfEKgztY1Ds=
Date:   Tue, 13 Oct 2020 16:55:48 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, linux-mm@kvack.org,
        mateusznosek0@gmail.com, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org
Subject:  [patch 134/181] mm/page_alloc.c: fix early params garbage
 value accesses
Message-ID: <20201013235548.UTQ9GPv9r%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
