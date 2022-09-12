Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAF6AC6FA83
	for <mm-commits@archiver.kernel.org>; Mon, 12 Sep 2022 19:29:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbiILT3K (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 12 Sep 2022 15:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbiILT3J (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 12 Sep 2022 15:29:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C224E459AA
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 12:29:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7B3AAB80DBF
        for <mm-commits@vger.kernel.org>; Mon, 12 Sep 2022 19:29:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337C7C433D6;
        Mon, 12 Sep 2022 19:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1663010946;
        bh=L31EYHG16kMmuVopyK0e1jNq4isRCEzFoVPRqzfkpxA=;
        h=Date:To:From:Subject:From;
        b=z+Hb+9J+4tJWeQ/cay0aPdV6ikUMWs8l9pRo0R6VR3h715I88xb9ZzSts75dXobQy
         UsfVzXE851VoeCsm8+CngnjQkRk43d9paeHzM+0V2XByyqAXr/duDfB9kFVIyRIzCj
         JYUFQsbCSzSpqZHMjo6VcY87mxJ3XYYxLoVVZNvo=
Date:   Mon, 12 Sep 2022 12:29:05 -0700
To:     mm-commits@vger.kernel.org, zealci@zte.com.cn, tglx@linutronix.de,
        luto@kernel.org, liam.howlett@oracle.com, fenghua.yu@intel.com,
        ebiederm@xmission.com, brauner@kernel.org, bigeasy@linutronix.de,
        xu.panda@zte.com.cn, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + fork-remove-duplicate-included-header-files.patch added to mm-nonmm-unstable branch
Message-Id: <20220912192906.337C7C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: fork: remove duplicate included header files
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     fork-remove-duplicate-included-header-files.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/fork-remove-duplicate-included-header-files.patch

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
From: Xu Panda <xu.panda@zte.com.cn>
Subject: fork: remove duplicate included header files
Date: Mon, 12 Sep 2022 07:15:57 +0000

linux/sched/mm.h is included more than once.

Link: https://lkml.kernel.org/r/20220912071556.16811-1-xu.panda@zte.com.cn
Signed-off-by: Xu Panda <xu.panda@zte.com.cn>
Reported-by: Zeal Robot <zealci@zte.com.cn>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner (Microsoft) <brauner@kernel.org>
Cc: "Eric W . Biederman" <ebiederm@xmission.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 -
 1 file changed, 1 deletion(-)

--- a/kernel/fork.c~fork-remove-duplicate-included-header-files
+++ a/kernel/fork.c
@@ -97,7 +97,6 @@
 #include <linux/scs.h>
 #include <linux/io_uring.h>
 #include <linux/bpf.h>
-#include <linux/sched/mm.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
_

Patches currently in -mm which might be from xu.panda@zte.com.cn are

fork-remove-duplicate-included-header-files.patch

