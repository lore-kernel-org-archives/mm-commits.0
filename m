Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D89C74A5B
	for <mm-commits@archiver.kernel.org>; Thu, 23 Mar 2023 21:21:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCWVVh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 23 Mar 2023 17:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjCWVVg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Mar 2023 17:21:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE1D32CC70
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 14:21:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77D6FB82251
        for <mm-commits@vger.kernel.org>; Thu, 23 Mar 2023 21:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C635C433D2;
        Thu, 23 Mar 2023 21:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679606492;
        bh=Ez/ZZDDXQh0zIvxttDdDQPKepva3rOIw7GsytoPvQP4=;
        h=Date:To:From:Subject:From;
        b=IB+n6+4KR/hMX26NiK1zTDR75hsYZ2c3+cJBO1dqUUfOOf87bn+UhYXG4f1/jZEwm
         Xt/bFNi+oqoo9QjPwAk7ubMzy6u/kCrdslH15LBo3ll89rtlGrgpdlOwSF0g9Gbfao
         +cIbqyeKnmj9nenYfI8/j95y7d3uEAdEGxFLO0UQ=
Date:   Thu, 23 Mar 2023 14:21:31 -0700
To:     mm-commits@vger.kernel.org, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com, elfring@users.sourceforge.net,
        Markus.Elfring@web.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch added to mm-unstable branch
Message-Id: <20230323212132.2C635C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/mempolicy: fix exception handling in shared_policy_replace()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch

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
From: Markus Elfring <Markus.Elfring@web.de>
Subject: mm/mempolicy: fix exception handling in shared_policy_replace()
Date: Thu, 23 Mar 2023 18:30:48 +0100

The label “err_out” was used to jump to another pointer check despite of
the detail in the implementation of the function “shared_policy_replace”
that it was determined already that a corresponding variable contained a
null pointer because of a failed call of the function “kmem_cache_alloc”.

1. Use more appropriate labels instead.

2. The implementation of the function “mpol_put” contains a pointer check
   for its single input parameter.
   Thus delete a redundant check in the caller.


This issue was detected by using the Coccinelle software.

Fixes: 42288fe366c4f1ce7522bc9f27d0bc2a81c55264 ("mm: mempolicy: Convert shared_policy mutex to spinlock")
Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Mel Gorman <mgorman@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/mm/mempolicy.c~mm-mempolicy-fix-exception-handling-in-shared_policy_replace
+++ a/mm/mempolicy.c
@@ -2736,13 +2736,12 @@ restart:
 		sp_insert(sp, new);
 	write_unlock(&sp->lock);
 	ret = 0;
+put_mpol:
+	mpol_put(mpol_new);
 
-err_out:
-	if (mpol_new)
-		mpol_put(mpol_new);
 	if (n_new)
 		kmem_cache_free(sn_cache, n_new);
-
+exit:
 	return ret;
 
 alloc_new:
@@ -2750,10 +2749,10 @@ alloc_new:
 	ret = -ENOMEM;
 	n_new = kmem_cache_alloc(sn_cache, GFP_KERNEL);
 	if (!n_new)
-		goto err_out;
+		goto exit;
 	mpol_new = kmem_cache_alloc(policy_cache, GFP_KERNEL);
 	if (!mpol_new)
-		goto err_out;
+		goto put_mpol;
 	atomic_set(&mpol_new->refcnt, 1);
 	goto restart;
 }
_

Patches currently in -mm which might be from Markus.Elfring@web.de are

mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch

