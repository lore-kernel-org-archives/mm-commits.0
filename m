Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_RED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D29CC433B4
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:43:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E8ABE610CB
	for <mm-commits@archiver.kernel.org>; Tue, 18 May 2021 23:43:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235758AbhERXo2 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 May 2021 19:44:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235382AbhERXo2 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 18 May 2021 19:44:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C171561074;
        Tue, 18 May 2021 23:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1621381389;
        bh=jcbOO/YPtCxeIGEnKpLbN/AINA6xwR5WmPnD1BqTmLg=;
        h=Date:From:To:Subject:From;
        b=k3agrNbjQEPhtfQTn1yd+JFLTopRxbssbiTXqgM8kAzd/IVYhmDov7mh2mY+1GQQN
         Oy+COYjxp02LC6boBiMa6gr8z1Po/hIm8qkT9ozwjQovvGFDcISA+hPXd86BlxSyoV
         u0Oo/1Bj+nbIihuJf28OxULvgmJUUJ5Bxzyk1I98=
Date:   Tue, 18 May 2021 16:43:09 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, oliver.sang@intel.com,
        paulmck@kernel.org, vbabka@suse.cz
Subject:  +
 mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch added to
 -mm tree
Message-ID: <20210518234309.2l-fFjza5%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm/slub: use stackdepot to save stack trace in objects-fix
has been added to the -mm tree.  Its filename is
     mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vlastimil Babka <vbabka@suse.cz>
Subject: mm/slub: use stackdepot to save stack trace in objects-fix

Paul reports [1] lockdep splat HARDIRQ-safe -> HARDIRQ-unsafe lock order
detected.  Kernel test robot reports [2]
BUG:sleeping_function_called_from_invalid_context_at_mm/page_alloc.c

The stack trace might be saved from contexts where we can't block so GFP_KERNEL
is unsafe. So Use GFP_NOWAIT. Under memory pressure we might thus fail to save
some new unique stack, but that should be extremely rare.

[1] https://lore.kernel.org/linux-mm/20210515204622.GA2672367@paulmck-ThinkPad-P17-Gen-1/
[2] https://lore.kernel.org/linux-mm/20210516144152.GA25903@xsang-OptiPlex-9020/

Link: https://lkml.kernel.org/r/20210516195150.26740-1-vbabka@suse.cz
Reported-by: Paul E. McKenney <paulmck@kernel.org>
Tested-by: Paul E. McKenney <paulmck@kernel.org>
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2
+++ a/mm/slub.c
@@ -624,7 +624,7 @@ static void set_track(struct kmem_cache
 
 	if (addr) {
 #ifdef CONFIG_STACKDEPOT
-		p->handle = save_stack_depot_trace(GFP_KERNEL);
+		p->handle = save_stack_depot_trace(GFP_NOWAIT);
 #endif
 		p->addr = addr;
 		p->cpu = smp_processor_id();
_

Patches currently in -mm which might be from vbabka@suse.cz are

kunit-make-test-lock-irq-safe.patch
mm-memcg-slab-create-a-new-set-of-kmalloc-cg-n-caches-fix.patch
mm-slub-use-stackdepot-to-save-stack-trace-in-objects-fix-2.patch

