Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 585FAC00A5A
	for <mm-commits@archiver.kernel.org>; Thu, 19 Jan 2023 03:42:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229852AbjASDmH (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Jan 2023 22:42:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjASDlI (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Jan 2023 22:41:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 137BE63E24
        for <mm-commits@vger.kernel.org>; Wed, 18 Jan 2023 19:37:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59DE1619DD
        for <mm-commits@vger.kernel.org>; Thu, 19 Jan 2023 03:37:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F87C433D2;
        Thu, 19 Jan 2023 03:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1674099433;
        bh=3dji0vqI5gYASZzg2o6bFcQrkjkpK1tG2SOZH+LJXxQ=;
        h=Date:To:From:Subject:From;
        b=NPwAu7/upQsNGPt9dWrHcXM2+F1oiq6imvyF8KZvQ+WQwWPsOjyuawgfu7XW3Ow7Y
         Te2LSUahhAPkJnk7XooqCo65JzpwSpBQPuMcxMn6s4XNoiZOUY+rBB8CFFWpDcVDz/
         nZnvl0Hs+bewKtFyAmyPfSWPPphAbBRZHdgA0xv4=
Date:   Wed, 18 Jan 2023 19:37:12 -0800
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shy828301@gmail.com, riel@surriel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-align-larger-anonymous-mappings-on-thp-boundaries.patch added to mm-unstable branch
Message-Id: <20230119033713.96F87C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: align larger anonymous mappings on THP boundaries
has been added to the -mm mm-unstable branch.  Its filename is
     mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

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
From: Rik van Riel <riel@surriel.com>
Subject: mm: align larger anonymous mappings on THP boundaries
Date: Tue, 9 Aug 2022 14:24:57 -0400

Align larger anonymous memory mappings on THP boundaries by going through
thp_get_unmapped_area if THPs are enabled for the current process.

With this patch, larger anonymous mappings are now THP aligned.  When a
malloc library allocates a 2MB or larger arena, that arena can now be
mapped with THPs right from the start, which can result in better TLB hit
rates and execution time.

Link: https://lkml.kernel.org/r/20220809142457.4751229f@imladris.surriel.com
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Yang Shi <shy828301@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/mm/mmap.c~mm-align-larger-anonymous-mappings-on-thp-boundaries
+++ a/mm/mmap.c
@@ -1782,6 +1782,9 @@ get_unmapped_area(struct file *file, uns
 		 */
 		pgoff = 0;
 		get_area = shmem_get_unmapped_area;
+	} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		/* Ensures that larger anonymous mappings are THP aligned. */
+		get_area = thp_get_unmapped_area;
 	}
 
 	addr = get_area(file, addr, len, pgoff, flags);
_

Patches currently in -mm which might be from riel@surriel.com are

mm-align-larger-anonymous-mappings-on-thp-boundaries.patch

