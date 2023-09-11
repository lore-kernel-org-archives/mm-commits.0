Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9378DCA0EC6
	for <mm-commits@archiver.kernel.org>; Mon, 11 Sep 2023 22:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240804AbjIKWWc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 11 Sep 2023 18:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244028AbjIKSsv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 11 Sep 2023 14:48:51 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F891B6
        for <mm-commits@vger.kernel.org>; Mon, 11 Sep 2023 11:48:47 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB321C433C7;
        Mon, 11 Sep 2023 18:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694458126;
        bh=grFqsGjAaRoTusyxT7KVaEmm0ldc+YgO9NcOWqjp4xo=;
        h=Date:To:From:Subject:From;
        b=iDLGZWij5IjFvKoAYCyUrQhArrSfr32zD4NNLn2lEBlb5i/d8mFtTOPkcBl1WMvXz
         IKI4Hm8Woejja6537gB/50CFbssRQckHkqKlsPzgdzXbBdHhkkua0DFuvV/Ld92upy
         5Ce250TDAMLGbRMv9bORCUAYPNkfAFe+1eIUo5L0=
Date:   Mon, 11 Sep 2023 11:48:46 -0700
To:     mm-commits@vger.kernel.org, agruenba@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-add-kthread_stop_put-v2.patch added to mm-nonmm-unstable branch
Message-Id: <20230911184846.BB321C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread-add-kthread_stop_put-v2
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-add-kthread_stop_put-v2.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-add-kthread_stop_put-v2.patch

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
kthread-add-kthread_stop_put-v2.patch

