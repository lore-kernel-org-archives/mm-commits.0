Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96404C0032E
	for <mm-commits@archiver.kernel.org>; Wed, 25 Oct 2023 23:49:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234917AbjJYXtI (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 25 Oct 2023 19:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233217AbjJYXsp (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 25 Oct 2023 19:48:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86BC1B6
        for <mm-commits@vger.kernel.org>; Wed, 25 Oct 2023 16:48:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5878C433C7;
        Wed, 25 Oct 2023 23:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1698277712;
        bh=N8/gKA88VJxQGeD11Vm0wCQUJ6jzFdQGyn0WLEcecy8=;
        h=Date:To:From:Subject:From;
        b=Z/mve63ljvBtOvzax/Ci3JxbEHzxBSE75NDzzDPig9eRQYzgL92wmz2wJ38OPsqHm
         XJ63EcNNEK4JVqViQrBPiUX1BCCt3Qn1vCjABHakitaJYQNxyLPKHhKuh+rT+tyx4v
         MUyIHnhPs42MKZR2RgRZPHMO5+qlpgzqvXIP0adM=
Date:   Wed, 25 Oct 2023 16:48:32 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-swap-avoid-a-xa-load-for-swapout-path.patch removed from -mm tree
Message-Id: <20231025234832.A5878C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/swap: avoid a xa load for swapout path
has been removed from the -mm tree.  Its filename was
     mm-swap-avoid-a-xa-load-for-swapout-path.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kairui Song <kasong@tencent.com>
Subject: mm/swap: avoid a xa load for swapout path
Date: Tue, 17 Oct 2023 09:17:28 +0800

A variable is never used for swapout path (shadowp is NULL) and compiler
is unable to optimize out the unneeded load since it's a function call.

The was introduced by 3852f6768ede ("mm/swapcache: support to handle the
shadow entries").

Link: https://lkml.kernel.org/r/20231017011728.37508-1-ryncsn@gmail.com
Signed-off-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Huang Ying <ying.huang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_state.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/swap_state.c~mm-swap-avoid-a-xa-load-for-swapout-path
+++ a/mm/swap_state.c
@@ -109,9 +109,9 @@ int add_to_swap_cache(struct folio *foli
 			goto unlock;
 		for (i = 0; i < nr; i++) {
 			VM_BUG_ON_FOLIO(xas.xa_index != idx + i, folio);
-			old = xas_load(&xas);
-			if (xa_is_value(old)) {
-				if (shadowp)
+			if (shadowp) {
+				old = xas_load(&xas);
+				if (xa_is_value(old))
 					*shadowp = old;
 			}
 			xas_store(&xas, folio);
_

Patches currently in -mm which might be from kasong@tencent.com are


