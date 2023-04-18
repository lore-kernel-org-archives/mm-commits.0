Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9E54C77B7C
	for <mm-commits@archiver.kernel.org>; Tue, 18 Apr 2023 21:22:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232943AbjDRVW5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 18 Apr 2023 17:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232926AbjDRVW4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 18 Apr 2023 17:22:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 799507680;
        Tue, 18 Apr 2023 14:22:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 149DC615E8;
        Tue, 18 Apr 2023 21:22:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F145C433D2;
        Tue, 18 Apr 2023 21:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1681852960;
        bh=64vzBXNtXbfCzQRAAy/mqOg2r3D5a2bzf8zy/CT6VKI=;
        h=Date:To:From:Subject:From;
        b=bfHXXldMw66wfePf3ePqWRkjrGTFV1CNpwCuVS9Xcy+CVt0Zp/KkxdRzvrR+gYOB6
         qQIJ88FaVojI7y2H0tX6SsLbM13VOnBontQuJoHFgwXeEumNSE8ClpgFLWLgtPBQ6R
         WWyATwwoy6vQpJokKl1LNEranpRAjMVx01HMLaDI=
Date:   Tue, 18 Apr 2023 14:22:39 -0700
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        shakeelb@google.com, m.szyprowski@samsung.com,
        mathieu.desnoyers@efficios.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-fix-memory-leak-on-mm_init-error-handling.patch removed from -mm tree
Message-Id: <20230418212240.6F145C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm: fix memory leak on mm_init error handling
has been removed from the -mm tree.  Its filename was
     mm-fix-memory-leak-on-mm_init-error-handling.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: mm: fix memory leak on mm_init error handling
Date: Thu, 30 Mar 2023 09:38:22 -0400

commit f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
introduces a memory leak by missing a call to destroy_context() when a
percpu_counter fails to allocate.

Before introducing the per-cpu counter allocations, init_new_context() was
the last call that could fail in mm_init(), and thus there was no need to
ever invoke destroy_context() in the error paths.  Adding the following
percpu counter allocations adds error paths after init_new_context(),
which means its associated destroy_context() needs to be called when
percpu counters fail to allocate.

Link: https://lkml.kernel.org/r/20230330133822.66271-1-mathieu.desnoyers@efficios.com
Fixes: f1a7941243c1 ("mm: convert mm's rss stats into percpu_counter")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/fork.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/fork.c~mm-fix-memory-leak-on-mm_init-error-handling
+++ a/kernel/fork.c
@@ -1174,6 +1174,7 @@ static struct mm_struct *mm_init(struct
 fail_pcpu:
 	while (i > 0)
 		percpu_counter_destroy(&mm->rss_stat[--i]);
+	destroy_context(mm);
 fail_nocontext:
 	mm_free_pgd(mm);
 fail_nopgd:
_

Patches currently in -mm which might be from mathieu.desnoyers@efficios.com are


