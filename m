From: akpm@linux-foundation.org
Subject: [merged] lib-atomic64-initialize-locks-statically-to-fix-early-users.patch removed from -mm tree
Date: Fri, 21 Dec 2012 12:40:20 -0800
Message-ID: <20121221204021.A3CA420004E__4404.82691997222$1356122450$gmane$org@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wi0-f201.google.com ([209.85.212.201]:49757 "EHLO
	mail-wi0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab2LUUkY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 21 Dec 2012 15:40:24 -0500
Received: by mail-wi0-f201.google.com with SMTP id hm2so272692wib.2
        for <mm-commits@vger.kernel.org>; Fri, 21 Dec 2012 12:40:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sboyd@codeaurora.org, benh@kernel.crashing.org, davem@davemloft.net, ebiederm@xmission.com, stable@vger.kernel.org, tony@atomide.com, vaibhav.bedia@ti.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: atomic64: initialize locks statically to fix early users
has been removed from the -mm tree.  Its filename was
     lib-atomic64-initialize-locks-statically-to-fix-early-users.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Stephen Boyd <sboyd@codeaurora.org>
Subject: lib: atomic64: initialize locks statically to fix early users

The atomic64 library uses a handful of static spin locks to implement
atomic 64-bit operations on architectures without support for atomic
64-bit instructions.  Unfortunately, the spinlocks are initialized in a
pure initcall and that is too late for the vfs namespace code which wants
to use atomic64 operations before the initcall is run (introduced by
8823c07 "vfs: Add setns support for the mount namespace").

This leads to BUG messages such as:

BUG: spinlock bad magic on CPU#0, swapper/0/0
 lock: atomic64_lock+0x240/0x400, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
[<c001af64>] (unwind_backtrace+0x0/0xf0) from [<c02c2010>] (do_raw_spin_lock+0x158/0x198)
[<c02c2010>] (do_raw_spin_lock+0x158/0x198) from [<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58)
[<c04d89ec>] (_raw_spin_lock_irqsave+0x4c/0x58) from [<c02cabf0>] (atomic64_add_return+0x30/0x5c)
[<c02cabf0>] (atomic64_add_return+0x30/0x5c) from [<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac)
[<c0124564>] (alloc_mnt_ns.clone.14+0x44/0xac) from [<c0124f4c>] (create_mnt_ns+0xc/0x54)
[<c0124f4c>] (create_mnt_ns+0xc/0x54) from [<c06f31a4>] (mnt_init+0x120/0x1d4)
[<c06f31a4>] (mnt_init+0x120/0x1d4) from [<c06f2d50>] (vfs_caches_init+0xe0/0x10c)
[<c06f2d50>] (vfs_caches_init+0xe0/0x10c) from [<c06d4798>] (start_kernel+0x29c/0x300)
[<c06d4798>] (start_kernel+0x29c/0x300) from [<80008078>] (0x80008078)

coming out early on during boot when spinlock debugging is enabled.

Fix this problem by initializing the spinlocks statically at compile time.

Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
Reported-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Tested-by: Vaibhav Bedia <vaibhav.bedia@ti.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Tested-by: Tony Lindgren <tony@atomide.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/atomic64.c |   17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff -puN lib/atomic64.c~lib-atomic64-initialize-locks-statically-to-fix-early-users lib/atomic64.c
--- a/lib/atomic64.c~lib-atomic64-initialize-locks-statically-to-fix-early-users
+++ a/lib/atomic64.c
@@ -31,7 +31,11 @@
 static union {
 	raw_spinlock_t lock;
 	char pad[L1_CACHE_BYTES];
-} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp;
+} atomic64_lock[NR_LOCKS] __cacheline_aligned_in_smp = {
+	[0 ... (NR_LOCKS - 1)] = {
+		.lock =  __RAW_SPIN_LOCK_UNLOCKED(atomic64_lock.lock),
+	},
+};
 
 static inline raw_spinlock_t *lock_addr(const atomic64_t *v)
 {
@@ -173,14 +177,3 @@ int atomic64_add_unless(atomic64_t *v, l
 	return ret;
 }
 EXPORT_SYMBOL(atomic64_add_unless);
-
-static int init_atomic64_lock(void)
-{
-	int i;
-
-	for (i = 0; i < NR_LOCKS; ++i)
-		raw_spin_lock_init(&atomic64_lock[i].lock);
-	return 0;
-}
