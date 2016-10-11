From: akpm@linux-foundation.org
Subject: [patch 013/102] include/linux: provide a safe version of
 container_of()
Date: Tue, 11 Oct 2016 13:51:38 -0700
Message-ID: <57fd50da.RG8enyPS5lOmBaK1%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:37892 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752514AbcJKUwf (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 11 Oct 2016 16:52:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, glider@google.com, dvyukov@google.com, edumazet@google.com, kcc@google.com, mingo@elte.hu

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
@@ -836,6 +836,21 @@ static inline void ftrace_dump(enum ftra
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
