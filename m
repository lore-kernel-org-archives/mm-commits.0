From: akpm@linux-foundation.org
Subject: + ipc-inline-ipc_buildid.patch added to -mm tree
Date: Mon, 10 Sep 2007 13:15:09 -0700
Message-ID: <200709102015.l8AKF9rW008731@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50714 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564AbXIJUPn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 10 Sep 2007 16:15:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: Nadia.Derbey@bull.net


The patch titled
     ipc: inline ipc_buildid()
has been added to the -mm tree.  Its filename is
     ipc-inline-ipc_buildid.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: ipc: inline ipc_buildid()
From: Nadia Derbey <Nadia.Derbey@bull.net>

This is a trivial patch that changes the ipc_buildid() routine into a static
inline.

Signed-off-by: Nadia Derbey <Nadia.Derbey@bull.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/util.c |    5 -----
 ipc/util.h |    6 +++++-
 2 files changed, 5 insertions(+), 6 deletions(-)

diff -puN ipc/util.c~ipc-inline-ipc_buildid ipc/util.c
--- a/ipc/util.c~ipc-inline-ipc_buildid
+++ a/ipc/util.c
@@ -695,11 +695,6 @@ struct kern_ipc_perm *ipc_lock(struct ip
 	return out;
 }
 
-int ipc_buildid(struct ipc_ids* ids, int id, int seq)
-{
-	return SEQ_MULTIPLIER*seq + id;
-}
-
 #ifdef __ARCH_WANT_IPC_PARSE_VERSION
 
 
diff -puN ipc/util.h~ipc-inline-ipc_buildid ipc/util.h
--- a/ipc/util.h~ipc-inline-ipc_buildid
+++ a/ipc/util.h
@@ -106,7 +106,6 @@ void ipc_rcu_getref(void *ptr);
 void ipc_rcu_putref(void *ptr);
 
 struct kern_ipc_perm *ipc_lock(struct ipc_ids *, int);
-int ipc_buildid(struct ipc_ids* ids, int id, int seq);
 
 void kernel_to_ipc64_perm(struct kern_ipc_perm *in, struct ipc64_perm *out);
 void ipc64_perm_to_ipc_perm(struct ipc64_perm *in, struct ipc_perm *out);
@@ -126,6 +125,11 @@ extern int ipcget_new(struct ipc_namespa
 extern int ipcget_public(struct ipc_namespace *, struct ipc_ids *,
 			struct ipc_ops *, struct ipc_params *);
 
+static inline int ipc_buildid(struct ipc_ids *ids, int id, int seq)
+{
+	return SEQ_MULTIPLIER * seq + id;
+}
+
 static inline int ipc_checkid(struct ipc_ids *ids, struct kern_ipc_perm *ipcp,
 				int uid)
 {
_

Patches currently in -mm which might be from Nadia.Derbey@bull.net are

ipc-store-ipcs-into-idrs.patch
ipc-unify-the-syscalls-code.patch
ipc-remove-the-ipc_get-routine.patch
ipc-integrate-ipc_checkid-into-ipc_lock.patch
ipc-introduce-the-ipcid_to_idx-macro.patch
ipc-inline-ipc_buildid.patch
