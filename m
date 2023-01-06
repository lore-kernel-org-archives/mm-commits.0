Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86404C3DA7A
	for <mm-commits@archiver.kernel.org>; Fri,  6 Jan 2023 01:59:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229464AbjAFB7D (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 5 Jan 2023 20:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbjAFB6s (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 5 Jan 2023 20:58:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1745063CF
        for <mm-commits@vger.kernel.org>; Thu,  5 Jan 2023 17:58:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A9BDD61CCD
        for <mm-commits@vger.kernel.org>; Fri,  6 Jan 2023 01:58:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028FCC433EF;
        Fri,  6 Jan 2023 01:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1672970327;
        bh=fvY8pePFJoI+u2cT8Uhmy8vsuUTXijKeQttLA/bNbms=;
        h=Date:To:From:Subject:From;
        b=zCIAFESSfuXc1WBXxTzMb+QfmuBeaAHe8KukHctfx+yIjCby+4MJI/3o8Mw4ICyys
         jFYv/cO5QniKk4l3tRVPOxwanliceMAVAhPlcrfXsAupAkeJfR6VsHc4DOl0f4tQZq
         eC+wFGcWRCXTw5/L7gEIw1Sibiq++kTWAbnsJ+kE=
Date:   Thu, 05 Jan 2023 17:58:46 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, pmladek@suse.com,
        qiang1.zhang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch added to mm-nonmm-unstable branch
Message-Id: <20230106015847.028FCC433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread_worker: check all delayed works when destroy kthread worker
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch

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
From: Zqiang <qiang1.zhang@intel.com>
Subject: kthread_worker: check all delayed works when destroy kthread worker
Date: Wed, 4 Jan 2023 22:42:30 +0800

When destroying a kthread worker warn if there are still some pending
delayed works.  This indicates that the caller should clear all pending
delayed works before destroying the kthread worker.

Link: https://lkml.kernel.org/r/20230104144230.938521-1-qiang1.zhang@intel.com
Signed-off-by: Zqiang <qiang1.zhang@intel.com>
Acked-by: Tejun Heo <tj@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/kernel/kthread.c~kthread_worker-check-all-delayed-works-when-destroy-kthread-worker
+++ a/kernel/kthread.c
@@ -1382,6 +1382,10 @@ EXPORT_SYMBOL_GPL(kthread_flush_worker);
  * Flush and destroy @worker.  The simple flush is enough because the kthread
  * worker API is used only in trivial scenarios.  There are no multi-step state
  * machines needed.
+ *
+ * Note that this function is not responsible for handling delayed work, so
+ * caller should be responsible for queuing or canceling all delayed work items
+ * before invoke this function.
  */
 void kthread_destroy_worker(struct kthread_worker *worker)
 {
@@ -1393,6 +1397,7 @@ void kthread_destroy_worker(struct kthre
 
 	kthread_flush_worker(worker);
 	kthread_stop(task);
+	WARN_ON(!list_empty(&worker->delayed_work_list));
 	WARN_ON(!list_empty(&worker->work_list));
 	kfree(worker);
 }
_

Patches currently in -mm which might be from qiang1.zhang@intel.com are

kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch

