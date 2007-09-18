From: akpm@linux-foundation.org
Subject: + ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch added to -mm tree
Date: Tue, 18 Sep 2007 10:01:28 -0700
Message-ID: <200709181701.l8IH1Sml014042@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39353 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758311AbXIRRCC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 18 Sep 2007 13:02:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     IPC: sleeping function called ...
has been added to the -mm tree.  Its filename is
     ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: IPC: sleeping function called ...
From: Nadia Derbey <Nadia.Derbey@bull.net>

This patch fixes the missing rcu_read_(un)lock in the ipc code

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    3 ++-
 ipc/util.h |    4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff -puN ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-3 ipc/util.c
--- a/ipc/util.c~ipc-integrate-ipc_checkid-into-ipc_lock-fix-3
+++ a/ipc/util.c
@@ -295,6 +295,7 @@ int ipc_addid(struct ipc_ids* ids, struc
 
 	spin_lock_init(&new->lock);
 	new->deleted = 0;
+	rcu_read_lock();
 	spin_lock(&new->lock);
 	return id;
 }
@@ -690,7 +691,7 @@ struct kern_ipc_perm *ipc_lock(struct ip
 		rcu_read_unlock();
 		return ERR_PTR(-EINVAL);
 	}
-	rcu_read_unlock();
+
 	return out;
 }
 
diff -puN ipc/util.h~ipc-integrate-ipc_checkid-into-ipc_lock-fix-3 ipc/util.h
--- a/ipc/util.h~ipc-integrate-ipc_checkid-into-ipc_lock-fix-3
+++ a/ipc/util.h
@@ -135,12 +135,14 @@ static inline int ipc_checkid(struct ipc
 
 static inline void ipc_lock_by_ptr(struct kern_ipc_perm *perm)
 {
+	rcu_read_lock();
 	spin_lock(&perm->lock);
 }
 
 static inline void ipc_unlock(struct kern_ipc_perm *perm)
 {
 	spin_unlock(&perm->lock);
+	rcu_read_unlock();
 }
 
 static inline struct kern_ipc_perm *ipc_lock_check(struct ipc_ids *ids,
@@ -153,7 +155,7 @@ static inline struct kern_ipc_perm *ipc_
 		return out;
 
 	if (ipc_checkid(ids, out, id)) {
-		spin_unlock(&out->lock);
+		ipc_unlock(out);
 		return ERR_PTR(-EIDRM);
 	}
 
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-store-ipcs-into-idrs.patch
ipc-unify-the-syscalls-code.patch
ipc-remove-the-ipc_get-routine.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-2.patch
ipc-integrate-ipc_checkid-into-ipc_lock-fix-3.patch
storing-ipcs-into-idrs.patch
ipc-introduce-the-ipcid_to_idx-macro.patch
ipc-inline-ipc_buildid.patch
