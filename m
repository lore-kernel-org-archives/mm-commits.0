Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5945AECAAD8
	for <mm-commits@archiver.kernel.org>; Wed, 21 Sep 2022 20:22:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiIUUWR (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 21 Sep 2022 16:22:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230227AbiIUUWO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 21 Sep 2022 16:22:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E56A4053
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 13:22:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D75E626AC
        for <mm-commits@vger.kernel.org>; Wed, 21 Sep 2022 20:22:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4A3C433D6;
        Wed, 21 Sep 2022 20:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663791732;
        bh=FXDF7BXcFOF0i5LwUGbIgEqzHVhaI8bGU3Q+GQOZHyQ=;
        h=Date:To:From:Subject:From;
        b=O+1/k6HAjXHzMgGehZWSXGg31DYvRJjn4tHlMO9KPolkTiyyScKW3Qa+ymTFv1yay
         Y/awzXMDW3Z/43dzx9kBBWyFdM0QgeHRFfbsQqtKKp4cleZHWqUgCv+V+WAdNU885V
         Ne68ZzlsGHs5WO+CvCfuQxv5INWOOzY2cn+PCRYo=
Date:   Wed, 21 Sep 2022 13:22:11 -0700
To:     mm-commits@vger.kernel.org, tim.c.chen@linux.intel.com,
        manfred@colorfullif.com, jiebin.sun@intel.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20220921202212.BA4A3C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/msg: avoid negative value by overflow in msginfo
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch

This patch will later appear in the mm-nonmm-unstable branch at
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
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix.patch

