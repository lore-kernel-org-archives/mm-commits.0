From: akpm@linux-foundation.org
Subject: [patch 85/94] sysvipc: properly name ipc_addid() limit
 parameter
Date: Fri, 17 Nov 2017 15:31:15 -0800
Message-ID: <20171117233115.gXvqE5enC%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:56162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966968AbdKQXbQ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:31:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dave@stgolabs.net, dbueso@suse.de, manfred@colorfullife.com, mm-commits@vger.kernel.org, torvalds@linux-foundation.org

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
