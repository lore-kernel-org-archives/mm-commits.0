Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93053C433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:09:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357154AbiCYBLX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357142AbiCYBLR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:11:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4267360077
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1714B82707
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A404C340EC;
        Fri, 25 Mar 2022 01:09:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648170581;
        bh=JEwlsmaCWsYPSfq4eMAfyXLhoiviqfYNsh02Ru88fq0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=lvBSUYJJ0rJRnJx3HIaHwVNWCIZwr9mZ6jlykJWrLEM+Qq68v29n88az47NrtlzCE
         +nnNbMoSMSgCZ8OirjaqaUqvDwgLpb7xXT3M2XVz+7zYJ3BjJjiCt4veJNcqyOJ3Kl
         EwwFQ8P8mGi39yOTHdgeIKChBnKSP3aVkAq1QqaU=
Date:   Thu, 24 Mar 2022 18:09:40 -0700
To:     david@redhat.com, hch@lst.de, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 022/114] mm: unexport page_init_poison
Message-Id: <20220325010941.7A404C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: mm: unexport page_init_poison

page_init_poison is only used in core MM code, so unexport it.

Link: https://lkml.kernel.org/r/20220207063446.1833404-1-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/debug.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/debug.c~mm-unexport-page_init_poison
+++ a/mm/debug.c
@@ -261,5 +261,4 @@ void page_init_poison(struct page *page,
 	if (page_init_poisoning)
 		memset(page, PAGE_POISON_PATTERN, size);
 }
-EXPORT_SYMBOL_GPL(page_init_poison);
 #endif		/* CONFIG_DEBUG_VM */
_
