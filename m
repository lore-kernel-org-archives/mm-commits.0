Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52060E728CF
	for <mm-commits@archiver.kernel.org>; Fri, 29 Sep 2023 18:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233321AbjI2Soo (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 29 Sep 2023 14:44:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233712AbjI2Son (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 29 Sep 2023 14:44:43 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EEA199
        for <mm-commits@vger.kernel.org>; Fri, 29 Sep 2023 11:44:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CE8BC433C7;
        Fri, 29 Sep 2023 18:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1696013080;
        bh=Zbg/LEOBwnWzg6158Q/YBjL+KTPmygFhziLRXd0f9wo=;
        h=Date:To:From:Subject:From;
        b=hATZ1U6+Bj+OfGQsInEQcoQNPs98bQQJ6cWpGaiHoBaRLfAZGdbN3rnVMWw8wiK6F
         BspT9kKyXRbpBGk8ZoGeV1LGEcOC6UA+Ml14VfakYD6NOiQEG0avZJVSwcH7OpK5Qq
         QKM3aeLqvLA6EbQo5SuXRWHhEafna9MwBHmtS0/8=
Date:   Fri, 29 Sep 2023 11:44:39 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dennis@kernel.org, akpm@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch added to mm-unstable branch
Message-Id: <20230929184440.1CE8BC433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmem-scoped-objcg-protection-checkpatch-fixes
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch

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
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-kmem-scoped-objcg-protection-checkpatch-fixes
Date: Fri Sep 29 11:43:48 AM PDT 2023

WARNING: else is not generally useful after a break or return
#73: FILE: mm/memcontrol.c:3135:
+		return objcg;
+	} else {

total: 0 errors, 1 warnings, 111 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

./patches/mm-kmem-scoped-objcg-protection.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-scoped-objcg-protection-checkpatch-fixes
+++ a/mm/memcontrol.c
@@ -3132,11 +3132,11 @@ __always_inline struct obj_cgroup *curre
 		 * to use the objcg by the current task.
 		 */
 		return objcg;
-	} else {
-		memcg = this_cpu_read(int_active_memcg);
-		if (unlikely(memcg))
-			goto from_memcg;
 	}
+
+	memcg = this_cpu_read(int_active_memcg);
+	if (unlikely(memcg))
+		goto from_memcg;
 	return NULL;
 
 from_memcg:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
mm-memcg-reconsider-kmemlimit_in_bytes-deprecation-fix.patch
mm-shrinker-convert-shrinker_rwsem-to-mutex-fix.patch
mm-memcg-add-thp-swap-out-info-for-anonymous-reclaim-fix.patch
mm-hugetlb-skip-initialization-of-gigantic-tail-struct-pages-if-freed-by-hvo-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-ksm-add-smart-page-scanning-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix.patch
mm-ksm-document-smart-scan-mode-fix-2.patch
mm-kmem-scoped-objcg-protection-checkpatch-fixes.patch
kthread-add-kthread_stop_put-v2-fix.patch

