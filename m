Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEF6C352A1
	for <mm-commits@archiver.kernel.org>; Thu,  1 Dec 2022 00:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiLAAPM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 30 Nov 2022 19:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbiLAAOv (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 30 Nov 2022 19:14:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587B5A1A3E
        for <mm-commits@vger.kernel.org>; Wed, 30 Nov 2022 16:08:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 104F9B81AD6
        for <mm-commits@vger.kernel.org>; Thu,  1 Dec 2022 00:08:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C346EC433D6;
        Thu,  1 Dec 2022 00:08:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669853321;
        bh=N1ZhV4veHfoCxGMRJUXA6kkyHuRgpuAYZAo4QqRapj8=;
        h=Date:To:From:Subject:From;
        b=afT8rNbgZXxKsQWydAeDJAJmr5I0A1/U8UyHYHxE3Qv+OmGgZ7q4SUw+dgKH9vN1a
         eb3mwnoLJRRR5xwDJsyNVe4mgOs80yOPjMQoG7HmzaodtmorBCxd0n8HQswGJ9RNEV
         2QafC+YeloZX+TlBmF2TZoObVjECXZOGXMkX7nJs=
Date:   Wed, 30 Nov 2022 16:08:41 -0800
To:     mm-commits@vger.kernel.org, abaci@linux.alibaba.com,
        yang.lee@linux.alibaba.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [folded-merged] lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch removed from -mm tree
Message-Id: <20221201000841.C346EC433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: objpool: fix some kernel-doc comments
has been removed from the -mm tree.  Its filename was
     lib-objpool-added-ring-array-based-lockless-mpmc-queue-fix.patch

This patch was dropped because it was folded into lib-objpool-added-ring-array-based-lockless-mpmc-queue.patch

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

lib-objpool-added-ring-array-based-lockless-mpmc-queue.patch

