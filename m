From: akpm@linux-foundation.org
Subject: + kasan-fix-races-in-quarantine_remove_cache-v2.patch added to
 -mm tree
Date: Thu, 09 Mar 2017 13:58:50 -0800
Message-ID: <58c1d01a.ic+S5R1FqW8i/Ajc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37534 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdCIV6w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 9 Mar 2017 16:58:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dvyukov@google.com, aryabinin@virtuozzo.com, gthelen@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-fix-races-in-quarantine_remove_cache-v2
has been added to the -mm tree.  Its filename is
     kasan-fix-races-in-quarantine_remove_cache-v2.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kasan-fix-races-in-quarantine_remove_cache-v2.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kasan-fix-races-in-quarantine_remove_cache-v2.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dmitry Vyukov <dvyukov@google.com>
Subject: kasan-fix-races-in-quarantine_remove_cache-v2

Changes since v1:
 - sorted includes

Link: http://lkml.kernel.org/r/20170309094028.51088-1-dvyukov@google.com
Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Greg Thelen <gthelen@google.com>


I've done some assessment of how good synchronize_srcu() works in this
case. And on a 4 CPU VM I see that it blocks waiting for pending read
critical sections in about 2-3% of cases. Which looks good to me.

I suspect that these races are the root cause of some GPFs that
I episodically hit. Previously I did not have any explanation for them.

BUG: unable to handle kernel NULL pointer dereference at 00000000000000c8
IP: qlist_free_all+0x2e/0xc0 mm/kasan/quarantine.c:155
PGD 6aeea067
PUD 60ed7067
PMD 0
Oops: 0000 [#1] SMP KASAN
Dumping ftrace buffer:
   (ftrace buffer empty)
Modules linked in:
CPU: 0 PID: 13667 Comm: syz-executor2 Not tainted 4.10.0+ #60
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Bochs 01/01/2011
task: ffff88005f948040 task.stack: ffff880069818000
RIP: 0010:qlist_free_all+0x2e/0xc0 mm/kasan/quarantine.c:155
RSP: 0018:ffff88006981f298 EFLAGS: 00010246
RAX: ffffea0000ffff00 RBX: 0000000000000000 RCX: ffffea0000ffff1f
RDX: 0000000000000000 RSI: ffff88003fffc3e0 RDI: 0000000000000000
RBP: ffff88006981f2c0 R08: ffff88002fed7bd8 R09: 00000001001f000d
R10: 00000000001f000d R11: ffff88006981f000 R12: ffff88003fffc3e0
R13: ffff88006981f2d0 R14: ffffffff81877fae R15: 0000000080000000
FS:  00007fb911a2d700(0000) GS:ffff88003ec00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000000000c8 CR3: 0000000060ed6000 CR4: 00000000000006f0
Call Trace:
 quarantine_reduce+0x10e/0x120 mm/kasan/quarantine.c:239
 kasan_kmalloc+0xca/0xe0 mm/kasan/kasan.c:590
 kasan_slab_alloc+0x12/0x20 mm/kasan/kasan.c:544
 slab_post_alloc_hook mm/slab.h:456 [inline]
 slab_alloc_node mm/slub.c:2718 [inline]
 kmem_cache_alloc_node+0x1d3/0x280 mm/slub.c:2754
 __alloc_skb+0x10f/0x770 net/core/skbuff.c:219
 alloc_skb include/linux/skbuff.h:932 [inline]
 _sctp_make_chunk+0x3b/0x260 net/sctp/sm_make_chunk.c:1388
 sctp_make_data net/sctp/sm_make_chunk.c:1420 [inline]
 sctp_make_datafrag_empty+0x208/0x360 net/sctp/sm_make_chunk.c:746
 sctp_datamsg_from_user+0x7e8/0x11d0 net/sctp/chunk.c:266
 sctp_sendmsg+0x2611/0x3970 net/sctp/socket.c:1962
 inet_sendmsg+0x164/0x5b0 net/ipv4/af_inet.c:761
 sock_sendmsg_nosec net/socket.c:633 [inline]
 sock_sendmsg+0xca/0x110 net/socket.c:643
 SYSC_sendto+0x660/0x810 net/socket.c:1685
 SyS_sendto+0x40/0x50 net/socket.c:1653
---
 1 file changed, 36 insertions(+), 6 deletions(-)

index 6f1ed1630873..5c44c08f46b6 100644
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kasan/quarantine.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kasan/quarantine.c~kasan-fix-races-in-quarantine_remove_cache-v2 mm/kasan/quarantine.c
--- a/mm/kasan/quarantine.c~kasan-fix-races-in-quarantine_remove_cache-v2
+++ a/mm/kasan/quarantine.c
@@ -25,9 +25,9 @@
 #include <linux/printk.h>
 #include <linux/shrinker.h>
 #include <linux/slab.h>
+#include <linux/srcu.h>
 #include <linux/string.h>
 #include <linux/types.h>
-#include <linux/srcu.h>
 
 #include "../slab.h"
 #include "kasan.h"
_

Patches currently in -mm which might be from dvyukov@google.com are

kasan-resched-in-quarantine_remove_cache.patch
kasan-fix-races-in-quarantine_remove_cache.patch
kasan-fix-races-in-quarantine_remove_cache-v2.patch

