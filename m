Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0A3EE82CAC
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243761AbjJDUXM (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244241AbjJDUWf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D84F2EC
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:31 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46652C433C7;
        Wed,  4 Oct 2023 20:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450951;
        bh=3usxg0P+9Vw3pK7XnZRxNo1XZNtj/FboKkg5imMJwzw=;
        h=Date:To:From:Subject:From;
        b=uzcBf0u9fKteCxZyLR6NLs/pB/Vsa7iFv94wbJpyK7bUH66cJgXT3NqQw8w9nZfTH
         qCv81TjSpFTOmZy5VpI0NTAlJ7tcyr8uXa+GOBVeR5YSAxQEJdY4pxhHYy+sdiy6rb
         muqdtGzMXQ4CZ1xJXQyN5Sx3ud71GAjF7k/H29Kg=
Date:   Wed, 04 Oct 2023 13:22:29 -0700
To:     mm-commits@vger.kernel.org, shuah@kernel.org, rostedt@goodmis.org,
        corbet@lwn.net, sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses.patch removed from -mm tree
Message-Id: <20231004202231.46652C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/core: make DAMOS uses nr_accesses_bp instead of nr_accesses
has been removed from the -mm tree.  Its filename was
     mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/core: make DAMOS uses nr_accesses_bp instead of nr_accesses
Date: Sat, 16 Sep 2023 02:09:37 +0000

Patch series "mm/damon: implement DAMOS apply intervals".

DAMON-based operation schemes are applied for every aggregation interval. 
That is mainly because schemes are using nr_accesses, which be complete to
be used for every aggregation interval.

This makes some DAMOS use cases be tricky.  Quota setting under long
aggregation interval is one such example.  Suppose the aggregation
interval is ten seconds, and there is a scheme having CPU quota 100ms per
1s.  The scheme will actually uses 100ms per ten seconds, since it cannobe
be applied before next aggregation interval.  The feature is working as
intended, but the results might not that intuitive for some users.  This
could be fixed by updating the quota to 1s per 10s.  But, in the case, the
CPU usage of DAMOS could look like spikes, and actually make a bad effect
to other CPU-sensitive workloads.

Also, with such huge aggregation interval, users may want schemes to be
applied more frequently.

DAMON provides nr_accesses_bp, which is updated for each sampling interval
in a way that reasonable to be used.  By using that instead of
nr_accesses, DAMOS can have its own time interval and mitigate abovely
mentioned issues.

This patchset makes DAMOS schemes to use nr_accesses_bp instead of
nr_accesses, and have their own timing intervals.  Also update DAMOS tried
regions sysfs files and DAMOS before_apply tracepoint to use the new data
as their source.  Note that the interval is zero by default, and it is
interpreted to use the aggregation interval instead.  This avoids making
user-visible behavioral changes.


Patches Seuqeunce
-----------------

The first patch (patch 1/9) makes DAMOS uses nr_accesses_bp instead of
nr_accesses, and following two patches (patches 2/9 and 3/9) updates DAMON
sysfs interface for DAMOS tried regions and the DAMOS before_apply
tracespoint to use nr_accesses_bp instead of nr_accesses, respectively.

The following two patches (patches 4/9 and 5/9) implements the
scheme-specific apply interval for DAMON kernel API users and update the
design document for the new feature.

Finally, the following four patches (patches 6/9, 7/9, 8/9 and 9/9) add
support of the feature in DAMON sysfs interface, add a simple selftest
test case, and document the new file on the usage and the ABI documents,
repsectively.


This patch (of 9):

DAMON provides nr_accesses_bp, which becomes same to nr_accesses * 10000
for every aggregation interval, but updated every sampling interval with a
reasonable accuracy.  Since DAMON-based operation schemes are applied in
every aggregation interval using nr_accesses, using nr_accesses_bp instead
will make no difference to users.  Meanwhile, it allows DAMOS to apply the
schemes in a time interval that less than the aggregation interval.  It
could be useful and more flexible for some cases.  Do it.

Link: https://lkml.kernel.org/r/20230916020945.47296-1-sj@kernel.org
Link: https://lkml.kernel.org/r/20230916020945.47296-2-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/damon/core.c~mm-damon-core-make-damos-uses-nr_accesses_bp-instead-of-nr_accesses
+++ a/mm/damon/core.c
@@ -770,12 +770,13 @@ static void damon_split_region_at(struct
 static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 {
 	unsigned long sz;
+	unsigned int nr_accesses = r->nr_accesses_bp / 10000;
 
 	sz = damon_sz_region(r);
 	return s->pattern.min_sz_region <= sz &&
 		sz <= s->pattern.max_sz_region &&
-		s->pattern.min_nr_accesses <= r->nr_accesses &&
-		r->nr_accesses <= s->pattern.max_nr_accesses &&
+		s->pattern.min_nr_accesses <= nr_accesses &&
+		nr_accesses <= s->pattern.max_nr_accesses &&
 		s->pattern.min_age_region <= r->age &&
 		r->age <= s->pattern.max_age_region;
 }
_

Patches currently in -mm which might be from sj@kernel.org are


