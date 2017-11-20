From: akpm@linux-foundation.org
Subject: [merged]
 sysvipc-properly-name-ipc_addid-limit-parameter.patch removed from -mm tree
Date: Mon, 20 Nov 2017 13:26:51 -0800
Message-ID: <20171120212651.ljeTaKvv-%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40984 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753146AbdKTV0w (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 20 Nov 2017 16:26:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org


The patch titled
     Subject: sysvipc: properly name ipc_addid() limit parameter
has been removed from the -mm tree.  Its filename was
     sysvipc-properly-name-ipc_addid-limit-parameter.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
@@ -262,7 +262,7 @@ static inline int ipc_buildid(int id, st
  * ipc_addid - add an ipc identifier
  * @ids: ipc identifier set
  * @new: new ipc permission set
- * @size: limit for the number of used ids
+ * @limit: limit for the number of used ids
  *
  * Add an entry 'new' to the ipc ids idr. The permissions object is
  * initialised and the first free entry is set up and the id assigned
@@ -271,16 +271,16 @@ static inline int ipc_buildid(int id, st
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


