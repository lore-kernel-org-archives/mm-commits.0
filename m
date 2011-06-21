From: akpm@linux-foundation.org
Subject: + atomic-update-comments-in-atomich.patch added to -mm tree
Date: Tue, 21 Jun 2011 15:57:34 -0700
Message-ID: <201106212257.p5LMvYmD029773@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37146 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752903Ab1FUW54 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 21 Jun 2011 18:57:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: asharma@fb.com, davem@davemloft.net, eric.dumazet@gmail.com, mingo@elte.hu, vapier.adi@gmail.com, vapier@gentoo.org


The patch titled
     atomic: Update comments in atomic.h
has been added to the -mm tree.  Its filename is
     atomic-update-comments-in-atomich.patch

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

atomic-use-linux-atomich.patch
atomic-move-atomic_add_unless-to-generic-code.patch
atomic-cleanup-asm-generic-atomich-inclusion.patch
atomic-update-comments-in-atomich.patch
asm-generic-atomich-simplify-inc-dec-test-helpers.patch

