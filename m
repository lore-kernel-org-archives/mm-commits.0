From: akpm@linux-foundation.org
Subject: + linux-kernelh-add-correct-kernel-doc-notation.patch added to
 -mm tree
Date: Wed, 04 Oct 2017 15:33:27 -0700
Message-ID: <59d561b7.wtpKEbwPP+DlF7zc%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44774 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750951AbdJDWd2 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 18:33:28 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdunlap@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/kernel.h: add/correct kernel-doc notation
has been added to the -mm tree.  Its filename is
     linux-kernelh-add-correct-kernel-doc-notation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/linux-kernelh-add-correct-kernel-doc-notation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/linux-kernelh-add-correct-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: linux/kernel.h: add/correct kernel-doc notation

Add kernel-doc notation for some macros.  Correct kernel-doc comments &
typos for a few macros.

Link: http://lkml.kernel.org/r/76fa1403-1511-be4c-e9c4-456b43edfad3@infradead.org
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   90 ++++++++++++++++++++++++++++++++-------
 1 file changed, 74 insertions(+), 16 deletions(-)

diff -puN include/linux/kernel.h~linux-kernelh-add-correct-kernel-doc-notation include/linux/kernel.h
--- a/include/linux/kernel.h~linux-kernelh-add-correct-kernel-doc-notation
+++ a/include/linux/kernel.h
@@ -44,6 +44,12 @@
 
 #define STACK_MAGIC	0xdeadbeef
 
+/**
+ * REPEAT_BYTE - repeat the value @x multiple times as an unsigned long value
+ * @x: value to repeat
+ *
+ * NOTE: @x is not checked for > 0xff; larger values produce odd results.
+ */
 #define REPEAT_BYTE(x)	((~0ul / 0xff) * (x))
 
 /* @a is a power of 2 value */
@@ -57,6 +63,10 @@
 #define READ			0
 #define WRITE			1
 
+/**
+ * ARRAY_SIZE - get the number of elements in array @arr
+ * @arr: array to be sized
+ */
 #define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]) + __must_be_array(arr))
 
 #define u64_to_user_ptr(x) (		\
@@ -76,7 +86,15 @@
 #define round_up(x, y) ((((x)-1) | __round_mask(x, y))+1)
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+/**
+ * FIELD_SIZEOF - get the size of a struct's field
+ * @t: the target struct
+ * @f: the target struct's field
+ * Return: the size of @f in the struct definition without having a
+ * declared instance of @t.
+ */
 #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
+
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
 
 #define DIV_ROUND_DOWN_ULL(ll, d) \
@@ -107,7 +125,7 @@
 /*
  * Divide positive or negative dividend by positive or negative divisor
  * and round to closest integer. Result is undefined for negative
- * divisors if he dividend variable type is unsigned and for negative
+ * divisors if the dividend variable type is unsigned and for negative
  * dividends if the divisor variable type is unsigned.
  */
 #define DIV_ROUND_CLOSEST(x, divisor)(			\
@@ -247,13 +265,13 @@ extern int _cond_resched(void);
  * @ep_ro: right open interval endpoint
  *
  * Perform a "reciprocal multiplication" in order to "scale" a value into
- * range [0, ep_ro), where the upper interval endpoint is right-open.
+ * range [0, @ep_ro), where the upper interval endpoint is right-open.
  * This is useful, e.g. for accessing a index of an array containing
- * ep_ro elements, for example. Think of it as sort of modulus, only that
+ * @ep_ro elements, for example. Think of it as sort of modulus, only that
  * the result isn't that of modulo. ;) Note that if initial input is a
  * small value, then result will return 0.
  *
- * Return: a result based on val in interval [0, ep_ro).
+ * Return: a result based on @val in interval [0, @ep_ro).
  */
 static inline u32 reciprocal_scale(u32 val, u32 ep_ro)
 {
@@ -618,8 +636,8 @@ do {									\
  * trace_printk - printf formatting in the ftrace buffer
  * @fmt: the printf format for printing
  *
- * Note: __trace_printk is an internal function for trace_printk and
- *       the @ip is passed in via the trace_printk macro.
+ * Note: __trace_printk is an internal function for trace_printk() and
+ *       the @ip is passed in via the trace_printk() macro.
  *
  * This function allows a kernel developer to debug fast path sections
  * that printk is not appropriate for. By scattering in various
@@ -629,7 +647,7 @@ do {									\
  * This is intended as a debugging tool for the developer only.
  * Please refrain from leaving trace_printks scattered around in
  * your code. (Extra memory is used for special buffers that are
- * allocated when trace_printk() is used)
+ * allocated when trace_printk() is used.)
  *
  * A little optization trick is done here. If there's only one
  * argument, there's no need to scan the string for printf formats.
@@ -681,7 +699,7 @@ int __trace_printk(unsigned long ip, con
  *       the @ip is passed in via the trace_puts macro.
  *
  * This is similar to trace_printk() but is made for those really fast
- * paths that a developer wants the least amount of "Heisenbug" affects,
+ * paths that a developer wants the least amount of "Heisenbug" effects,
  * where the processing of the print format is still too much.
  *
  * This function allows a kernel developer to debug fast path sections
@@ -692,7 +710,7 @@ int __trace_printk(unsigned long ip, con
  * This is intended as a debugging tool for the developer only.
  * Please refrain from leaving trace_puts scattered around in
  * your code. (Extra memory is used for special buffers that are
- * allocated when trace_puts() is used)
+ * allocated when trace_puts() is used.)
  *
  * Returns: 0 if nothing was written, positive # if string was.
  *  (1 when __trace_bputs is used, strlen(str) when __trace_puts is used)
@@ -771,6 +789,12 @@ static inline void ftrace_dump(enum ftra
 	t2 min2 = (y);					\
 	(void) (&min1 == &min2);			\
 	min1 < min2 ? min1 : min2; })
+
+/**
+ * min - return minimum of two values of the same or compatible types
+ * @x: first value
+ * @y: second value
+ */
 #define min(x, y)					\
 	__min(typeof(x), typeof(y),			\
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),	\
@@ -781,12 +805,31 @@ static inline void ftrace_dump(enum ftra
 	t2 max2 = (y);					\
 	(void) (&max1 == &max2);			\
 	max1 > max2 ? max1 : max2; })
+
+/**
+ * max - return maximum of two values of the same or compatible types
+ * @x: first value
+ * @y: second value
+ */
 #define max(x, y)					\
 	__max(typeof(x), typeof(y),			\
 	      __UNIQUE_ID(max1_), __UNIQUE_ID(max2_),	\
 	      x, y)
 
+/**
+ * min3 - return minimum of three values
+ * @x: first value
+ * @y: second value
+ * @z: third value
+ */
 #define min3(x, y, z) min((typeof(x))min(x, y), z)
+
+/**
+ * max3 - return maximum of three values
+ * @x: first value
+ * @y: second value
+ * @z: third value
+ */
 #define max3(x, y, z) max((typeof(x))max(x, y), z)
 
 /**
@@ -805,8 +848,8 @@ static inline void ftrace_dump(enum ftra
  * @lo: lowest allowable value
  * @hi: highest allowable value
  *
- * This macro does strict typechecking of lo/hi to make sure they are of the
- * same type as val.  See the unnecessary pointer comparisons.
+ * This macro does strict typechecking of @lo/@hi to make sure they are of the
+ * same type as @val.  See the unnecessary pointer comparisons.
  */
 #define clamp(val, lo, hi) min((typeof(val))max(val, lo), hi)
 
@@ -816,11 +859,24 @@ static inline void ftrace_dump(enum ftra
  *
  * Or not use min/max/clamp at all, of course.
  */
+
+/**
+ * min_t - return minimum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
 #define min_t(type, x, y)				\
 	__min(type, type,				\
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),	\
 	      x, y)
 
+/**
+ * max_t - return maximum of two values, using the specified type
+ * @type: data type to use
+ * @x: first value
+ * @y: second value
+ */
 #define max_t(type, x, y)				\
 	__max(type, type,				\
 	      __UNIQUE_ID(min1_), __UNIQUE_ID(min2_),	\
@@ -834,7 +890,7 @@ static inline void ftrace_dump(enum ftra
  * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of type
- * 'type' to make all the comparisons.
+ * @type to make all the comparisons.
  */
 #define clamp_t(type, val, lo, hi) min_t(type, max_t(type, val, lo), hi)
 
@@ -845,15 +901,17 @@ static inline void ftrace_dump(enum ftra
  * @hi: maximum allowable value
  *
  * This macro does no typechecking and uses temporary variables of whatever
- * type the input argument 'val' is.  This is useful when val is an unsigned
- * type and min and max are literals that will otherwise be assigned a signed
+ * type the input argument @val is.  This is useful when @val is an unsigned
+ * type and @lo and @hi are literals that will otherwise be assigned a signed
  * integer type.
  */
 #define clamp_val(val, lo, hi) clamp_t(typeof(val), val, lo, hi)
 
 
-/*
- * swap - swap value of @a and @b
+/**
+ * swap - swap values of @a and @b
+ * @a: first value
+ * @b: second value
  */
 #define swap(a, b) \
 	do { typeof(a) __tmp = (a); (a) = (b); (b) = __tmp; } while (0)
_

Patches currently in -mm which might be from rdunlap@infradead.org are

kernel-hacking-menu-runtime-testing-keep-tests-together.patch
linux-kernelh-add-correct-kernel-doc-notation.patch

