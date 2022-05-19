Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBB3C433EF
	for <mm-commits@archiver.kernel.org>; Thu, 19 May 2022 17:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242893AbiESRiu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 19 May 2022 13:38:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiESRim (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 19 May 2022 13:38:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036BD64737
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 10:38:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 935CF6187D
        for <mm-commits@vger.kernel.org>; Thu, 19 May 2022 17:38:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FADC34100;
        Thu, 19 May 2022 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652981921;
        bh=WZGU8B+2efJl//yfFrcxdhawsUrX2P4muhf94fg+43c=;
        h=Date:To:From:Subject:From;
        b=zVOEOZslriNpjBUyf0o8b5VvqNn9L1TH4oO8etvJqAjeEQIlmN2zzFB1RPNsTS43X
         cNE7vjXM6qAmKXFa3YT9w7D5iFjWdtDI5QHUDQxxhGN7WzKsFCinJ30CWvCEplFMRH
         PisxFoTZflTnJrZjV2mZwGEUfv1rxVkvIisqamzI=
Date:   Thu, 19 May 2022 10:38:40 -0700
To:     mm-commits@vger.kernel.org, len.baker@gmx.com,
        gustavoars@kernel.org, dhowells@redhat.com,
        stephen.s.brennan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] assoc_array-fix-bug_on-during-garbage-collect-v2.patch removed from -mm tree
Message-Id: <20220519173840.F1FADC34100@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: assoc_array: fix BUG_ON during garbage collect
has been removed from the -mm tree.  Its filename was
     assoc_array-fix-bug_on-during-garbage-collect-v2.patch

This patch was dropped because it was folded into assoc_array-fix-bug_on-during-garbage-collect.patch

------------------------------------------------------
From: Stephen Brennan <stephen.s.brennan@oracle.com>
Subject: assoc_array: Fix BUG_ON during garbage collect

correct comparison to "<="

Link: https://lkml.kernel.org/r/20220512215045.489140-1-stephen.s.brennan@oracle.com
Fixes: 3cb989501c26 ("Add a generic associative array implementation.")
Signed-off-by: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Len Baker <len.baker@gmx.com>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/assoc_array.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/assoc_array.c~assoc_array-fix-bug_on-during-garbage-collect-v2
+++ a/lib/assoc_array.c
@@ -1609,7 +1609,7 @@ retry_compress:
 		}
 	}
 
-	if (retained && new_n->nr_leaves_on_branch < ASSOC_ARRAY_FAN_OUT) {
+	if (retained && new_n->nr_leaves_on_branch <= ASSOC_ARRAY_FAN_OUT) {
 		pr_devel("internal nodes remain despite enough space, retrying\n");
 		goto retry_compress;
 	}
_

Patches currently in -mm which might be from stephen.s.brennan@oracle.com are

assoc_array-fix-bug_on-during-garbage-collect.patch

