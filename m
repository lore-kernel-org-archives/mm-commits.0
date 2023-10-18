Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AFFACDB483
	for <mm-commits@archiver.kernel.org>; Wed, 18 Oct 2023 14:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235339AbjJROgu (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 18 Oct 2023 10:36:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235341AbjJROgh (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 18 Oct 2023 10:36:37 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8241BDF
        for <mm-commits@vger.kernel.org>; Wed, 18 Oct 2023 07:34:48 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64613C433C7;
        Wed, 18 Oct 2023 14:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1697639688;
        bh=LJdGZtJala4XmwkUpwUqBvi09HzCxcMevWTE2+VFYy4=;
        h=Date:To:From:Subject:From;
        b=Vu28J8EhWrZL7ec1n7zXc7IV90kbWyztjfVd3bUTE3qL2RHeB3DLY+4P9fYu8bKUe
         GJyS0+ijmuS0AEywHCCOWPgM4WUqBEKeNKmYX0XzrF0n7x0RpaG6LTUXg5P3Buep8j
         khs9LsTi/s8ar2ibG3+t+SwG0EFmzGhFgX5tncwY=
Date:   Wed, 18 Oct 2023 07:34:47 -0700
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        roman.gushchin@linux.dev, rientjes@google.com,
        naresh.kamboju@linaro.org, muchun.song@linux.dev,
        mhocko@kernel.org, hannes@cmpxchg.org, dennis@kernel.org,
        akpm@linux-foundation.org, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch added to mm-unstable branch
Message-Id: <20231018143448.64613C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch

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
Subject: mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix
Date: Wed Oct 18 07:33:49 AM PDT 2023

fix comment typo, per Vlastimil

Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/memcontrol.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/memcontrol.h~mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix
+++ a/include/linux/memcontrol.h
@@ -291,7 +291,7 @@ struct mem_cgroup {
 #ifdef CONFIG_MEMCG_KMEM
 	int kmemcg_id;
 	/*
-	 * memcg->objcg is wiped out as a part of the objcg repaprenting
+	 * memcg->objcg is wiped out as a part of the objcg reparenting
 	 * process. memcg->orig_objcg preserves a pointer (and a reference)
 	 * to the original objcg until the end of live of memcg.
 	 */
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

mm-shmem-fix-race-in-shmem_undo_range-w-thp-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-fix.patch
fs-proc-task_mmu-implement-ioctl-to-get-and-optionally-clear-info-about-ptes-fix-2.patch
mm-add-printf-attribute-to-shrinker_debugfs_name_alloc-fix.patch
mm-kmem-make-memcg-keep-a-reference-to-the-original-objcg-fix.patch
mark-stuff-as-__ro_after_init-checkpatch-fixes.patch
mark-stuff-as-__ro_after_init-fix.patch

