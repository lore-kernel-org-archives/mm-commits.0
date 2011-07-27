From: akpm@linux-foundation.org
Subject: [merged] atomic-update-comments-in-atomich.patch removed from -mm tree
Date: Wed, 27 Jul 2011 12:30:00 -0700
Message-ID: <201107271928.p6RJSkMd003335@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49357 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755063Ab1G0T3U (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jul 2011 15:29:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: asharma@fb.com, davem@davemloft.net, eric.dumazet@gmail.com, mingo@elte.hu, vapier.adi@gmail.com, vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     atomic: Update comments in atomic.h
has been removed from the -mm tree.  Its filename was
     atomic-update-comments-in-atomich.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: atomic: Update comments in atomic.h
From: Arun Sharma <asharma@fb.com>

This clarifies the differences between <linux/atomic.h> and
<asm-generic/atomic.h>

Signed-off-by: Arun Sharma <asharma@fb.com>
Suggested-by: Mike Frysinger <vapier.adi@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Miller <davem@davemloft.net>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/atomic.h |    4 +++-
 include/linux/atomic.h       |    1 +
 2 files changed, 4 insertions(+), 1 deletion(-)

diff -puN include/asm-generic/atomic.h~atomic-update-comments-in-atomich include/asm-generic/atomic.h
--- a/include/asm-generic/atomic.h~atomic-update-comments-in-atomich
+++ a/include/asm-generic/atomic.h
@@ -1,5 +1,7 @@
 /*
- * Generic C implementation of atomic counter operations
+ * Generic C implementation of atomic counter operations. Usable on
+ * UP systems only. Do not include in machine independent code.
+ *
  * Originally implemented for MN10300.
  *
  * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
diff -puN include/linux/atomic.h~atomic-update-comments-in-atomich include/linux/atomic.h
--- a/include/linux/atomic.h~atomic-update-comments-in-atomich
+++ a/include/linux/atomic.h
@@ -1,3 +1,4 @@
+/* Atomic operations usable in machine independent code */
 #ifndef _LINUX_ATOMIC_H
 #define _LINUX_ATOMIC_H
 #include <asm/atomic.h>
_

Patches currently in -mm which might be from asharma@fb.com are

origin.patch
sparc-rename-atomic_add_unless.patch

