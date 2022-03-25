Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E59FC433EF
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 01:32:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353515AbiCYBeR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 24 Mar 2022 21:34:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357547AbiCYBdQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 24 Mar 2022 21:33:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B86BD7C3
        for <mm-commits@vger.kernel.org>; Thu, 24 Mar 2022 18:31:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B8ACB8272B
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 01:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54560C340EC;
        Fri, 25 Mar 2022 01:31:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648171901;
        bh=twzK+8oTYGfHN1Y4GIoHsNRN0NzORnNf3X5t6SNO03I=;
        h=Date:To:From:Subject:From;
        b=lX+K5RCC1/b0CA9kXY/x3WhhpiNLFB8L+XoQyvpNVXDEWwCJoEB3Tn+N1YxL/bvhO
         fQGJ/oURgc7NlNSM4e4czlbreHSegQ6eg9m4XdxJU+3N6Nl17QxiWoSMgNmm5daVj7
         INSVpy0EJ4d4RKpUWiVO6AWA1Xp7rktcTOI+e9uI=
Date:   Thu, 24 Mar 2022 18:31:40 -0700
To:     mm-commits@vger.kernel.org, naoya.horiguchi@nec.com,
        linmiaohe@huawei.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch removed from -mm tree
Message-Id: <20220325013141.54560C340EC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memory-failure.c: rework the signaling logic in kill_proc
has been removed from the -mm tree.  Its filename was
     mm-memory-failurec-rework-the-signaling-logic-in-kill_proc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Miaohe Lin <linmiaohe@huawei.com>
Subject: mm/memory-failure.c: rework the signaling logic in kill_proc

BUS_MCEERR_AR code is only sent when MF_ACTION_REQUIRED is set and the
target is current.  Rework the code to make this clear.

Link: https://lkml.kernel.org/r/20220218090118.1105-4-linmiaohe@huawei.com
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Acked-by: Naoya Horiguchi <naoya.horiguchi@nec.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memory-failure.c |   16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

--- a/mm/memory-failure.c~mm-memory-failurec-rework-the-signaling-logic-in-kill_proc
+++ a/mm/memory-failure.c
@@ -258,16 +258,13 @@ static int kill_proc(struct to_kill *tk,
 	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware memory corruption\n",
 			pfn, t->comm, t->pid);
 
-	if (flags & MF_ACTION_REQUIRED) {
-		if (t == current)
-			ret = force_sig_mceerr(BUS_MCEERR_AR,
-					 (void __user *)tk->addr, addr_lsb);
-		else
-			/* Signal other processes sharing the page if they have PF_MCE_EARLY set. */
-			ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
-				addr_lsb, t);
-	} else {
+	if ((flags & MF_ACTION_REQUIRED) && (t == current))
+		ret = force_sig_mceerr(BUS_MCEERR_AR,
+				 (void __user *)tk->addr, addr_lsb);
+	else
 		/*
+		 * Signal other processes sharing the page if they have
+		 * PF_MCE_EARLY set.
 		 * Don't use force here, it's convenient if the signal
 		 * can be temporarily blocked.
 		 * This could cause a loop when the user sets SIGBUS
@@ -275,7 +272,6 @@ static int kill_proc(struct to_kill *tk,
 		 */
 		ret = send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
 				      addr_lsb, t);  /* synchronous? */
-	}
 	if (ret < 0)
 		pr_info("Memory failure: Error sending signal to %s:%d: %d\n",
 			t->comm, t->pid, ret);
_

Patches currently in -mm which might be from linmiaohe@huawei.com are

mm-huge_memory-make-is_transparent_hugepage-static.patch

