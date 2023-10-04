Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4008E7C4FA
	for <mm-commits@archiver.kernel.org>; Wed,  4 Oct 2023 20:23:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244908AbjJDUXE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Oct 2023 16:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244964AbjJDUWa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2023 16:22:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8C4193
        for <mm-commits@vger.kernel.org>; Wed,  4 Oct 2023 13:22:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210D0C433C9;
        Wed,  4 Oct 2023 20:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696450921;
        bh=OACURJ+iMoYQHsAbUENMhdz5sVX+E/TzYx9MjYb9RvU=;
        h=Date:To:From:Subject:From;
        b=AnD8tN6SN/yirxIRTsh5GUYVglt9OdloTP71EXcRQVR0R5NBMDmx9oCmAIjc0w/2m
         Ubp6iYmexIrmyKJHreJobLx8xIp51AScyxqiLohykKfwm4EeTkzhVHGH6NxUzr+JoF
         CDm4qKl5Phjg6DzPAKC1NlkYfdBkszLPskH0a2lE=
Date:   Wed, 04 Oct 2023 13:21:59 -0700
To:     mm-commits@vger.kernel.org, brendanhiggins@google.com,
        sj@kernel.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-stable] mm-damon-vaddr-call-damon_update_region_access_rate-always.patch removed from -mm tree
Message-Id: <20231004202201.210D0C433C9@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/vaddr: call damon_update_region_access_rate() always
has been removed from the -mm tree.  Its filename was
     mm-damon-vaddr-call-damon_update_region_access_rate-always.patch

This patch was dropped because it was merged into the mm-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/vaddr: call damon_update_region_access_rate() always
Date: Fri, 15 Sep 2023 02:52:45 +0000

When getting mm_struct of the monitoring target process fails, there wil
be no need to increase the access rate counter (nr_accesses) of the
regions for the process.  Hence, damon_va_check_accesses() skips calling
damon_update_region_access_rate() in the case.  This breaks the assumption
that damon_update_region_access_rate() is called for every region, for
every sampling interval.  Call the function for every region even in the
case.  This might increase the overhead in some cases, but such case would
not be frequent, so no significant impact is really expected.

Link: https://lkml.kernel.org/r/20230915025251.72816-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: Brendan Higgins <brendanhiggins@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/damon/vaddr.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/mm/damon/vaddr.c~mm-damon-vaddr-call-damon_update_region_access_rate-always
+++ a/mm/damon/vaddr.c
@@ -564,6 +564,11 @@ static void __damon_va_check_access(stru
 	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
 
+	if (!mm) {
+		damon_update_region_access_rate(r, false);
+		return;
+	}
+
 	/* If the region is in the last checked page, reuse the result */
 	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
 				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
@@ -587,15 +592,14 @@ static unsigned int damon_va_check_acces
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		if (!mm)
-			continue;
 		same_target = false;
 		damon_for_each_region(r, t) {
 			__damon_va_check_access(mm, r, same_target);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 			same_target = true;
 		}
-		mmput(mm);
+		if (mm)
+			mmput(mm);
 	}
 
 	return max_nr_accesses;
_

Patches currently in -mm which might be from sj@kernel.org are


