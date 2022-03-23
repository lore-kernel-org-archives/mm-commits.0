Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD6C5C433EF
	for <mm-commits@archiver.kernel.org>; Wed, 23 Mar 2022 22:46:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345284AbiCWWs1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 23 Mar 2022 18:48:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345274AbiCWWs0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 23 Mar 2022 18:48:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D6A7CB13
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 15:46:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2E7DFB82120
        for <mm-commits@vger.kernel.org>; Wed, 23 Mar 2022 22:46:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E385C340E8;
        Wed, 23 Mar 2022 22:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648075613;
        bh=2qEXhdrRy1QVZNz9sX+vUJRrItyDRSZ6Pn3ZH6E9Zeo=;
        h=Date:To:From:Subject:From;
        b=GVEaiqVIT+y9a+r2daw9dTy08EvdxRJfl/kP8ZhN2mA7EqScovpZY1WBv5CvhJsxb
         M9EUTBRYWwawWmJ3OHaDmmSU1TzMwbm2WlZLnAlEmz+7+GE5JzpVZi8ROKLHGb5VNM
         CQJhymWb4s9qqN5xxN8O46SfvDIk3CnO5omZ5APk=
Date:   Wed, 23 Mar 2022 15:46:52 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, natechancellor@gmail.com,
        lukas.bulwahn@gmail.com, bsingharora@gmail.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] taskstats-remove-unneeded-dead-assignment-fix.patch removed from -mm tree
Message-Id: <20220323224653.8E385C340E8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: taskstats-remove-unneeded-dead-assignment-fix
has been removed from the -mm tree.  Its filename was
     taskstats-remove-unneeded-dead-assignment-fix.patch

This patch was dropped because it was folded into taskstats-remove-unneeded-dead-assignment.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: taskstats-remove-unneeded-dead-assignment-fix

reduce scope of `rc'

Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Balbir Singh <bsingharora@gmail.com>
Cc: Nathan Chancellor <natechancellor@gmail.com>
Cc: Tom Rix <trix@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/taskstats.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/taskstats.c~taskstats-remove-unneeded-dead-assignment-fix
+++ a/kernel/taskstats.c
@@ -113,12 +113,14 @@ static void send_cpu_listeners(struct sk
 	struct listener *s, *tmp;
 	struct sk_buff *skb_next, *skb_cur = skb;
 	void *reply = genlmsg_data(genlhdr);
-	int rc, delcount = 0;
+	int delcount = 0;
 
 	genlmsg_end(skb, reply);
 
 	down_read(&listeners->sem);
 	list_for_each_entry(s, &listeners->list, list) {
+		int rc;
+
 		skb_next = NULL;
 		if (!list_is_last(&s->list, &listeners->list)) {
 			skb_next = skb_clone(skb_cur, GFP_KERNEL);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

taskstats-remove-unneeded-dead-assignment.patch
memcg-sync-flush-only-if-periodic-flush-is-delayed-fix.patch
mm.patch
documentation-vm-page_ownerrst-update-the-documentation-fix.patch
mm-mempolicy-convert-from-atomic_t-to-refcount_t-on-mempolicy-refcnt-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
mm-oom_killc-fix-vm_oom_kill_table-ifdeffery.patch
kasan-improve-vmalloc-tests-fix-3-fix.patch
mm-slightly-clarify-ksm-logic-in-do_swap_page-fix.patch
mm-huge_memory-remove-stale-locking-logic-from-__split_huge_pmd-fix.patch
mutex-subsystem-synchro-test-module-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

