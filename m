Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AD33C433ED
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 03:51:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B6D61168
	for <mm-commits@archiver.kernel.org>; Fri,  9 Apr 2021 03:51:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232918AbhDIDvg (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 8 Apr 2021 23:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:42354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232662AbhDIDvg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 8 Apr 2021 23:51:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A5B796103D;
        Fri,  9 Apr 2021 03:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1617940282;
        bh=IQxr0+XuLVM0w745TZLgfRkovF1s4T4ubqGOIXojFSY=;
        h=Date:From:To:Subject:From;
        b=sB4mnWlzKpDFawmXJxhwAKhxhFyy8H+qXaUb+qtQcxERa+GS+0nKCwsRYO4lSC5ey
         PhAsiei5Dx/diX/bGnG0J8QMNlC1YtDq70bu6kM4NFdn13UUonzBtdZxq+204D53Ne
         9X+d+LLRqBOqyKk27mOCt/hHwLGWyCTV5bwlo7Nk=
Date:   Thu, 08 Apr 2021 20:51:22 -0700
From:   akpm@linux-foundation.org
To:     chris@chrisdown.name, guro@fb.com, hannes@cmpxchg.org,
        hughd@google.com, mhocko@suse.com, mm-commits@vger.kernel.org,
        shakeelb@google.com
Subject:  +
 mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch
 added to -mm tree
Message-ID: <20210409035122.n5ytKRgcK%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: page_counter: mitigate consequences of a page_counter underflow
has been added to the -mm tree.  Its filename is
     mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: mm: page_counter: mitigate consequences of a page_counter underflow

When the unsigned page_counter underflows, even just by a few pages, a
cgroup will not be able to run anything afterwards and trigger the OOM
killer in a loop.

Underflows shouldn't happen, but when they do in practice, we may just be
off by a small amount that doesn't interfere with the normal operation -
consequences don't need to be that dire.

Reset the page_counter to 0 upon underflow.  We'll issue a warning that
the accounting will be off and then try to keep limping along.

[ We used to do this with the original res_counter, where it was a
  more straight-forward correction inside the spinlock section. I
  didn't carry it forward into the lockless page counters for
  simplicity, but it turns out this is quite useful in practice. ]

Link: https://lkml.kernel.org/r/20210408143155.2679744-1-hannes@cmpxchg.org
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Roman Gushchin <guro@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_counter.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/mm/page_counter.c~mm-page_counter-mitigate-consequences-of-a-page_counter-underflow
+++ a/mm/page_counter.c
@@ -52,9 +52,13 @@ void page_counter_cancel(struct page_cou
 	long new;
 
 	new = atomic_long_sub_return(nr_pages, &counter->usage);
-	propagate_protected_usage(counter, new);
 	/* More uncharges than charges? */
-	WARN_ON_ONCE(new < 0);
+	if (WARN_ONCE(new < 0, "page_counter underflow: %ld nr_pages=%lu\n",
+		      new, nr_pages)) {
+		new = 0;
+		atomic_long_set(&counter->usage, new);
+	}
+	propagate_protected_usage(counter, new);
 }
 
 /**
_

Patches currently in -mm which might be from hannes@cmpxchg.org are

mm-page-writeback-simplify-memcg-handling-in-test_clear_page_writeback.patch
mm-memcontrol-fix-cpuhotplug-statistics-flushing.patch
mm-memcontrol-kill-mem_cgroup_nodeinfo.patch
mm-memcontrol-privatize-memcg_page_state-query-functions.patch
cgroup-rstat-support-cgroup1.patch
cgroup-rstat-punt-root-level-optimization-to-individual-controllers.patch
mm-memcontrol-switch-to-rstat.patch
mm-memcontrol-switch-to-rstat-fix-2.patch
mm-memcontrol-consolidate-lruvec-stat-flushing.patch
kselftests-cgroup-update-kmem-test-for-new-vmstat-implementation.patch
mm-page_counter-mitigate-consequences-of-a-page_counter-underflow.patch

