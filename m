Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93F16E82CDE
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244869AbjJDUXM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244575AbjJDUWj (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:39 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C4CFC
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0CDC433CB;
        Wed,  4 Oct 2023 20:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450955;
        bh=wfCqlMXD3gA8lpeAFVfMXs8dByqa2YzAiUMCaTwZqYI=;
        h=Date:To:From:Subject:From;
        b=e0VZ/fzG1EBpY3dC0eDzAts0MmJJzCpfhgwJ/f8GcCTWkdL6WYbOC3kZ4oY6hmRRf
         5wKhZpu5n6zUFdS+z5F5SCHrYOrUaBKRAWLtNE9skZV+3yAV/e2/bAR0TPcSfUdTHJ
         kuJBoks8abSDbJvPveh+0yhvezBT3g22JtYCONpc=
Date:   Wed, 04 Oct 2023 13:22:33 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch removed from -mm tree
Message-Id: <20231004202235.5A0CDC433CB@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: use nr_accesses_bp as a source of damos_before_apply tracepoint
has been removed from the -mm tree.  Its filename was
     mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: use nr_accesses_bp as a source of damos_before_apply tracepoint
Date: Sat, 16 Sep 2023 02:09:39 +0000

damos_before_apply tracepoint is exposing access rate of DAMON regions
using nr_accesses field of regions, which was actually used by DAMOS in
the past.  However, it has changed to use nr_accesses_bp instead.  Update
the tracepoint to expose the value that DAMOS is really using.

Note that it doesn't expose the value as is in the basis point, but after
converting it to the natural number by dividing it by 10,000.  Therefore
this change doesn't make user-visible behavioral differences.

Link: https://lkml.kernel.org/r/20230916020945.47296-4-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/trace/events/damon.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/trace/events/damon.h~mm-damon-core-use-nr_accesses_bp-as-a-source-of-damos_before_apply-tracepoint
+++ a/include/trace/events/damon.h
@@ -36,7 +36,7 @@ TRACE_EVENT_CONDITION(damos_before_apply
 		__entry->target_idx = target_idx;
 		__entry->start = r->ar.start;
 		__entry->end = r->ar.end;
-		__entry->nr_accesses = r->nr_accesses;
+		__entry->nr_accesses = r->nr_accesses_bp / 10000;
 		__entry->age = r->age;
 		__entry->nr_regions = nr_regions;
 	),
_

Patches currently in -mm which might be from sj@kernel.org are


