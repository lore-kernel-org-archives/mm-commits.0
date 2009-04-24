From: akpm@linux-foundation.org
Subject: + ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch added to -mm tree
Date: Thu, 23 Apr 2009 17:02:47 -0700
Message-ID: <200904240002.n3O02l1g005211@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42773 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751667AbZDXAFg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 23 Apr 2009 20:05:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: oleg@redhat.com, roland@redhat.com


The patch titled
     ptrace: mm_need_new_owner: use ->real_parent to search in the siblings
has been added to the -mm tree.  Its filename is
     ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch

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
Subject: ptrace: mm_need_new_owner: use ->real_parent to search in the siblings
From: Oleg Nesterov <oleg@redhat.com>

"Search in the siblings" should use ->real_parent, not ->parent.  If the
task is traced then ->parent == tracer, while the task's parent is always
->real_parent.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Roland McGrath <roland@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/exit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/exit.c~ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings kernel/exit.c
--- a/kernel/exit.c~ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings
+++ a/kernel/exit.c
@@ -586,7 +586,7 @@ retry:
 	/*
 	 * Search in the siblings
 	 */
-	list_for_each_entry(c, &p->parent->children, sibling) {
+	list_for_each_entry(c, &p->real_parent->children, sibling) {
 		if (c->mm == mm)
 			goto assign_new_owner;
 	}
_

Patches currently in -mm which might be from oleg@redhat.com are

slow_work_thread-should-do-the-exclusive-wait.patch
rework-fix-is_single_threaded.patch
getrusage-fill-ru_maxrss-value.patch
ptrace-remove-pt_dtrace-from-arch-h8300.patch
ptrace-remove-pt_dtrace-from-avr32-mn10300-parisc-s390-sh-xtensa.patch
ptrace-remove-pt_dtrace-from-m68k-m68knommu.patch
ptrace-remove-pt_dtrace-from-arch-m32r.patch
ptrace-mm_need_new_owner-use-real_parent-to-search-in-the-siblings.patch
ptrace-tracehook_unsafe_exec-remove-the-stale-comment.patch
signals-split-do_tkill.patch
signals-implement-sys_rt_tgsigqueueinfo.patch
x86-hookup-sys_rt_tgsigqueueinfo.patch
signals-tracehook_notify_jctl-change.patch

