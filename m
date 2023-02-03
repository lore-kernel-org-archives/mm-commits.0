Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90F85C636CC
	for <mm-commits@archiver.kernel.org>; Fri,  3 Feb 2023 06:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231923AbjBCGvQ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 3 Feb 2023 01:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbjBCGvD (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 3 Feb 2023 01:51:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4F445F53
        for <mm-commits@vger.kernel.org>; Thu,  2 Feb 2023 22:50:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 32D6661DBF
        for <mm-commits@vger.kernel.org>; Fri,  3 Feb 2023 06:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 883DCC4339B;
        Fri,  3 Feb 2023 06:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1675407058;
        bh=17BZky6pWDujsywR/16QoiTXOPscDNQYJZky6AhMaYs=;
        h=Date:To:From:Subject:From;
        b=GZsVb5Bx5nwBGXlQSgN/XlmzzZoHH2IaPMULK8mpKQoDLQ3L6XVRpGQ3UFYoikpWG
         xc2SnNTFMMW5QKymWTuCk11V2bTMqiMnzSMI5CAWaabV1DF4lwc7Tf4T6L104HLQjl
         Mk3GeD0WV9sc5LzdXhsZL8v0sOiXtyAKrimSPZ0Q=
Date:   Thu, 02 Feb 2023 22:50:58 -0800
To:     mm-commits@vger.kernel.org, tj@kernel.org, pmladek@suse.com,
        qiang1.zhang@intel.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-nonmm-stable] kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch removed from -mm tree
Message-Id: <20230203065058.883DCC4339B@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread_worker: check all delayed works when destroy kthread worker
has been removed from the -mm tree.  Its filename was
     kthread_worker-check-all-delayed-works-when-destroy-kthread-worker.patch

This patch was dropped because it was merged into the mm-nonmm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

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
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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


