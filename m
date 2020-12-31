Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C21CC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A2F9223E4
	for <mm-commits@archiver.kernel.org>; Thu, 31 Dec 2020 18:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726531AbgLaSYD (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 31 Dec 2020 13:24:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:34094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbgLaSYD (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 31 Dec 2020 13:24:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46CB52246B;
        Thu, 31 Dec 2020 18:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1609438978;
        bh=jdHS1qCxB+3J/tkbebvMsD3K2Wddh+1yvo8RDBwDyJg=;
        h=Date:From:To:Subject:From;
        b=fYPt1moulQR//kJ1hY6YYC7w/0BBeQl1M+TBxDyO1D9dCSynZo3Xgs6m9a/4R4tI6
         dmIZ+JLCA9BeVO0yuQoiPIXHRJcg+QEsI5nIWR1u9fT1Z/kMYCSRjW+tkRNDUK1bTW
         V7yj8BB8fbtdcKycoo/q5GhpDZOwtmomOemlMqks=
Date:   Thu, 31 Dec 2020 10:22:57 -0800
From:   akpm@linux-foundation.org
To:     deller@gmx.de, kaleshsingh@google.com,
        kirill.shutemov@linux.intel.com, linux@roeck-us.net,
        lokeshgidra@google.com, minchan@kernel.org,
        mm-commits@vger.kernel.org, surenb@google.com
Subject:  [merged] mm-mremap-fix-extent-calculation.patch removed
 from -mm tree
Message-ID: <20201231182257.QI8l5roc3%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap.c: fix extent calculation
has been removed from the -mm tree.  Its filename was
     mm-mremap-fix-extent-calculation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
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

Patches currently in -mm which might be from kaleshsingh@google.com are


