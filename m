From: akpm@linux-foundation.org
Subject: [merged]
 mm-slub-fix-a-memory-leak-in-sysfs_slab_add.patch removed from -mm tree
Date: Thu, 04 Jun 2020 10:15:53 -0700
Message-ID: <20200604171553.E_dyk_mF4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:36996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729866AbgFDRPy (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 4 Jun 2020 13:15:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: cl@linux.com, hulkci@huawei.com, iamjoonsoo.kim@lge.com, mm-commits@vger.kernel.org, penberg@kernel.org, rientjes@google.com, wanghai38@huawei.com


The patch titled
     Subject: mm/slub: fix a memory leak in sysfs_slab_add()
has been removed from the -mm tree.  Its filename was
     mm-slub-fix-a-memory-leak-in-sysfs_slab_add.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Wang Hai <wanghai38@huawei.com>
Subject: mm/slub: fix a memory leak in sysfs_slab_add()

syzkaller reports for memory leak when kobject_init_and_add() returns an
error in the function sysfs_slab_add() [1]

When this happened, the function kobject_put() is not called for the
corresponding kobject, which potentially leads to memory leak.

This patch fixes the issue by calling kobject_put() even if
kobject_init_and_add() fails.

[1]
BUG: memory leak
unreferenced object 0xffff8880a6d4be88 (size 8):
  comm "syz-executor.3", pid 946, jiffies 4295772514 (age 18.396s)
  hex dump (first 8 bytes):
    70 69 64 5f 33 00 ff ff                          pid_3...
  backtrace:
    [<00000000a0980095>] kstrdup+0x35/0x70 mm/util.c:60
    [<00000000ef0cff3f>] kstrdup_const+0x3d/0x50 mm/util.c:82
    [<00000000e2461486>] kvasprintf_const+0x112/0x170 lib/kasprintf.c:48
    [<000000005d749e93>] kobject_set_name_vargs+0x55/0x130 lib/kobject.c:289
    [<0000000094e31519>] kobject_add_varg lib/kobject.c:384 [inline]
    [<0000000094e31519>] kobject_init_and_add+0xd8/0x170 lib/kobject.c:473
    [<0000000060f13e32>] sysfs_slab_add+0x1d8/0x290 mm/slub.c:5811
    [<00000000fe1d9a22>] __kmem_cache_create+0x50a/0x570 mm/slub.c:4384
    [<000000006a71a1b4>] create_cache+0x113/0x1e0 mm/slab_common.c:407
    [<0000000089491438>] kmem_cache_create_usercopy+0x1a1/0x260 mm/slab_common.c:505
    [<000000008c992595>] kmem_cache_create+0xd/0x10 mm/slab_common.c:564
    [<000000005320c4b6>] create_pid_cachep kernel/pid_namespace.c:54 [inline]
    [<000000005320c4b6>] create_pid_namespace kernel/pid_namespace.c:96 [inline]
    [<000000005320c4b6>] copy_pid_ns+0x77c/0x8f0 kernel/pid_namespace.c:148
    [<00000000fc8e1a2b>] create_new_namespaces+0x26b/0xa30 kernel/nsproxy.c:95
    [<0000000080f0c9a5>] unshare_nsproxy_namespaces+0xa7/0x1e0 kernel/nsproxy.c:229
    [<0000000007e05aea>] ksys_unshare+0x3d2/0x770 kernel/fork.c:2969
    [<00000000e04c8e4b>] __do_sys_unshare kernel/fork.c:3037 [inline]
    [<00000000e04c8e4b>] __se_sys_unshare kernel/fork.c:3035 [inline]
    [<00000000e04c8e4b>] __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3035
    [<000000005c4707c7>] do_syscall_64+0xa1/0x530 arch/x86/entry/common.c:295

Link: http://lkml.kernel.org/r/20200602115033.1054-1-wanghai38@huawei.com
Fixes: 80da026a8e5d ("mm/slub: fix slab double-free in case of duplicate sysfs filename")
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Reported-by: Hulk Robot <hulkci@huawei.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/slub.c~mm-slub-fix-a-memory-leak-in-sysfs_slab_add
+++ a/mm/slub.c
@@ -5835,8 +5835,10 @@ static int sysfs_slab_add(struct kmem_ca
 
 	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
-	if (err)
+	if (err) {
+		kobject_put(&s->kobj);
 		goto out;
+	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
 	if (err)
_

Patches currently in -mm which might be from wanghai38@huawei.com are
