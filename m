Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC084C76195
	for <mm-commits@archiver.kernel.org>; Mon, 27 Mar 2023 20:19:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjC0UTo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 27 Mar 2023 16:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232648AbjC0UTi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 27 Mar 2023 16:19:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3DC32127
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 13:19:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60587B81334
        for <mm-commits@vger.kernel.org>; Mon, 27 Mar 2023 20:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D67C433D2;
        Mon, 27 Mar 2023 20:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1679948374;
        bh=/ynUf0EfanAhXKweQn1w0yO78YL4jnFjAGfGLa9W9F8=;
        h=Date:To:From:Subject:From;
        b=dsS2KfcfiwTSiIXZYtd7SAeNKrtGgUs2oFFIDtSDVMwczYfxg/PJ79bIYYvUgLV/5
         BvKRyV73Z4K/HMcBCqL4IPkNgCO89nWQfz7lhCaHOIbzWI9JPZttkBL35k5cD7Vb+Z
         ezJ+5UJKj/aex9937Vcny/2yEjxJuJ71AJHeKm8A=
Date:   Mon, 27 Mar 2023 13:19:33 -0700
To:     mm-commits@vger.kernel.org, glider@google.com, elver@google.com,
        dvyukov@google.com, thunder.leizhen@huawei.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch added to mm-unstable branch
Message-Id: <20230327201934.18D67C433D2@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: kmsan: fix a stale comment in kmsan_save_stack_with_flags()
has been added to the -mm mm-unstable branch.  Its filename is
     kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch

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
From: Zhen Lei <thunder.leizhen@huawei.com>
Subject: kmsan: fix a stale comment in kmsan_save_stack_with_flags()
Date: Mon, 27 Mar 2023 11:41:49 +0800

After commit 446ec83805dd ("mm/page_alloc: use might_alloc()") and commit
84172f4bb752 ("mm/page_alloc: combine __alloc_pages and
__alloc_pages_nodemask"), the comment is no longer accurate.  Flag
'__GFP_DIRECT_RECLAIM' is clear enough on its own, so remove the comment
rather than update it.

Link: https://lkml.kernel.org/r/20230327034149.942-1-thunder.leizhen@huawei.com
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Reviewed-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmsan/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmsan/core.c~kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags
+++ a/mm/kmsan/core.c
@@ -73,7 +73,7 @@ depot_stack_handle_t kmsan_save_stack_wi
 
 	nr_entries = stack_trace_save(entries, KMSAN_STACK_DEPTH, 0);
 
-	/* Don't sleep (see might_sleep_if() in __alloc_pages_nodemask()). */
+	/* Don't sleep. */
 	flags &= ~__GFP_DIRECT_RECLAIM;
 
 	handle = __stack_depot_save(entries, nr_entries, flags, true);
_

Patches currently in -mm which might be from thunder.leizhen@huawei.com are

kmsan-fix-a-stale-comment-in-kmsan_save_stack_with_flags.patch

