From: akpm@linux-foundation.org
Subject: [patch 12/14] mm/mempolicy: fix use after free when calling
 get_mempolicy
Date: Fri, 18 Aug 2017 15:16:24 -0700
Message-ID: <59976738.PKzxyoq73vw/gKqu%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46612 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752381AbdHRWQ0 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 18 Aug 2017 18:16:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, zhongjiang@huawei.com, mgorman@techsingularity.net, mhocko@suse.com, minchan@kernel.org, rientjes@google.com, stable@vger.kernel.org, vbabka@suse.cz

From: zhong jiang <zhongjiang@huawei.com>
Subject: mm/mempolicy: fix use after free when calling get_mempolicy

I hit a use after free issue when executing trinity and repoduced it with
KASAN enabled.  The related call trace is as follows.

BUG: KASan: use after free in SyS_get_mempolicy+0x3c8/0x960 at addr ffff8801f582d766
Read of size 2 by task syz-executor1/798

INFO: Allocated in mpol_new.part.2+0x74/0x160 age=3 cpu=1 pid=799
__slab_alloc+0x768/0x970
kmem_cache_alloc+0x2e7/0x450
mpol_new.part.2+0x74/0x160
mpol_new+0x66/0x80
SyS_mbind+0x267/0x9f0
system_call_fastpath+0x16/0x1b
INFO: Freed in __mpol_put+0x2b/0x40 age=4 cpu=1 pid=799
__slab_free+0x495/0x8e0
kmem_cache_free+0x2f3/0x4c0
__mpol_put+0x2b/0x40
SyS_mbind+0x383/0x9f0
system_call_fastpath+0x16/0x1b
INFO: Slab 0xffffea0009cb8dc0 objects=23 used=8 fp=0xffff8801f582de40 flags=0x200000000004080
INFO: Object 0xffff8801f582d760 @offset=5984 fp=0xffff8801f582d600

Bytes b4 ffff8801f582d750: ae 01 ff ff 00 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a  ........ZZZZZZZZ
Object ffff8801f582d760: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
Object ffff8801f582d770: 6b 6b 6b 6b 6b 6b 6b a5                          kkkkkkk.
Redzone ffff8801f582d778: bb bb bb bb bb bb bb bb                          ........
Padding ffff8801f582d8b8: 5a 5a 5a 5a 5a 5a 5a 5a                          ZZZZZZZZ
Memory state around the buggy address:
ffff8801f582d600: fb fb fb fc fc fc fc fc fc fc fc fc fc fc fc fc
ffff8801f582d680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8801f582d700: fc fc fc fc fc fc fc fc fc fc fc fc fb fb fb fc

!shared memory policy is not protected against parallel removal by other
thread which is normally protected by the mmap_sem.  do_get_mempolicy,
however, drops the lock midway while we can still access it later.  Early
premature up_read is a historical artifact from times when put_user was
called in this path see https://lwn.net/Articles/124754/ but that is gone
since 8bccd85ffbaf ("[PATCH] Implement sys_* do_* layering in the memory
policy layer.").  but when we have the the current mempolicy ref count
model.  The issue was introduced accordingly.

Fix the issue by removing the premature release.

Link: http://lkml.kernel.org/r/1502950924-27521-1-git-send-email-zhongjiang@huawei.com
Signed-off-by: zhong jiang <zhongjiang@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: <stable@vger.kernel.org>	[2.6+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/mempolicy.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN mm/mempolicy.c~mm-mempolicy-fix-use-after-free-when-calling-get_mempolicy mm/mempolicy.c
--- a/mm/mempolicy.c~mm-mempolicy-fix-use-after-free-when-calling-get_mempolicy
+++ a/mm/mempolicy.c
@@ -861,11 +861,6 @@ static long do_get_mempolicy(int *policy
 		*policy |= (pol->flags & MPOL_MODE_FLAGS);
 	}
 
-	if (vma) {
-		up_read(&current->mm->mmap_sem);
-		vma = NULL;
-	}
