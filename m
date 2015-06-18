From: akpm@linux-foundation.org
Subject: +
 mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc.patch added
 to -mm tree
Date: Thu, 18 Jun 2015 11:37:44 -0700
Message-ID: <55830ff8.p6MtL4uB5zF4KaoG%akpm__35216.8166348294$1434652686$gmane$org@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55071 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbbFRShp (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 18 Jun 2015 14:37:45 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: Larry.Finger@lwfinger.net, catalin.marinas@arm.com, cl@linux-foundation.org, kafai@fb.com, kamalesh@linux.vnet.ibm.com, stable@vger.kernel.org, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: mm: kmemleak_alloc_percpu() should follow the gfp from per_alloc()
has been added to the -mm tree.  Its filename is
     mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Larry Finger <Larry.Finger@lwfinger.net>
Subject: mm: kmemleak_alloc_percpu() should follow the gfp from per_alloc()

Beginning at commit d52d3997f843 ("ipv6: Create percpu rt6_info"), the
following INFO splat is logged:

===============================
[ INFO: suspicious RCU usage. ]
4.1.0-rc7-next-20150612 #1 Not tainted
-------------------------------
kernel/sched/core.c:7318 Illegal context switch in RCU-bh read-side critical section!
other info that might help us debug this:
rcu_scheduler_active = 1, debug_locks = 0
 3 locks held by systemd/1:
 #0:  (rtnl_mutex){+.+.+.}, at: [<ffffffff815f0c8f>] rtnetlink_rcv+0x1f/0x40
 #1:  (rcu_read_lock_bh){......}, at: [<ffffffff816a34e2>] ipv6_add_addr+0x62/0x540
 #2:  (addrconf_hash_lock){+...+.}, at: [<ffffffff816a3604>] ipv6_add_addr+0x184/0x540
stack backtrace:
CPU: 0 PID: 1 Comm: systemd Not tainted 4.1.0-rc7-next-20150612 #1
Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20   04/17/2014
 0000000000000001 ffff880224e07838 ffffffff817263a4 ffffffff810ccf2a
 ffff880224e08000 ffff880224e07868 ffffffff810b6827 0000000000000000
 ffffffff81a445d3 00000000000004f4 ffff88022682e100 ffff880224e07898
Call Trace:
 [<ffffffff817263a4>] dump_stack+0x4c/0x6e
 [<ffffffff810ccf2a>] ? console_unlock+0x1ca/0x510
 [<ffffffff810b6827>] lockdep_rcu_suspicious+0xe7/0x120
 [<ffffffff8108cf05>] ___might_sleep+0x1d5/0x1f0
 [<ffffffff8108cf6d>] __might_sleep+0x4d/0x90
 [<ffffffff811f3789>] ? create_object+0x39/0x2e0
 [<ffffffff811da427>] kmem_cache_alloc+0x47/0x250
 [<ffffffff813c19ae>] ? find_next_zero_bit+0x1e/0x20
 [<ffffffff811f3789>] create_object+0x39/0x2e0
 [<ffffffff810b7eb6>] ? mark_held_locks+0x66/0x90
 [<ffffffff8172efab>] ? _raw_spin_unlock_irqrestore+0x4b/0x60
 [<ffffffff817193c1>] kmemleak_alloc_percpu+0x61/0xe0
 [<ffffffff811a26f0>] pcpu_alloc+0x370/0x630

Additional backtrace lines are truncated.  In addition, the above splat is
followed by several "BUG: sleeping function called from invalid context at
mm/slub.c:1268" outputs.  As suggested by Martin KaFai Lau, these are the
clue to the fix.  Routine kmemleak_alloc_percpu() always uses GFP_KERNEL
for its allocations, whereas it should follow the gfp from its callers.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Acked-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: <stable@vger.kernel.org>	[3.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmemleak.h |    6 ++++--
 mm/kmemleak.c            |    9 +++++----
 mm/percpu.c              |    2 +-
 3 files changed, 10 insertions(+), 7 deletions(-)

diff -puN include/linux/kmemleak.h~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc include/linux/kmemleak.h
--- a/include/linux/kmemleak.h~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc
+++ a/include/linux/kmemleak.h
@@ -28,7 +28,8 @@
 extern void kmemleak_init(void) __ref;
 extern void kmemleak_alloc(const void *ptr, size_t size, int min_count,
 			   gfp_t gfp) __ref;
-extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size) __ref;
+extern void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size,
+				  gfp_t gfp) __ref;
 extern void kmemleak_free(const void *ptr) __ref;
 extern void kmemleak_free_part(const void *ptr, size_t size) __ref;
 extern void kmemleak_free_percpu(const void __percpu *ptr) __ref;
@@ -71,7 +72,8 @@ static inline void kmemleak_alloc_recurs
 					    gfp_t gfp)
 {
 }
-static inline void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size)
+static inline void kmemleak_alloc_percpu(const void __percpu *ptr, size_t size,
+					 gfp_t gfp)
 {
 }
 static inline void kmemleak_free(const void *ptr)
diff -puN mm/kmemleak.c~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc mm/kmemleak.c
--- a/mm/kmemleak.c~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc
+++ a/mm/kmemleak.c
@@ -930,12 +930,13 @@ EXPORT_SYMBOL_GPL(kmemleak_alloc);
  * kmemleak_alloc_percpu - register a newly allocated __percpu object
  * @ptr:	__percpu pointer to beginning of the object
  * @size:	size of the object
+ * @gfp:	flags used for kmemleak internal memory allocations
  *
  * This function is called from the kernel percpu allocator when a new object
- * (memory block) is allocated (alloc_percpu). It assumes GFP_KERNEL
- * allocation.
+ * (memory block) is allocated (alloc_percpu).
  */
-void __ref kmemleak_alloc_percpu(const void __percpu *ptr, size_t size)
+void __ref kmemleak_alloc_percpu(const void __percpu *ptr, size_t size,
+				 gfp_t gfp)
 {
 	unsigned int cpu;
 
@@ -948,7 +949,7 @@ void __ref kmemleak_alloc_percpu(const v
 	if (kmemleak_enabled && ptr && !IS_ERR(ptr))
 		for_each_possible_cpu(cpu)
 			create_object((unsigned long)per_cpu_ptr(ptr, cpu),
-				      size, 0, GFP_KERNEL);
+				      size, 0, gfp);
 	else if (kmemleak_early_log)
 		log_early(KMEMLEAK_ALLOC_PERCPU, ptr, size, 0);
 }
diff -puN mm/percpu.c~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc mm/percpu.c
--- a/mm/percpu.c~mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc
+++ a/mm/percpu.c
@@ -1030,7 +1030,7 @@ area_found:
 		memset((void *)pcpu_chunk_addr(chunk, cpu, 0) + off, 0, size);
 
 	ptr = __addr_to_pcpu_ptr(chunk->base_addr + off);
-	kmemleak_alloc_percpu(ptr, size);
+	kmemleak_alloc_percpu(ptr, size, gfp);
 	return ptr;
 
 fail_unlock:
_

Patches currently in -mm which might be from Larry.Finger@lwfinger.net are

mm-kmemleak_alloc_percpu-should-follow-the-gfp-from-per_alloc.patch
linux-next.patch

