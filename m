From: akpm@linux-foundation.org
Subject: + kprobes-sanitize-struct-kretprobe_instance-allocations.patch added to -mm tree
Date: Fri, 30 Oct 2009 14:13:37 -0700
Message-ID: <200910302113.n9ULDb6L032606@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932867AbZJ3VOl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Oct 2009 17:14:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ananth@in.ibm.com, fweisbec@gmail.com, jkenisto@us.ibm.com, mhiramat@redhat.com, mingo@elte.hu


The patch titled
     kprobes: sanitize struct kretprobe_instance allocations
has been added to the -mm tree.  Its filename is
     kprobes-sanitize-struct-kretprobe_instance-allocations.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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
Cc: Masami Hiramatsu <mhiramat@redhat.com>
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
kprobes-sanitize-struct-kretprobe_instance-allocations.patch

