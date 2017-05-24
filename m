From: akpm@linux-foundation.org
Subject: [to-be-updated]
 kernelh-handle-pointers-to-arrays-better-in-container_of.patch removed from -mm tree
Date: Wed, 24 May 2017 11:59:29 -0700
Message-ID: <5925d811.q73cZXM5x2pBojvw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57272 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754524AbdEXS7a (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 24 May 2017 14:59:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: abbotti@mev.co.uk, bp@suse.de, glider@google.com, hidehiro.kawai.ez@hitachi.com, johannes.berg@intel.com, linux@rasmusvillemoes.dk, mina86@mina86.com, peterz@infradead.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel.h: handle pointers to arrays better in container_of()
has been removed from the -mm tree.  Its filename was
     kernelh-handle-pointers-to-arrays-better-in-container_of.patch

This patch was dropped because an updated version will be merged

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

Replace the type checking performed by the macro to avoid these
warnings.  Make sure `*(ptr)` either has type compatible with the
member, or has type compatible with `void`, ignoring qualifiers.  Raise
compiler errors if this is not true.  This is stronger than the previous
behaviour, which only resulted in compiler warnings for a type mismatch.

Link: http://lkml.kernel.org/r/20170523160112.3446-3-abbotti@mev.co.uk
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Acked-by: Michal Nazarewicz <mina86@mina86.com>
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
+#include <linux/bug.h>
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


