Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7AC5C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  7 Mar 2022 23:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232786AbiCGXdN (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 7 Mar 2022 18:33:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234760AbiCGXdM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 7 Mar 2022 18:33:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5A712A9F
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 15:32:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ABB8A6124A
        for <mm-commits@vger.kernel.org>; Mon,  7 Mar 2022 23:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10BBEC340E9;
        Mon,  7 Mar 2022 23:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1646695936;
        bh=w4sOf0JMk/IcDO2qZNSmo5hh+qkMLXWk6NurejXaTtA=;
        h=Date:To:From:Subject:From;
        b=LGaWbF5tXAwOyn42rf+woavfOaoShInSJ6zEqnMJKDirSsPD29f51g/61ATwfoR0w
         aC6tORcl1htzDbUDOQz7KdzTkN8LeH9Pk4vx4TpC1oCV7QkBIZuw3lIJbr+Gj3qTOb
         txMv2sUOrZ4GkREoWNKiw5Bjj1NxLCTpBNIUY9bA=
Date:   Mon, 07 Mar 2022 15:32:15 -0800
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, natechancellor@gmail.com,
        bsingharora@gmail.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + taskstats-remove-unneeded-dead-assignment.patch added to -mm tree
Message-Id: <20220307233216.10BBEC340E9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats: remove unneeded dead assignment
has been added to the -mm tree.  Its filename is
     taskstats-remove-unneeded-dead-assignment.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/taskstats-remove-unneeded-dead-assignment.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/taskstats-remove-unneeded-dead-assignment.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: taskstats: remove unneeded dead assignment

make clang-analyzer on x86_64 defconfig caught my attention with:

  kernel/taskstats.c:120:2: warning: Value stored to 'rc' is never read \
  [clang-analyzer-deadcode.DeadStores]
          rc = 0;
          ^

Commit d94a041519f3 ("taskstats: free skb, avoid returns in
send_cpu_listeners") made send_cpu_listeners() not return a value and
hence, the rc variable remained only to be used within the loop where
it is always assigned before read and it does not need any other
initialisation.

So, simply remove this unneeded dead initializing assignment.

As compilers will detect this unneeded assignment and optimize this anyway,
the resulting object code is identical before and after this change.

No functional change. No change to object code.

Link: https://lkml.kernel.org/r/20220307093942.21310-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-remove-unneeded-dead-assignment
+++ a/kernel/taskstats.c
@@ -117,7 +117,6 @@ static void send_cpu_listeners(struct sk
 
 	genlmsg_end(skb, reply);
 
-	rc = 0;
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
 		skb_next = NULL;
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

taskstats-remove-unneeded-dead-assignment.patch

