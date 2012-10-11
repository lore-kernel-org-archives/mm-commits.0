From: akpm@linux-foundation.org
Subject: [merged] lglock-make-the-per_cpu-locks-static.patch removed from -mm tree
Date: Thu, 11 Oct 2012 13:59:33 -0700
Message-ID: <20121011205934.1D7015C0050@hpza9.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f202.google.com ([209.85.215.202]:48095 "EHLO
	mail-ea0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759261Ab2JKU7g (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 11 Oct 2012 16:59:36 -0400
Received: by mail-ea0-f202.google.com with SMTP id q10so62534eaa.1
        for <mm-commits@vger.kernel.org>; Thu, 11 Oct 2012 13:59:35 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: laijs@cn.fujitsu.com, ak@linux.intel.com, rusty@rustcorp.com.au, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: lglock: make the per_cpu locks static
has been removed from the -mm tree.  Its filename was
     lglock-make-the-per_cpu-locks-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

