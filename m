Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C78AC433ED
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 01:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 541C461077
	for <mm-commits@archiver.kernel.org>; Thu,  1 Apr 2021 01:17:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbhDABRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 31 Mar 2021 21:17:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:44264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232866AbhDABQ6 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 31 Mar 2021 21:16:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E8AD61075;
        Thu,  1 Apr 2021 01:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617239818;
        bh=rFACLmwnMmSHPk3+2zmf0v7Y8RCxgwStpWbDTaCkwto=;
        h=Date:From:To:Subject:From;
        b=e4y1Ya+HZF3MHp9N/CYuvBCSOKBonozfj4WGD0LKfrGJEnWDG4RGJxNn9Z4Mq65Hk
         EjrneE2ONunnQeKL3SHTEx9+PE8S2S/PXZxSkghxkAOn7ToSHQBSOrb3tneMgDe7L1
         pBF28PD6CfgVu3gqrDTuiP1jLJSOVGEtScBmMrL8=
Date:   Wed, 31 Mar 2021 18:16:57 -0700
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, alexander.duyck@gmail.com,
        alobakin@pm.me, brouer@redhat.com, chuck.lever@oracle.com,
        davem@davemloft.net, hch@infradead.org,
        ilias.apalodimas@linaro.org, mgorman@techsingularity.net,
        mm-commits@vger.kernel.org, vbabka@suse.cz, willy@infradead.org
Subject:  +
 =?US-ASCII?Q?mm-page=5Falloc-add-an-array-based-interface-to-the-bulk-?=
 =?US-ASCII?Q?page-allocator-fix.patch?= added to -mm tree
Message-ID: <20210401011657.-oBvOJRYa%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix
has been added to the -mm tree.  Its filename is
     mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix

remove now unused local `allocated'

Cc: Alexander Duyck <alexander.duyck@gmail.com>
Cc: Alexander Lobakin <alobakin@pm.me>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Chuck Lever <chuck.lever@oracle.com>
Cc: David Miller <davem@davemloft.net>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/mm/page_alloc.c~mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix
+++ a/mm/page_alloc.c
@@ -5040,7 +5040,6 @@ unsigned long __alloc_pages_bulk(gfp_t g
 	struct alloc_context ac;
 	gfp_t alloc_gfp;
 	unsigned int alloc_flags = ALLOC_WMARK_LOW;
-	int allocated = 0;
 	int nr_populated = 0;
 
 	if (WARN_ON_ONCE(nr_pages <= 0))
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

kasan-remove-redundant-config-option-fix.patch
mm-gup-check-page-posion-status-for-coredump-fix.patch
mm.patch
mm-memcontrol-switch-to-rstat-fix.patch
mm-page_alloc-add-an-array-based-interface-to-the-bulk-page-allocator-fix.patch
mm-vmscan-add-shrinker_info_protected-helper-fix.patch
mmmemory_hotplug-allocate-memmap-from-the-added-memory-range-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
kernel-forkc-export-kernel_thread-to-modules.patch

