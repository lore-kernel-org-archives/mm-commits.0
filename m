From: akpm@linux-foundation.org
Subject: [merged]
 signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch
 removed from -mm tree
Date: Tue, 14 Oct 2014 11:21:14 -0700
Message-ID: <543d699a.fkBNZxc5QJbj5bVG%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44387 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840AbaJNSVN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:21:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: oleg@redhat.com, jeffrey.t.kirsher@intel.com, josh@joshtriplett.org, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     Subject: signal: use BUILD_BUG() instead of _NSIG_WORDS_is_unsupported_size()
has been removed from the -mm tree.  Its filename was
     signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

[sfr@canb.auug.org.au: fix powerpc build failures]
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reported-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/signal.h |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

diff -puN include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size include/linux/signal.h
--- a/include/linux/signal.h~signal-use-build_bug-instead-of-_nsig_words_is_unsupported_size
+++ a/include/linux/signal.h
@@ -2,6 +2,7 @@
 #define _LINUX_SIGNAL_H
 
 #include <linux/list.h>
+#include <linux/bug.h>
 #include <uapi/linux/signal.h>
 
 struct task_struct;
@@ -67,7 +68,6 @@ static inline int sigismember(sigset_t *
 
 static inline int sigisemptyset(sigset_t *set)
 {
-	extern void _NSIG_WORDS_is_unsupported_size(void);
 	switch (_NSIG_WORDS) {
 	case 4:
 		return (set->sig[3] | set->sig[2] |
@@ -77,7 +77,7 @@ static inline int sigisemptyset(sigset_t
 	case 1:
 		return set->sig[0] == 0;
 	default:
-		_NSIG_WORDS_is_unsupported_size();
+		BUILD_BUG();
 		return 0;
 	}
 }
@@ -90,24 +90,23 @@ static inline int sigisemptyset(sigset_t
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
 
@@ -128,16 +127,14 @@ _SIG_SET_BINOP(sigandnsets, _sig_andn)
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

origin.patch
linux-next.patch

