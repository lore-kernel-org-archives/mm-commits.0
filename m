Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E027EC433E0
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:34:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 844F423A5F
	for <mm-commits@archiver.kernel.org>; Thu, 21 Jan 2021 22:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725969AbhAUWe3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 21 Jan 2021 17:34:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725794AbhAUWe1 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 21 Jan 2021 17:34:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE1D323A5F;
        Thu, 21 Jan 2021 22:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1611268427;
        bh=QxTkRJbdFicXm4zbqYSUzQTGtaggwHqdqN08iT2AH1Q=;
        h=Date:From:To:Subject:From;
        b=JRsDGAkUjqB5Olu4hRck1Qlzb/h/J88SCX8a3IL8NX2yKAsfE8WdOvaXlAeKpjyr2
         HzvWlmesH6ZJoKt8TbX3iHxNEkJWwbhMx2U4oyyWThV2S/DAq4THVA+ZqgaefUjejR
         NO6Ve3lk+NmMkPiclvY12tanaTbw1JzwwOeR6s9s=
Date:   Thu, 21 Jan 2021 14:33:46 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org
Subject:  + mm-swap_slotsc-remove-redundant-null-check.patch added
 to -mm tree
Message-ID: <20210121223346.mw9ivwrEs%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove redundant NULL check
has been added to the -mm tree.  Its filename is
     mm-swap_slotsc-remove-redundant-null-check.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-swap_slotsc-remove-redundant-null-check.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-swap_slotsc-remove-redundant-null-check.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Yang Li <abaci-bugfix@linux.alibaba.com>
Subject: mm/swap_slots.c: remove redundant NULL check

Fix below warnings reported by coccicheck:
./mm/swap_slots.c:197:3-9: WARNING: NULL check before some freeing
functions is not needed.

Link: https://lkml.kernel.org/r/1611214229-11225-1-git-send-email-abaci-bugfix@linux.alibaba.com
Signed-off-by: Yang Li <abaci-bugfix@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swap_slots.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/swap_slots.c~mm-swap_slotsc-remove-redundant-null-check
+++ a/mm/swap_slots.c
@@ -193,8 +193,7 @@ static void drain_slots_cache_cpu(unsign
 			cache->slots_ret = NULL;
 		}
 		spin_unlock_irq(&cache->free_lock);
-		if (slots)
-			kvfree(slots);
+		kvfree(slots);
 	}
 }
 
_

Patches currently in -mm which might be from abaci-bugfix@linux.alibaba.com are

mm-swap_slotsc-remove-redundant-null-check.patch
mm-memcontrol-remove-redundant-null-check.patch
vmalloc-remove-redundant-null-check.patch

