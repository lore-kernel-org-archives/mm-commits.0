From: akpm@linux-foundation.org
Subject: [merged] linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch removed from -mm tree
Date: Tue, 18 Dec 2012 12:09:28 -0800
Message-ID: <20121218200928.9C903100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:33006 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755249Ab2LRUJ3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 18 Dec 2012 15:09:29 -0500
Received: by mail-gg0-f202.google.com with SMTP id k1so126076ggn.1
        for <mm-commits@vger.kernel.org>; Tue, 18 Dec 2012 12:09:29 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: josh@joshtriplett.org, ecashin@coraid.com, mm-commits@vger.kernel.org


The patch titled
     Subject: linux/compiler.h: add __must_hold macro for functions called with a lock held
has been removed from the -mm tree.  Its filename was
     linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Josh Triplett <josh@joshtriplett.org>
Subject: linux/compiler.h: add __must_hold macro for functions called with a lock held

linux/compiler.h has macros to denote functions that acquire or release
locks, but not to denote functions called with a lock held that return
with the lock still held.  Add a __must_hold macro to cover that case.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Reported-by: Ed Cashin <ecashin@coraid.com>
Tested-by: Ed Cashin <ecashin@coraid.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/compiler.h |    2 ++
 1 file changed, 2 insertions(+)

diff -puN include/linux/compiler.h~linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held include/linux/compiler.h
--- a/include/linux/compiler.h~linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held
+++ a/include/linux/compiler.h
@@ -10,6 +10,7 @@
 # define __force	__attribute__((force))
 # define __nocast	__attribute__((nocast))
 # define __iomem	__attribute__((noderef, address_space(2)))
+# define __must_hold(x)	__attribute__((context(x,1,1)))
 # define __acquires(x)	__attribute__((context(x,0,1)))
 # define __releases(x)	__attribute__((context(x,1,0)))
 # define __acquire(x)	__context__(x,1)
@@ -33,6 +34,7 @@ extern void __chk_io_ptr(const volatile 
 # define __chk_user_ptr(x) (void)0
 # define __chk_io_ptr(x) (void)0
 # define __builtin_warning(x, y...) (1)
+# define __must_hold(x)
 # define __acquires(x)
 # define __releases(x)
 # define __acquire(x) (void)0
_

Patches currently in -mm which might be from josh@joshtriplett.org are

origin.patch

