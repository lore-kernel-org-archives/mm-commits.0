From: Andrew Morton <akpm@linux-foundation.org>
Subject: + lib-add-might_fault-to-strncpy_from_user.patch added to
 -mm tree
Date: Tue, 14 Apr 2020 16:56:35 -0700
Message-ID: <20200414235635.XYO2L15nu%akpm@linux-foundation.org>
References: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.99]:60826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2634489AbgDNX4g (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 14 Apr 2020 19:56:36 -0400
In-Reply-To: <20200412004155.1a8f4e081b4e03ef5903abb5@linux-foundation.org>
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christophe.leroy@c-s.fr, jannh@google.com, kpsingh@chromium.org, kpsingh@google.com, mm-commits@vger.kernel.org, peterz@infradead.org


The patch titled
     Subject: lib: Add might_fault() to strncpy_from_user.
has been added to the -mm tree.  Its filename is
     lib-add-might_fault-to-strncpy_from_user.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lib-add-might_fault-to-strncpy_from_user.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lib-add-might_fault-to-strncpy_from_user.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: KP Singh <kpsingh@chromium.org>
Subject: lib: Add might_fault() to strncpy_from_user.


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

lib-add-might_fault-to-strncpy_from_user.patch
