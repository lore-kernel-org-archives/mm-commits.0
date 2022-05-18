Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9A6C4332F
	for <mm-commits@archiver.kernel.org>; Wed, 18 May 2022 17:32:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240857AbiERRcd (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 May 2022 13:32:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240868AbiERRcc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 May 2022 13:32:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF16815E4B1
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 10:32:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52E15617B6
        for <mm-commits@vger.kernel.org>; Wed, 18 May 2022 17:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A7CC385A5;
        Wed, 18 May 2022 17:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652895150;
        bh=sxWcMi6/+7qpK0XId/7lpDtUSTtOJebS6HPx4ktHx6I=;
        h=Date:To:From:Subject:From;
        b=RR9qrJI2wZVpWHuQg5wPTM/YK4muyHXiI80FDgY4h6qgmchzry7ysKqQTB/1HCzLC
         ngIvCZGhdn8w61L/PlWJ+F+L4aemdp/NSQKVoibONvZgJ7RX+MwwfONeRClTy7kYbj
         GA29Fp59pkFvYHP4ODCoagtr4MUcZl+Tw/6+WZac=
Date:   Wed, 18 May 2022 10:32:29 -0700
To:     mm-commits@vger.kernel.org, elver@google.com, liuyun01@kylinos.cn,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kfence-print-disabling-or-re-enabling-message.patch added to mm-unstable branch
Message-Id: <20220518173230.A6A7CC385A5@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/kfence: print disabling or re-enabling message
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kfence-print-disabling-or-re-enabling-message.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kfence-print-disabling-or-re-enabling-message.patch

This patch will later appear in the mm-unstable branch at
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
From: Jackie Liu <liuyun01@kylinos.cn>
Subject: mm/kfence: print disabling or re-enabling message
Date: Wed, 18 May 2022 15:31:05 +0800

By printing information, we can friendly prompt the status change
information of kfence by dmesg and record by syslog.

Also, set kfence_enabled to false only when needed.

Link: https://lkml.kernel.org/r/20220518073105.3160335-1-liu.yun@linux.dev
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Co-developed-by: Marco Elver <elver@google.com>
Signed-off-by: Marco Elver <elver@google.com>
Reviewed-by: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kfence/core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/mm/kfence/core.c~mm-kfence-print-disabling-or-re-enabling-message
+++ a/mm/kfence/core.c
@@ -69,8 +69,11 @@ static int param_set_sample_interval(con
 	if (ret < 0)
 		return ret;
 
-	if (!num) /* Using 0 to indicate KFENCE is disabled. */
+	/* Using 0 to indicate KFENCE is disabled. */
+	if (!num && READ_ONCE(kfence_enabled)) {
+		pr_info("disabled\n");
 		WRITE_ONCE(kfence_enabled, false);
+	}
 
 	*((unsigned long *)kp->arg) = num;
 
@@ -908,6 +911,7 @@ static int kfence_enable_late(void)
 
 	WRITE_ONCE(kfence_enabled, true);
 	queue_delayed_work(system_unbound_wq, &kfence_timer, 0);
+	pr_info("re-enabled\n");
 	return 0;
 }
 
_

Patches currently in -mm which might be from liuyun01@kylinos.cn are

mm-kfence-print-disabling-or-re-enabling-message.patch

