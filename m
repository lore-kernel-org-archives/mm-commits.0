From: akpm@linux-foundation.org
Subject: [merged] kernel-pidc-move-statement.patch removed from -mm tree
Date: Mon, 08 Jul 2013 12:36:50 -0700
Message-ID: <51db14d2.U4dUBsRp/jxkBI3N%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51725 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3GHTgu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:36:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, serge.hallyn@canonical.com, ebiederm@xmission.com, raphael.scarv@gmail.com

Subject: [merged] kernel-pidc-move-statement.patch removed from -mm tree
To: raphael.scarv@gmail.com,ebiederm@xmission.com,serge.hallyn@canonical.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:36:50 -0700


The patch titled
     Subject: kernel/pid.c: move statement
has been removed from the -mm tree.  Its filename was
     kernel-pidc-move-statement.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: "Raphael S. Carvalho" <raphael.scarv@gmail.com>
Subject: kernel/pid.c: move statement

Move statement to static initilization of init_pid_ns.

Signed-off-by: Raphael S. Carvalho <raphael.scarv@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/pid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/pid.c~kernel-pidc-move-statement kernel/pid.c
--- a/kernel/pid.c~kernel-pidc-move-statement
+++ a/kernel/pid.c
@@ -75,6 +75,7 @@ struct pid_namespace init_pid_ns = {
 		[ 0 ... PIDMAP_ENTRIES-1] = { ATOMIC_INIT(BITS_PER_PAGE), NULL }
 	},
 	.last_pid = 0,
+	.nr_hashed = PIDNS_HASH_ADDING,
 	.level = 0,
 	.child_reaper = &init_task,
 	.user_ns = &init_user_ns,
@@ -590,7 +591,6 @@ void __init pidmap_init(void)
 	/* Reserve PID 0. We never call free_pidmap(0) */
 	set_bit(0, init_pid_ns.pidmap[0].page);
 	atomic_dec(&init_pid_ns.pidmap[0].nr_free);
-	init_pid_ns.nr_hashed = PIDNS_HASH_ADDING;
 
 	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
 			SLAB_HWCACHE_ALIGN | SLAB_PANIC);
_

Patches currently in -mm which might be from raphael.scarv@gmail.com are

origin.patch
kernel-auditfilterc-fixing-build-warning.patch

