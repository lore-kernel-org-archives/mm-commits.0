Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D883C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  2 Feb 2022 22:52:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237297AbiBBWw7 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 2 Feb 2022 17:52:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236831AbiBBWw6 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 2 Feb 2022 17:52:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B91BFC061714
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 14:52:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73DB4B832BF
        for <mm-commits@vger.kernel.org>; Wed,  2 Feb 2022 22:52:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE56C004E1;
        Wed,  2 Feb 2022 22:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1643842375;
        bh=6HzehVya+RKtHw34+QZ3Jf3BW6I39O8A/XcCi8k4atU=;
        h=Date:To:From:Subject:From;
        b=GrlKy3GbI/VrWaz1S5JEDiUAX2UVyQ3ip39YfRi4ho8Q2hyD10AIlJkCO+ZpA0QCW
         mCHuFw7I4eSpAjwGgZdm3ljTSZHTLsyKpwrQ6V3cgpZNrEIhOSyEgyPdKXzRNRCdaN
         Mtjn1QaSOVAQX2jNezvd7hGi8J8Dr9U5CQfAoMN8=
Received: by hp1 (sSMTP sendmail emulation); Wed, 02 Feb 2022 14:52:52 -0800
Date:   Wed, 02 Feb 2022 14:52:52 -0800
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        senozhatsky@chromium.org, rppt@kernel.org, rostedt@goodmis.org,
        rientjes@google.com, pmladek@suse.com, mhocko@kernel.org,
        linux@rasmusvillemoes.dk, ira.weiny@intel.com, hannes@cmpxchg.org,
        guro@fb.com, aquini@redhat.com, andriy.shevchenko@linux.intel.com,
        longman@redhat.com, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-vsprintf-avoid-redundant-work-with-0-size.patch added to -mm tree
Message-Id: <20220202225253.9AE56C004E1@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: avoid redundant work with 0 size
has been added to the -mm tree.  Its filename is
     lib-vsprintf-avoid-redundant-work-with-0-size.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/lib-vsprintf-avoid-redundant-work-with-0-size.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/lib-vsprintf-avoid-redundant-work-with-0-size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: lib/vsprintf: avoid redundant work with 0 size

Patch series "mm/page_owner: Extend page_owner to show memcg information", v4.

While debugging the constant increase in percpu memory consumption on a
system that spawned large number of containers, it was found that a lot of
offline mem_cgroup structures remained in place without being freed. 
Further investigation indicated that those mem_cgroup structures were
pinned by some pages.

In order to find out what those pages are, the existing page_owner
debugging tool is extended to show memory cgroup information and whether
those memcgs are offline or not.  With the enhanced page_owner tool, the
following is a typical page that pinned the mem_cgroup structure in my
test case:

Page allocated via order 0, mask 0x1100cca(GFP_HIGHUSER_MOVABLE), pid 162970 (podman), ts 1097761405537 ns, free_ts 1097760838089 ns
PFN 1925700 type Movable Block 3761 type Movable Flags 0x17ffffc00c001c(uptodate|dirty|lru|reclaim|swapbacked|node=0|zone=2|lastcpupid=0x1fffff)
 prep_new_page+0xac/0xe0
 get_page_from_freelist+0x1327/0x14d0
 __alloc_pages+0x191/0x340
 alloc_pages_vma+0x84/0x250
 shmem_alloc_page+0x3f/0x90
 shmem_alloc_and_acct_page+0x76/0x1c0
 shmem_getpage_gfp+0x281/0x940
 shmem_write_begin+0x36/0xe0
 generic_perform_write+0xed/0x1d0
 __generic_file_write_iter+0xdc/0x1b0
 generic_file_write_iter+0x5d/0xb0
 new_sync_write+0x11f/0x1b0
 vfs_write+0x1ba/0x2a0
 ksys_write+0x59/0xd0
 do_syscall_64+0x37/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
Charged to offline memcg libpod-conmon-15e4f9c758422306b73b2dd99f9d50a5ea53cbb16b4a13a2c2308a4253cc0ec8.

So the page was not freed because it was part of a shmem segment.  That is
useful information that can help users to diagnose similar problems.

With cgroup v1, /proc/cgroups can be read to find out the total number of
memory cgroups (online + offline).  With cgroup v2, the cgroup.stat of the
root cgroup can be read to find the number of dying cgroups (most likely
pinned by dying memcgs).

The page_owner feature is not supposed to be enabled for production system
due to its memory overhead.  However, if it is suspected that dying memcgs
are increasing over time, a test environment with page_owner enabled can
then be set up with appropriate workload for further analysis on what may
be causing the increasing number of dying memcgs.


This patch (of 4):

For *scnprintf(), vsnprintf() is always called even if the input size is
0.  That is a waste of time, so just return 0 in this case.

Note that vsnprintf() will never return -1 to indicate an error.  So
skipping the call to vsnprintf() when size is 0 will have no functional
impact at all.

Link: https://lkml.kernel.org/r/20220202203036.744010-1-longman@redhat.com
Link: https://lkml.kernel.org/r/20220202203036.744010-2-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: David Rientjes <rientjes@google.com>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Acked-by: Roman Gushchin <guro@fb.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/lib/vsprintf.c~lib-vsprintf-avoid-redundant-work-with-0-size
+++ a/lib/vsprintf.c
@@ -2895,13 +2895,15 @@ int vscnprintf(char *buf, size_t size, c
 {
 	int i;
 
+	if (unlikely(!size))
+		return 0;
+
 	i = vsnprintf(buf, size, fmt, args);
 
 	if (likely(i < size))
 		return i;
-	if (size != 0)
-		return size - 1;
-	return 0;
+
+	return size - 1;
 }
 EXPORT_SYMBOL(vscnprintf);
 
_

Patches currently in -mm which might be from longman@redhat.com are

lib-vsprintf-avoid-redundant-work-with-0-size.patch
mm-page_owner-use-scnprintf-to-avoid-excessive-buffer-overrun-check.patch
mm-page_owner-print-memcg-information.patch
mm-page_owner-record-task-command-name.patch
mm-sparsemem-fix-mem_section-will-never-be-null-gcc-12-warning.patch
ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

