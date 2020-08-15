Return-Path: <SRS0=U74d=BZ=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLACK autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 623ACC433DF
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35710207DA
	for <mm-commits@archiver.kernel.org>; Sat, 15 Aug 2020 00:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597450465;
	bh=nNLf770Ao2q+ixwPT3mJ1DJk2qZngH182kJo0OuAWvU=;
	h=Date:From:To:Subject:Reply-To:List-ID:From;
	b=eq91pSnGeBum/+0NAYu06EZWWK8XMsJ4Q+1GuerotU5hE/KH3xfPaz7oBAVRkKttF
	 36Vqpw28d7VA7NJEG9CXa/PjqDCj6WyDSbbZnZGRaTWKSJXwbk/4LKUFbC7mCTK52e
	 Y8TW6qDggqlG4T5OQX7GhjJQRwj4UwVHnDEishXs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgHOAOY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Aug 2020 20:14:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:50478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726213AbgHOAOY (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 14 Aug 2020 20:14:24 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F32C520781;
        Sat, 15 Aug 2020 00:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597450464;
        bh=nNLf770Ao2q+ixwPT3mJ1DJk2qZngH182kJo0OuAWvU=;
        h=Date:From:To:Subject:From;
        b=15i/eANvt/SnS0+4QvOFaDnwEUeQwE41GRYBh7TvtU1LTQNbtVJSHBS+vBMNrS4Nf
         lNuPLXO96UpgvaPbVVvLk1j5s0l3G8cO4Z0qzohBkk9WBTPC2QOPlPu6m8e38IH/48
         lE5ZaXEWSe18bBMITFF5KsSwaMXmERCc8Cn9r2SQ=
Date:   Fri, 14 Aug 2020 17:14:23 -0700
From:   akpm@linux-foundation.org
To:     cai@lca.pw, elver@google.com, hughd@google.com,
        mm-commits@vger.kernel.org
Subject:  [folded-merged]
 mm-swapfile-fix-and-annotate-various-data-races-v2.patch removed from -mm
 tree
Message-ID: <20200815001423.bv5QZVnBj%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-swapfile-fix-and-annotate-various-data-races-v2
has been removed from the -mm tree.  Its filename was
     mm-swapfile-fix-and-annotate-various-data-races-v2.patch

This patch was dropped because it was folded into mm-swapfile-fix-and-annotate-various-data-races.patch

------------------------------------------------------
From: Qian Cai <cai@lca.pw>
Subject: mm-swapfile-fix-and-annotate-various-data-races-v2

add a missing annotation for si->flags in memory.c

Link: http://lkml.kernel.org/r/1581612647-5958-1-git-send-email-cai@lca.pw
Signed-off-by: Qian Cai <cai@lca.pw>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memory.c~mm-swapfile-fix-and-annotate-various-data-races-v2
+++ a/mm/memory.c
@@ -3130,8 +3130,8 @@ vm_fault_t do_swap_page(struct vm_fault
 	if (!page) {
 		struct swap_info_struct *si = swp_swap_info(entry);
 
-		if (si->flags & SWP_SYNCHRONOUS_IO &&
-				__swap_count(entry) == 1) {
+		if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
+		    __swap_count(entry) == 1) {
 			/* skip swapcache */
 			page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma,
 							vmf->address);
_

Patches currently in -mm which might be from cai@lca.pw are

mm-kmemleak-silence-kcsan-splats-in-checksum.patch
mm-frontswap-mark-various-intentional-data-races.patch
mm-page_io-mark-various-intentional-data-races.patch
mm-swap_state-mark-various-intentional-data-races.patch
mm-swapfile-fix-and-annotate-various-data-races.patch
mm-page_counter-fix-various-data-races-at-memsw.patch
mm-memcontrol-fix-a-data-race-in-scan-count.patch
mm-list_lru-fix-a-data-race-in-list_lru_count_one.patch
mm-mempool-fix-a-data-race-in-mempool_free.patch
mm-rmap-annotate-a-data-race-at-tlb_flush_batched.patch
mm-swap-annotate-data-races-for-lru_rotate_pvecs.patch
mm-annotate-a-data-race-in-page_zonenum.patch
fork-silence-a-false-postive-warning-in-__mmdrop.patch

