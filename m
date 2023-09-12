Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED46EEE3F08
	for <mm-commits@archiver.kernel.org>; Tue, 12 Sep 2023 17:42:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbjILRmX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Sep 2023 13:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbjILRmW (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 12 Sep 2023 13:42:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF04C1
        for <mm-commits@vger.kernel.org>; Tue, 12 Sep 2023 10:42:18 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844FCC433C8;
        Tue, 12 Sep 2023 17:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1694540538;
        bh=dz3tpTNAfrOaXe4VdfFT+k2VPoDM2oIU2TCdeFWEAGI=;
        h=Date:To:From:Subject:From;
        b=mHI6ZKjEotiWpelDOn6me149dur5GEpEeODGXCrA8YOZ4reXDuop6805gqszxoUk1
         MvpFywmSPu1lYz0Mw0xnJtqsx5kP2UTS9pUsobdD+Nq8UN9iea48vIPgRHPep/umIo
         08mhxyQRakLEwl2ZVRG+1X2YvU6+HnVtxZV6IyPE=
Date:   Tue, 12 Sep 2023 10:42:17 -0700
To:     mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        agruenba@redhat.com, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kthread-add-kthread_stop_put-v2-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20230912174218.844FCC433C8@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kthread-add-kthread_stop_put-v2-fix
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     kthread-add-kthread_stop_put-v2-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kthread-add-kthread_stop_put-v2-fix.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kthread-add-kthread_stop_put-v2-fix
Date: Tue Sep 12 10:41:17 AM PDT 2023

document kthread_stop_put()'s argument

Cc: Andreas Gruenbacher <agruenba@redhat.com>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lkml.kernel.org/r/20230912152030.34e9ac3d@canb.auug.org.au

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kthread.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kthread.c~kthread-add-kthread_stop_put-v2-fix
+++ a/kernel/kthread.c
@@ -717,6 +717,7 @@ EXPORT_SYMBOL(kthread_stop);
 
 /**
  * kthread_stop_put - stop a thread and put its task struct
+ * @k: thread created by kthread_create().
  *
  * Stops a thread created by kthread_create() and put its task_struct.
  * Only use when holding an extra task struct reference obtained by
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
revert-scripts-gdb-symbols-add-specific-ko-module-load-command.patch
kthread-add-kthread_stop_put-v2-fix.patch

