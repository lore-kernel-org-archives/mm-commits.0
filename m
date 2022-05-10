Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74CE6C433EF
	for <mm-commits@archiver.kernel.org>; Tue, 10 May 2022 04:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236222AbiEJEZY (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 10 May 2022 00:25:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234357AbiEJEYO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 10 May 2022 00:24:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D8A1D676D
        for <mm-commits@vger.kernel.org>; Mon,  9 May 2022 21:18:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6368CB81AF7
        for <mm-commits@vger.kernel.org>; Tue, 10 May 2022 04:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19F08C385C2;
        Tue, 10 May 2022 04:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652156287;
        bh=Fj1n39dViKzrJHn/VV0t9JfyhTBprlOePCSTbA27QAE=;
        h=Date:To:From:Subject:From;
        b=G9Qu65YTZvXa5BU8AQiSCNH/dSo2TDCq0+uDGiaECWODWWj/WAMZMK2GCcW/PdX7n
         7P30H7dKmqTxitnEqo+phK1dnH19ewHU98LTgevpOfczz87gvKyUlCXWxznuIpWsTl
         TUNuZ4cNjbeNBJ8Gs8R/0ZKpaa3k1u1gO1j61BaE=
Date:   Mon, 09 May 2022 21:18:06 -0700
To:     mm-commits@vger.kernel.org, trix@redhat.com,
        ndesaulniers@google.com, nathan@kernel.org,
        michalorzel.eng@gmail.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] ipc-sem-remove-redundant-assignments.patch removed from -mm tree
Message-Id: <20220510041807.19F08C385C2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/sem: remove redundant assignments
has been removed from the -mm tree.  Its filename was
     ipc-sem-remove-redundant-assignments.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Michal Orzel <michalorzel.eng@gmail.com>
Subject: ipc/sem: remove redundant assignments

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

 ipc/sem.c |    2 --
 1 file changed, 2 deletions(-)

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


