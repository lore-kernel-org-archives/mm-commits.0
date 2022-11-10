Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FF78C4332F
	for <mm-commits@archiver.kernel.org>; Thu, 10 Nov 2022 03:16:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232195AbiKJDQZ (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 9 Nov 2022 22:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbiKJDQY (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 9 Nov 2022 22:16:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EBD31C911
        for <mm-commits@vger.kernel.org>; Wed,  9 Nov 2022 19:16:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5AC49B82065
        for <mm-commits@vger.kernel.org>; Thu, 10 Nov 2022 03:16:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE98BC433D6;
        Thu, 10 Nov 2022 03:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1668050181;
        bh=QTi7YrQFNJFkhBzucRKOv5YZnR9RPZWuynoc2/EFmCc=;
        h=Date:To:From:Subject:From;
        b=MIYoFMrZiiOelsUrT9Q1HD6q9YiDuKEE/9kI0RdFSTb6ZhV5XOzW8+NASnWbNy8QB
         TLR9m5Q+j1eiiWubZ6eVHVm58mhizGbSnDdgQ8LnTSREvzmRJaYauttK4cvUZYMtlO
         B0dbFyzfpIykc8vco+6sdFdlxwq/Fmi8W8Y6m0+s=
Date:   Wed, 09 Nov 2022 19:16:20 -0800
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch added to mm-nonmm-unstable branch
Message-Id: <20221110031620.EE98BC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib: objpool: fix some kernel-doc comments
has been added to the -mm mm-nonmm-unstable branch.  Its filename is
     lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

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
From: Yang Li <yang.lee@linux.alibaba.com>
Subject: lib: objpool: fix some kernel-doc comments
Date: Wed, 9 Nov 2022 11:57:04 +0800

Make the description of @oh to @head in objpool_pop()
to clear the below warnings:

lib/objpool.c:425: warning: Excess function parameter 'oh' description in 'objpool_pop'
lib/objpool.c:425: warning: Function parameter or member 'head' not described in 'objpool_pop'

Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=2821
Link: https://lkml.kernel.org/r/20221109035704.88975-1-yang.lee@linux.alibaba.com
Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
Reported-by: Abaci Robot <abaci@linux.alibaba.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/objpool.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/objpool.c~lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix
+++ a/lib/objpool.c
@@ -414,7 +414,7 @@ static inline void *__objpool_try_get_sl
  * objpool_pop: allocate an object from objects pool
  *
  * args:
- * @oh:  object pool
+ * @head:  object pool used to allocate an object
  *
  * return:
  *   object: NULL if failed (object pool is empty)
_

Patches currently in -mm which might be from yang.lee@linux.alibaba.com are

lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

