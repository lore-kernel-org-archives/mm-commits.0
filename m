Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63DC5FA3745
	for <mm-commits@archiver.kernel.org>; Fri, 28 Oct 2022 21:08:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiJ1VIK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 28 Oct 2022 17:08:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbiJ1VHg (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 28 Oct 2022 17:07:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E59912498BC
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 14:07:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9E70EB82A8C
        for <mm-commits@vger.kernel.org>; Fri, 28 Oct 2022 21:07:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E497C433D6;
        Fri, 28 Oct 2022 21:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1666991253;
        bh=Q9YHRhb+DJgNEhQBYiAQe66IvJpJ6135Y8ZX0D0m5IU=;
        h=Date:To:From:Subject:From;
        b=SZ5TUpFUMZw0szsXXuQVrxcuhcPZxmv4ovTLlD9C/FWMx3E0iMXtNRwIVyZG2JsXN
         cra7Cc233SAybzHQIOQWtZZfNLKEHBjspip8ne80/V1gpfQ9aMZJLvdRb7LIGpBa8x
         T9ja3Vs/k3ZdzQ2ikEvTwKifr5JSntxdTQjAEesg=
Date:   Fri, 28 Oct 2022 14:07:32 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        Liam.Howlett@oracle.com, lukas.bulwahn@gmail.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch removed from -mm tree
Message-Id: <20221028210733.2E497C433D6@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: lib: maple_tree: remove unneeded initialization in mtree_range_walk()
has been removed from the -mm tree.  Its filename was
     lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: lib: maple_tree: remove unneeded initialization in mtree_range_walk()
Date: Wed, 26 Oct 2022 14:00:29 +0200

Before the do-while loop in mtree_range_walk(), the variables next, min,
max need to be initialized.  The variables last, prev_min and prev_max are
set within the loop body before they are eventually used after exiting the
loop body.

As it is a do-while loop, the loop body is executed at least once, so the
variables last, prev_min and prev_max do not need to be initialized before
the loop body.

Remove unneeded initialization of last and prev_min.

The needless initialization was reported by clang-analyzer as Dead Stores.

As the compiler already identifies these assignments as unneeded, it
optimizes the assignments away.  Hence:

No functional change. No change in object code.

Link: https://lkml.kernel.org/r/20221026120029.12555-2-lukas.bulwahn@gmail.com
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


--- a/lib/maple_tree.c~lib-maple_tree-remove-unneeded-initialization-in-mtree_range_walk
+++ a/lib/maple_tree.c
@@ -2903,8 +2903,8 @@ static inline void *mtree_range_walk(str
 	unsigned long max, min;
 	unsigned long prev_max, prev_min;
 
-	last = next = mas->node;
-	prev_min = min = mas->min;
+	next = mas->node;
+	min = mas->min;
 	max = mas->max;
 	do {
 		offset = 0;
_

Patches currently in -mm which might be from lukas.bulwahn@gmail.com are

mm-shmem-remove-unneeded-assignments-in-shmem_get_folio_gfp.patch

