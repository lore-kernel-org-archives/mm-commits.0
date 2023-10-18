Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFEDBC41513
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 21:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjJRVfP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 17:35:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjJRVfO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 17:35:14 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1062D6B
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 14:34:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7E5C433CC;
        Wed, 18 Oct 2023 21:34:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697664889;
        bh=GWPnrL+j7wp3/K+6jsJfPm+ODKhDtNhlzrsZfI96UjQ=;
        h=Date:To:From:Subject:From;
        b=YdWFBK5rVOxrx5v+IZdDuc48wA1QUqYmNLORAFqCqTvKUWO5tlDf4+B19zOolXpcU
         FYqTBRoQ0k0QSnxPPgzDWT8DLyar4YujNrH2hI6YKqD85Ytf2/ZcWSL/Xi139P8LjP
         PH80UNLbWPtIbLG4tWb5yALlJGGfwWqIbQejMtZg=
Date:   Wed, 18 Oct 2023 14:34:48 -0700
To:     mm-commits@vger.kernel.org, willy@infradead.org,
        shakeelb@google.com, roman.gushchin@linux.dev, mhocko@suse.com,
        hannes@cmpxchg.org, gustavoars@kernel.org, keescook@chromium.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch removed from -mm tree
Message-Id: <20231018213449.6B7E5C433CC@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/memcg: annotate struct mem_cgroup_threshold_ary with __counted_by
has been removed from the -mm tree.  Its filename was
     mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: Kees Cook <keescook@chromium.org>
Subject: mm/memcg: annotate struct mem_cgroup_threshold_ary with __counted_by
Date: Fri, 22 Sep 2023 10:53:28 -0700

Prepare for the coming implementation by GCC and Clang of the __counted_by
attribute.  Flexible array members annotated with __counted_by can have
their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
(for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
functions).

As found with Coccinelle[1], add __counted_by for struct
mem_cgroup_threshold_ary.

[1] https://github.com/kees/kernel-tools/blob/trunk/coccinelle/examples/counted_by.cocci

Link: https://lkml.kernel.org/r/20230922175327.work.985-kees@kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-memcg-annotate-struct-mem_cgroup_threshold_ary-with-__counted_by
+++ a/include/linux/memcontrol.h
@@ -143,7 +143,7 @@ struct mem_cgroup_threshold_ary {
 	/* Size of entries[] */
 	unsigned int size;
 	/* Array of thresholds */
-	struct mem_cgroup_threshold entries[];
+	struct mem_cgroup_threshold entries[] __counted_by(size);
 };
 
 struct mem_cgroup_thresholds {
_

Patches currently in -mm which might be from keescook@chromium.org are

ocfs2-annotate-struct-ocfs2_replay_map-with-__counted_by.patch
gcov-annotate-struct-gcov_iterator-with-__counted_by.patch

