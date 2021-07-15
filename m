Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0858C1B08C
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BBBC61377
	for <mm-commits@archiver.kernel.org>; Thu, 15 Jul 2021 04:26:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236306AbhGOE3h (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 15 Jul 2021 00:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:35954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230076AbhGOE3g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 15 Jul 2021 00:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14CBC61370;
        Thu, 15 Jul 2021 04:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1626323204;
        bh=EvAqvIQgDcf1PNa0VFscBQXiBlZFL89QbmFq6qI+xbw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=vnksTXKzoryNR6zPfA1cz5dIIMAWDD1ZslJyXezxEnMUHjpQnSHnMT7IvKfIipQFx
         bEh50uLuAzZ/8/BaS9xh/MQcRv9fL4SJmmvvMstJI5G9IQR0Y4OT+YAM0BoPBBUkQq
         IlVPZDIVOr1ALJ/C1EEAZFbHLNL2vBYr9GtbZzRE=
Date:   Wed, 14 Jul 2021 21:26:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, david@redhat.com, ddstreet@ieee.org,
        jhubbard@nvidia.com, linux-mm@kvack.org, mcroce@microsoft.com,
        mgorman@techsingularity.net, mhocko@kernel.org,
        mm-commits@vger.kernel.org, shy828301@gmail.com,
        torvalds@linux-foundation.org, vbabka@suse.cz
Subject:  [patch 04/13] Revert "mm/page_alloc: make
 should_fail_alloc_page() static"
Message-ID: <20210715042643.wjrzYaNvu%akpm@linux-foundation.org>
In-Reply-To: <20210714212609.fad116e584ba1194981a6294@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Matteo Croce <mcroce@microsoft.com>
Subject: Revert "mm/page_alloc: make should_fail_alloc_page() static"

This reverts commit f7173090033c70886d925995e9dfdfb76dbb2441.

Fix an unresolved symbol error when CONFIG_DEBUG_INFO_BTF=y:

  LD      vmlinux
  BTFIDS  vmlinux
FAILED unresolved symbol should_fail_alloc_page
make: *** [Makefile:1199: vmlinux] Error 255
make: *** Deleting file 'vmlinux'

Link: https://lkml.kernel.org/r/20210708191128.153796-1-mcroce@linux.microsoft.com
Fixes: f7173090033c ("mm/page_alloc: make should_fail_alloc_page() static")
Signed-off-by: Matteo Croce <mcroce@microsoft.com>
Acked-by: Mel Gorman <mgorman@techsingularity.net>
Tested-by: John Hubbard <jhubbard@nvidia.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Yang Shi <shy828301@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/page_alloc.c~revert-mm-page_alloc-make-should_fail_alloc_page-static
+++ a/mm/page_alloc.c
@@ -3820,7 +3820,7 @@ static inline bool __should_fail_alloc_p
 
 #endif /* CONFIG_FAIL_PAGE_ALLOC */
 
-static noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
+noinline bool should_fail_alloc_page(gfp_t gfp_mask, unsigned int order)
 {
 	return __should_fail_alloc_page(gfp_mask, order);
 }
_
