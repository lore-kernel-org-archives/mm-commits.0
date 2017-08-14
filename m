From: akpm@linux-foundation.org
Subject: + debugobjects-make-kmemleak-ignore-debug-objects.patch added to
 -mm tree
Date: Mon, 14 Aug 2017 14:27:02 -0700
Message-ID: <599215a6.r7uZ8/wBqO0V0vh9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56044 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752224AbdHNV1D (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 14 Aug 2017 17:27:03 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: longman@redhat.com, catalin.marinas@arm.com, mingo@kernel.org, tglx@linutronix.de, mm-commits@vger.kernel.org


The patch titled
     Subject: debugobjects: make kmemleak ignore debug objects
has been added to the -mm tree.  Its filename is
     debugobjects-make-kmemleak-ignore-debug-objects.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/debugobjects-make-kmemleak-ignore-debug-objects.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/debugobjects-make-kmemleak-ignore-debug-objects.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Waiman Long <longman@redhat.com>
Subject: debugobjects: make kmemleak ignore debug objects

The allocated debug objects are either on the free list or in the hashed
bucket lists.  So they won't get lost.  However if both debug objects and
kmemleak are enabled and kmemleak scanning is done while some of the debug
objects are transitioning from one list to the others, false negative
reporting of memory leaks may happen for those objects.  For example,

[38687.275678] kmemleak: 12 new suspected memory leaks (see
/sys/kernel/debug/kmemleak)
unreferenced object 0xffff92e98aabeb68 (size 40):
  comm "ksmtuned", pid 4344, jiffies 4298403600 (age 906.430s)
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 d0 bc db 92 e9 92 ff ff  ................
    01 00 00 00 00 00 00 00 38 36 8a 61 e9 92 ff ff  ........86.a....
  backtrace:
    [<ffffffff8fa5378a>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff8f47c019>] kmem_cache_alloc+0xe9/0x320
    [<ffffffff8f62ed96>] __debug_object_init+0x3e6/0x400
    [<ffffffff8f62ef01>] debug_object_activate+0x131/0x210
    [<ffffffff8f330d9f>] __call_rcu+0x3f/0x400
    [<ffffffff8f33117d>] call_rcu_sched+0x1d/0x20
    [<ffffffff8f4a183c>] put_object+0x2c/0x40
    [<ffffffff8f4a188c>] __delete_object+0x3c/0x50
    [<ffffffff8f4a18bd>] delete_object_full+0x1d/0x20
    [<ffffffff8fa535c2>] kmemleak_free+0x32/0x80
    [<ffffffff8f47af07>] kmem_cache_free+0x77/0x350
    [<ffffffff8f453912>] unlink_anon_vmas+0x82/0x1e0
    [<ffffffff8f440341>] free_pgtables+0xa1/0x110
    [<ffffffff8f44af91>] exit_mmap+0xc1/0x170
    [<ffffffff8f29db60>] mmput+0x80/0x150
    [<ffffffff8f2a7609>] do_exit+0x2a9/0xd20

The references in the debug objects may also hide a real memory leak.

As there is no point in having kmemleak to track debug object allocations,
kmemleak checking is now disabled for debug objects.

Link: http://lkml.kernel.org/r/1502718733-8527-1-git-send-email-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c        |    2 +-
 lib/debugobjects.c |    3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN init/main.c~debugobjects-make-kmemleak-ignore-debug-objects init/main.c
--- a/init/main.c~debugobjects-make-kmemleak-ignore-debug-objects
+++ a/init/main.c
@@ -658,8 +658,8 @@ asmlinkage __visible void __init start_k
 		initrd_start = 0;
 	}
 #endif
-	debug_objects_mem_init();
 	kmemleak_init();
+	debug_objects_mem_init();
 	setup_per_cpu_pageset();
 	numa_policy_init();
 	if (late_time_init)
diff -puN lib/debugobjects.c~debugobjects-make-kmemleak-ignore-debug-objects lib/debugobjects.c
--- a/lib/debugobjects.c~debugobjects-make-kmemleak-ignore-debug-objects
+++ a/lib/debugobjects.c
@@ -18,6 +18,7 @@
 #include <linux/debugfs.h>
 #include <linux/slab.h>
 #include <linux/hash.h>
+#include <linux/kmemleak.h>
 
 #define ODEBUG_HASH_BITS	14
 #define ODEBUG_HASH_SIZE	(1 << ODEBUG_HASH_BITS)
@@ -110,6 +111,7 @@ static void fill_pool(void)
 		if (!new)
 			return;
 
+		kmemleak_ignore(new);
 		raw_spin_lock_irqsave(&pool_lock, flags);
 		hlist_add_head(&new->node, &obj_pool);
 		debug_objects_allocated++;
@@ -1080,6 +1082,7 @@ static int __init debug_objects_replace_
 		obj = kmem_cache_zalloc(obj_cache, GFP_KERNEL);
 		if (!obj)
 			goto free;
+		kmemleak_ignore(obj);
 		hlist_add_head(&obj->node, &objects);
 	}
 
_

Patches currently in -mm which might be from longman@redhat.com are

debugobjects-make-kmemleak-ignore-debug-objects.patch

