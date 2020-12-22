Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94BF0C433E6
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:33:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 593B62333B
	for <mm-commits@archiver.kernel.org>; Tue, 22 Dec 2020 19:33:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726289AbgLVTdm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 22 Dec 2020 14:33:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:34154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgLVTdm (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 22 Dec 2020 14:33:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B97B823130;
        Tue, 22 Dec 2020 19:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1608665581;
        bh=L3AarQKqpby3ztfLtPzaZfLo8vNzSmRUC8Fb1Tevhrw=;
        h=Date:From:To:Subject:From;
        b=F6iVsdNFMCG7PWn549uX2cDaZlcR5iLDuirnXzQhRFcjSdMtpqR14vclYRcHxYDdO
         kCXgA5L5JU2i1EfO7NwzvpVzuHO+UKSfJTX8RhrvxJireu40oeGj7cWs1qfOt/9reo
         MgvRc/VZUJvkBQ4rmnL82xQdldliSvCP1n3Y8Vk0=
Date:   Tue, 22 Dec 2020 11:32:59 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, surenb@google.com, minchan@kernel.org,
        lokeshgidra@google.com, linux@roeck-us.net, kaleshsingh@google.com
Subject:  + mm-mremap-fix-extent-calculation.patch added to -mm tree
Message-ID: <20201222193259.fnm5T%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mremap.c: fix extent calculation
has been added to the -mm tree.  Its filename is
     mm-mremap-fix-extent-calculation.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mremap-fix-extent-calculation.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mremap-fix-extent-calculation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

mm-mremap-fix-extent-calculation.patch

