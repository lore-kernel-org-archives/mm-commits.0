From: akpm@linux-foundation.org
Subject: + ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch added to -mm tree
Date: Tue, 30 May 2017 12:32:11 -0700
Message-ID: <592dc8bb.zaZuKFHsGgPCzxQD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47260 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750977AbdE3TcR (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 30 May 2017 15:32:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc-merge-ipc_rcu-and-kern_ipc_perm-fix
has been added to the -mm tree.  Its filename is
     ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Manfred Spraul <manfred@colorfullife.com>
Subject: ipc-merge-ipc_rcu-and-kern_ipc_perm-fix

V2: Really include the memset() into ipc_alloc_rcu().

Link: http://lkml.kernel.org/r/564f8612-0601-b267-514f-a9f650ec9b32@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN ipc/util.c~ipc-merge-ipc_rcu-and-kern_ipc_perm-fix ipc/util.c
--- a/ipc/util.c~ipc-merge-ipc_rcu-and-kern_ipc_perm-fix
+++ a/ipc/util.c
@@ -432,6 +432,8 @@ struct kern_ipc_perm *ipc_rcu_alloc(int
 	struct kern_ipc_perm *out = ipc_alloc(size);
 	if (unlikely(!out))
 		return NULL;
+
+	memset(out, 0, size);
 	atomic_set(&out->refcount, 1);
 	return out;
 }
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-semc-remove-sem_base-embed-struct-sem-v3.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm-fix.patch
include-linux-semh-correctly-document-sem_ctime.patch
ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

