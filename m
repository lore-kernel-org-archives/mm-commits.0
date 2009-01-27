From: akpm@linux-foundation.org
Subject: + get_mm_hiwater_xxx-trivial-s-define-inline.patch added to -mm tree
Date: Mon, 26 Jan 2009 19:41:02 -0800
Message-ID: <200901270341.n0R3f2H6008929@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41371 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751497AbZA0Dl1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 26 Jan 2009 22:41:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, hugh@veritas.com, kosaki.motohiro@jp.fujitsu.com


The patch titled
     get_mm_hiwater_xxx: trivial, s/define/inline/
has been added to the -mm tree.  Its filename is
     get_mm_hiwater_xxx-trivial-s-define-inline.patch

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
Subject: get_mm_hiwater_xxx: trivial, s/define/inline/
From: Oleg Nesterov <oleg@redhat.com>

Andrew pointed out get_mm_hiwater_xxx() evaluate "mm" argument thrice/twice,
make them inline.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/sched.h |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff -puN include/linux/sched.h~get_mm_hiwater_xxx-trivial-s-define-inline include/linux/sched.h
--- a/include/linux/sched.h~get_mm_hiwater_xxx-trivial-s-define-inline
+++ a/include/linux/sched.h
@@ -397,8 +397,15 @@ extern void arch_unmap_area_topdown(stru
 		(mm)->hiwater_vm = (mm)->total_vm;	\
 } while (0)
 
-#define get_mm_hiwater_rss(mm)	max((mm)->hiwater_rss, get_mm_rss(mm))
-#define get_mm_hiwater_vm(mm)	max((mm)->hiwater_vm, (mm)->total_vm)
+static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
+{
+	return max(mm->hiwater_rss, get_mm_rss(mm));
+}
+
+static inline unsigned long get_mm_hiwater_vm(struct mm_struct *mm)
+{
+	return max(mm->hiwater_vm, mm->total_vm);
+}
 
 extern void set_dumpable(struct mm_struct *mm, int value);
 extern int get_dumpable(struct mm_struct *mm);
_

Patches currently in -mm which might be from oleg@redhat.com are

linux-next.patch
pipe_rdwr_fasync-fix-the-error-handling-to-prevent-the-leak-crash.patch
get_mm_hiwater_xxx-trivial-s-define-inline.patch
getrusage-fill-ru_maxrss-value.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu.patch
pids-document-task_pgrp-task_session-is-not-safe-without-tasklist-rcu-fix.patch
pids-improve-get_task_pid-to-fix-the-unsafe-sys_wait4-task_pgrp.patch
pids-refactor-vnr-nr_ns-helpers-to-make-them-safe.patch

