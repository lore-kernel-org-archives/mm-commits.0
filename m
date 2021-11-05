Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C70C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F38C6126A
	for <mm-commits@archiver.kernel.org>; Fri,  5 Nov 2021 20:40:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233501AbhKEUmk (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 5 Nov 2021 16:42:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233498AbhKEUmk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Nov 2021 16:42:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F3006056B;
        Fri,  5 Nov 2021 20:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1636144800;
        bh=AggLZ8nA2+U/SPGcwOBQOGanO0LrnntBQMKbQkeoafk=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=zC/z0uwtkF3++ZxXOtOvmBkx6jaFjq1+pVoSrzGOYiDCNiljU/Y/neiIFsJ5noXSI
         SXg928D8ppbgsYBsxWcm/RnNh+zlE+BDeHxP1NVpK9uWBPvJ7h2egzwmzIs/CmGxpx
         +Giw21Z/f1hQyWfJZ0dxEDGpumchlCEYOHV1eZzQ=
Date:   Fri, 05 Nov 2021 13:39:59 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, edumazet@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, npiggin@gmail.com,
        torvalds@linux-foundation.org
Subject:  [patch 102/262] mm/large system hash: avoid possible NULL
 deref in alloc_large_system_hash
Message-ID: <20211105203959.pBhGbu8m4%akpm@linux-foundation.org>
In-Reply-To: <20211105133408.cccbb98b71a77d5e8430aba1@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Subject: mm/large system hash: avoid possible NULL deref in alloc_large_system_hash

If __vmalloc() returned NULL, is_vm_area_hugepages(NULL) will fault if
CONFIG_HAVE_ARCH_HUGE_VMALLOC=y

Link: https://lkml.kernel.org/r/20210915212530.2321545-1-eric.dumazet@gmail.com
Fixes: 121e6f3258fe ("mm/vmalloc: hugepage vmalloc mappings")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/page_alloc.c~mm-large-system-hash-avoid-possible-null-deref-in-alloc_large_system_hash
+++ a/mm/page_alloc.c
@@ -8762,7 +8762,8 @@ void *__init alloc_large_system_hash(con
 		} else if (get_order(size) >= MAX_ORDER || hashdist) {
 			table = __vmalloc(size, gfp_flags);
 			virt = true;
-			huge = is_vm_area_hugepages(table);
+			if (table)
+				huge = is_vm_area_hugepages(table);
 		} else {
 			/*
 			 * If bucketsize is not a power-of-two, we may free
_
