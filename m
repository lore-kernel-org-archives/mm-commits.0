From: akpm@linux-foundation.org
Subject: + alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch added to -mm tree
Date: Wed, 15 Aug 2012 15:03:33 -0700
Message-ID: <20120815220334.5A2E1100048@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ob0-f202.google.com ([209.85.214.202]:51352 "EHLO
	mail-ob0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2HOWDg (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 15 Aug 2012 18:03:36 -0400
Received: by obbwc20 with SMTP id wc20so1498016obb.1
        for <mm-commits@vger.kernel.org>; Wed, 15 Aug 2012 15:03:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mgorman@suse.de, James.Bottomley@hansenpartnership.com, dave.anglin@bell.net, davem@davemloft.net, fengguang.wu@intel.com, ink@jurassic.park.msu.ru, kyle@parisc-linux.org, mattst88@gmail.com, rth@twiddle.net, tony.luck@gmail.com


The patch titled
     Subject: alpha: redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts
has been added to the -mm tree.  Its filename is
     alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mel Gorman <mgorman@suse.de>
Subject: alpha: redefine ATOMIC_INIT and ATOMIC64_INIT to drop the casts

The following build error occurred during an alpha build:

net/core/sock.c:274:36: error: initializer element is not constant

Dave Anglin says:
> Here is the line in sock.i:
>
> struct static_key memalloc_socks = ((struct static_key) { .enabled =
> ((atomic_t) { (0) }) });

The above line contains two compound literals.  It also uses a designated
initializer to initialize the field enabled.  A compound literal is not a
constant expression.

The location of the above statement isn't fully clear, but if a compound
literal occurs outside the body of a function, the initializer list must
consist of constant expressions.

Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Richard Henderson <rth@twiddle.net>
Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Tony Luck <tony.luck@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: John David Anglin <dave.anglin@bell.net>
Cc: Kyle McMartin <kyle@parisc-linux.org>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/alpha/include/asm/atomic.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/alpha/include/asm/atomic.h~alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts arch/alpha/include/asm/atomic.h
--- a/arch/alpha/include/asm/atomic.h~alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts
+++ a/arch/alpha/include/asm/atomic.h
@@ -14,8 +14,8 @@
  */
 
 
-#define ATOMIC_INIT(i)		( (atomic_t) { (i) } )
-#define ATOMIC64_INIT(i)	( (atomic64_t) { (i) } )
+#define ATOMIC_INIT(i)		{ (i) }
+#define ATOMIC64_INIT(i)	{ (i) }
 
 #define atomic_read(v)		(*(volatile int *)&(v)->counter)
 #define atomic64_read(v)	(*(volatile long *)&(v)->counter)
_

Patches currently in -mm which might be from mgorman@suse.de are

linux-next.patch
mm-hugetlbfs-correctly-populate-shared-pmd.patch
mm-hugetlbfs-correctly-populate-shared-pmd-fix.patch
alpha-redefine-atomic_init-and-atomic64_init-to-drop-the-casts.patch

