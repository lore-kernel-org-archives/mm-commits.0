Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA2F0E936E2
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:24:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245014AbjJDUYm (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244940AbjJDUXa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20FEF180
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:27 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 847FCC433CA;
        Wed,  4 Oct 2023 20:23:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696451006;
        bh=DnE+zfS8mLHTN8CjX5gZO5bHnN3ifJ00rp2yIuydt60=;
        h=Date:To:From:Subject:From;
        b=Pq9EbKSxWDtZvJl/k5bpYCtJm1NWWV0pzld9oacOyvAKG1tOHEcbjGEas8gf+y/ZT
         Bu6VIvk7hcJyAY0nD+0yf/uJplEJ+3mE+z4vCkQKhJIS3niUlTH7RZjGHKxO0Upu2s
         iQAw0q0eERuHlM11dNtn9eBAxNYtWdRXjp0C4c0U=
Date:   Wed, 04 Oct 2023 13:23:25 -0700
To:     mm-commits@vger.kernel.org, ebiederm@xmission.com,
        David.Laight@ACULAB.COM, oleg@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] __kill_pgrp_info-simplify-the-calculation-of-return-value.patch removed from -mm tree
Message-Id: <20231004202326.847FCC433CA@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: __kill_pgrp_info: simplify the calculation of return value
has been removed from the -mm tree.  Its filename was
     __kill_pgrp_info-simplify-the-calculation-of-return-value.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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


