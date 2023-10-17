Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B79BCDB474
	for <mm-commits@archiver.kernel.org>; Tue, 17 Oct 2023 15:24:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344336AbjJQPYz (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 17 Oct 2023 11:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344061AbjJQPYy (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 17 Oct 2023 11:24:54 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7CD4F0
        for <mm-commits@vger.kernel.org>; Tue, 17 Oct 2023 08:24:52 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FAE5C433C8;
        Tue, 17 Oct 2023 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697556292;
        bh=X/jIWVDvnBubWEcr9tMKBsOs7pFZ+4K2RFLm+POKGAw=;
        h=Date:To:From:Subject:From;
        b=MGREnj2hVXuUPBU22dSPMPnS91WeVb0NKDq2Bi3WnfQ7X5empldoXowKKoj+4TO4A
         W5SCGCX/lngUK971kfUyFHKreZwWtHhVJqg0Chlmkpv8Wy+SCrVfP7hDLur4o3KkpJ
         jhEW46wj0oPz5Kq0nUiVzfF+ZBaUMAj/ze+WtDHU=
Date:   Tue, 17 Oct 2023 08:24:51 -0700
To:     mm-commits@vger.kernel.org, ying.huang@intel.com,
        willy@infradead.org, kasong@tencent.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-swap-avoid-a-xa-load-for-swapout-path.patch added to mm-unstable branch
Message-Id: <20231017152452.7FAE5C433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: avoid a xa load for swapout path
has been added to the -mm mm-unstable branch.  Its filename is
     mm-swap-avoid-a-xa-load-for-swapout-path.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-swap-avoid-a-xa-load-for-swapout-path.patch

This patch will later appear in the mm-unstable branch at
    git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next via the mm-everything
branch at git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
and is updated there every 2-3 working days

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
@@ -111,9 +111,9 @@ int add_to_swap_cache(struct folio *foli
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

mm-oom_killer-simplify-oom-killer-info-dump-helper.patch
mm-swap-avoid-a-xa-load-for-swapout-path.patch

