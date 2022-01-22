Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 822E7C433EF
	for <mm-commits@archiver.kernel.org>; Sat, 22 Jan 2022 06:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiAVGOr (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 22 Jan 2022 01:14:47 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44776 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbiAVGOq (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sat, 22 Jan 2022 01:14:46 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 20ADD60FBB
        for <mm-commits@vger.kernel.org>; Sat, 22 Jan 2022 06:14:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC07C004E1;
        Sat, 22 Jan 2022 06:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642832085;
        bh=SXsAzVtZQJaz7P/EVkE+3mSCPtRfifI7CCh/99oESMk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=YIBdAxLCKaUIIp/pmGtegGYU1kptGgn3XieqC+o3Yqb8dxzDnEIYPQ9XcJuMzXBLb
         Dw5gzwghsK2/bi5++bzOh2eKdWFeFuM/ONmbyL25a/4Wpeoko9RjRC3Ja4VmS4dAOr
         Nqvbg5Y/K5+hMLw+OG6zWQMFWehm+qTSUtKghlGs=
Date:   Fri, 21 Jan 2022 22:14:44 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, ddstreet@ieee.org, geert@linux-m68k.org,
        hch@lst.de, hughd@google.com, jgross@suse.com,
        Konrad.wilk@oracle.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sjenning@redhat.com,
        torvalds@linux-foundation.org, vitaly.wool@konsulko.com,
        willy@infradead.org
Subject:  [patch 60/69] frontswap: remove frontswap_shrink
Message-ID: <20220122061444.1FC7mEObZ%akpm@linux-foundation.org>
In-Reply-To: <20220121221021.60533b009c357d660791476e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>
Subject: frontswap: remove frontswap_shrink

frontswap_shrink is never called, so remove it.

Link: https://lkml.kernel.org/r/20211224062246.1258487-5-hch@lst.de
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Juergen Gross <jgross@suse.com>
Cc: Dan Streetman <ddstreet@ieee.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Konrad Rzeszutek Wilk <Konrad.wilk@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/frontswap.rst |   13 ----
 include/linux/frontswap.h      |    1 
 mm/frontswap.c                 |   83 -------------------------------
 3 files changed, 97 deletions(-)

--- a/Documentation/vm/frontswap.rst~frontswap-remove-frontswap_shrink
+++ a/Documentation/vm/frontswap.rst
@@ -255,19 +255,6 @@ the old data and ensure that it is no lo
 swap subsystem then writes the new data to the read swap device,
 this is the correct course of action to ensure coherency.
 
-* What is frontswap_shrink for?
-
-When the (non-frontswap) swap subsystem swaps out a page to a real
-swap device, that page is only taking up low-value pre-allocated disk
-space.  But if frontswap has placed a page in transcendent memory, that
-page may be taking up valuable real estate.  The frontswap_shrink
-routine allows code outside of the swap subsystem to force pages out
-of the memory managed by frontswap and back into kernel-addressable memory.
-For example, in RAMster, a "suction driver" thread will attempt
-to "repatriate" pages sent to a remote machine back to the local machine;
-this is driven using the frontswap_shrink mechanism when memory pressure
-subsides.
-
 * Why does the frontswap patch create the new include file swapfile.h?
 
 The frontswap code depends on some swap-subsystem-internal data
--- a/include/linux/frontswap.h~frontswap-remove-frontswap_shrink
+++ a/include/linux/frontswap.h
@@ -24,7 +24,6 @@ struct frontswap_ops {
 };
 
 extern void frontswap_register_ops(struct frontswap_ops *ops);
-extern void frontswap_shrink(unsigned long);
 extern unsigned long frontswap_curr_pages(void);
 
 extern bool __frontswap_test(struct swap_info_struct *, pgoff_t);
--- a/mm/frontswap.c~frontswap-remove-frontswap_shrink
+++ a/mm/frontswap.c
@@ -341,89 +341,6 @@ static unsigned long __frontswap_curr_pa
 	return totalpages;
 }
 
-static int __frontswap_unuse_pages(unsigned long total, unsigned long *unused,
-					int *swapid)
-{
-	int ret = -EINVAL;
-	struct swap_info_struct *si = NULL;
-	int si_frontswap_pages;
-	unsigned long total_pages_to_unuse = total;
-	unsigned long pages = 0, pages_to_unuse = 0;
-
-	assert_spin_locked(&swap_lock);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		si_frontswap_pages = atomic_read(&si->frontswap_pages);
-		if (total_pages_to_unuse < si_frontswap_pages) {
-			pages = pages_to_unuse = total_pages_to_unuse;
-		} else {
-			pages = si_frontswap_pages;
-			pages_to_unuse = 0; /* unuse all */
-		}
-		/* ensure there is enough RAM to fetch pages from frontswap */
-		if (security_vm_enough_memory_mm(current->mm, pages)) {
-			ret = -ENOMEM;
-			continue;
-		}
-		vm_unacct_memory(pages);
-		*unused = pages_to_unuse;
-		*swapid = si->type;
-		ret = 0;
-		break;
-	}
-
-	return ret;
-}
-
-/*
- * Used to check if it's necessary and feasible to unuse pages.
- * Return 1 when nothing to do, 0 when need to shrink pages,
- * error code when there is an error.
- */
-static int __frontswap_shrink(unsigned long target_pages,
-				unsigned long *pages_to_unuse,
-				int *type)
-{
-	unsigned long total_pages = 0, total_pages_to_unuse;
-
-	assert_spin_locked(&swap_lock);
-
-	total_pages = __frontswap_curr_pages();
-	if (total_pages <= target_pages) {
-		/* Nothing to do */
-		*pages_to_unuse = 0;
-		return 1;
-	}
-	total_pages_to_unuse = total_pages - target_pages;
-	return __frontswap_unuse_pages(total_pages_to_unuse, pages_to_unuse, type);
-}
-
-/*
- * Frontswap, like a true swap device, may unnecessarily retain pages
- * under certain circumstances; "shrink" frontswap is essentially a
- * "partial swapoff" and works by calling try_to_unuse to attempt to
- * unuse enough frontswap pages to attempt to -- subject to memory
- * constraints -- reduce the number of pages in frontswap to the
- * number given in the parameter target_pages.
- */
-void frontswap_shrink(unsigned long target_pages)
-{
-	unsigned long pages_to_unuse = 0;
-	int type, ret;
-
-	/*
-	 * we don't want to hold swap_lock while doing a very
-	 * lengthy try_to_unuse, but swap_list may change
-	 * so restart scan from swap_active_head each time
-	 */
-	spin_lock(&swap_lock);
-	ret = __frontswap_shrink(target_pages, &pages_to_unuse, &type);
-	spin_unlock(&swap_lock);
-	if (ret == 0)
-		try_to_unuse(type, true, pages_to_unuse);
-	return;
-}
-EXPORT_SYMBOL(frontswap_shrink);
-
 /*
  * Count and return the number of frontswap pages across all
  * swap devices.  This is exported so that backend drivers can
_
