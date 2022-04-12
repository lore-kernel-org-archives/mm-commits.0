Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A73F7C43217
	for <mm-commits@archiver.kernel.org>; Tue, 12 Apr 2022 23:24:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiDLX0y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:26:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbiDLX0Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Apr 2022 19:26:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A055237
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 15:12:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EAD69B8200D
        for <mm-commits@vger.kernel.org>; Tue, 12 Apr 2022 22:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1F0C385A5;
        Tue, 12 Apr 2022 22:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1649801536;
        bh=rEyerkwd8eJzwLYNBl5lUPf80glAnuf75FSdVPvIBkM=;
        h=Date:To:From:Subject:From;
        b=przePeyJETMF9rDICog3nO/52Yd54P1yqtenO6yZOaFbizvHuGoePRKdwB4IywLip
         eRl/wfo8BrB0xA1IHJrgBHy4JBwiQuQNH+xnDbjuBTtLmvlMmBFVZ/jpicKK1/F2xt
         WGw3W7aqTcAQfTZbXWJaDFzispJVzinUP8PAIEc8=
Date:   Tue, 12 Apr 2022 15:12:13 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org,
        michalorzel.eng@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-sem-remove-redundant-assignments.patch added to -mm tree
Message-Id: <20220412221216.7E1F0C385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/sem: Remove redundant assignments
has been added to the -mm tree.  Its filename is
     ipc-sem-remove-redundant-assignments.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/ipc-sem-remove-redundant-assignments.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/ipc-sem-remove-redundant-assignments.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Orzel <michalorzel.eng@gmail.com>
Subject: ipc/sem: Remove redundant assignments

Get rid of redundant assignments which end up in values not being
read either because they are overwritten or the function ends.

Reported by clang-tidy [deadcode.DeadStores]

Link: https://lkml.kernel.org/r/20220409101933.207157-1-michalorzel.eng@gmail.com
Signed-off-by: Michal Orzel <michalorzel.eng@gmail.com>
Reviewed-by: Tom Rix <trix@redhat.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/ipc/sem.c~ipc-sem-remove-redundant-assignments
+++ a/ipc/sem.c
@@ -766,7 +766,6 @@ static int perform_atomic_semop(struct s
 	for (sop = sops; sop < sops + nsops; sop++) {
 		curr = &sma->sems[sop->sem_num];
 		sem_op = sop->sem_op;
-		result = curr->semval;
 
 		if (sop->sem_flg & SEM_UNDO) {
 			int undo = un->semadj[sop->sem_num] - sem_op;
@@ -1430,7 +1429,6 @@ static int semctl_main(struct ipc_namesp
 	if (err)
 		goto out_rcu_wakeup;
 
-	err = -EACCES;
 	switch (cmd) {
 	case GETALL:
 	{
_

Patches currently in -mm which might be from michalorzel.eng@gmail.com are

kexec-remove-redundant-assignments.patch
ipc-sem-remove-redundant-assignments.patch

