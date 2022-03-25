Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B4BC43219
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357322AbiCYBb4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:31:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357339AbiCYBbt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:31:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB1B36E32
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AAE7661923
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FB98C340EC;
        Fri, 25 Mar 2022 01:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171806;
        bh=crpK6ry4oWThrH0Wuq+44auX6KqqDLMbbzB82R0e4zY=;
        h=Date:To:From:Subject:From;
        b=JHQm9MkFDUYeZNsW23R2p8ZzQVqAA9COosAh+r1PklsQQkyt45mcCdKZhg88ptqZo
         LP/JuAQC8uxqsgoAs/SeUwF1SLzq/ckoTgeuqnPDbusgHRGh7Gm5G4oAv8cSvDZCeU
         tk5qeIH3c5yOtnQp5LItz4Yj6CtMNcBfLr2a9OVU=
Date:   Thu, 24 Mar 2022 18:30:05 -0700
To:     mm-commits@vger.kernel.org, libang.linuxer@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch removed from -mm tree
Message-Id: <20220325013006.0FB98C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap: fix confusing comment in folio_mark_accessed
has been removed from the -mm tree.  Its filename was
     mm-swap-fix-confusing-comment-in-folio_mark_accessed.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Bang Li <libang.linuxer@gmail.com>
Subject: mm/swap: fix confusing comment in folio_mark_accessed

For unevictable pages, we don't need mark them.

Link: https://lkml.kernel.org/r/20220311141519.59948-1-libang.linuxer@gmail.com
Signed-off-by: Bang Li <libang.linuxer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/swap.c~mm-swap-fix-confusing-comment-in-folio_mark_accessed
+++ a/mm/swap.c
@@ -425,7 +425,7 @@ void folio_mark_accessed(struct folio *f
 		/*
 		 * Unevictable pages are on the "LRU_UNEVICTABLE" list. But,
 		 * this list is never rotated or maintained, so marking an
-		 * evictable page accessed has no effect.
+		 * unevictable page accessed has no effect.
 		 */
 	} else if (!folio_test_active(folio)) {
 		/*
_

Patches currently in -mm which might be from libang.linuxer@gmail.com are


