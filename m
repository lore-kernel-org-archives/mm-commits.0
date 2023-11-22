Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06B89C27C40
	for <mm-commits@archiver.kernel.org>; Wed, 22 Nov 2023 21:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbjKVVwm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 22 Nov 2023 16:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231623AbjKVVwl (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 22 Nov 2023 16:52:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF371B3
        for <mm-commits@vger.kernel.org>; Wed, 22 Nov 2023 13:52:37 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4645AC433C7;
        Wed, 22 Nov 2023 21:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700689957;
        bh=lDZBYlFd+rTSs8vJs9wb6tf+zmn+/ik6CYJTak3hCCs=;
        h=Date:To:From:Subject:From;
        b=jO9sDL6nHwcsuCROQxv8bbwhLmmbusr65h7QAteybpCzQzb2g9GPfbblR7gIKB4jY
         gxzLjNMbVsNig5jVH7QE8m4Z/HvdKOY72q+gtxAi+SDxdmqlwRhbZLzdGCIwJ/3Uv1
         1J4yEnix+sX4edRsfwvRMdAjC60lZEVXHCdlspmM=
Date:   Wed, 22 Nov 2023 13:52:36 -0800
To:     mm-commits@vger.kernel.org, fancer.lancer@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch added to mm-unstable branch
Message-Id: <20231122215237.4645AC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mm_init.c: append newline to the unavailable ranges log-message
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

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
From: Serge Semin <fancer.lancer@gmail.com>
Subject: mm/mm_init.c: append newline to the unavailable ranges log-message
Date: Wed, 22 Nov 2023 21:24:04 +0300

Based on the init_unavailable_range() method and it's callee semantics no
multi-line info messages are intended to be printed to the console.  Thus
append the '\n' symbol to the respective info string.

Link: https://lkml.kernel.org/r/20231122182419.30633-7-fancer.lancer@gmail.com
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mm_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/mm_init.c~mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message
+++ a/mm/mm_init.c
@@ -827,7 +827,7 @@ static void __init init_unavailable_rang
 	}
 
 	if (pgcnt)
-		pr_info("On node %d, zone %s: %lld pages in unavailable ranges",
+		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
 }
 
_

Patches currently in -mm which might be from fancer.lancer@gmail.com are

mm-mm_initc-extend-init-unavailable-range-doc-info.patch
mm-mm_initc-append-newline-to-the-unavailable-ranges-log-message.patch

