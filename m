From: akpm@linux-foundation.org
Subject: + sparse-group-the-defines-by-functionality.patch added to
 -mm tree
Date: Thu, 25 Jun 2020 16:16:39 -0700
Message-ID: <20200625231639.7A6Hp%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:38122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728599AbgFYXQk (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Jun 2020 19:16:40 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, miguel.ojeda.sandonis@gmail.com, geert@linux-m68k.org, luc.vanoostenryck@gmail.com


The patch titled
     Subject: sparse: group the defines by functionality
has been added to the -mm tree.  Its filename is
     sparse-group-the-defines-by-functionality.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sparse-group-the-defines-by-functionality.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sparse-group-the-defines-by-functionality.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Subject: sparse: group the defines by functionality

By popular demand, reorder the defines for sparse annotations and group
them by functionality.

Link: lore.kernel.org/r/CAMuHMdWQsirja-h3wBcZezk+H2Q_HShhAks8Hc8ps5fTAp=ObQ@mail.gmail.com
Link: http://lkml.kernel.org/r/20200621143652.53798-1-luc.vanoostenryck@gmail.com
Signed-off-by: Luc Van Oostenryck <luc.vanoostenryck@gmail.com>
Acked-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler_types.h |   44 +++++++++++++++++--------------
 1 file changed, 25 insertions(+), 19 deletions(-)

--- a/include/linux/compiler_types.h~sparse-group-the-defines-by-functionality
+++ a/include/linux/compiler_types.h
@@ -5,48 +5,54 @@
 #ifndef __ASSEMBLY__
 
 #ifdef __CHECKER__
+/* address spaces */
 # define __kernel	__attribute__((address_space(0)))
 # define __user		__attribute__((noderef, address_space(__user)))
-# define __safe		__attribute__((safe))
-# define __force	__attribute__((force))
-# define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(__iomem)))
+# define __percpu	__attribute__((noderef, address_space(__percpu)))
+# define __rcu		__attribute__((noderef, address_space(__rcu)))
+extern void __chk_user_ptr(const volatile void __user *);
+extern void __chk_io_ptr(const volatile void __iomem *);
+/* context/locking */
 # define __must_hold(x)	__attribute__((context(x,1,1)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
 # define __release(x)	__context__(x,-1)
 # define __cond_lock(x,c)	((c) ? ({ __acquire(x); 1; }) : 0)
-# define __percpu	__attribute__((noderef, address_space(__percpu)))
-# define __rcu		__attribute__((noderef, address_space(__rcu)))
+/* other */
+# define __force	__attribute__((force))
+# define __nocast	__attribute__((nocast))
+# define __safe		__attribute__((safe))
 # define __private	__attribute__((noderef))
-extern void __chk_user_ptr(const volatile void __user *);
-extern void __chk_io_ptr(const volatile void __iomem *);
 # define ACCESS_PRIVATE(p, member) (*((typeof((p)->member) __force *) &(p)->member))
 #else /* __CHECKER__ */
+/* address spaces */
+# define __kernel
 # ifdef STRUCTLEAK_PLUGIN
-#  define __user __attribute__((user))
+#  define __user	__attribute__((user))
 # else
 #  define __user
 # endif
-# define __kernel
-# define __safe
-# define __force
-# define __nocast
 # define __iomem
-# define __chk_user_ptr(x) (void)0
-# define __chk_io_ptr(x) (void)0
-# define __builtin_warning(x, y...) (1)
+# define __percpu
+# define __rcu
+# define __chk_user_ptr(x)	(void)0
+# define __chk_io_ptr(x)	(void)0
+/* context/locking */
 # define __must_hold(x)
 # define __acquires(x)
 # define __releases(x)
-# define __acquire(x) (void)0
-# define __release(x) (void)0
+# define __acquire(x)	(void)0
+# define __release(x)	(void)0
 # define __cond_lock(x,c) (c)
-# define __percpu
-# define __rcu
+/* other */
+# define __force
+# define __nocast
+# define __safe
 # define __private
 # define ACCESS_PRIVATE(p, member) ((p)->member)
+# define __builtin_warning(x, y...) (1)
 #endif /* __CHECKER__ */
 
 /* Indirect macros required for expanded argument pasting, eg. __LINE__. */
_

Patches currently in -mm which might be from luc.vanoostenryck@gmail.com are

maintainers-update-info-for-sparse.patch
fix-annotation-of-ioreadwrite1632be.patch
sparse-group-the-defines-by-functionality.patch
lib-generic-radix-treec-remove-unneeded-__rcu.patch
