Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1E7C433F5
	for <mm-commits@archiver.kernel.org>; Mon,  3 Oct 2022 21:28:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbiJCV2U (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 3 Oct 2022 17:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiJCV1X (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 3 Oct 2022 17:27:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC994F69F
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 14:18:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC580601D7
        for <mm-commits@vger.kernel.org>; Mon,  3 Oct 2022 21:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A62C433D6;
        Mon,  3 Oct 2022 21:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1664831911;
        bh=kl/rAB7B+nh8ya0o52OPPu03TXCWhqSowlCdpgVlU78=;
        h=Date:To:From:Subject:From;
        b=Em31SdzIAdCDHi11VCpwer0JB7YeIF+ncCnIfkgtMwShsHACEn5c9258VCS/EBUx5
         SCHF+buucvkBJHc6pS9eWHK0dWN3SJQdMwBziJcnEnWzLiCcSqIrMgB5/pvP1ZM6HR
         5xbOz20iMp8Tfke4uqWSfWlvCXjxnJSDYX8LRHc0=
Date:   Mon, 03 Oct 2022 14:18:30 -0700
To:     mm-commits@vger.kernel.org, vasily.averin@linux.dev, tj@kernel.org,
        tim.c.chen@linux.intel.com, shakeelb@google.com,
        manfred@colorfullife.com, legion@kernel.org, jiebin.sun@intel.com,
        ebiederm@xmission.com, dennis@kernel.org, dave@stgolabs.net,
        cl@linux.com, alexander.mikhalitsyn@virtuozzo.com,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch removed from -mm tree
Message-Id: <20221003211831.05A62C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes.patch

This patch was dropped because it was folded into ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
Date: Tue Sep 13 02:45:19 PM PDT 2022

WARNING: labels should not be indented
#158: FILE: ipc/msg.c:1319:
+	fail_msg_hdrs:

WARNING: labels should not be indented
#160: FILE: ipc/msg.c:1321:
+	fail_msg_bytes:

ERROR: space required after that ';' (ctx:VxV)
#203: FILE: ipc/util.h:75:
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0;}
                                                                   ^

total: 1 errors, 2 warnings, 144 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
Cc: Alexey Gladkov <legion@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Jiebin Sun <jiebin.sun@intel.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vasily Averin <vasily.averin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    8 ++++----
 ipc/util.h |    2 +-
 2 files changed, 5 insertions(+), 5 deletions(-)

--- a/ipc/msg.c~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
+++ a/ipc/msg.c
@@ -1316,10 +1316,10 @@ int msg_init_ns(struct ipc_namespace *ns
 	ipc_init_ids(&ns->ids[IPC_MSG_IDS]);
 	return 0;
 
-	fail_msg_hdrs:
-		percpu_counter_destroy(&ns->percpu_msg_bytes);
-	fail_msg_bytes:
-		return ret;
+fail_msg_hdrs:
+	percpu_counter_destroy(&ns->percpu_msg_bytes);
+fail_msg_bytes:
+	return ret;
 }
 
 #ifdef CONFIG_IPC_NS
--- a/ipc/util.h~ipc-msg-mitigate-the-lock-contention-with-percpu-counter-checkpatch-fixes
+++ a/ipc/util.h
@@ -72,7 +72,7 @@ void msg_exit_ns(struct ipc_namespace *n
 void shm_exit_ns(struct ipc_namespace *ns);
 #else
 static inline void sem_init_ns(struct ipc_namespace *ns) { }
-static inline int msg_init_ns(struct ipc_namespace *ns) { return 0;}
+static inline int msg_init_ns(struct ipc_namespace *ns) { return 0; }
 static inline void shm_init_ns(struct ipc_namespace *ns) { }
 
 static inline void sem_exit_ns(struct ipc_namespace *ns) { }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

fs-uninline-inode_maybe_inc_iversion.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter.patch
ipc-msg-mitigate-the-lock-contention-with-percpu-counter-fix-fix.patch

