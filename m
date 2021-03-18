Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A5BC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 03:10:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDEA864EED
	for <mm-commits@archiver.kernel.org>; Thu, 18 Mar 2021 03:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229702AbhCRDJ7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhCRDJb (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 17 Mar 2021 23:09:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 201E964E90;
        Thu, 18 Mar 2021 03:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1616036970;
        bh=OLdRmMpj1riRM3kOG+T2j5+/8cHFlhWxUj2xuSN0DEU=;
        h=Date:From:To:Subject:From;
        b=lPDVhMWYH53kYu/PqUMRjl9GgsaO0ynOE0RW9GLWW/QyKy59sY2Z37GuVQFHaxJqq
         E3cGbO2j8UTYZZv+KoxG4XicU7BIwSsGwJov2ERxMAV5WfMi4lS54rXQmUc4bLqG3/
         6IpF+v3gAfOLwvfd9kY5/pTeOa07+SBQbSKNlPEI=
Date:   Wed, 17 Mar 2021 20:09:29 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, guro@fb.com, hannes@cmpxchg.org,
        hca@linux.ibm.com, hughd@google.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        shakeelb@google.com
Subject:  +
 memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch added to -mm
 tree
Message-ID: <20210318030929.6rfQBB7xY%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: set page->private before calling swap_readpage
has been added to the -mm tree.  Its filename is
     memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: set page->private before calling swap_readpage

The function swap_readpage() (and other functions it call) extracts swap
entry from page->private.  However for SWP_SYNCHRONOUS_IO, the kernel
skips the swapcache and thus we need to manually set the page->private
with the swap entry before calling swap_readpage().

Link: https://lkml.kernel.org/r/20210318015959.2986837-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: Heiko Carstens <hca@linux.ibm.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/memory.c~memcg-charge-before-adding-to-swapcache-on-swapin-fix
+++ a/mm/memory.c
@@ -3324,7 +3324,11 @@ vm_fault_t do_swap_page(struct vm_fault
 					workingset_refault(page, shadow);
 
 				lru_cache_add(page);
+
+				/* To provide entry to swap_readpage() */
+				set_page_private(page, entry.val);
 				swap_readpage(page, true);
+				set_page_private(page, 0);
 			}
 		} else {
 			page = swapin_readahead(entry, GFP_HIGHUSER_MOVABLE,
_

Patches currently in -mm which might be from shakeelb@google.com are

memcg-cleanup-root-memcg-checks.patch
memcg-enable-memcg-oom-kill-for-__gfp_nofail.patch
memcg-charge-before-adding-to-swapcache-on-swapin.patch
memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch

