Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1322AC433FE
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:28:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbiJCV2V (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiJCV1X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722365C94B
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:18:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F7B2610A5
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C05C433D7;
        Mon,  3 Oct 2022 21:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831912;
        bh=bzBTDDkK52H/poN7AqpOr1XFxGG8uvmCp/i4dq5SRb4=;
        h=Date:To:From:Subject:From;
        b=ywwOjZ/EHeNKIIMWSO9cx1CGfOUFMKMBmDYgcqe3k3dTRmQ02AcXEQcyuQE08d2Tq
         x8j038ZO72LTKaijFELYR9BP29uAb97scR8FvUnZrJfpFq/Gi1gpML857g1R8Ja82Z
         BBPZsuKAv9oa2mqdpv2F0arZbGaAOyyCX95OTCHk=
Date:   Mon, 03 Oct 2022 14:18:31 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        manfred@colorfullif.com, jiebin.sun@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch removed from -mm tree
Message-Id: <20221003211832.61C05C433D7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc/msg: avoid negative value by overflow in msginfo
has been removed from the -mm tree.  Its filename was
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch

This patch was dropped because it was folded into ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

------------------------------------------------------
From: Jiebin Sun <jiebin.sun@intel.com>
Subject: ipc/msg: avoid negative value by overflow in msginfo
Date: Tue, 20 Sep 2022 23:08:09 +0800

The 32-bit value in msginfo struct could be negative if we get it from
signed 64-bit.  Clamping it to INT_MAX helps to avoid the negative value
by overflow.

Link: https://lkml.kernel.org/r/20220920150809.4014944-1-jiebin.sun@intel.com
Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>
Reviewed-by: Manfred Spraul <manfred@colorfullif.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix
+++ a/ipc/msg.c
@@ -501,8 +501,8 @@ static int msgctl_info(struct ipc_namesp
 	max_idx = ipc_get_maxidx(&msg_ids(ns));
 	up_read(&msg_ids(ns).rwsem);
 	if (cmd == MSG_INFO) {
-		msginfo->msgmap = percpu_counter_sum(&ns->percpu_msg_hdrs);
-		msginfo->msgtql = percpu_counter_sum(&ns->percpu_msg_bytes);
+		msginfo->msgmap = min(percpu_counter_sum(&ns->percpu_msg_hdrs), INT_MAX);
+		msginfo->msgtql = min(percpu_counter_sum(&ns->percpu_msg_bytes), INT_MAX);
 	} else {
 		msginfo->msgmap = MSGMAP;
 		msginfo->msgpool = MSGPOOL;
_

Patches currently in -mm which might be from jiebin.sun@intel.com are

percpu-add-percpu_counter_add_local-and-percpu_counter_sub_local.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

