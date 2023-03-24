Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6CE6C6FD20
	for <mm-commits@archiver.kernel.org>; Fri, 24 Mar 2023 19:17:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231215AbjCXTRT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 24 Mar 2023 15:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbjCXTRS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 24 Mar 2023 15:17:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE9EB20D0B
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 12:17:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3BD85627C0
        for <mm-commits@vger.kernel.org>; Fri, 24 Mar 2023 19:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C42CC433EF;
        Fri, 24 Mar 2023 19:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679685436;
        bh=+makHyEPNUBWZ+1qFUBxEowCtr+3lff8fwjYQJuZIws=;
        h=Date:To:From:Subject:From;
        b=O+ddBel4eMmAACyOchCa9ISxeEv1bFjxNlp0avhw2ggWbp4oe0IKYhaH6ZPhT9CQp
         i/R5MUDvdpxdY5KbWpdvYQ4OW+Uo2J09g3SPJBgL+W5Qyl7PDU4RKCgVe2KvoCKcTz
         u5prKqV3m5/N/KTSJHGOQ8K4APlVIMRFWL5YaBzg=
Date:   Fri, 24 Mar 2023 12:17:15 -0700
To:     mm-commits@vger.kernel.org, mgorman@suse.de,
        kosaki.motohiro@jp.fujitsu.com, elfring@users.sourceforge.net,
        Markus.Elfring@web.de, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [to-be-updated] mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch removed from -mm tree
Message-Id: <20230324191716.8C42CC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/mempolicy: fix exception handling in shared_policy_replace()
has been removed from the -mm tree.  Its filename was
     mm-mempolicy-fix-exception-handling-in-shared_policy_replace.patch

This patch was dropped because an updated version will be merged

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


