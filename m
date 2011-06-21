From: akpm@linux-foundation.org
Subject: + asm-generic-atomich-simplify-inc-dec-test-helpers.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:57:36 -0700
Message-ID: <201106212257.p5LMva11029776@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60576 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab1FUW5l (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:57:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: vapier@gentoo.org, asharma@fb.com


The patch titled
     asm-generic/atomic.h: simplify inc/dec test helpers
has been added to the -mm tree.  Its filename is
     asm-generic-atomich-simplify-inc-dec-test-helpers.patch

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
Subject: asm-generic/atomic.h: simplify inc/dec test helpers
From: Mike Frysinger <vapier@gentoo.org>

We already declared inc/dec helpers, so we don't need to call the
atomic_{add,sub}_return funcs directly.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Cc: Arun Sharma <asharma@fb.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/atomic.h~asm-generic-atomich-simplify-inc-dec-test-helpers include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~asm-generic-atomich-simplify-inc-dec-test-helpers
+++ a/include/asm-generic/atomic.h
@@ -119,8 +119,8 @@ static inline void atomic_dec(atomic_t *
 #define atomic_inc_return(v)		atomic_add_return(1, (v))
 
 #define atomic_sub_and_test(i, v)	(atomic_sub_return((i), (v)) == 0)
-#define atomic_dec_and_test(v)		(atomic_sub_return(1, (v)) == 0)
-#define atomic_inc_and_test(v)		(atomic_add_return(1, (v)) == 0)
+#define atomic_dec_and_test(v)		(atomic_dec_return(v) == 0)
+#define atomic_inc_and_test(v)		(atomic_inc_return(v) == 0)
 
 #define atomic_xchg(ptr, v)		(xchg(&(ptr)->counter, (v)))
 #define atomic_cmpxchg(v, old, new)	(cmpxchg(&((v)->counter), (old), (new)))
_

Patches currently in -mm which might be from vapier@gentoo.org are

mm-nommuc-fix-remap_pfn_range.patch
linux-next.patch
asm-generic-systemh-drop-useless-__kernel__.patch
ptrace-unify-show_regs-prototype.patch
ptrace-unify-show_regs-prototype-fix.patch
atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch
asm-generic-atomich-simplify-inc-dec-test-helpers.patch

