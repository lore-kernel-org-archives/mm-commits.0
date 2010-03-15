From: akpm@linux-foundation.org
Subject: [merged] nodemask-fix-the-declaration-of-nodemask_alloc.patch removed from -mm tree
Date: Mon, 15 Mar 2010 00:00:23 -0400
Message-ID: <201003150700.o2F70uNI016667@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57643 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935755Ab0COHBO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 15 Mar 2010 03:01:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: miaox@cn.fujitsu.com, lee.schermerhorn@hp.com, menage@google.com, mingo@elte.hu, npiggin@suse.de, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     nodemask: fix the declaration of NODEMASK_ALLOC()
has been removed from the -mm tree.  Its filename was
     nodemask-fix-the-declaration-of-nodemask_alloc.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

