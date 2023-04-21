Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB82DC77B76
	for <mm-commits@archiver.kernel.org>; Fri, 21 Apr 2023 19:44:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbjDUToX (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 21 Apr 2023 15:44:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232925AbjDUToX (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 21 Apr 2023 15:44:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F4C19A1
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 12:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4CF65292
        for <mm-commits@vger.kernel.org>; Fri, 21 Apr 2023 19:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD092C433EF;
        Fri, 21 Apr 2023 19:44:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1682106261;
        bh=8fqKKXWCq37l6m1DGMTzrEC5wWrGq3Fvcu0M6jrb6xQ=;
        h=Date:To:From:Subject:From;
        b=g4DqP0BYuP8AWXi219oJsiLq4iyJjkypBRLlPcHhtX1TnzimxpH/fIF5qt8Q/D9ge
         GSKyojFvd/cqO8smyAoBnSbGTpSrgU06c/vBTz8PJuDnjyl6G3FnicPa8cM1P8LlN1
         cb4/vfOCBQ23aYYjWGacYB+0/CTCwuflVvYq1G/o=
Date:   Fri, 21 Apr 2023 12:44:20 -0700
To:     mm-commits@vger.kernel.org, shakeelb@google.com,
        muchun.song@linux.dev, mhocko@kernel.org, hannes@cmpxchg.org,
        dvyukov@google.com, roman.gushchin@linux.dev,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-fix-a-null-pointer-dereference-in-obj_stock_flush_required.patch added to mm-unstable branch
Message-Id: <20230421194420.DD092C433EF@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: fix a NULL pointer dereference in obj_stock_flush_required()
has been added to the -mm mm-unstable branch.  Its filename is
     mm-kmem-fix-a-null-pointer-dereference-in-obj_stock_flush_required.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-fix-a-null-pointer-dereference-in-obj_stock_flush_required.patch

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
From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: mm: kmem: fix a NULL pointer dereference in obj_stock_flush_required()
Date: Fri, 21 Apr 2023 10:40:54 -0700

KCSAN found an issue in obj_stock_flush_required():
stock->cached_objcg can be reset between the check and dereference:

==================================================================
BUG: KCSAN: data-race in drain_all_stock / drain_obj_stock

write to 0xffff888237c2a2f8 of 8 bytes by task 19625 on cpu 0:
 drain_obj_stock+0x408/0x4e0 mm/memcontrol.c:3306
 refill_obj_stock+0x9c/0x1e0 mm/memcontrol.c:3340
 obj_cgroup_uncharge+0xe/0x10 mm/memcontrol.c:3408
 memcg_slab_free_hook mm/slab.h:587 [inline]
 __cache_free mm/slab.c:3373 [inline]
 __do_kmem_cache_free mm/slab.c:3577 [inline]
 kmem_cache_free+0x105/0x280 mm/slab.c:3602
 __d_free fs/dcache.c:298 [inline]
 dentry_free fs/dcache.c:375 [inline]
 __dentry_kill+0x422/0x4a0 fs/dcache.c:621
 dentry_kill+0x8d/0x1e0
 dput+0x118/0x1f0 fs/dcache.c:913
 __fput+0x3bf/0x570 fs/file_table.c:329
 ____fput+0x15/0x20 fs/file_table.c:349
 task_work_run+0x123/0x160 kernel/task_work.c:179
 resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
 exit_to_user_mode_loop+0xcf/0xe0 kernel/entry/common.c:171
 exit_to_user_mode_prepare+0x6a/0xa0 kernel/entry/common.c:203
 __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
 syscall_exit_to_user_mode+0x26/0x140 kernel/entry/common.c:296
 do_syscall_64+0x4d/0xc0 arch/x86/entry/common.c:86
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

read to 0xffff888237c2a2f8 of 8 bytes by task 19632 on cpu 1:
 obj_stock_flush_required mm/memcontrol.c:3319 [inline]
 drain_all_stock+0x174/0x2a0 mm/memcontrol.c:2361
 try_charge_memcg+0x6d0/0xd10 mm/memcontrol.c:2703
 try_charge mm/memcontrol.c:2837 [inline]
 mem_cgroup_charge_skmem+0x51/0x140 mm/memcontrol.c:7290
 sock_reserve_memory+0xb1/0x390 net/core/sock.c:1025
 sk_setsockopt+0x800/0x1e70 net/core/sock.c:1525
 udp_lib_setsockopt+0x99/0x6c0 net/ipv4/udp.c:2692
 udp_setsockopt+0x73/0xa0 net/ipv4/udp.c:2817
 sock_common_setsockopt+0x61/0x70 net/core/sock.c:3668
 __sys_setsockopt+0x1c3/0x230 net/socket.c:2271
 __do_sys_setsockopt net/socket.c:2282 [inline]
 __se_sys_setsockopt net/socket.c:2279 [inline]
 __x64_sys_setsockopt+0x66/0x80 net/socket.c:2279
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x41/0xc0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd

value changed: 0xffff8881382d52c0 -> 0xffff888138893740

Reported by Kernel Concurrency Sanitizer on:
CPU: 1 PID: 19632 Comm: syz-executor.0 Not tainted 6.3.0-rc2-syzkaller-00387-g534293368afa #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/02/2023

Fix it by reading the cached_objcg with READ_ONCE().

Link: https://lkml.kernel.org/r/20230421174054.3434533-1-roman.gushchin@linux.dev
Fixes: bf4f059954dc ("mm: memcg/slab: obj_cgroup API")
Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
Reported-by: syzbot+774c29891415ab0fd29d@syzkaller.appspotmail.com
Reported-by: Dmitry Vyukov <dvyukov@google.com>
  Link: https://lore.kernel.org/linux-mm/CACT4Y+ZfucZhM60YPphWiCLJr6+SGFhT+jjm8k1P-a_8Kkxsjg@mail.gmail.com/T/#t
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-kmem-fix-a-null-pointer-dereference-in-obj_stock_flush_required
+++ a/mm/memcontrol.c
@@ -3343,10 +3343,11 @@ static struct obj_cgroup *drain_obj_stoc
 static bool obj_stock_flush_required(struct memcg_stock_pcp *stock,
 				     struct mem_cgroup *root_memcg)
 {
+	struct obj_cgroup *objcg = READ_ONCE(stock->cached_objcg);
 	struct mem_cgroup *memcg;
 
-	if (stock->cached_objcg) {
-		memcg = obj_cgroup_memcg(stock->cached_objcg);
+	if (objcg) {
+		memcg = obj_cgroup_memcg(objcg);
 		if (memcg && mem_cgroup_is_descendant(memcg, root_memcg))
 			return true;
 	}
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-fix-a-null-pointer-dereference-in-obj_stock_flush_required.patch

