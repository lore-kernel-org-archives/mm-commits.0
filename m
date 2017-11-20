From: akpm@linux-foundation.org
Subject: + lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch
 added to -mm tree
Date: Mon, 20 Nov 2017 15:58:52 -0800
Message-ID: <5a136c3c./0XuY2ORKjYFfpeR%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53036 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751616AbdKTX6x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 18:58:53 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, aryabinin@virtuozzo.com, dvyukov@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lib/stackdepot.c: use a non-instrumented version of memcmp()
has been added to the -mm tree.  Its filename is
     lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Alexander Potapenko <glider@google.com>
Subject: lib/stackdepot.c: use a non-instrumented version of memcmp()

stackdepot used to call memcmp(), which compiler tools normally
instrument, therefore every lookup used to unnecessarily call instrumented
code.  This is somewhat ok in the case of KASAN, but under KMSAN a lot of
time was spent in the instrumentation.

Link: http://lkml.kernel.org/r/20171117172149.69562-1-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/stackdepot.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff -puN lib/stackdepot.c~lib-stackdepot-use-a-non-instrumented-version-of-memcmp lib/stackdepot.c
--- a/lib/stackdepot.c~lib-stackdepot-use-a-non-instrumented-version-of-memcmp
+++ a/lib/stackdepot.c
@@ -163,6 +163,21 @@ static inline u32 hash_stack(unsigned lo
 			       STACK_HASH_SEED);
 }
 
+/* Use our own, non-instrumented version of memcmp().
+ *
+ * We actually don't care about the order, just the equality.
+ */
+static inline
+int stackdepot_memcmp(const unsigned long *u1, const unsigned long *u2,
+			unsigned int n)
+{
+	for ( ; n-- ; u1++, u2++) {
+		if (*u1 != *u2)
+			return 1;
+	}
+	return 0;
+}
+
 /* Find a stack that is equal to the one stored in entries in the hash */
 static inline struct stack_record *find_stack(struct stack_record *bucket,
 					     unsigned long *entries, int size,
@@ -173,10 +188,8 @@ static inline struct stack_record *find_
 	for (found = bucket; found; found = found->next) {
 		if (found->hash == hash &&
 		    found->size == size &&
-		    !memcmp(entries, found->entries,
-			    size * sizeof(unsigned long))) {
+		    !stackdepot_memcmp(entries, found->entries, size))
 			return found;
-		}
 	}
 	return NULL;
 }
_

Patches currently in -mm which might be from glider@google.com are

lib-stackdepot-use-a-non-instrumented-version-of-memcmp.patch

