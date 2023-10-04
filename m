Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56F1CE936E0
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbjJDUXg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244732AbjJDUXK (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:23:10 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B20C1
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:23:07 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91624C433CB;
        Wed,  4 Oct 2023 20:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450986;
        bh=VZH5QoeWzdVOX9h9Aj8mE/K6KApQL/BuwYT/l9G8tQg=;
        h=Date:To:From:Subject:From;
        b=z05uj2fmdAwccOCOjG3aQny57JYAgDBd9oGzSzLaBod+D97ffdeV+d0TM7bpV+0jN
         CfVm2VltHWlGR13ubqN41zBiawflJosugn5kdUsnIYi4K/0IWNe0WeGc8Wl5mBT4PO
         s/6bczto/EkeSGdJhrda2No9NlcvekmmmA4IzYhM=
Date:   Wed, 04 Oct 2023 13:23:05 -0700
To:     mm-commits@vger.kernel.org, agruenba@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] kthread-add-kthread_stop_put-v2.patch removed from -mm tree
Message-Id: <20231004202306.91624C433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: kthread-add-kthread_stop_put-v2
has been removed from the -mm tree.  Its filename was
     kthread-add-kthread_stop_put-v2.patch

This patch was dropped because it was folded into kthread-add-kthread_stop_put.patch

------------------------------------------------------
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: kthread-add-kthread_stop_put-v2
Date: Mon, 11 Sep 2023 13:17:30 +0200

fix kerneldoc comment

Link: https://lkml.kernel.org/r/20230911111730.2565537-1-agruenba@redhat.com
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |   13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

--- a/kernel/kthread.c~kthread-add-kthread_stop_put-v2
+++ a/kernel/kthread.c
@@ -718,16 +718,9 @@ EXPORT_SYMBOL(kthread_stop);
 /**
  * kthread_stop_put - stop a thread and put its task struct
  *
- * Stops a kthread and put its task_struct.  This is meant for callers
- * that are holding an extra reference on the task struct, for example:
- *
- *   t = kthread_create(...);
- *   if (!IS_ERR(t)) {
- *     get_task_struct(t);
- *     wake_up_process(t);
- *   }
- *
- * Returns the result of kthread_stop().
+ * Stops a thread created by kthread_create() and put its task_struct.
+ * Only use when holding an extra task struct reference obtained by
+ * calling get_task_struct().
  */
 int kthread_stop_put(struct task_struct *k)
 {
_

Patches currently in -mm which might be from agruenba@redhat.com are

kthread-add-kthread_stop_put.patch

