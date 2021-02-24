Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D48FC433E9
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4407764F39
	for <mm-commits@archiver.kernel.org>; Wed, 24 Feb 2021 20:05:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhBXUFZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 24 Feb 2021 15:05:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:56702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235461AbhBXUDy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 24 Feb 2021 15:03:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16D7564E09;
        Wed, 24 Feb 2021 20:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614196976;
        bh=T85Xr9DPB97rqTmjlllDlIAKZVTOHYa0asJFqBT5srk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=q/AFx7eU6VRssTE7HU2EtPoLJq8H9Pf4MSSLyVqwUsPAIDkYyaKK9RNvGuyJuy+Li
         80A4Pf7CGtbKaMh1A9NHBfTA0M7p+dCHLJZn/hlrvkHkvBrlLSwCpqjtAl3EaRtGII
         Vn7/POCjuooG51grwbwzN8jNOEjNsLevplIkDnjs=
Date:   Wed, 24 Feb 2021 12:02:55 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     abaci-bugfix@linux.alibaba.com, abaci@linux.alibaba.com,
        akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 050/173] mm/swap_slots.c: remove redundant NULL
 check
Message-ID: <20210224200255.cTufYVXJh%akpm@linux-foundation.org>
In-Reply-To: <20210224115824.1e289a6895087f10c41dd8d6@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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
