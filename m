From: akpm@linux-foundation.org
Subject: [patch 02/96] kernel.h: handle pointers to arrays better
 in container_of()
Date: Wed, 12 Jul 2017 14:33:04 -0700
Message-ID: <20170712213304.3tOD-Vpse%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53070 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754096AbdGLVdH (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:33:07 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, akpm@linux-foundation.org, arnd@arndb.de, bp@suse.de, glider@google.com, hidehiro.kawai.ez@hitachi.com, johannes.berg@intel.com, keescook@chromium.org, linux@rasmusvillemoes.dk, mina86@mina86.com, mm-commits@vger.kernel.org, peterz@infradead.org, torvalds@linux-foundation.org

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

[arnd@arndb.de: fix new warnings for container_of()]
  Link: http://lkml.kernel.org/r/20170620200940.90557-1-arnd@arndb.de
Link: http://lkml.kernel.org/r/20170525120316.24473-7-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
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

 include/linux/kernel.h |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

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
 
@@ -854,9 +855,12 @@ static inline void ftrace_dump(enum ftra
  * @member:	the name of the member within the struct.
  *
  */
-#define container_of(ptr, type, member) ({			\
-	const typeof( ((type *)0)->member ) *__mptr = (ptr);	\
-	(type *)( (char *)__mptr - offsetof(type,member) );})
+#define container_of(ptr, type, member) ({				\
+	void *__mptr = (void *)(ptr);					\
+	BUILD_BUG_ON_MSG(!__same_type(*(ptr), ((type *)0)->member) &&	\
+			 !__same_type(*(ptr), void),			\
+			 "pointer type mismatch in container_of()");	\
+	((type *)(__mptr - offsetof(type, member))); })
 
 /* Rebuild everything on CONFIG_FTRACE_MCOUNT_RECORD */
 #ifdef CONFIG_FTRACE_MCOUNT_RECORD
_
