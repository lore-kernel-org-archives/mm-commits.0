Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE389C83F2C
	for <mm-commits@archiver.kernel.org>; Mon,  4 Sep 2023 00:02:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349595AbjIDACe (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 3 Sep 2023 20:02:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbjIDACd (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 3 Sep 2023 20:02:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27B0E102
        for <mm-commits@vger.kernel.org>; Sun,  3 Sep 2023 17:02:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C6C62B80C9D
        for <mm-commits@vger.kernel.org>; Mon,  4 Sep 2023 00:02:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBB7C433C9;
        Mon,  4 Sep 2023 00:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1693785746;
        bh=vreLUnZKoDKu+q+8cTyVwoO6Vzg2qCX6e0HkUM2D+eU=;
        h=Date:To:From:Subject:From;
        b=z4S7X4rpu/MatXdYRl7Gmnya6e2hfM1tL9XeboEwNG5oRp+/c5D25OC7GIEf+hU8g
         +evqP1d/g6DfgD97Kg/um8EFhykcM0YwvUTnuyD8bch6bcYcBXcoNfs8t6gI54kh6T
         VmoI4VlChg01cEXLCa1yYU3eW0akBzVV9p/bnXro=
Date:   Sun, 03 Sep 2023 17:02:24 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        David.Laight@ACULAB.COM, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + __kill_pgrp_info-simplify-the-calculation-of-return-value.patch added to mm-nonmm-unstable branch
Message-Id: <20230904000226.7DBB7C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: __kill_pgrp_info: simplify the calculation of return value
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     __kill_pgrp_info-simplify-the-calculation-of-return-value.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/__kill_pgrp_info-simplify-the-calculation-of-return-value.patch

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
From: Oleg Nesterov <oleg@redhat.com>
Subject: __kill_pgrp_info: simplify the calculation of return value
Date: Wed, 23 Aug 2023 19:14:55 +0200

No need to calculate/check the "success" variable, we can kill it and update
retval in the main loop unless it is zero.

Link: https://lkml.kernel.org/r/20230823171455.GA12188@redhat.com
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Suggested-by: David Laight <David.Laight@ACULAB.COM>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/signal.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/kernel/signal.c~__kill_pgrp_info-simplify-the-calculation-of-return-value
+++ a/kernel/signal.c
@@ -1471,16 +1471,21 @@ int group_send_sig_info(int sig, struct
 int __kill_pgrp_info(int sig, struct kernel_siginfo *info, struct pid *pgrp)
 {
 	struct task_struct *p = NULL;
-	int retval, success;
+	int ret = -ESRCH;
 
-	success = 0;
-	retval = -ESRCH;
 	do_each_pid_task(pgrp, PIDTYPE_PGID, p) {
 		int err = group_send_sig_info(sig, info, p, PIDTYPE_PGID);
-		success |= !err;
-		retval = err;
+		/*
+		 * If group_send_sig_info() succeeds at least once ret
+		 * becomes 0 and after that the code below has no effect.
+		 * Otherwise we return the last err or -ESRCH if this
+		 * process group is empty.
+		 */
+		if (ret)
+			ret = err;
 	} while_each_pid_task(pgrp, PIDTYPE_PGID, p);
-	return success ? 0 : retval;
+
+	return ret;
 }
 
 int kill_pid_info(int sig, struct kernel_siginfo *info, struct pid *pid)
_

Patches currently in -mm which might be from oleg@redhat.com are

change-thread_group_empty-to-use-task_struct-thread_node.patch
kill-task_struct-thread_group.patch
__kill_pgrp_info-simplify-the-calculation-of-return-value.patch

