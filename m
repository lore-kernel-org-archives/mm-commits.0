From: akpm@linux-foundation.org
Subject: +
 ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch added to
 -mm tree
Date: Tue, 09 Jun 2015 15:24:25 -0700
Message-ID: <55776799.zELfsripR8PrOrMw%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753352AbbFIWY0 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:24:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc,sysv: make return -EIDRM when racing with RMID consistent
has been added to the -mm tree.  Its filename is
     ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch

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
Subject: ipc,sysv: make return -EIDRM when racing with RMID consistent

The ipc_lock helper is used by all forms of sysv ipc to acquire the ipc
object's spinlock.  Upon error (bogus identifier), we always return
-EINVAL, whether the problem be in the idr path or because we raced with a
task performing RMID.  For the later, however, all ipc related manpages,
state the that for:

       EIDRM  <ID> points to a removed identifier.

And return:

       EINVAL Invalid <ID> value, or unaligned, etc.

Which (EINVAL) should only return once the ipc resource is deleted.  For
all types of ipc this is done immediately upon a RMID command.  However,
shared memory behaves slightly different as it can merely mark a segment
for deletion, and delay the actual freeing until there are no more active
consumers.  Per shmctl(IPC_RMID) manpage:

""
Mark  the  segment to be destroyed.  The segment will only actually
be destroyed after the last process detaches it (i.e., when the
shm_nattch member of the associated structure shmid_ds is zero).
""

Unlike ipc_lock, paths that behave "correctly", at least per the manpage,
involve controlling the ipc resource via *ctl(), doing the exact same
validity check as ipc_lock after right acquiring the spinlock:

	if (!ipc_valid_object()) {
		err = -EIDRM;
		goto out_unlock;
	}

Thus make ipc_lock consistent with the rest of ipc code and return -EIDRM
in ipc_lock when !ipc_valid_object().

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent ipc/util.c
--- a/ipc/util.c~ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent
+++ a/ipc/util.c
@@ -583,19 +583,22 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	rcu_read_lock();
 	out = ipc_obtain_object_idr(ids, id);
 	if (IS_ERR(out))
-		goto err1;
+		goto err;
 
 	spin_lock(&out->lock);
 
-	/* ipc_rmid() may have already freed the ID while ipc_lock
-	 * was spinning: here verify that the structure is still valid
+	/*
+	 * ipc_rmid() may have already freed the ID while ipc_lock()
+	 * was spinning: here verify that the structure is still valid.
+	 * Upon races with RMID, return -EIDRM, thus indicating that
+	 * the ID points to a removed identifier.
 	 */
 	if (ipc_valid_object(out))
 		return out;
 
 	spin_unlock(&out->lock);
-	out = ERR_PTR(-EINVAL);
-err1:
+	out = ERR_PTR(-EIDRM);
+err:
 	rcu_read_unlock();
 	return out;
 }
_

Patches currently in -mm which might be from dave@stgolabs.net are

mm-hugetlb-document-the-reserve-map-region-tracking-routines.patch
mm-hugetlb-compute-return-the-number-of-regions-added-by-region_add.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages.patch
mm-hugetlb-handle-races-in-alloc_huge_page-and-hugetlb_reserve_pages-v4.patch
ipcshm-move-bug_on-check-into-shm_lock.patch
ipcmsg-provide-barrier-pairings-for-lockless-receive.patch
ipc-rename-ipc_obtain_object.patch
ipcsysv-make-return-eidrm-when-racing-with-rmid-consistent.patch
ipcsysv-return-einval-upon-incorrect-id-seqnum.patch
linux-next.patch

