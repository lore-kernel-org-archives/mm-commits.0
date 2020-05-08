From: Andrew Morton <akpm@linux-foundation.org>
Subject: +
 mm-memcontrol-document-the-new-swap-control-behavior.patch added to -mm
 tree
Date: Fri, 08 May 2020 16:20:16 -0700
Message-ID: <20200508232016.qG1Jl93aY%akpm@linux-foundation.org>
References: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:41938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727110AbgEHXUS (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 8 May 2020 19:20:18 -0400
In-Reply-To: <20200507183509.c5ef146c5aaeb118a25a39a8@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: alex.shi@linux.alibaba.com, guro@fb.com, hannes@cmpxchg.org, hughd@google.com, iamjoonsoo.kim@lge.com, kirill@shutemov.name, mhocko@suse.com, mm-commits@vger.kernel.org, shakeelb@google.com


The patch titled
     Subject: mm: memcontrol: document the new swap control behavior
has been added to the -mm tree.  Its filename is
     mm-memcontrol-document-the-new-swap-control-behavior.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-memcontrol-document-the-new-swap-control-behavior.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-memcontrol-document-the-new-swap-control-behavior.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: mm: memcontrol: document the new swap control behavior

Link: http://lkml.kernel.org/r/20200508183105.225460-18-hannes@cmpxchg.org
Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <guro@fb.com>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/admin-guide/cgroup-v1/memory.rst |   19 +++++----------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/Documentation/admin-guide/cgroup-v1/memory.rst~mm-memcontrol-document-the-new-swap-control-behavior
+++ a/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -199,11 +199,11 @@ An RSS page is unaccounted when it's ful
 unaccounted when it's removed from radix-tree. Even if RSS pages are fully
 unmapped (by kswapd), they may exist as SwapCache in the system until they
 are really freed. Such SwapCaches are also accounted.
-A swapped-in page is not accounted until it's mapped.
+A swapped-in page is accounted after adding into swapcache.
 
 Note: The kernel does swapin-readahead and reads multiple swaps at once.
-This means swapped-in pages may contain pages for other tasks than a task
-causing page fault. So, we avoid accounting at swap-in I/O.
+Since page's memcg recorded into swap whatever memsw enabled, the page will
+be accounted after swapin.
 
 At page migration, accounting information is kept.
 
@@ -222,18 +222,13 @@ the cgroup that brought it in -- this wi
 But see section 8.2: when moving a task to another cgroup, its pages may
 be recharged to the new cgroup, if move_charge_at_immigrate has been chosen.
 
-Exception: If CONFIG_MEMCG_SWAP is not used.
-When you do swapoff and make swapped-out pages of shmem(tmpfs) to
-be backed into memory in force, charges for pages are accounted against the
-caller of swapoff rather than the users of shmem.
