From: akpm@linux-foundation.org
Subject: + linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch added to -mm tree
Date: Tue, 09 Oct 2012 13:07:38 -0700
Message-ID: <20121009200738.A75B2100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:51634 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584Ab2JIUHj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 16:07:39 -0400
Received: by mail-gg0-f202.google.com with SMTP id i4so682063ggm.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 13:07:39 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: josh@joshtriplett.org, ecashin@coraid.com


The patch titled
     Subject: linux/compiler.h: add __must_hold macro for functions called with a lock held
has been added to the -mm tree.  Its filename is
     linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
linux-next.patch
linux-compilerh-add-__must_hold-macro-for-functions-called-with-a-lock-held.patch

