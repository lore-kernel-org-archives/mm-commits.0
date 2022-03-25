Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A904BC4332F
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:35:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356410AbiCYBhL (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:37:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357525AbiCYBf5 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:35:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 129BD3B033
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:34:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 94AAE60A75
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF104C340EC;
        Fri, 25 Mar 2022 01:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648172054;
        bh=08fdCpHjzZ63osXy+9UgStxG8nM0fdqoHiu3IOgrBIs=;
        h=Date:To:From:Subject:From;
        b=I0SDBDNZMJPpuZkq/mjeXM6xjd3eutdbEZFXwIjzw0VQKVxcfDpRTGY5SJNxkOO88
         cB8mEX5vWQ/3jmbCC2Di4yAkEOLOdPvTxmtMcA3ye2ICBNhghdUJe7Xei4xEgSSx6a
         6h09u36qqjdzKiwyoGNyg1c/hE0jWOQ6tof0bKuA=
Date:   Thu, 24 Mar 2022 18:34:13 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, natechancellor@gmail.com,
        bsingharora@gmail.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] taskstats-remove-unneeded-dead-assignment.patch removed from -mm tree
Message-Id: <20220325013413.EF104C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats: remove unneeded dead assignment
has been removed from the -mm tree.  Its filename was
     taskstats-remove-unneeded-dead-assignment.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are


