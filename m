From: akpm@linux-foundation.org
Subject: +
 ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch added to -mm tree
Date: Thu, 25 May 2017 15:11:30 -0700
Message-ID: <59275692.uLH8DdxBXx7ZDXeF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43264 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970366AbdEYWLb (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 May 2017 18:11:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: manfred@colorfullife.com, dave@stgolabs.net, keescook@chromium.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/util.h: update documentation for ipc_getref() and ipc_putref()
has been added to the -mm tree.  Its filename is
     ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

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
Subject: ipc/util.h: update documentation for ipc_getref() and ipc_putref()

Now that ipc_rcu_alloc() and ipc_rcu_free() are removed,
document when it is valid to use ipc_getref() and ipc_putref().

Link: http://lkml.kernel.org/r/20170525185107.12869-21-manfred@colorfullife.com
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.h |    3 +++
 1 file changed, 3 insertions(+)

diff -puN ipc/util.h~ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref ipc/util.h
--- a/ipc/util.h~ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref
+++ a/ipc/util.h
@@ -112,6 +112,9 @@ int ipcperms(struct ipc_namespace *ns, s
  * Objects are reference counted, they start with reference count 1.
  * getref increases the refcount, the putref call that reduces the recount
  * to 0 schedules the rcu destruction. Caller must guarantee locking.
+ *
+ * refcount is initialized by ipc_addid(), before that point call_rcu()
+ * must be used.
  */
 int ipc_rcu_getref(struct kern_ipc_perm *ptr);
 void ipc_rcu_putref(struct kern_ipc_perm *ptr,
_

Patches currently in -mm which might be from manfred@colorfullife.com are

ipc-semc-remove-sem_base-embed-struct-sem.patch
ipc-semc-remove-sem_base-embed-struct-sem-v3.patch
ipc-merge-ipc_rcu-and-kern_ipc_perm.patch
include-linux-semh-correctly-document-sem_ctime.patch
ipc-semc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-shmc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-msgc-avoid-ipc_rcu_putref-for-failed-ipc_addid.patch
ipc-utilh-update-documentation-for-ipc_getref-and-ipc_putref.patch

