From: akpm@linux-foundation.org
Subject: [merged] slub-missing-test-for-partial-pages-flush-work-in-flush_all.patch removed from -mm tree
Date: Wed, 23 May 2012 12:51:09 -0700
Message-ID: <20120523195109.9B93AA0210@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f202.google.com ([209.85.160.202]:51197 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932897Ab2EWTvQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 23 May 2012 15:51:16 -0400
Received: by ghbz15 with SMTP id z15so188861ghb.1
        for <mm-commits@vger.kernel.org>; Wed, 23 May 2012 12:51:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: majianpeng@gmail.com, cl@linux.com, gilad@benyossef.com, jlayton@redhat.com, penberg@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: slub: missing test for partial pages flush work in flush_all()
has been removed from the -mm tree.  Its filename was
     slub-missing-test-for-partial-pages-flush-work-in-flush_all.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: majianpeng <majianpeng@gmail.com>
Subject: slub: missing test for partial pages flush work in flush_all()

I found some kernel messages such as:

SLUB raid5-md127: kmem_cache_destroy called for cache that still has objects.
Pid: 6143, comm: mdadm Tainted: G           O 3.4.0-rc6+        #75
Call Trace:
[<ffffffff811227f8>] kmem_cache_destroy+0x328/0x400
[<ffffffffa005ff1d>] free_conf+0x2d/0xf0 [raid456]
[<ffffffffa0060791>] stop+0x41/0x60 [raid456]
[<ffffffffa000276a>] md_stop+0x1a/0x60 [md_mod]
[<ffffffffa000c974>] do_md_stop+0x74/0x470 [md_mod]
[<ffffffffa000d0ff>] md_ioctl+0xff/0x11f0 [md_mod]
[<ffffffff8127c958>] blkdev_ioctl+0xd8/0x7a0
[<ffffffff8115ef6b>] block_ioctl+0x3b/0x40
[<ffffffff8113b9c6>] do_vfs_ioctl+0x96/0x560
[<ffffffff8113bf21>] sys_ioctl+0x91/0xa0
[<ffffffff816e9d22>] system_call_fastpath+0x16/0x1b

Then using kmemleak I found these messages:

unreferenced object 0xffff8800b6db7380 (size 112):
  comm "mdadm", pid 5783, jiffies 4294810749 (age 90.589s)
  hex dump (first 32 bytes):
    01 01 db b6 ad 4e ad de ff ff ff ff ff ff ff ff  .....N..........
    ff ff ff ff ff ff ff ff 98 40 4a 82 ff ff ff ff  .........@J.....
  backtrace:
    [<ffffffff816b52c1>] kmemleak_alloc+0x21/0x50
    [<ffffffff8111a11b>] kmem_cache_alloc+0xeb/0x1b0
    [<ffffffff8111c431>] kmem_cache_open+0x2f1/0x430
    [<ffffffff8111c6c8>] kmem_cache_create+0x158/0x320
    [<ffffffffa008f979>] setup_conf+0x649/0x770 [raid456]
    [<ffffffffa009044b>] run+0x68b/0x840 [raid456]
    [<ffffffffa000bde9>] md_run+0x529/0x940 [md_mod]
    [<ffffffffa000c218>] do_md_run+0x18/0xc0 [md_mod]
    [<ffffffffa000dba8>] md_ioctl+0xba8/0x11f0 [md_mod]
    [<ffffffff81272b28>] blkdev_ioctl+0xd8/0x7a0
    [<ffffffff81155bfb>] block_ioctl+0x3b/0x40
    [<ffffffff811326d6>] do_vfs_ioctl+0x96/0x560
    [<ffffffff81132c31>] sys_ioctl+0x91/0xa0
    [<ffffffff816dd3a2>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

This bug was introduced by a8364d5555b ("slub: only IPI CPUs that have per
cpu obj to flush"), which did not include checks for per cpu partial pages
being present on a cpu.

Signed-off-by: majianpeng <majianpeng@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>
Tested-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/slub.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/slub.c~slub-missing-test-for-partial-pages-flush-work-in-flush_all mm/slub.c
--- a/mm/slub.c~slub-missing-test-for-partial-pages-flush-work-in-flush_all
+++ a/mm/slub.c
@@ -2040,7 +2040,7 @@ static bool has_cpu_slab(int cpu, void *
 	struct kmem_cache *s = info;
 	struct kmem_cache_cpu *c = per_cpu_ptr(s->cpu_slab, cpu);
 
-	return !!(c->page);
+	return c->page || c->partial;
 }
 
 static void flush_all(struct kmem_cache *s)
_

Patches currently in -mm which might be from majianpeng@gmail.com are

origin.patch
linux-next.patch

