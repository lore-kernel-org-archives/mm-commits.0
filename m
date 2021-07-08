Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B702C07E95
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:29:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C5D561CCB
	for <mm-commits@archiver.kernel.org>; Thu,  8 Jul 2021 00:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbhGHAca (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 7 Jul 2021 20:32:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:39962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230000AbhGHAca (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Wed, 7 Jul 2021 20:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14EC061C91;
        Thu,  8 Jul 2021 00:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1625704189;
        bh=sjbY13vAgwAKVXJRIiO9+eNG5N7NL+vWIcimPGdnMOA=;
        h=Date:From:To:Subject:From;
        b=l+3PvgOM1cgmkEt6ohKCfcVp6vJGM7ey7jTY+JVBT8wjj5AZAOkv0fhj7EE9qA3LV
         93DZ42ox8pFKRGvFHUpHgs6iQtH7XGtP5aY6n3UtNp70idESwaWta7TqUzlSV9ccWy
         ZXsl1juAgZB4Aq57jXeJ9d/FuH2nsaZwRq34A+Fw=
Date:   Wed, 07 Jul 2021 17:29:48 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, paulmck@kernel.org,
        oliver.sang@intel.com, vbabka@suse.cz
Subject:  [folded-merged]
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch removed
 from -mm tree
Message-ID: <20210708002948.wi-VD%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use stackdepot to save stack trace in objects-fix
has been removed from the -mm tree.  Its filename was
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

This patch was dropped because it was folded into mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/slub: use stackdepot to save stack trace in objects-fix

Paul reports [1] lockdep splat HARDIRQ-safe -> HARDIRQ-unsafe lock order
detected.  Kernel test robot reports [2]
BUG:sleeping_function_called_from_invalid_context_at_mm/page_alloc.c

The stack trace might be saved from contexts where we can't block so GFP_KERNEL
is unsafe. So use GFP_NOWAIT. Under memory pressure we might thus fail to save
some new unique stack, but that should be extremely rare.

[1] https://lore.kernel.org/linux-mm/20210515204622.GA2672367@paulmck-ThinkPad-P17-Gen-1/
[2] https://lore.kernel.org/linux-mm/20210516144152.GA25903@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20210516195150.26740-1-vbabka@suse.cz
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2
+++ a/mm/slub.c
@@ -646,7 +646,7 @@ static void set_track(struct kmem_cache
 
 	if (addr) {
 #ifdef CONFIG_STACKDEPOT
-		p->handle = save_stack_depot_trace(GFP_KERNEL);
+		p->handle = save_stack_depot_trace(GFP_NOWAIT);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
_

Patches currently in -mm which might be from vbabka@suse.cz are

mm-slub-use-stackdepot-to-save-stack-trace-in-objects.patch

