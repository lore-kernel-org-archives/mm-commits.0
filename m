From: akpm@linux-foundation.org
Subject: + nodemask-fix-the-declaration-of-nodemask_alloc.patch added to -mm tree
Date: Wed, 03 Mar 2010 15:39:08 -0800
Message-ID: <201003032339.o23Nd96Y005580@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56827 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752938Ab0CCXjY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Mar 2010 18:39:24 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: miaox@cn.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com


The patch titled
     nodemask: fix the declaration of NODEMASK_ALLOC()
has been added to the -mm tree.  Its filename is
     nodemask-fix-the-declaration-of-nodemask_alloc.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: nodemask: fix the declaration of NODEMASK_ALLOC()
From: Miao Xie <miaox@cn.fujitsu.com>

we can't declarate two variable at the same scope by NODEMASK_ALLOC().

This patch fixes it.

Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Paul Menage <menage@google.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/nodemask.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/nodemask.h~nodemask-fix-the-declaration-of-nodemask_alloc include/linux/nodemask.h
--- a/include/linux/nodemask.h~nodemask-fix-the-declaration-of-nodemask_alloc
+++ a/include/linux/nodemask.h
@@ -483,7 +483,7 @@ static inline int num_node_state(enum no
 			type *name = kmalloc(sizeof(*name), gfp_flags)
 #define NODEMASK_FREE(m)			kfree(m)
 #else
-#define NODEMASK_ALLOC(type, name, gfp_flags)	type _name, *name = &_name
+#define NODEMASK_ALLOC(type, name, gfp_flags)	type _##name, *name = &_##name
 #define NODEMASK_FREE(m)			do {} while (0)
 #endif
 
_

Patches currently in -mm which might be from miaox@cn.fujitsu.com are

cpuset-fix-the-problem-that-cpuset_mem_spread_node-returns-an-offline-node.patch
nodemask-fix-the-declaration-of-nodemask_alloc.patch
cpuset-alloc-nodemask_t-at-heap-not-stack.patch
cpusetmm-use-rwlock-to-protect-task-mempolicy-and-mems_allowed.patch

