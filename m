From: akpm@linux-foundation.org
Subject: + sysvipc-properly-name-ipc_addid-limit-parameter.patch added to
 -mm tree
Date: Tue, 03 Oct 2017 14:59:52 -0700
Message-ID: <59d40858.sFKdmLNpPbF1WY0E%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53738 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751172AbdJCV7x (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 3 Oct 2017 17:59:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: properly name ipc_addid() limit parameter
has been added to the -mm tree.  Its filename is
     sysvipc-properly-name-ipc_addid-limit-parameter.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/sysvipc-properly-name-ipc_addid-limit-parameter.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/sysvipc-properly-name-ipc_addid-limit-parameter.patch

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
Subject: sysvipc: properly name ipc_addid() limit parameter

This is better understood as a limit, instead of size; exactly like the
function comment indicates.  Rename it.

Link: http://lkml.kernel.org/r/20170831172049.14576-4-dave@stgolabs.net
Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff -puN ipc/util.c~sysvipc-properly-name-ipc_addid-limit-parameter ipc/util.c
--- a/ipc/util.c~sysvipc-properly-name-ipc_addid-limit-parameter
+++ a/ipc/util.c
@@ -261,7 +261,7 @@ static inline int ipc_buildid(int id, st
  * ipc_addid - add an ipc identifier
  * @ids: ipc identifier set
  * @new: new ipc permission set
- * @size: limit for the number of used ids
+ * @limit: limit for the number of used ids
  *
  * Add an entry 'new' to the ipc ids idr. The permissions object is
  * initialised and the first free entry is set up and the id assigned
@@ -270,16 +270,16 @@ static inline int ipc_buildid(int id, st
  *
  * Called with writer ipc_ids.rwsem held.
  */
-int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int size)
+int ipc_addid(struct ipc_ids *ids, struct kern_ipc_perm *new, int limit)
 {
 	kuid_t euid;
 	kgid_t egid;
 	int id, err;
 
-	if (size > IPCMNI)
-		size = IPCMNI;
+	if (limit > IPCMNI)
+		limit = IPCMNI;
 
-	if (!ids->tables_initialized || ids->in_use >= size)
+	if (!ids->tables_initialized || ids->in_use >= limit)
 		return -ENOSPC;
 
 	idr_preload(GFP_KERNEL);
_

Patches currently in -mm which might be from dave@stgolabs.net are

mmcompaction-serialize-waitqueue_active-checks-for-real.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore.patch
sysvipc-duplicate-lock-comments-wrt-ipc_addid.patch
sysvipc-properly-name-ipc_addid-limit-parameter.patch
sysvipc-make-get_maxid-o1-again.patch

