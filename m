From: akpm@linux-foundation.org
Subject: [to-be-updated] atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive.patch removed from -mm tree
Date: Tue, 12 Mar 2013 13:22:11 -0700
Message-ID: <20130312202212.4443931C297@corp2gmr1-1.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f73.google.com ([209.85.212.73]:63325 "EHLO
	mail-vb0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755508Ab3CLUWN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Mar 2013 16:22:13 -0400
Received: by mail-vb0-f73.google.com with SMTP id fj18so23544vbb.0
        for <mm-commits@vger.kernel.org>; Tue, 12 Mar 2013 13:22:12 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: tom.leiming@gmail.com, shli@kernel.org, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive
has been removed from the -mm tree.  Its filename was
     atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive.patch

This patch was dropped because an updated version will be merged

------------------------------------------------------
From: Ming Lei <tom.leiming@gmail.com>
Subject: atomic: improve atomic_inc_unless_negative/atomic_dec_unless_positive

Generally, both atomic_inc_unless_negative() and
atomic_dec_unless_positive() need at least two atomic_cmpxchg() to
complete the atomic operation.  In fact, the 1st atomic_cmpxchg() is just
used to read current value of the atomic variable at most times.

Considered memory barrier, bus lock, cache walking, etc.  things may be
involved in atomic_cmpxchg(), it is much expensive than atomic_read(),
which is just the simple below:

	(*(volatile int *)&(v)->counter)

so this patch can save one extra atomic_cmpxchg() for the two helpers
under general situation, and should improve them a bit.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/atomic.h |   28 ++++++++++++++++++----------
 1 file changed, 18 insertions(+), 10 deletions(-)

diff -puN include/linux/atomic.h~atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-improve-atomic_inc_unless_negative-atomic_dec_unless_positive
+++ a/include/linux/atomic.h
@@ -63,26 +63,34 @@ static inline int atomic_inc_not_zero_hi
 #ifndef atomic_inc_unless_negative
 static inline int atomic_inc_unless_negative(atomic_t *p)
 {
-	int v, v1;
-	for (v = 0; v >= 0; v = v1) {
-		v1 = atomic_cmpxchg(p, v, v + 1);
-		if (likely(v1 == v))
+	int v, t;
+
+	v = atomic_read(p);
+	while (1) {
+		if (unlikely(v < 0))
+			return 0;
+		t = atomic_cmpxchg(p, v, v + 1);
+		if (likely(t == v))
 			return 1;
+		v = t;
 	}
-	return 0;
 }
 #endif
 
 #ifndef atomic_dec_unless_positive
 static inline int atomic_dec_unless_positive(atomic_t *p)
 {
-	int v, v1;
-	for (v = 0; v <= 0; v = v1) {
-		v1 = atomic_cmpxchg(p, v, v - 1);
-		if (likely(v1 == v))
+	int v, t;
+
+	v = atomic_read(p);
+	while (1) {
+		if (unlikely(v > 0))
+			return 0;
+		t = atomic_cmpxchg(p, v, v - 1);
+		if (likely(t == v))
 			return 1;
+		v = t;
 	}
-	return 0;
 }
 #endif
 
_

Patches currently in -mm which might be from tom.leiming@gmail.com are


