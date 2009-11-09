From: akpm@linux-foundation.org
Subject: [merged] kprobes-sanitize-struct-kretprobe_instance-allocations.patch removed from -mm tree
Date: Mon, 09 Nov 2009 11:55:51 -0800
Message-ID: <200911091955.nA9Jtpvh024866@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33851 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326AbZKIT4N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 9 Nov 2009 14:56:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ananth@in.ibm.com, fweisbec@gmail.com, jkenisto@us.ibm.com, mhiramat@redhat.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     kprobes: sanitize struct kretprobe_instance allocations
has been removed from the -mm tree.  Its filename was
     kprobes-sanitize-struct-kretprobe_instance-allocations.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: sanitize struct kretprobe_instance allocations
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

For as long as kretprobes have existed, we've allocated NR_CPUS instances
of kretprobe_instance structures.  With the default value of
CONFIG_NR_CPUS increasing on certain architectures, we are potentially
wasting kernel memory.

See http://sourceware.org/bugzilla/show_bug.cgi?id=10839#c3 for more
details.

Use a saner num_possible_cpus() instead of NR_CPUS for allocation.

Signed-off-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Acked-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Jim Keniston <jkenisto@us.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN kernel/kprobes.c~kprobes-sanitize-struct-kretprobe_instance-allocations kernel/kprobes.c
--- a/kernel/kprobes.c~kprobes-sanitize-struct-kretprobe_instance-allocations
+++ a/kernel/kprobes.c
@@ -1035,9 +1035,9 @@ int __kprobes register_kretprobe(struct 
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * NR_CPUS);
+		rp->maxactive = max(10, 2 * num_possible_cpus());
 #else
-		rp->maxactive = NR_CPUS;
+		rp->maxactive = num_possible_cpus();
 #endif
 	}
 	spin_lock_init(&rp->lock);
_

Patches currently in -mm which might be from ananth@in.ibm.com are

linux-next.patch

