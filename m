From: akpm@linux-foundation.org
Subject: + include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck.patch added to -mm tree
Date: Wed, 24 Oct 2012 12:33:58 -0700
Message-ID: <20121024193359.2E8585C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-wg0-f74.google.com ([74.125.82.74]:57172 "EHLO
	mail-wg0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757474Ab2JXTeC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 24 Oct 2012 15:34:02 -0400
Received: by mail-wg0-f74.google.com with SMTP id dt11so58985wgb.1
        for <mm-commits@vger.kernel.org>; Wed, 24 Oct 2012 12:34:00 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: weiyang@linux.vnet.ibm.com, jkosina@suse.cz, richard.weinberger@gmail.com, stefani@seibold.net


The patch titled
     Subject: include/linux/kfifo.h: replace open-coded type check code with typecheck()
has been added to the -mm tree.  Its filename is
     include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Wei Yang <weiyang@linux.vnet.ibm.com>
Subject: include/linux/kfifo.h: replace open-coded type check code with typecheck()

In the kfifo macros, one piece of code which is arounded by if(0) will
check the type of __tmp->ptr_const and __buf.  If they are of different
types a compilation warning is generated..  This piece of code is not self
explaining and a little bit hard to understand.

Based on Andrew Morton's suggestion, replace this with typecheck() which
will be easy to understand.

Signed-off-by: Wei Yang <weiyang@linux.vnet.ibm.com>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>
Acked-by: Stefani Seibold <stefani@seibold.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kfifo.h |   22 +++++-----------------
 1 file changed, 5 insertions(+), 17 deletions(-)

diff -puN include/linux/kfifo.h~include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck include/linux/kfifo.h
--- a/include/linux/kfifo.h~include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck
+++ a/include/linux/kfifo.h
@@ -390,10 +390,7 @@ __kfifo_int_must_check_helper( \
 	unsigned int __ret; \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__val))NULL; \
-	} \
+	typecheck(typeof(__tmp->ptr_const), __val); \
 	if (__recsize) \
 		__ret = __kfifo_in_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -433,7 +430,7 @@ __kfifo_uint_must_check_helper( \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
 	if (0) \
-		__val = (typeof(__tmp->ptr))0; \
+		__val = (typeof(__tmp->ptr))NULL; \
 	if (__recsize) \
 		__ret = __kfifo_out_r(__kfifo, __val, sizeof(*__val), \
 			__recsize); \
@@ -512,10 +509,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr_const) __dummy __attribute__ ((unused)); \
-		__dummy = (typeof(__buf))NULL; \
-	} \
+	typecheck(typeof(__tmp->ptr_const), __buf);\
 	(__recsize) ?\
 	__kfifo_in_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_in(__kfifo, __buf, __n); \
@@ -565,10 +559,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy = NULL; \
-		__buf = __dummy; \
-	} \
+	typecheck(typeof(__tmp->ptr), __buf); \
 	(__recsize) ?\
 	__kfifo_out_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out(__kfifo, __buf, __n); \
@@ -777,10 +768,7 @@ __kfifo_uint_must_check_helper( \
 	unsigned long __n = (n); \
 	const size_t __recsize = sizeof(*__tmp->rectype); \
 	struct __kfifo *__kfifo = &__tmp->kfifo; \
-	if (0) { \
-		typeof(__tmp->ptr) __dummy __attribute__ ((unused)) = NULL; \
-		__buf = __dummy; \
-	} \
+	typecheck(typeof(__tmp->ptr), __buf); \
 	(__recsize) ? \
 	__kfifo_out_peek_r(__kfifo, __buf, __n, __recsize) : \
 	__kfifo_out_peek(__kfifo, __buf, __n); \
_

Patches currently in -mm which might be from weiyang@linux.vnet.ibm.com are

include-linux-kfifoh-replace-open-coded-type-check-code-with-typecheck.patch

