Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C054EC433FE
	for <mm-commits@archiver.kernel.org>; Fri, 25 Mar 2022 22:41:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233899AbiCYWnP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 25 Mar 2022 18:43:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233901AbiCYWnJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 25 Mar 2022 18:43:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BDF208C1E
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 15:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F21F2614BD
        for <mm-commits@vger.kernel.org>; Fri, 25 Mar 2022 22:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C32C340ED;
        Fri, 25 Mar 2022 22:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648248092;
        bh=SIhQ/QF4q1KnvEg3+sKrYvYXbRsNUR4nzdubndfoGC0=;
        h=Date:To:From:Subject:From;
        b=h+/PD+E/16y0flrTeHUursancrD0OI5JH5iPISaakf5cIQBjhPXOwiZX9CaWEKA0X
         cL8OsfoZoXNyxcKBbFOWxIxEOi8B0PXeUpRDm6a1BiQswqMYqI6oG8UZyzoF7bgQ+q
         mXnVEIWUr1JTm8rgDUvsVeoIyNglCvwAMJ0NPyys=
Date:   Fri, 25 Mar 2022 15:41:31 -0700
To:     mm-commits@vger.kernel.org, vdavydov.dev@gmail.com,
        senozhatsky@chromium.org, rppt@linux.ibm.com, rostedt@goodmis.org,
        roman.gushchin@linux.dev, rientjes@google.com, pmladek@suse.com,
        mhocko@kernel.org, linux@rasmusvillemoes.dk, ira.weiny@intel.com,
        hannes@cmpxchg.org, guro@fb.com, aquini@redhat.com,
        andriy.shevchenko@linux.intel.com, longman@redhat.com,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged] lib-vsprintf-avoid-redundant-work-with-0-size.patch removed from -mm tree
Message-Id: <20220325224132.53C32C340ED@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: lib/vsprintf: avoid redundant work with 0 size
has been removed from the -mm tree.  Its filename was
     lib-vsprintf-avoid-redundant-work-with-0-size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
Acked-by: Rafael Aquini <aquini@redhat.com>
Acked-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/vsprintf.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/lib/vsprintf.c~lib-vsprintf-avoid-redundant-work-with-0-size
+++ a/lib/vsprintf.c
@@ -2906,13 +2906,15 @@ int vscnprintf(char *buf, size_t size, c
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

ipc-mqueue-use-get_tree_nodev-in-mqueue_get_tree.patch

