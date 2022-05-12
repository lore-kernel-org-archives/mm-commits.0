Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70B5AC433EF
	for <mm-commits@archiver.kernel.org>; Thu, 12 May 2022 23:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359382AbiELXO2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 12 May 2022 19:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347549AbiELXOZ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 12 May 2022 19:14:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7245B13F91B
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 16:14:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29231B82BA3
        for <mm-commits@vger.kernel.org>; Thu, 12 May 2022 23:14:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD624C385B8;
        Thu, 12 May 2022 23:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652397261;
        bh=6jz+LYZDnqwvfS7bsfmg7CJvjS76mdPyWao4S02q7IE=;
        h=Date:To:From:Subject:From;
        b=2WuJEbRjItXx8ZEU9JbniN34nfnR+7KvLhsIHjZbu7ptJEBfoLpxJmlq38ZmC21UC
         4boxfi28w1PxoG/tA95dIUkN+TGR3fMf0fKiqkmQCBp+6AQB848eFMClnUu3dXULNn
         dlWFV0DDWVZEt3wT7C72Z6Qbi6uwALCWRtU4IK7c=
Date:   Thu, 12 May 2022 16:14:20 -0700
To:     mm-commits@vger.kernel.org, len.baker@gmx.com,
        gustavoars@kernel.org, dhowells@redhat.com,
        stephen.s.brennan@oracle.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + assoc_array-fix-bug_on-during-garbage-collect-v2.patch added to mm-hotfixes-unstable branch
Message-Id: <20220512231421.BD624C385B8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: assoc_array: Fix BUG_ON during garbage collect
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     assoc_array-fix-bug_on-during-garbage-collect-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/assoc_array-fix-bug_on-during-garbage-collect-v2.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
assoc_array-fix-bug_on-during-garbage-collect-v2.patch

