From: akpm@linux-foundation.org
Subject: [merged] lib-add-might_fault-to-strncpy_from_user.patch
 removed from -mm tree
Date: Fri, 05 Jun 2020 13:19:05 -0700
Message-ID: <20200605201905.WBW0js01t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:45196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728082AbgFEUTF (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Fri, 5 Jun 2020 16:19:05 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christophe.leroy@c-s.fr, jannh@google.com, kpsingh@chromium.org, kpsingh@google.com, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: lib: Add might_fault() to strncpy_from_user.
has been removed from the -mm tree.  Its filename was
     lib-add-might_fault-to-strncpy_from_user.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: KP Singh <kpsingh@chromium.org>
Subject: lib: Add might_fault() to strncpy_from_user.

From: KP Singh <kpsingh@google.com>

When updating a piece of broken logic from using get_user to
strncpy_from_user, we noticed that a warning which is expected when
calling a function that might fault from an atomic context with
pagefaults enabled disappeared.

Not having this warning in place can lead to calling strncpy_from_user
from an atomic context and eventually kernel crashes/stack corruption.

Link: http://lkml.kernel.org/r/20200414225705.255711-1-kpsingh@chromium.org
Signed-off-by: KP Singh <kpsingh@google.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/strncpy_from_user.c |    1 +
 1 file changed, 1 insertion(+)

--- a/lib/strncpy_from_user.c~lib-add-might_fault-to-strncpy_from_user
+++ a/lib/strncpy_from_user.c
@@ -98,6 +98,7 @@ long strncpy_from_user(char *dst, const
 {
 	unsigned long max_addr, src_addr;
 
+	might_fault();
 	if (unlikely(count <= 0))
 		return 0;
 
_

Patches currently in -mm which might be from kpsingh@chromium.org are
