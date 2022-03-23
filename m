Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A934EC4332F
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 23:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345426AbiCWXIi (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 19:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345436AbiCWXIf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 19:08:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A526190CEF
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 16:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5563FB8214F
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 23:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10843C340E8;
        Wed, 23 Mar 2022 23:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648076821;
        bh=GjfTSEjREVFETddnHTx3cT/Fhv/AEqbaNHY+hVV71Pc=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mBpfeBqd8aUU3Frd340eKGpiVJQIlPHG+11jlF0Q43fY+5Wf+p9F/Nubpy8VTcUdj
         ui0Xch30KMol2sqDrsWpmmSwBeVtBZG2MjFcmXzOoe5rE9zKASBN/is4LKRI0g+XEl
         F9ZF8kIbFngbhxF0YvGCSp9JUJIgJlaEyQlYFQLI=
Date:   Wed, 23 Mar 2022 16:07:00 -0700
To:     trix@redhat.com, ndesaulniers@google.com, natechancellor@gmail.com,
        bsingharora@gmail.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org, patches@lists.linux.dev,
        linux-mm@kvack.org, mm-commits@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220323160453.65922ced539cbf445b191555@linux-foundation.org>
Subject: [patch 34/41] taskstats: remove unneeded dead assignment
Message-Id: <20220323230701.10843C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

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

[akpm@linux-foundation.org: reduce scope of `rc']
Link: https://lkml.kernel.org/r/20220307093942.21310-1-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Tom Rix <trix@redhat.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/taskstats.c~taskstats-remove-unneeded-dead-assignment
+++ a/kernel/taskstats.c
@@ -113,13 +113,14 @@ static void send_cpu_listeners(struct sk
 	struct listener *s, *tmp;
 	struct sk_buff *skb_next, *skb_cur = skb;
 	void *reply = genlmsg_data(genlhdr);
-	int rc, delcount = 0;
+	int delcount = 0;
 
 	genlmsg_end(skb, reply);
 
-	rc = 0;
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
+		int rc;
+
 		skb_next = NULL;
 		if (!list_is_last(&s->list, &listeners->list)) {
 			skb_next = skb_clone(skb_cur, GFP_KERNEL);
_
