From: akpm@linux-foundation.org
Subject: [merged] asm-generic-atomich-simplify-inc-dec-test-helpers.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:30:02 -0700
Message-ID: <201107271928.p6RJSmfm003338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37147 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755052Ab1G0T3J (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, asharma@fb.com, mm-commits@vger.kernel.org


The patch titled
     asm-generic/atomic.h: simplify inc/dec test helpers
has been removed from the -mm tree.  Its filename was
     asm-generic-atomich-simplify-inc-dec-test-helpers.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch
linux-next.patch

