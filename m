From: akpm@linux-foundation.org
Subject: [patch 50/96] ipc/sem: drop __sem_free()
Date: Wed, 12 Jul 2017 14:35:31 -0700
Message-ID: <20170712213531.OQgXtUU2G%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53674 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVfc (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:35:32 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, keescook@chromium.org, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

From: Kees Cook <keescook@chromium.org>
Subject: ipc/sem: drop __sem_free()

The remaining users of __sem_free() can simply call kvfree() instead for
better readability.

[manfred@colorfullife.com: Rediff to keep rcu protection for security_sem_alloc()]
Link: http://lkml.kernel.org/r/20170525185107.12869-20-manfred@colorfullife.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/sem.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff -puN ipc/sem.c~ipc-sem-drop-__sem_free ipc/sem.c
--- a/ipc/sem.c~ipc-sem-drop-__sem_free
+++ a/ipc/sem.c
@@ -258,18 +258,13 @@ static void merge_queues(struct sem_arra
 	}
 }
 
-static void __sem_free(struct sem_array *sma)
-{
-	kvfree(sma);
-}
