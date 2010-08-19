From: akpm@linux-foundation.org
Subject: + kfifo-add-parenthesis-for-macro-parameter-reference.patch added to -mm tree
Date: Thu, 19 Aug 2010 16:49:59 -0700
Message-ID: <201008192349.o7JNnxV4015730@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47652 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751659Ab0HSXub (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 19 Aug 2010 19:50:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, stefani@seibold.net


The patch titled
     kfifo: add parenthesis for macro parameter reference
has been added to the -mm tree.  Its filename is
     kfifo-add-parenthesis-for-macro-parameter-reference.patch

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
Subject: kfifo: add parenthesis for macro parameter reference
From: Huang Ying <ying.huang@intel.com>

Some macro parameter references inside typeof() operator are not enclosed
with parenthesis.  It should be safer to add them.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   58 ++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 29 deletions(-)

diff -puN include/linux/kfifo.h~kfifo-add-parenthesis-for-macro-parameter-reference include/linux/kfifo.h
--- a/include/linux/kfifo.h~kfifo-add-parenthesis-for-macro-parameter-reference
+++ a/include/linux/kfifo.h
@@ -214,7 +214,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_reset(fifo) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	__tmp->kfifo.in = __tmp->kfifo.out = 0; \
 })
 
@@ -228,7 +228,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_reset_out(fifo)	\
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	__tmp->kfifo.out = __tmp->kfifo.in; \
 })
 
@@ -238,7 +238,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define kfifo_len(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpl = (fifo); \
+	typeof((fifo) + 1) __tmpl = (fifo); \
 	__tmpl->kfifo.in - __tmpl->kfifo.out; \
 })
 
@@ -248,7 +248,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define	kfifo_is_empty(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	__tmpq->kfifo.in == __tmpq->kfifo.out; \
 })
 
@@ -258,7 +258,7 @@ __kfifo_must_check_helper(unsigned int v
  */
 #define	kfifo_is_full(fifo) \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	kfifo_len(__tmpq) > __tmpq->kfifo.mask; \
 })
 
@@ -269,7 +269,7 @@ __kfifo_must_check_helper(unsigned int v
 #define	kfifo_avail(fifo) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmpq = (fifo); \
+	typeof((fifo) + 1) __tmpq = (fifo); \
 	const size_t __recsize = sizeof(*__tmpq->rectype); \
 	unsigned int __avail = kfifo_size(__tmpq) - kfifo_len(__tmpq); \
 	(__recsize) ? ((__avail <= __recsize) ? 0 : \
@@ -284,7 +284,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_skip(fifo) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__recsize) \
@@ -302,7 +302,7 @@ __kfifo_must_check_helper( \
 #define kfifo_peek_len(fifo) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	(!__recsize) ? kfifo_len(__tmp) * sizeof(*__tmp->type) : \
@@ -325,7 +325,7 @@ __kfifo_must_check_helper( \
 #define kfifo_alloc(fifo, size, gfp_mask) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	__is_kfifo_ptr(__tmp) ? \
 	__kfifo_alloc(__kfifo, size, sizeof(*__tmp->type), gfp_mask) : \
@@ -339,7 +339,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_free(fifo) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (__is_kfifo_ptr(__tmp)) \
 		__kfifo_free(__kfifo); \
@@ -358,7 +358,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_init(fifo, buffer, size) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	__is_kfifo_ptr(__tmp) ? \
 	__kfifo_init(__kfifo, buffer, size, sizeof(*__tmp->type)) : \
@@ -379,8 +379,8 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_put(fifo, val) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -421,8 +421,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_get(fifo, val) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -462,8 +462,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_peek(fifo, val) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(val + 1) __val = (val); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((val) + 1) __val = (val); \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -501,8 +501,8 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_in(fifo, buf, n) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -554,8 +554,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_out(fifo, buf, n) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -611,7 +611,7 @@ __kfifo_must_check_helper( \
 #define	kfifo_from_user(fifo, from, len, copied) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	const void __user *__from = (from); \
 	unsigned int __len = (len); \
 	unsigned int *__copied = (copied); \
@@ -639,7 +639,7 @@ __kfifo_must_check_helper( \
 #define	kfifo_to_user(fifo, to, len, copied) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	void __user *__to = (to); \
 	unsigned int __len = (len); \
 	unsigned int *__copied = (copied); \
@@ -666,7 +666,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_dma_in_prepare(fifo, sgl, nents, len) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	struct scatterlist *__sgl = (sgl); \
 	int __nents = (nents); \
 	unsigned int __len = (len); \
@@ -690,7 +690,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_dma_in_finish(fifo, len) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	unsigned int __len = (len); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -717,7 +717,7 @@ __kfifo_must_check_helper( \
  */
 #define	kfifo_dma_out_prepare(fifo, sgl, nents, len) \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo);  \
 	struct scatterlist *__sgl = (sgl); \
 	int __nents = (nents); \
 	unsigned int __len = (len); \
@@ -741,7 +741,7 @@ __kfifo_must_check_helper( \
  */
 #define kfifo_dma_out_finish(fifo, len) \
 (void)({ \
-	typeof(fifo + 1) __tmp = (fifo); \
+	typeof((fifo) + 1) __tmp = (fifo); \
 	unsigned int __len = (len); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
@@ -766,8 +766,8 @@ __kfifo_must_check_helper( \
 #define	kfifo_out_peek(fifo, buf, n) \
 __kfifo_must_check_helper( \
 ({ \
-	typeof(fifo + 1) __tmp = (fifo); \
-	typeof(buf + 1) __buf = (buf); \
+	typeof((fifo) + 1) __tmp = (fifo); \
+	typeof((buf) + 1) __buf = (buf); \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
_

Patches currently in -mm which might be from ying.huang@intel.com are

origin.patch
kfifo-add-parenthesis-for-macro-parameter-reference.patch

