From: akpm@linux-foundation.org
Subject: - rcu-move-three-variables-to-__read_mostly-to-save-space.patch removed from -mm tree
Date: Thu, 13 Dec 2007 15:30:46 -0800
Message-ID: <200712132330.lBDNUkZq023909@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37562 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbXLMXcN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 13 Dec 2007 18:32:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dada1@cosmosbay.com, dipankar@in.ibm.com, mingo@elte.hu, paulmck@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     RCU: move three variables to __read_mostly to save space
has been removed from the -mm tree.  Its filename was
     rcu-move-three-variables-to-__read_mostly-to-save-space.patch

This patch was dropped because Changes in git-x86 broke it

------------------------------------------------------
Subject: RCU: move three variables to __read_mostly to save space
From: Eric Dumazet <dada1@cosmosbay.com>

I noticed this vmlinux layout on i686 (where CONFIG_X86_L1_CACHE_SHIFT = 7) :

c06cdab4 d pid_caches_lh
c06cdb00 d qlowmark
c06cdb04 d qhimark
c06cdb08 d blimit
c06cdb80 d rcu_ctrlblk
c06cdc80 d rcu_bh_ctrlblk

This means that qlowmark, qhimark and blimit use a whole 128 bytes cache line.
Linker is not smart enough for us.

Moving these three variables to read_mostly section saves 116 (128-12) bytes.

# size vmlinux vmlinux.before_patch
    text    data     bss     dec     hex filename
6343966  490818  630784 7465568  71ea60 vmlinux
6343966  490930  630784 7465680  71ead0 vmlinux.before_patch

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Dipankar Sarma <dipankar@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/rcupdate.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/rcupdate.c~rcu-move-three-variables-to-__read_mostly-to-save-space kernel/rcupdate.c
--- a/kernel/rcupdate.c~rcu-move-three-variables-to-__read_mostly-to-save-space
+++ a/kernel/rcupdate.c
@@ -75,9 +75,9 @@ DEFINE_PER_CPU(struct rcu_data, rcu_bh_d
 
 /* Fake initialization required by compiler */
 static DEFINE_PER_CPU(struct tasklet_struct, rcu_tasklet) = {NULL};
-static int blimit = 10;
-static int qhimark = 10000;
-static int qlowmark = 100;
+static int blimit __read_mostly = 10;
+static int qhimark __read_mostly = 10000;
+static int qlowmark __read_mostly = 100;
 
 static atomic_t rcu_barrier_cpu_count;
 static DEFINE_MUTEX(rcu_barrier_mutex);
_

Patches currently in -mm which might be from dada1@cosmosbay.com are

parport-dev-timeslice-is-an-unsigned-long-not-an-int.patch
git-net.patch
git-sched.patch
percpu-__percpu_alloc_mask-can-dynamically-size-percpu_data.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open.patch
get-rid-of-nr_open-and-introduce-a-sysctl_nr_open-fix.patch
rcu-move-three-variables-to-__read_mostly-to-save-space.patch
