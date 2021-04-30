Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E55F9C433B4
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:24:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF62761445
	for <mm-commits@archiver.kernel.org>; Fri, 30 Apr 2021 05:24:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhD3FYr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 30 Apr 2021 01:24:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:37666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229581AbhD3FYr (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 30 Apr 2021 01:24:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A0B661423;
        Fri, 30 Apr 2021 05:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1619760239;
        bh=IoplVkK/gI3MdNqWDPFNhdaivSyILA9NZYRdjLOqKtE=;
        h=Date:From:To:Subject:From;
        b=0gJVSw6jvqxJxK8fFWXdiDsovmkWhosHD/GAW7XZceeeJXxthlb78b+6HcrT2AkHJ
         QWgVMq+5n0bb/0MHLUwleGHpfVLgy5c3aMQkR9FNKfaR3B+dsZYv3ggyw/bID1WY+Y
         6Wc3itKW9oxTcWKsW/H5ej1wBaolcivyx0EZHMJI=
Date:   Thu, 29 Apr 2021 22:23:58 -0700
From:   akpm@linux-foundation.org
To:     borntraeger@de.ibm.com, guro@fb.com, hannes@cmpxchg.org,
        hca@linux.ibm.com, hughd@google.com, mhocko@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        shakeelb@google.com
Subject:  [folded-merged]
 memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch removed from
 -mm tree
Message-ID: <20210430052358.6QyRDxi-C%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: memcg: set page->private before calling swap_readpage
has been removed from the -mm tree.  Its filename was
     memcg-charge-before-adding-to-swapcache-on-swapin-fix.patch

This patch was dropped because it was folded into memcg-charge-before-adding-to-swapcache-on-swapin.patch

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
Tested-by: Heiko Carstens <hca@linux.ibm.com>
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

