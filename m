From: akpm@linux-foundation.org
Subject: + lglock-make-the-per_cpu-locks-static.patch added to -mm tree
Date: Tue, 09 Oct 2012 14:49:51 -0700
Message-ID: <20121009214952.3ADD5100047@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qa0-f74.google.com ([209.85.216.74]:65147 "EHLO
	mail-qa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757051Ab2JIVtx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Oct 2012 17:49:53 -0400
Received: by mail-qa0-f74.google.com with SMTP id a16so556620qae.1
        for <mm-commits@vger.kernel.org>; Tue, 09 Oct 2012 14:49:52 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: laijs@cn.fujitsu.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk


The patch titled
     Subject: lglock: make the per_cpu locks static
has been added to the -mm tree.  Its filename is
     lglock-make-the-per_cpu-locks-static.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: lglock: make the per_cpu locks static

The per_cpu locks are not used outside the file which contains the
DEFINE_LGLOCK(), so we can make these symbols static.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/lglock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/lglock.h~lglock-make-the-per_cpu-locks-static include/linux/lglock.h
--- a/include/linux/lglock.h~lglock-make-the-per_cpu-locks-static
+++ a/include/linux/lglock.h
@@ -49,7 +49,7 @@ struct lglock {
 };
 
 #define DEFINE_LGLOCK(name)						\
-	DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)			\
+	static DEFINE_PER_CPU(arch_spinlock_t, name ## _lock)		\
 	= __ARCH_SPIN_LOCK_UNLOCKED;					\
 	struct lglock name = { .lock = &name ## _lock }
 
_

Patches currently in -mm which might be from laijs@cn.fujitsu.com are

origin.patch
linux-next.patch
lglock-remove-unused-define_lglock_lockdep.patch
lglock-make-the-per_cpu-locks-static.patch
lglock-add-define_static_lglock.patch

