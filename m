From: akpm@linux-foundation.org
Subject: + kfifo-fix-kfifo_alloc-to-return-a-signed-int-value.patch added to -mm tree
Date: Wed, 20 Oct 2010 14:22:55 -0700
Message-ID: <201010202122.o9KLMt49005095@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165Ab0JTVXJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 20 Oct 2010 17:23:09 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: stefani@seibold.net, randy.dunlap@oracle.com


The patch titled
     kfifo: fix kfifo_alloc() to return a signed int value
has been added to the -mm tree.  Its filename is
     kfifo-fix-kfifo_alloc-to-return-a-signed-int-value.patch

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
Subject: kfifo: fix kfifo_alloc() to return a signed int value
From: Stefani Seibold <stefani@seibold.net>

Add a new __kfifo_int_must_check_helper() helper function, which is needed
for kfifo_alloc() to return the right signed integer value.

The origin __kfifo_must_check_helper() helper was renamed into
__kfifo_uint_must_check_helper() to show the sign which is expected and
returned.

(And revert the temporary disabling of __kfifo_must_check_helper())

Signed-off-by: Stefani Seibold <stefani@seibold.net>
Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-fix-kfifo_alloc-to-return-a-signed-int-value include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-fix-kfifo_alloc-to-return-a-signed-int-value
+++ a/include/linux/kfifo.h
@@ -171,8 +171,17 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
 	}
 
 
-/* __kfifo_must_check_helper() is temporarily disabled because it was faulty */
-#define __kfifo_must_check_helper(x) (x)
+static inline unsigned int __must_check
+__kfifo_uint_must_check_helper(unsigned int val)
+{
+	return val;
+}
+
+static inline int __must_check
+__kfifo_int_must_check_helper(int val)
+{
+	return val;
+}
 
 /**
  * kfifo_initialized - Check if the fifo is initialized
@@ -264,7 +273,7 @@ struct kfifo_rec_ptr_2 __STRUCT_KFIFO_PT
  * @fifo: address of the fifo to be used
  */
 #define	kfifo_avail(fifo) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmpq = (fifo); \
 	const size_t __recsize = sizeof(*__tmpq->rectype); \
@@ -297,7 +306,7 @@ __kfifo_must_check_helper( \
  * This function returns the size of the next fifo record in number of bytes.
  */
 #define kfifo_peek_len(fifo) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
@@ -320,7 +329,7 @@ __kfifo_must_check_helper( \
  * Return 0 if no error, otherwise an error code.
  */
 #define kfifo_alloc(fifo, size, gfp_mask) \
-__kfifo_must_check_helper( \
+__kfifo_int_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -416,7 +425,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_get(fifo, val) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	typeof((val) + 1) __val = (val); \
@@ -457,7 +466,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_peek(fifo, val) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	typeof((val) + 1) __val = (val); \
@@ -549,7 +558,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_out(fifo, buf, n) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	typeof((buf) + 1) __buf = (buf); \
@@ -577,7 +586,7 @@ __kfifo_must_check_helper( \
  * copied.
  */
 #define	kfifo_out_spinlocked(fifo, buf, n, lock) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	unsigned long __flags; \
 	unsigned int __ret; \
@@ -606,7 +615,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_from_user(fifo, from, len, copied) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	const void __user *__from = (from); \
@@ -634,7 +643,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_to_user(fifo, to, len, copied) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
@@ -761,7 +770,7 @@ __kfifo_must_check_helper( \
  * writer, you don't need extra locking to use these macro.
  */
 #define	kfifo_out_peek(fifo, buf, n) \
-__kfifo_must_check_helper( \
+__kfifo_uint_must_check_helper( \
 ({ \
 	typeof((fifo) + 1) __tmp = (fifo); \
 	typeof((buf) + 1) __buf = (buf); \
_

Patches currently in -mm which might be from stefani@seibold.net are

kfifo-disable-__kfifo_must_check_helper.patch
kfifo-fix-kfifo_alloc-to-return-a-signed-int-value.patch

