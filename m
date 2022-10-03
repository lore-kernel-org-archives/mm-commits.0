Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DE37C4332F
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:28:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiJCV2W (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:28:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiJCV1Y (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:27:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FEE4564FD
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07744B815F8
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:18:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D313C433C1;
        Mon,  3 Oct 2022 21:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831913;
        bh=rqqX/Z3KkXQg2Sb9qkzol58LXZ55dV+EOTO5MGik6/k=;
        h=Date:To:From:Subject:From;
        b=FDay09f29KjhQVsl6b3asSQ9bvCfeDTMzNSVMLQLgq63RNfk7pL/CxHuvIX+nFt6y
         GOWbukaFnrbI/dKlpphMftlexoG3Y4KB8Im7cVHVcomWgoWTHirY/t/KMcF0X4wA6u
         mipiv9XVx5NvIYWD9vXylh6fPzuM4616mrRlGaZ4=
Date:   Mon, 03 Oct 2022 14:18:32 -0700
To:     mm-commits@vger.kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch removed from -mm tree
Message-Id: <20221003211833.9D313C433C1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: a
has been removed from the -mm tree.  Its filename was
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

This patch was dropped because it was folded into ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: a
Date: Wed Sep 21 04:54:33 PM PDT 2022

In file included from ./include/linux/kernel.h:26,
                 from ./arch/x86/include/asm/percpu.h:27,
                 from ./arch/x86/include/asm/preempt.h:6,
                 from ./include/linux/preempt.h:78,
                 from ./include/linux/spinlock.h:55,
                 from ./include/linux/ipc.h:5,
                 from ./include/uapi/linux/msg.h:5,
                 from ./include/linux/msg.h:6,
                 from ipc/msg.c:27:
ipc/msg.c: In function 'msgctl_info':
./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
ipc/msg.c:504:35: note: in expansion of macro 'min'
  504 |                 msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs), INT_MAX);
      |                                   ^~~
./include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast [-Werror]
   20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
      |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
   26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
      |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
   36 |         __builtin_choose_expr(__safe_cmp(x, y), \
      |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
   45 | #define min(x, y)       __careful_cmp(x, y, <)
      |                         ^~~~~~~~~~~~~
ipc/msg.c:505:35: note: in expansion of macro 'min'
  505 |                 msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes), INT_MAX);
      |                                   ^~~



Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix
+++ a/ipc/msg.c
@@ -501,8 +501,12 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs), INT_MAX);
-		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes), INT_MAX);
+		msginfo->msgmap = min_t(int,
+				     percpu_counter_sum(&ns->percpu_msg_hdrs),
+				     INT_MAX);
+		msginfo->msgtql = min_t(int,
+		                     percpu_counter_sum(&ns->percpu_msg_bytes),
+				     INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

