From: akpm@linux-foundation.org
Subject: +
 include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch added
 to -mm tree
Date: Mon, 16 Jun 2014 16:19:46 -0700
Message-ID: <539f7b92.46xTibhGA8z2oehV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46468 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbaFPXTr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Jun 2014 19:19:47 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rostedt@goodmis.org, hagen@jauu.net, mina86@mina86.com


The patch titled
     Subject: include/linux/kernel.h: rewrite min3, max3 and clamp using min and max
has been added to the -mm tree.  Its filename is
     include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michal Nazarewicz <mina86@mina86.com>
Subject: include/linux/kernel.h: rewrite min3, max3 and clamp using min and max

It appears that gcc is better at optimising a double call to min and max
rather than open coded min3 and max3.  This can be observed here:

    $ cat min-max.c
    #define min(x, y) ({				\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	(void) (&_min1 == &_min2);		\
    	_min1 < _min2 ? _min1 : _min2; })
    #define min3(x, y, z) ({			\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	typeof(z) _min3 = (z);			\
    	(void) (&_min1 == &_min2);		\
    	(void) (&_min1 == &_min3);		\
    	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
    		(_min2 < _min3 ? _min2 : _min3); })

    int fmin3(int x, int y, int z) { return min3(x, y, z); }
    int fmin2(int x, int y, int z) { return min(min(x, y), z); }

    $ gcc -O2 -o min-max.s -S min-max.c; cat min-max.s
    	.file	"min-max.c"
    	.text
    	.p2align 4,,15
    	.globl	fmin3
    	.type	fmin3, @function
    fmin3:
    .LFB0:
    	.cfi_startproc
    	cmpl	%esi, %edi
    	jl	.L5
    	cmpl	%esi, %edx
    	movl	%esi, %eax
    	cmovle	%edx, %eax
    	ret
    	.p2align 4,,10
    	.p2align 3
    .L5:
    	cmpl	%edi, %edx
    	movl	%edi, %eax
    	cmovle	%edx, %eax
    	ret
    	.cfi_endproc
    .LFE0:
    	.size	fmin3, .-fmin3
    	.p2align 4,,15
    	.globl	fmin2
    	.type	fmin2, @function
    fmin2:
    .LFB1:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	movl	%edx, %eax
    	cmovle	%esi, %edi
    	cmpl	%edx, %edi
    	cmovle	%edi, %eax
    	ret
    	.cfi_endproc
    .LFE1:
    	.size	fmin2, .-fmin2
    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
    	.section	.note.GNU-stack,"",@progbits

fmin3 function, which uses open-coded min3 macro, is compiled into total
of ten instructions including a conditional branch, whereas fmin2
function, which uses two calls to min2 macro, is compiled into six
instructions with no branches.

Similarly, open-coded clamp produces the same code as clamp using min and
max macros, but the latter is much shorter:

    $ cat clamp.c
    #define clamp(val, min, max) ({			\
    	typeof(val) __val = (val);		\
    	typeof(min) __min = (min);		\
    	typeof(max) __max = (max);		\
    	(void) (&__val == &__min);		\
    	(void) (&__val == &__max);		\
    	__val = __val < __min ? __min: __val;	\
    	__val > __max ? __max: __val; })
    #define min(x, y) ({				\
    	typeof(x) _min1 = (x);			\
    	typeof(y) _min2 = (y);			\
    	(void) (&_min1 == &_min2);		\
    	_min1 < _min2 ? _min1 : _min2; })
    #define max(x, y) ({				\
    	typeof(x) _max1 = (x);			\
    	typeof(y) _max2 = (y);			\
    	(void) (&_max1 == &_max2);		\
    	_max1 > _max2 ? _max1 : _max2; })

    int fclamp(int v, int min, int max) { return clamp(v, min, max); }
    int fclampmm(int v, int min, int max) { return min(max(v, min), max); }

    $ gcc -O2 -o clamp.s -S clamp.c; cat clamp.s
    	.file	"clamp.c"
    	.text
    	.p2align 4,,15
    	.globl	fclamp
    	.type	fclamp, @function
    fclamp:
    .LFB0:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	movl	%edx, %eax
    	cmovge	%esi, %edi
    	cmpl	%edx, %edi
    	cmovle	%edi, %eax
    	ret
    	.cfi_endproc
    .LFE0:
    	.size	fclamp, .-fclamp
    	.p2align 4,,15
    	.globl	fclampmm
    	.type	fclampmm, @function
    fclampmm:
    .LFB1:
    	.cfi_startproc
    	cmpl	%edi, %esi
    	cmovge	%esi, %edi
    	cmpl	%edi, %edx
    	movl	%edi, %eax
    	cmovle	%edx, %eax
    	ret
    	.cfi_endproc
    .LFE1:
    	.size	fclampmm, .-fclampmm
    	.ident	"GCC: (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3"
    	.section	.note.GNU-stack,"",@progbits

Furthermore, after `make allmodconfig && make bzImage modules' this is the
comparison of image and modules sizes:

    # Without this patch applied
    $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
    350715800

    # With this patch applied
    $ ls -l arch/x86/boot/bzImage **/*.ko |awk '{size += $5} END {print size}'
    349856528

The above builds were done on:

    $ uname -a; gcc --version
    Linux mpn-glaptop 3.13.0-29-generic #53~precise1-Ubuntu SMP Wed Jun 4 22:06:25 UTC 2014 x86_64 x86_64 x86_64 GNU/Linux
    gcc (Ubuntu/Linaro 4.6.3-1ubuntu5) 4.6.3
    Copyright (C) 2011 Free Software Foundation, Inc.
    This is free software; see the source for copying conditions.  There is NO
    warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |   32 +++++---------------------------
 1 file changed, 5 insertions(+), 27 deletions(-)

diff -puN include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max include/linux/kernel.h
--- a/include/linux/kernel.h~include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max
+++ a/include/linux/kernel.h
@@ -719,23 +719,8 @@ static inline void ftrace_dump(enum ftra
 	(void) (&_max1 == &_max2);		\
 	_max1 > _max2 ? _max1 : _max2; })
 
-#define min3(x, y, z) ({			\
-	typeof(x) _min1 = (x);			\
-	typeof(y) _min2 = (y);			\
-	typeof(z) _min3 = (z);			\
-	(void) (&_min1 == &_min2);		\
-	(void) (&_min1 == &_min3);		\
-	_min1 < _min2 ? (_min1 < _min3 ? _min1 : _min3) : \
-		(_min2 < _min3 ? _min2 : _min3); })
-
-#define max3(x, y, z) ({			\
-	typeof(x) _max1 = (x);			\
-	typeof(y) _max2 = (y);			\
-	typeof(z) _max3 = (z);			\
-	(void) (&_max1 == &_max2);		\
-	(void) (&_max1 == &_max3);		\
-	_max1 > _max2 ? (_max1 > _max3 ? _max1 : _max3) : \
-		(_max2 > _max3 ? _max2 : _max3); })
+#define min3(x, y, z) min(min(x, y), z)
+#define max3(x, y, z) max(max(x, y), z)
 
 /**
  * min_not_zero - return the minimum that is _not_ zero, unless both are zero
@@ -750,20 +735,13 @@ static inline void ftrace_dump(enum ftra
 /**
  * clamp - return a value clamped to a given range with strict typechecking
  * @val: current value
- * @min: minimum allowable value
- * @max: maximum allowable value
+ * @lo: lowest allowable value
+ * @hi: highest allowable value
  *
  * This macro does strict typechecking of min/max to make sure they are of the
  * same type as val.  See the unnecessary pointer comparisons.
  */
-#define clamp(val, min, max) ({			\
-	typeof(val) __val = (val);		\
-	typeof(min) __min = (min);		\
-	typeof(max) __max = (max);		\
-	(void) (&__val == &__min);		\
-	(void) (&__val == &__max);		\
-	__val = __val < __min ? __min: __val;	\
-	__val > __max ? __max: __val; })
+#define clamp(val, lo, hi) min(max(val, lo), hi)
 
 /*
  * ..and if you can't take the strict
_

Patches currently in -mm which might be from mina86@mina86.com are

mm-page_alloc-simplify-drain_zone_pages-by-using-min.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max.patch
debugging-keep-track-of-page-owners.patch

