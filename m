Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4270C433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 909B864DF3
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234311AbhBYTWT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:22:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234690AbhBYTUG (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:20:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9128864F6A;
        Thu, 25 Feb 2021 19:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280415;
        bh=gwbPJRErphibtP0Gfc6RvXoaIsGRynIKYZMXA+7kVTQ=;
        h=Date:From:To:Subject:From;
        b=c98ZnaJNt78JV+OzbIzG8/t99LzNzKyMTd8tMqQrxgn2S04PILOMHityAdbHDJ6LO
         nsJkHjKuz9NSDTxBz4yhOueK0oA4QAOUJViSgYQI4a07c0B95K+buiLFQmyqnikNxh
         Gp9Sg+Mbc4HOBpRohFqewHZS9C38x0FKHPBPVUco=
Date:   Thu, 25 Feb 2021 11:13:35 -0800
From:   akpm@linux-foundation.org
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, david@redhat.com,
        mm-commits@vger.kernel.org
Subject:  [merged] mm-swap_slotsc-remove-redundant-null-check.patch
 removed from -mm tree
Message-ID: <20210225191335.NV_Wu6wWb%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/swap_slots.c: remove redundant NULL check
has been removed from the -mm tree.  Its filename was
     mm-swap_slotsc-remove-redundant-null-check.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Reviewed-by: David Hildenbrand <david@redhat.com>
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


