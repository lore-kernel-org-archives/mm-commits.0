From: akpm@linux-foundation.org
Subject: + include-linux-provide-a-safe-version-of-container_of.patch
 added to -mm tree
Date: Mon, 26 Sep 2016 16:37:04 -0700
Message-ID: <57e9b120.S5i8o8hG6vBjPy3K%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47308 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932504AbcIZXhF (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 26 Sep 2016 19:37:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: glider@google.com, dvyukov@google.com, edumazet@google.com, kcc@google.com, mingo@elte.hu, mm-commits@vger.kernel.org


The patch titled
     Subject: include/linux: provide a safe version of container_of()
has been added to the -mm tree.  Its filename is
     include-linux-provide-a-safe-version-of-container_of.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-linux-provide-a-safe-version-of-container_of.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-linux-provide-a-safe-version-of-container_of.patch

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
Subject: include/linux: provide a safe version of container_of()

Patch series "Clang: avoid undefined behavior in llist iterators":

This patchset fixes problems with pointer arithmetics overflow in llist
iterators, llist_for_each_entry() and llist_for_each_entry_safe().  Clang
turns those macros into infinite loops, because they're operating with
"negative" pointers.

As a follow-up it may make sense to convert other uses of llist_entry() to
llist_entry_safe(), or even replace uses of container_of() with
container_of_safe().


This patch (of 2):

Some code relies on "negative" (i.e.  too big) pointer values being
returned by container_of() when its first argument is NULL.  But doing so
breaks the compiler's assumptions that pointer arithmetic never overflows.

container_of_safe() checks its arguments and returns NULL in the case the
member offset within the container is greater than the pointer to the
member, otherwise it returns the result of container_of().

Link: http://lkml.kernel.org/r/1474636978-41435-2-git-send-email-glider@google.com
Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff -puN include/linux/kernel.h~include-linux-provide-a-safe-version-of-container_of include/linux/kernel.h
--- a/include/linux/kernel.h~include-linux-provide-a-safe-version-of-container_of
+++ a/include/linux/kernel.h
@@ -839,6 +839,21 @@ static inline void ftrace_dump(enum ftra
 	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
 	(type *)( (char *)__mptr - offsetof(type,member) );})
 
+/**
+ * container_of_safe - safe version of container_of
+ * @ptr:	the pointer to the member.
+ * @type:	the type of the container struct this is embedded in.
+ * @member:	the name of the member within the struct.
+ *
+ * In the case the value of @ptr is smaller than the offset of @member within
+ * @type, return 0.
+ */
+#define container_of_safe(ptr, type, member) ({			\
+	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
+        (size_t)__mptr >= offsetof(type,member) ?		\
+	(type *)( (char *)__mptr - offsetof(type,member) ) : (type *)0 ;})
+
+
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
 # define REBUILD_DUE_TO_FTRACE_MCOUNT_RECORD
_

Patches currently in -mm which might be from glider@google.com are

include-linux-provide-a-safe-version-of-container_of.patch
llist-introduce-llist_entry_safe.patch
kcov-do-not-instrument-lib-stackdepotc.patch

