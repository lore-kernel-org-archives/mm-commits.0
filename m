Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2610C11F67
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD80361D0C
	for <mm-commits@archiver.kernel.org>; Tue, 29 Jun 2021 02:42:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231680AbhF2CpL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 28 Jun 2021 22:45:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:37382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231398AbhF2CpL (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Mon, 28 Jun 2021 22:45:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 63FA561D0D;
        Tue, 29 Jun 2021 02:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1624934563;
        bh=+sJEQvdy8tMc7SUQRQq5PCyPADHavqZiWFWsrH4M2k8=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=AIYURMKSc9gksiVgk+s1QUvoek4mKIbpQhJfZIGrjugsfI48bJsUTWf1BvFbxVqmi
         u5seLhiqrcnKzNQ1KNrKyE+tPG8Mb+a97MPUJYWk9jcCy5u3ZDAeiBB7KPrms6IaIW
         cxcmCwyN20WFvaXwCWcz7Ab+wAvmrNyezk/PW/Xs=
Date:   Mon, 28 Jun 2021 19:42:43 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, arnd@arndb.de, corbet@lwn.net,
        david@redhat.com, geert@linux-m68k.org, ink@jurassic.park.msu.ru,
        linux-mm@kvack.org, mattst88@gmail.com, mm-commits@vger.kernel.org,
        rppt@linux.ibm.com, rth@twiddle.net, torvalds@linux-foundation.org,
        vgupta@synopsys.com
Subject:  [patch 181/192] arc: update comment about HIGHMEM
 implementation
Message-ID: <20210629024243.VERGuG22C%akpm@linux-foundation.org>
In-Reply-To: <20210628193256.008961950a714730751c1423@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Mike Rapoport <rppt@linux.ibm.com>
Subject: arc: update comment about HIGHMEM implementation

Arc does not use DISCONTIGMEM to implement high memory, update the comment
describing how high memory works to reflect this.

Link: https://lkml.kernel.org/r/20210608091316.3622-3-rppt@kernel.org
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: Vineet Gupta <vgupta@synopsys.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Richard Henderson <rth@twiddle.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/arc/mm/init.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/arc/mm/init.c~arc-update-comment-about-highmem-implementation
+++ a/arch/arc/mm/init.c
@@ -139,16 +139,13 @@ void __init setup_arch_memory(void)
 
 #ifdef CONFIG_HIGHMEM
 	/*
-	 * Populate a new node with highmem
-	 *
 	 * On ARC (w/o PAE) HIGHMEM addresses are actually smaller (0 based)
-	 * than addresses in normal ala low memory (0x8000_0000 based).
+	 * than addresses in normal aka low memory (0x8000_0000 based).
 	 * Even with PAE, the huge peripheral space hole would waste a lot of
-	 * mem with single mem_map[]. This warrants a mem_map per region design.
-	 * Thus HIGHMEM on ARC is imlemented with DISCONTIGMEM.
-	 *
-	 * DISCONTIGMEM in turns requires multiple nodes. node 0 above is
-	 * populated with normal memory zone while node 1 only has highmem
+	 * mem with single contiguous mem_map[].
+	 * Thus when HIGHMEM on ARC is enabled the memory map corresponding
+	 * to the hole is freed and ARC specific version of pfn_valid()
+	 * handles the hole in the memory map.
 	 */
 #ifdef CONFIG_DISCONTIGMEM
 	node_set_online(1);
_
