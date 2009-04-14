From: akpm@linux-foundation.org
Subject: [merged] ptrace-fix-exit_ptrace-vs-ptrace_traceme-race.patch removed from -mm tree
Date: Tue, 14 Apr 2009 12:49:35 -0700
Message-ID: <200904141949.n3EJnZA6019732@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55709 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753924AbZDNTwc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 14 Apr 2009 15:52:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, roland@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ptrace: fix exit_ptrace() vs ptrace_traceme() race
has been removed from the -mm tree.  Its filename was
     ptrace-fix-exit_ptrace-vs-ptrace_traceme-race.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ptrace: fix exit_ptrace() vs ptrace_traceme() race
From: Oleg Nesterov <oleg@redhat.com>

Pointed out by Roland.  The bug was recently introduced by me in
"forget_original_parent: split out the un-ptrace part", commit
39c626ae47c469abdfd30c6e42eff884931380d6.

Since that patch we have a window after exit_ptrace() drops tasklist and
before forget_original_parent() takes it again.  In this window the child
can do ptrace(PTRACE_TRACEME) and nobody can untrace this child after
that.

Change ptrace_traceme() to not attach to the exiting ->real_parent.  We
don't report the error in this case, we pretend we attach right before
->real_parent calls exit_ptrace() which should untrace us anyway.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/ptrace.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN kernel/ptrace.c~ptrace-fix-exit_ptrace-vs-ptrace_traceme-race kernel/ptrace.c
--- a/kernel/ptrace.c~ptrace-fix-exit_ptrace-vs-ptrace_traceme-race
+++ a/kernel/ptrace.c
@@ -604,10 +604,11 @@ repeat:
 		ret = security_ptrace_traceme(current->parent);
 
 		/*
-		 * Set the ptrace bit in the process ptrace flags.
-		 * Then link us on our parent's ptraced list.
+		 * Check PF_EXITING to ensure ->real_parent has not passed
+		 * exit_ptrace(). Otherwise we don't report the error but
+		 * pretend ->real_parent untraces us right after return.
 		 */
-		if (!ret) {
+		if (!ret && !(current->real_parent->flags & PF_EXITING)) {
 			current->ptrace |= PT_PTRACED;
 			__ptrace_link(current, current->real_parent);
 		}
_

Patches currently in -mm which might be from oleg@redhat.com are

origin.patch
getrusage-fill-ru_maxrss-value.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

