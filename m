Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005CA1E25E9
	for <mm-commits@vger.kernel.org>; Wed,  9 Oct 2024 21:00:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728507650; cv=none; b=WHraCADHRJEK7DOBOFJgFaxM6KTa7qMKl9Cn73vJgQASO3xOUHZ4huVbWFB4VzufSmTGmC/qgLxXFl195nyrZMRpG2zuAbj5RjlzV1TDjfqHzgvtqmAiHxzzr9b4popuaHBuzuGEr8J6KdfEFxz1OTkEDzeAuOJgZCEHhZJ9tHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728507650; c=relaxed/simple;
	bh=5ZOwGlUsRWwMP7m/90xmOTKsCLKMV6Pr2CDFHRnC0Ss=;
	h=Date:To:From:Subject:Message-Id; b=HsaQ4oQoJu+WGK5h1wYLaj3uq5v4gBclhdZehSZNxMQkplUUf+lwlbVj6Da7/JR8bLPcRMr46WToeY9Dv0LDTIDX86oAs6pO7E/dfbBfeJfU+7ZzuHg9C0/6469Ivpy30I6p9gMDZgfxqZ4P3yDDr1IfqX59k7IQFnXzDIzcudo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=d7QLTYOv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="d7QLTYOv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5053BC4CEC3;
	Wed,  9 Oct 2024 21:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1728507649;
	bh=5ZOwGlUsRWwMP7m/90xmOTKsCLKMV6Pr2CDFHRnC0Ss=;
	h=Date:To:From:Subject:From;
	b=d7QLTYOvrGG/aff1E8Rhfby+8+LSVkRIS74uL8GovfyY5AXyyqphjibTWBMWLgCm9
	 VgSMPaiPxWa6B947xzkdz9w8asRSd9cYyr2jHEVC7yY0N73eva/5GMt+IiO8Cmz2WG
	 2+PUSMRzQfL60Fupe1mwg5f+BvaGZ+akqR4vZk8k=
Date: Wed, 09 Oct 2024 14:00:48 -0700
To: mm-commits@vger.kernel.org,minchan@kernel.org,senozhatsky@chromium.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
Subject: + zram-do-not-open-code-comp-priority-0.patch added to mm-unstable branch
Message-Id: <20241009210049.5053BC4CEC3@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: mm-commits@vger.kernel.org
List-Id: <mm-commits.vger.kernel.org>
List-Subscribe: <mailto:mm-commits+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:mm-commits+unsubscribe@vger.kernel.org>


The patch titled
     Subject: zram: do not open-code comp priority 0
has been added to the -mm mm-unstable branch.  Its filename is
     zram-do-not-open-code-comp-priority-0.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/zram-do-not-open-code-comp-priority-0.patch

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
From: Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: zram: do not open-code comp priority 0
Date: Wed, 9 Oct 2024 13:28:00 +0900

A cosmetic change: do not open-code compression priority 0, use
ZRAM_PRIMARY_COMP instead.

Link: https://lkml.kernel.org/r/20241009042908.750260-1-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/block/zram/zram_drv.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/zram/zram_drv.c~zram-do-not-open-code-comp-priority-0
+++ a/drivers/block/zram/zram_drv.c
@@ -2285,7 +2285,7 @@ static void zram_destroy_comps(struct zr
 {
 	u32 prio;
 
-	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		struct zcomp *comp = zram->comps[prio];
 
 		zram->comps[prio] = NULL;
@@ -2357,7 +2357,7 @@ static ssize_t disksize_store(struct dev
 		goto out_unlock;
 	}
 
-	for (prio = 0; prio < ZRAM_MAX_COMPS; prio++) {
+	for (prio = ZRAM_PRIMARY_COMP; prio < ZRAM_MAX_COMPS; prio++) {
 		if (!zram->comp_algs[prio])
 			continue;
 
_

Patches currently in -mm which might be from senozhatsky@chromium.org are

zram-introduce-zram_pp_slot-flag.patch
zram-permit-only-one-post-processing-operation-at-a-time.patch
zram-rework-recompress-target-selection-strategy.patch
zram-rework-recompress-target-selection-strategy-fix.patch
zram-rework-writeback-target-selection-strategy.patch
zram-do-not-mark-idle-slots-that-cannot-be-idle.patch
zram-reshuffle-zram_free_page-flags-operations.patch
zram-remove-under_wb-and-simplify-writeback.patch
zram-do-not-open-code-comp-priority-0.patch

