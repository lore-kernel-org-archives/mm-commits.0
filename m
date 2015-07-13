From: akpm@linux-foundation.org
Subject: + ipc-convert-invalid-scenarios-to-use-warn_on.patch added to -mm tree
Date: Mon, 13 Jul 2015 14:33:20 -0700
Message-ID: <55a42ea0.C5Tjpcn1ZWM3jYJF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33490 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752091AbbGMVdV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 13 Jul 2015 17:33:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, torvalds@linux-foundation.org, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: convert invalid scenarios to use WARN_ON
has been added to the -mm tree.  Its filename is
     ipc-convert-invalid-scenarios-to-use-warn_on.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-convert-invalid-scenarios-to-use-warn_on.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-convert-invalid-scenarios-to-use-warn_on.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: ipc: convert invalid scenarios to use WARN_ON

Considering Linus' past rants about the (ab)use of BUG in the kernel, I
took a look at how we deal with such calls in ipc.  Given that any errors
or corruption in ipc code are most likely contained within the set of
processes participating in the broken mechanisms, there aren't really many
strong fatal system failure scenarios that would require a BUG call. 
Also, if something is seriously wrong, ipc might not be the place for such
a BUG either.

1. For example, recently, a customer hit one of these BUG_ONs in shm
   after failing shm_lock().  A busted ID imho does not merit a BUG_ON,
   and WARN would have been better.

2. MSG_COPY functionality of posix msgrcv(2) for checkpoint/restore. 
   I don't see how we can hit this anyway -- at least it should be IS_ERR.
    The 'copy' arg from do_msgrcv is always set by calling prepare_copy()
   first and foremost.  We could also probably drop this check altogether.
    Either way, it does not merit a BUG_ON.

3. No ->fault() callback for the fs getting the corresponding page --
   seems selfish to make the system unusable.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msgutil.c |    2 +-
 ipc/shm.c     |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN ipc/msgutil.c~ipc-convert-invalid-scenarios-to-use-warn_on ipc/msgutil.c
--- a/ipc/msgutil.c~ipc-convert-invalid-scenarios-to-use-warn_on
+++ a/ipc/msgutil.c
@@ -123,7 +123,7 @@ struct msg_msg *copy_msg(struct msg_msg
 	size_t len = src->m_ts;
 	size_t alen;
 
-	BUG_ON(dst == NULL);
+	WARN_ON(dst == NULL);
 	if (src->m_ts > dst->m_ts)
 		return ERR_PTR(-EINVAL);
 
diff -puN ipc/shm.c~ipc-convert-invalid-scenarios-to-use-warn_on ipc/shm.c
--- a/ipc/shm.c~ipc-convert-invalid-scenarios-to-use-warn_on
+++ a/ipc/shm.c
@@ -159,7 +159,7 @@ static inline struct shmid_kernel *shm_l
 	 * We raced in the idr lookup or with shm_destroy().  Either way, the
 	 * ID is busted.
 	 */
-	BUG_ON(IS_ERR(ipcp));
+	WARN_ON(IS_ERR(ipcp));
 
 	return container_of(ipcp, struct shmid_kernel, shm_perm);
 }
@@ -393,7 +393,7 @@ static int shm_mmap(struct file *file, s
 		return ret;
 	sfd->vm_ops = vma->vm_ops;
 #ifdef CONFIG_MMU
-	BUG_ON(!sfd->vm_ops->fault);
+	WARN_ON(!sfd->vm_ops->fault);
 #endif
 	vma->vm_ops = &shm_vm_ops;
 	shm_open(vma);
_

Patches currently in -mm which might be from dave@stgolabs.net are

ipc-convert-invalid-scenarios-to-use-warn_on.patch

