From: akpm@linux-foundation.org
Subject: - tcpc-calculate-tcp_mem-based-on-low-memory-instead-of-all-memory.patch removed from -mm tree
Date: Wed, 02 Jul 2008 00:46:34 -0700
Message-ID: <200807020746.m627kY8Y005581@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55238 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753691AbYGBHsB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jul 2008 03:48:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miquels@cistron.nl, davem@davemloft.net, jheffner@psc.edu, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     tcp.c: calculate tcp_mem based on low memory instead of all memory
has been removed from the -mm tree.  Its filename was
     tcpc-calculate-tcp_mem-based-on-low-memory-instead-of-all-memory.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: tcp.c: calculate tcp_mem based on low memory instead of all memory
From: Miquel van Smoorenburg <miquels@cistron.nl>

I started upgrading a bunch of machines in my nntp server farm
to a recent kernel- 2.6.25.x. They were running 2.6.11.12 on
32 bits, and I upgraded them to 2.6.25.x on 64 bits.

All went fine until I noticed a few machines didn't have a 64
bit capable processor, so I had to keep them on a 32 bit kernel.
These are machines with dual xeons 3 Ghz and 8 GB of RAM.

On the 32 bit machines I keep getting the error below, and a flood
of these on a 9600 baud serial console essentially kills the machine:

diablo invoked oom-killer: gfp_mask=0xd0, order=0, oomkilladj=0
Pid: 4459, comm: diablo Not tainted 2.6.25.7-rc1 #1
 [<c0249660>] oom_kill_process+0x120/0x210
 [<c0227ff8>] __capable+0x8/0x20
 [<c0249898>] badness+0x128/0x1c0
 [<c0249b1c>] out_of_memory+0x17c/0x1c0
 [<c024bdf4>] __alloc_pages+0x254/0x350
 [<c03b75ad>] tcp_sendmsg+0x5cd/0xb50
 [<c0381672>] sock_aio_write+0xe2/0x100
 [<c02681e7>] do_sync_write+0xc7/0x110
 [<c0232f20>] autoremove_wake_function+0x0/0x50
 [<c0268af3>] vfs_write+0x133/0x140
 [<c0269131>] sys_write+0x41/0x70
 [<c0202e5e>] syscall_call+0x7/0xb

After some investigation, I found out that the values of
/proc/sys/net/ipv4/tcp_mem are quite different between
these two versions:

2.6.11.12:
$ cat tcp_mem
98304	131072	196608

2.6.25:
# cat tcp_mem
804672	1072896	1609344

Somwehere between 2.6.11.12 and 2.6.25, the calculation method of
the tcp_mem array was changed. Now 1609344 pages is 6.5 GB,
and that will ofcourse never fit in x86_32's low memory ..

I am not quite sure what the correct solution is here, I think
something like the patch below.

Alternatively we could use the existing calculation but limit 'limit'
to 3/4 of (totalram_pages - totalhigh_pages) if (totalhigh_pages > 0) ?



The tcp_mem array which contains limits on the total amount of
memory used by TCP sockets is calculated based on nr_all_pages.
On a 32 bits x86 system, we should base this on the number of
lowmem pages.

Signed-off-by: Miquel van Smoorenburg <miquels@cistron.nl>
Cc: John Heffner <jheffner@psc.edu>
Cc: David S. Miller <davem@davemloft.net>
Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN net/ipv4/tcp.c~tcpc-calculate-tcp_mem-based-on-low-memory-instead-of-all-memory net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~tcpc-calculate-tcp_mem-based-on-low-memory-instead-of-all-memory
+++ a/net/ipv4/tcp.c
@@ -260,6 +260,8 @@
 #include <linux/socket.h>
 #include <linux/random.h>
 #include <linux/bootmem.h>
+#include <linux/highmem.h>
+#include <linux/swap.h>
 #include <linux/cache.h>
 #include <linux/err.h>
 #include <linux/crypto.h>
@@ -2620,7 +2622,7 @@ __setup("thash_entries=", set_thash_entr
 void __init tcp_init(void)
 {
 	struct sk_buff *skb = NULL;
-	unsigned long limit;
+	unsigned long nr_pages, limit;
 	int order, i, max_share;
 
 	BUILD_BUG_ON(sizeof(struct tcp_skb_cb) > sizeof(skb->cb));
@@ -2689,8 +2691,9 @@ void __init tcp_init(void)
 	 * is up to 1/2 at 256 MB, decreasing toward zero with the amount of
 	 * memory, with a floor of 128 pages.
 	 */
-	limit = min(nr_all_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
-	limit = (limit * (nr_all_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
+	nr_pages = totalram_pages - totalhigh_pages;
+	limit = min(nr_pages, 1UL<<(28-PAGE_SHIFT)) >> (20-PAGE_SHIFT);
+	limit = (limit * (nr_pages >> (20-PAGE_SHIFT))) >> (PAGE_SHIFT-11);
 	limit = max(limit, 128UL);
 	sysctl_tcp_mem[0] = limit / 4 * 3;
 	sysctl_tcp_mem[1] = limit;
_

Patches currently in -mm which might be from miquels@cistron.nl are

linux-next.patch
scsi-dpt_i2o-is-bust-on-ia64.patch

