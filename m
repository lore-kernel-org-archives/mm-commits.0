Return-Path: <mm-commits-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2E2EC197A0
	for <mm-commits@archiver.kernel.org>; Thu, 16 Nov 2023 04:23:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230247AbjKPEX3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 15 Nov 2023 23:23:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjKPEX2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2023 23:23:28 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2A2C197
        for <mm-commits@vger.kernel.org>; Wed, 15 Nov 2023 20:23:24 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52799C433C7;
        Thu, 16 Nov 2023 04:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1700108604;
        bh=A5n1nUOwwkjk8qKNrK41GbYXtT9XHwxJ4+XrO2KZxmw=;
        h=Date:To:From:Subject:From;
        b=DfygwE24qMTX+MOXhYPczRiCYxnL87KN79xtSWG7Bpuck3r3sB6G5zvC3/n0PfQD/
         Ft9Tb5YDFG5wXpr40ShcSOuOgaJS5mM4UjQh4kRCKiUKOlmR8K62sebei/1Idbz2fW
         VBABQH7Ug4PYzhYIJic1buO/ItzlvgcwMkc45OH0=
Date:   Wed, 15 Nov 2023 20:23:23 -0800
To:     mm-commits@vger.kernel.org, vbabka@suse.cz, shakeelb@google.com,
        rientjes@google.com, muchun.song@linux.dev, mhocko@kernel.org,
        hannes@cmpxchg.org, erhard_f@mailbox.org, dennis@kernel.org,
        roman.gushchin@linux.dev, akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: + mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch added to mm-hotfixes-unstable branch
Message-Id: <20231116042324.52799C433C7@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmem: properly initialize local objcg variable in current_obj_cgroup()
has been added to the -mm mm-hotfixes-unstable branch.  Its filename is
     mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch

This patch will shortly appear at
     https://git.kernel.org/pub/scm/linux/kernel/git/akpm/25-new.git/tree/patches/mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch

This patch will later appear in the mm-hotfixes-unstable branch at
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
Subject: mm: kmem: properly initialize local objcg variable in current_obj_cgroup()
Date: Wed, 15 Nov 2023 18:51:09 -0800

Erhard reported that the 6.7-rc1 kernel panics on boot if being
built with clang-16. The problem was not reproducible with gcc.

[    5.975049] general protection fault, probably for non-canonical address 0xf555515555555557: 0000 [#1] SMP KASAN PTI
[    5.976422] KASAN: maybe wild-memory-access in range [0xaaaaaaaaaaaaaab8-0xaaaaaaaaaaaaaabf]
[    5.977475] CPU: 3 PID: 1 Comm: systemd Not tainted 6.7.0-rc1-Zen3 #77
[    5.977860] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[    5.977860] RIP: 0010:obj_cgroup_charge_pages+0x27/0x2d5
[    5.977860] Code: 90 90 90 55 41 57 41 56 41 55 41 54 53 89 d5 41 89 f6 49 89 ff 48 b8 00 00 00 00 00 fc ff df 49 83 c7 10 4d3
[    5.977860] RSP: 0018:ffffc9000001fb18 EFLAGS: 00010a02
[    5.977860] RAX: dffffc0000000000 RBX: aaaaaaaaaaaaaaaa RCX: ffff8883eb9a8b08
[    5.977860] RDX: 0000000000000005 RSI: 0000000000400cc0 RDI: aaaaaaaaaaaaaaaa
[    5.977860] RBP: 0000000000000005 R08: 3333333333333333 R09: 0000000000000000
[    5.977860] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8883eb9a8b18
[    5.977860] R13: 1555555555555557 R14: 0000000000400cc0 R15: aaaaaaaaaaaaaaba
[    5.977860] FS:  00007f2976438b40(0000) GS:ffff8883eb980000(0000) knlGS:0000000000000000
[    5.977860] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.977860] CR2: 00007f29769e0060 CR3: 0000000107222003 CR4: 0000000000370eb0
[    5.977860] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    5.977860] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    5.977860] Call Trace:
[    5.977860]  <TASK>
[    5.977860]  ? __die_body+0x16/0x75
[    5.977860]  ? die_addr+0x4a/0x70
[    5.977860]  ? exc_general_protection+0x1c9/0x2d0
[    5.977860]  ? cgroup_mkdir+0x455/0x9fb
[    5.977860]  ? __x64_sys_mkdir+0x69/0x80
[    5.977860]  ? asm_exc_general_protection+0x26/0x30
[    5.977860]  ? obj_cgroup_charge_pages+0x27/0x2d5
[    5.977860]  obj_cgroup_charge+0x114/0x1ab
[    5.977860]  pcpu_alloc+0x1a6/0xa65
[    5.977860]  ? mem_cgroup_css_alloc+0x1eb/0x1140
[    5.977860]  ? cgroup_apply_control_enable+0x26b/0x7c0
[    5.977860]  mem_cgroup_css_alloc+0x23f/0x1140
[    5.977860]  cgroup_apply_control_enable+0x26b/0x7c0
[    5.977860]  ? cgroup_kn_set_ugid+0x2d/0x1a0
[    5.977860]  cgroup_mkdir+0x455/0x9fb
[    5.977860]  ? __cfi_cgroup_mkdir+0x10/0x10
[    5.977860]  kernfs_iop_mkdir+0x130/0x170
[    5.977860]  vfs_mkdir+0x405/0x530
[    5.977860]  do_mkdirat+0x188/0x1f0
[    5.977860]  __x64_sys_mkdir+0x69/0x80
[    5.977860]  do_syscall_64+0x7d/0x100
[    5.977860]  ? do_syscall_64+0x89/0x100
[    5.977860]  ? do_syscall_64+0x89/0x100
[    5.977860]  ? do_syscall_64+0x89/0x100
[    5.977860]  ? do_syscall_64+0x89/0x100
[    5.977860]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[    5.977860] RIP: 0033:0x7f297671defb
[    5.977860] Code: 8b 05 39 7f 0d 00 bb ff ff ff ff 64 c7 00 16 00 00 00 e9 61 ff ff ff e8 23 0c 02 00 0f 1f 00 f3 0f 1e fa b88
[    5.977860] RSP: 002b:00007ffee6242bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000053
[    5.977860] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f297671defb
[    5.977860] RDX: 0000000000000000 RSI: 00000000000001ed RDI: 000055c6b449f0e0
[    5.977860] RBP: 00007ffee6242bf0 R08: 000000000000000e R09: 0000000000000000
[    5.977860] R10: 0000000000000000 R11: 0000000000000246 R12: 000055c6b445db80
[    5.977860] R13: 00000000000003a0 R14: 00007f2976a68651 R15: 00000000000003a0
[    5.977860]  </TASK>
[    5.977860] Modules linked in:
[    6.014095] ---[ end trace 0000000000000000 ]---
[    6.014701] RIP: 0010:obj_cgroup_charge_pages+0x27/0x2d5
[    6.015348] Code: 90 90 90 55 41 57 41 56 41 55 41 54 53 89 d5 41 89 f6 49 89 ff 48 b8 00 00 00 00 00 fc ff df 49 83 c7 10 4d3
[    6.017575] RSP: 0018:ffffc9000001fb18 EFLAGS: 00010a02
[    6.018255] RAX: dffffc0000000000 RBX: aaaaaaaaaaaaaaaa RCX: ffff8883eb9a8b08
[    6.019120] RDX: 0000000000000005 RSI: 0000000000400cc0 RDI: aaaaaaaaaaaaaaaa
[    6.019983] RBP: 0000000000000005 R08: 3333333333333333 R09: 0000000000000000
[    6.020849] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8883eb9a8b18
[    6.021747] R13: 1555555555555557 R14: 0000000000400cc0 R15: aaaaaaaaaaaaaaba
[    6.022609] FS:  00007f2976438b40(0000) GS:ffff8883eb980000(0000) knlGS:0000000000000000
[    6.023593] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    6.024296] CR2: 00007f29769e0060 CR3: 0000000107222003 CR4: 0000000000370eb0
[    6.025279] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    6.026139] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    6.027000] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

Actually the problem is caused by uninitialized local variable in
current_obj_cgroup().  If the root memory cgroup is set as an active
memory cgroup for a charging scope (as in the trace, where systemd tries
to create the first non-root cgroup, so the parent cgroup is the root
cgroup), the "for" loop is skipped and uninitialized objcg is returned,
causing a panic down the accounting stack.

The fix is trivial: initialize the objcg variable to NULL unconditionally
before the "for" loop.

Link: https://lkml.kernel.org/r/20231116025109.3775055-1-roman.gushchin@linux.dev
Fixes: e86828e5446d ("mm: kmem: scoped objcg protection")
Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/1959
Signed-off-by: Roman Gushchin (Cruise) <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 +
 1 file changed, 1 insertion(+)

--- a/mm/memcontrol.c~mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup
+++ a/mm/memcontrol.c
@@ -3166,6 +3166,7 @@ __always_inline struct obj_cgroup *curre
 	return NULL;
 
 from_memcg:
+	objcg = NULL;
 	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
 		/*
 		 * Memcg pointer is protected by scope (see set_active_memcg())
_

Patches currently in -mm which might be from roman.gushchin@linux.dev are

mm-kmem-properly-initialize-local-objcg-variable-in-current_obj_cgroup.patch

