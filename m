Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35EDDC433DB
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 055DC22227
	for <mm-commits@archiver.kernel.org>; Tue, 29 Dec 2020 23:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726278AbgL2XPo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 29 Dec 2020 18:15:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:37768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726274AbgL2XPo (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 29 Dec 2020 18:15:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EE52B2222A;
        Tue, 29 Dec 2020 23:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609283681;
        bh=h4KxPNu8JUKNQQue82eivjsaXfmQO5zgNGJKT/TWOVw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=1dYzjBhyjsGZwVbN6FDf7EZFm3S97O3O9Qty48RIN2gk1fWXJV3fnjA5bPBLlktZV
         QVldDSxaWRJ6VeJtrE/OLT8XM2dI+Xb7ax+9dwV0usueNss9bq5oZvqdJG0KctoCl2
         AJzPsrt00JnUv9TxWs8z6LAla4b4VuORxsQX+79E=
Date:   Tue, 29 Dec 2020 15:14:40 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, deller@gmx.de, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, linux-mm@kvack.org,
        linux@roeck-us.net, lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com,
        torvalds@linux-foundation.org
Subject:  [patch 07/16] mm/mremap.c: fix extent calculation
Message-ID: <20201229231440.q8f_qyKwg%akpm@linux-foundation.org>
In-Reply-To: <20201229151349.3285926ec0d1f65a27ac8534@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kalesh Singh <kaleshsingh@google.com>
Subject: mm/mremap.c: fix extent calculation

When `next < old_addr`, `next - old_addr` arithmetic underflows
causing `extent` to be incorrect.

Make `extent` the smaller of `next - old_addr` or `old_end - old_addr`.

Link: https://lkml.kernel.org/r/20201219170433.2418867-1-kaleshsingh@google.com
Fixes: c49dd34018026 ("mm: speedup mremap on 1GB or larger regions")
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
Reported-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Guenter Roeck <linux@roeck-us.net>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Helge Deller <deller@gmx.de>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mremap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/mremap.c~mm-mremap-fix-extent-calculation
+++ a/mm/mremap.c
@@ -358,7 +358,9 @@ static unsigned long get_extent(enum pgt
 
 	next = (old_addr + size) & mask;
 	/* even if next overflowed, extent below will be ok */
-	extent = (next > old_end) ? old_end - old_addr : next - old_addr;
+	extent = next - old_addr;
+	if (extent > old_end - old_addr)
+		extent = old_end - old_addr;
 	next = (new_addr + size) & mask;
 	if (extent > next - new_addr)
 		extent = next - new_addr;
_
