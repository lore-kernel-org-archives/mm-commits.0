From: akpm@linux-foundation.org
Subject: + ipc-rename-ipc_obtain_object.patch added to -mm tree
Date: Tue, 09 Jun 2015 15:24:23 -0700
Message-ID: <55776797.h+Fb4RFUDQU1WBLJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbbFIWYY (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 9 Jun 2015 18:24:24 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc: rename ipc_obtain_object
has been added to the -mm tree.  Its filename is
     ipc-rename-ipc_obtain_object.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ipc-rename-ipc_obtain_object.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ipc-rename-ipc_obtain_object.patch

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
Subject: ipc: rename ipc_obtain_object

...  to ipc_obtain_object_idr, which is more meaningful and makes the code
slightly easier to follow.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/msg.c  |    2 +-
 ipc/sem.c  |    4 ++--
 ipc/shm.c  |    2 +-
 ipc/util.c |    8 ++++----
 ipc/util.h |    2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff -puN ipc/msg.c~ipc-rename-ipc_obtain_object ipc/msg.c
--- a/ipc/msg.c~ipc-rename-ipc_obtain_object
+++ a/ipc/msg.c
@@ -76,7 +76,7 @@ struct msg_sender {
 
 static inline struct msg_queue *msq_obtain_object(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_obtain_object(&msg_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_idr(&msg_ids(ns), id);
 
 	if (IS_ERR(ipcp))
 		return ERR_CAST(ipcp);
diff -puN ipc/sem.c~ipc-rename-ipc_obtain_object ipc/sem.c
--- a/ipc/sem.c~ipc-rename-ipc_obtain_object
+++ a/ipc/sem.c
@@ -391,7 +391,7 @@ static inline struct sem_array *sem_obta
 	struct kern_ipc_perm *ipcp;
 	struct sem_array *sma;
 
-	ipcp = ipc_obtain_object(&sem_ids(ns), id);
+	ipcp = ipc_obtain_object_idr(&sem_ids(ns), id);
 	if (IS_ERR(ipcp))
 		return ERR_CAST(ipcp);
 
@@ -410,7 +410,7 @@ static inline struct sem_array *sem_obta
 
 static inline struct sem_array *sem_obtain_object(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_obtain_object(&sem_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_idr(&sem_ids(ns), id);
 
 	if (IS_ERR(ipcp))
 		return ERR_CAST(ipcp);
diff -puN ipc/shm.c~ipc-rename-ipc_obtain_object ipc/shm.c
--- a/ipc/shm.c~ipc-rename-ipc_obtain_object
+++ a/ipc/shm.c
@@ -129,7 +129,7 @@ void __init shm_init(void)
 
 static inline struct shmid_kernel *shm_obtain_object(struct ipc_namespace *ns, int id)
 {
-	struct kern_ipc_perm *ipcp = ipc_obtain_object(&shm_ids(ns), id);
+	struct kern_ipc_perm *ipcp = ipc_obtain_object_idr(&shm_ids(ns), id);
 
 	if (IS_ERR(ipcp))
 		return ERR_CAST(ipcp);
diff -puN ipc/util.c~ipc-rename-ipc_obtain_object ipc/util.c
--- a/ipc/util.c~ipc-rename-ipc_obtain_object
+++ a/ipc/util.c
@@ -555,7 +555,7 @@ void ipc64_perm_to_ipc_perm(struct ipc64
  * Call inside the RCU critical section.
  * The ipc object is *not* locked on exit.
  */
-struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id)
+struct kern_ipc_perm *ipc_obtain_object_idr(struct ipc_ids *ids, int id)
 {
 	struct kern_ipc_perm *out;
 	int lid = ipcid_to_idx(id);
@@ -581,7 +581,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	struct kern_ipc_perm *out;
 
 	rcu_read_lock();
-	out = ipc_obtain_object(ids, id);
+	out = ipc_obtain_object_idr(ids, id);
 	if (IS_ERR(out))
 		goto err1;
 
@@ -605,7 +605,7 @@ err1:
  * @ids: ipc identifier set
  * @id: ipc id to look for
  *
- * Similar to ipc_obtain_object() but also checks
+ * Similar to ipc_obtain_object_idr() but also checks
  * the ipc object reference counter.
  *
  * Call inside the RCU critical section.
@@ -613,7 +613,7 @@ err1:
  */
 struct kern_ipc_perm *ipc_obtain_object_check(struct ipc_ids *ids, int id)
 {
-	struct kern_ipc_perm *out = ipc_obtain_object(ids, id);
+	struct kern_ipc_perm *out = ipc_obtain_object_idr(ids, id);
 
 	if (IS_ERR(out))
 		goto out;
diff -puN ipc/util.h~ipc-rename-ipc_obtain_object ipc/util.h
--- a/ipc/util.h~ipc-rename-ipc_obtain_object
+++ a/ipc/util.h
@@ -132,7 +132,7 @@ void ipc_rcu_putref(void *ptr, void (*fu
 void ipc_rcu_free(struct rcu_head *head);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
-struct kern_ipc_perm *ipc_obtain_object(struct ipc_ids *ids, int id);
+struct kern_ipc_perm *ipc_obtain_object_idr(struct ipc_ids *ids, int id);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
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

