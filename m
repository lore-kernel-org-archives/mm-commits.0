From: akpm@linux-foundation.org
Subject: + ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch added to -mm tree
Date: Wed, 23 Jan 2008 13:25:58 -0800
Message-ID: <200801232125.m0NLPoFl027177@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41758 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814AbYAWV0a (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Jan 2008 16:26:30 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mhiramat@redhat.com, shaohua.li@intel.com, tony.luck@intel.com


The patch titled
     ia64: fix the order of atomic operations in restore_previous_kprobes()
has been added to the -mm tree.  Its filename is
     ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ia64: fix the order of atomic operations in restore_previous_kprobes()
From: Masami Hiramatsu <mhiramat@redhat.com>

Fix the order of atomic operations to prevent overwriting prev_kprobe[0]. 
To pop values from stack, we must decrement stack index right AFTER reading
values.

Details of this issue was reported to
http://sources.redhat.com/bugzilla/show_bug.cgi?id=2071

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Acked-by: Shaohua Li <shaohua.li@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/kprobes.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN arch/ia64/kernel/kprobes.c~ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes arch/ia64/kernel/kprobes.c
--- a/arch/ia64/kernel/kprobes.c~ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes
+++ a/arch/ia64/kernel/kprobes.c
@@ -381,9 +381,10 @@ static void __kprobes save_previous_kpro
 static void __kprobes restore_previous_kprobe(struct kprobe_ctlblk *kcb)
 {
 	unsigned int i;
-	i = atomic_sub_return(1, &kcb->prev_kprobe_index);
-	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i].kp;
-	kcb->kprobe_status = kcb->prev_kprobe[i].status;
+	i = atomic_read(&kcb->prev_kprobe_index);
+	__get_cpu_var(current_kprobe) = kcb->prev_kprobe[i-1].kp;
+	kcb->kprobe_status = kcb->prev_kprobe[i-1].status;
+	atomic_sub(1, &kcb->prev_kprobe_index);
 }
 
 static void __kprobes set_current_kprobe(struct kprobe *p,
_

Patches currently in -mm which might be from mhiramat@redhat.com are

ia64-fix-the-order-of-atomic-operations-in-restore_previous_kprobes.patch
git-x86.patch
