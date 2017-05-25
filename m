From: akpm@linux-foundation.org
Subject: + kernelh-handle-pointers-to-arrays-better-in-container_of.patch
 added to -mm tree
Date: Thu, 25 May 2017 16:09:55 -0700
Message-ID: <59276443.w2YFtuBAI2UxIB14%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46816 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1163136AbdEYXJ4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 19:09:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, bp@suse.de, glider@google.com, hidehiro.kawai.ez@hitachi.com, johannes.berg@intel.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: handle pointers to arrays better in container_of()
has been added to the -mm tree.  Its filename is
     kernelh-handle-pointers-to-arrays-better-in-container_of.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/kernelh-handle-pointers-to-arrays-better-in-container_of.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/kernelh-handle-pointers-to-arrays-better-in-container_of.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ian Abbott <abbotti@mev.co.uk>
Subject: kernel.h: handle pointers to arrays better in container_of()

If the first parameter of container_of() is a pointer to a
non-const-qualified array type (and the third parameter names a
non-const-qualified array member), the local variable __mptr will be
defined with a const-qualified array type.  In ISO C, these types are
incompatible.  They work as expected in GNU C, but some versions will
issue warnings.  For example, GCC 4.9 produces the warning "initialization
from incompatible pointer type".

Here is an example of where the problem occurs:

-------------------------------------------------------
 #include <linux/kernel.h>
 #include <linux/module.h>

MODULE_LICENSE("GPL");

struct st {
	int a;
	char b[16];
};

static int __init example_init(void) {
	struct st t = { .a = 101, .b = "hello" };
	char (*p)[16] = &t.b;
	struct st *x = container_of(p, struct st, b);
	printk(KERN_DEBUG "%p %p\n", (void *)&t, (void *)x);
	return 0;
}

static void __exit example_exit(void) {
}

module_init(example_init);
module_exit(example_exit);
-------------------------------------------------------

Building the module with gcc-4.9 results in these warnings (where '{m}'
is the module source and '{k}' is the kernel source):

-------------------------------------------------------
In file included from {m}/example.c:1:0:
{m}/example.c: In function `example_init':
{k}/include/linux/kernel.h:854:48: warning: initialization from
incompatible pointer type
  const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                ^
{m}/example.c:14:17: note: in expansion of macro `container_of'
  struct st *x = container_of(p, struct st, b);
                 ^
{k}/include/linux/kernel.h:854:48: warning: (near initialization for
`x')
  const typeof( ((type *)0)->member ) *__mptr = (ptr); \
                                                ^
{m}/example.c:14:17: note: in expansion of macro `container_of'
  struct st *x = container_of(p, struct st, b);
                 ^
-------------------------------------------------------

Replace the type checking performed by the macro to avoid these warnings. 
Make sure `*(ptr)` either has type compatible with the member, or has type
compatible with `void`, ignoring qualifiers.  Raise compiler errors if
this is not true.  This is stronger than the previous behaviour, which
only resulted in compiler warnings for a type mismatch.

Link: http://lkml.kernel.org/r/20170525120316.24473-7-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff -puN include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-handle-pointers-to-arrays-better-in-container_of
+++ a/include/linux/kernel.h
@@ -11,6 +11,7 @@
 #include <linux/log2.h>
 #include <linux/typecheck.h>
 #include <linux/printk.h>
+#include <linux/build_bug.h>
 #include <asm/byteorder.h>
 #include <uapi/linux/kernel.h>
 
@@ -850,9 +851,11 @@ static inline void ftrace_dump(enum ftra
  * @member:	the name of the member within the struct.
  *
  */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+#define container_of(ptr, type, member) ({				\
+	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
+			 !__same_type(*(ptr), void),			\
+			 "pointer type mismatch in container_of()");	\
+	((type *)((char *)(ptr) - offsetof(type, member))); })
 
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
_

Patches currently in -mm which might be from abbotti@mev.co.uk are

asm-generic-bugh-declare-struct-pt_regs-before-function-prototype.patch
linux-bugh-correct-formatting-of-block-comment.patch
linux-bugh-correct-foo-should-be-foo.patch
linux-bugh-correct-space-required-before-that.patch
bug-split-build_bug-stuff-out-into-linux-build_bugh.patch
kernelh-handle-pointers-to-arrays-better-in-container_of.patch

