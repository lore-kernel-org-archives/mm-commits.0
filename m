From: akpm@linux-foundation.org
Subject: +
 signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch added to -mm tree
Date: Wed, 24 Sep 2014 14:49:39 -0700
Message-ID: <54233c73.e39lcM9zZdEyBcsO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50362 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbaIXVtk (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Sep 2014 17:49:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, jeffrey.t.kirsher@intel.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: use BUILD_BUG() instead of _NSIG_WORDS_is_unsupported_size()
has been added to the -mm tree.  Its filename is
     signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Oleg Nesterov <oleg@redhat.com>
Subject: signal: use BUILD_BUG() instead of _NSIG_WORDS_is_unsupported_size()

Kill _NSIG_WORDS_is_unsupported_size(), use BUILD_BUG() instead.  This
simplifies the code, avoids the nested-externs warnings, and this way we
do not defer the problem to linker.

Also, fix the indentation in _SIG_SET_BINOP() and _SIG_SET_OP().

Note: this patch assumes that the code like "if (0) BUILD_BUG();" is
valid.  If not (say __compiletime_error() is not defined and thus
__compiletime_error_fallback() uses a negative array) we should fix
BUILD_BUG() and/or BUILD_BUG_ON_MSG().  This code should be fine by
definition, this is the documented purpose of BUILD_BUG().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |   28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff -puN include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size include/linux/signal.h
--- a/include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size
+++ a/include/linux/signal.h
@@ -67,7 +67,6 @@ static inline int sigismember(sigset_t *
 
 static inline int sigisemptyset(sigset_t *set)
 {
-	extern void _NSIG_WORDS_is_unsupported_size(void);
 	switch (_NSIG_WORDS) {
 	case 4:
 		return (set->sig[3] | set->sig[2] |
@@ -77,7 +76,7 @@ static inline int sigisemptyset(sigset_t
 	case 1:
 		return set->sig[0] == 0;
 	default:
-		_NSIG_WORDS_is_unsupported_size();
+		BUILD_BUG();
 		return 0;
 	}
 }
@@ -90,24 +89,23 @@ static inline int sigisemptyset(sigset_t
 #define _SIG_SET_BINOP(name, op)					\
 static inline void name(sigset_t *r, const sigset_t *a, const sigset_t *b) \
 {									\
-	extern void _NSIG_WORDS_is_unsupported_size(void);		\
 	unsigned long a0, a1, a2, a3, b0, b1, b2, b3;			\
 									\
 	switch (_NSIG_WORDS) {						\
-	    case 4:							\
+	case 4:								\
 		a3 = a->sig[3]; a2 = a->sig[2];				\
 		b3 = b->sig[3]; b2 = b->sig[2];				\
 		r->sig[3] = op(a3, b3);					\
 		r->sig[2] = op(a2, b2);					\
-	    case 2:							\
+	case 2:								\
 		a1 = a->sig[1]; b1 = b->sig[1];				\
 		r->sig[1] = op(a1, b1);					\
-	    case 1:							\
+	case 1:								\
 		a0 = a->sig[0]; b0 = b->sig[0];				\
 		r->sig[0] = op(a0, b0);					\
 		break;							\
-	    default:							\
-		_NSIG_WORDS_is_unsupported_size();			\
+	default:							\
+		BUILD_BUG();						\
 	}								\
 }
 
@@ -128,16 +126,14 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
 #define _SIG_SET_OP(name, op)						\
 static inline void name(sigset_t *set)					\
 {									\
-	extern void _NSIG_WORDS_is_unsupported_size(void);		\
-									\
 	switch (_NSIG_WORDS) {						\
-	    case 4: set->sig[3] = op(set->sig[3]);			\
-		    set->sig[2] = op(set->sig[2]);			\
-	    case 2: set->sig[1] = op(set->sig[1]);			\
-	    case 1: set->sig[0] = op(set->sig[0]);			\
+	case 4:	set->sig[3] = op(set->sig[3]);				\
+		set->sig[2] = op(set->sig[2]);				\
+	case 2:	set->sig[1] = op(set->sig[1]);				\
+	case 1:	set->sig[0] = op(set->sig[0]);				\
 		    break;						\
-	    default:							\
-		_NSIG_WORDS_is_unsupported_size();			\
+	default:							\
+		BUILD_BUG();						\
 	}								\
 }
 
_

Patches currently in -mm which might be from oleg@redhat.com are

fs-proc-task_mmuc-dont-use-task-mm-in-m_start-and-show_map.patch
fs-proc-task_mmuc-unify-simplify-do_maps_open-and-numa_maps_open.patch
proc-introduce-proc_mem_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_mmuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic.patch
fs-proc-task_mmuc-simplify-the-vma_stop-logic-checkpatch-fixes.patch
fs-proc-task_mmuc-cleanup-the-tail_vma-horror-in-m_next.patch
fs-proc-task_mmuc-shift-priv-task-=-null-from-m_start-to-m_stop.patch
fs-proc-task_mmuc-kill-the-suboptimal-and-confusing-m-version-logic.patch
fs-proc-task_mmuc-simplify-m_start-to-make-it-readable.patch
fs-proc-task_mmuc-introduce-m_next_vma-helper.patch
fs-proc-task_mmuc-reintroduce-m-version-logic.patch
fs-proc-task_mmuc-update-m-version-in-the-main-loop-in-m_start.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private.patch
fs-proc-task_nommuc-change-maps_open-to-use-__seq_open_private-fix.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open.patch
fs-proc-task_nommuc-shift-mm_access-from-m_start-to-proc_maps_open-checkpatch-fixes.patch
fs-proc-task_nommuc-dont-use-priv-task-mm.patch
proc-maps-replace-proc_maps_private-pid-with-struct-inode-inode.patch
proc-maps-make-vm_is_stack-logic-namespace-friendly.patch
prctl-pr_set_mm-introduce-pr_set_mm_map-operation-v4.patch
mempolicy-change-alloc_pages_vma-to-use-mpol_cond_put.patch
mempolicy-change-get_task_policy-to-return-default_policy-rather-than-null.patch
mempolicy-sanitize-the-usage-of-get_task_policy.patch
mempolicy-remove-the-task-arg-of-vma_policy_mof-and-simplify-it.patch
mempolicy-introduce-__get_vma_policy-export-get_task_policy.patch
mempolicy-fix-show_numa_map-vs-exec-do_set_mempolicy-race.patch
mempolicy-kill-do_set_mempolicy-down_writemm-mmap_sem.patch
mempolicy-unexport-get_vma_policy-and-remove-its-task-arg.patch
signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
coredump-add-%i-%i-in-core_pattern-to-report-the-tid-of-the-crashed-thread.patch
ipc-shm-kill-the-historical-wrong-mm-start_stack-check.patch
linux-next.patch

