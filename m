From: akpm@linux-foundation.org
Subject: - cifs-find_unc-cleanup.patch removed from -mm tree
Date: Tue, 06 May 2008 21:49:00 -0700
Message-ID: <200805070449.m474n0ug012014@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37939 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753967AbYEGEtE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 May 2008 00:49:04 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: gorcunov@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: find_unc() cleanup
has been removed from the -mm tree.  Its filename was
     cifs-find_unc-cleanup.patch

This patch was dropped because it no longer applies

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: find_unc() cleanup
From: Cyrill Gorcunov <gorcunov@gmail.com>

Remove over-indented code in find_unc().

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/connect.c |   64 +++++++++++++++++++++-----------------------
 1 file changed, 31 insertions(+), 33 deletions(-)

diff -puN fs/cifs/connect.c~cifs-find_unc-cleanup fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-find_unc-cleanup
+++ a/fs/cifs/connect.c
@@ -1362,45 +1362,43 @@ find_unc(__be32 new_target_ip_addr, char
 {
 	struct list_head *tmp;
 	struct cifsTconInfo *tcon;
+	__be32 old_ip;
 
 	read_lock(&GlobalSMBSeslock);
+
 	list_for_each(tmp, &GlobalTreeConnectionList) {
 		cFYI(1, ("Next tcon"));
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
-		if (tcon->ses) {
-			if (tcon->ses->server) {
-				cFYI(1,
-				     ("old ip addr: %x == new ip %x ?",
-				      tcon->ses->server->addr.sockAddr.sin_addr.
-				      s_addr, new_target_ip_addr));
-				if (tcon->ses->server->addr.sockAddr.sin_addr.
-				    s_addr == new_target_ip_addr) {
-	/* BB lock tcon, server and tcp session and increment use count here? */
-					/* found a match on the TCP session */
-					/* BB check if reconnection needed */
-					cFYI(1,
-					      ("IP match, old UNC: %s new: %s",
-					      tcon->treeName, uncName));
-					if (strncmp
-					    (tcon->treeName, uncName,
-					     MAX_TREE_SIZE) == 0) {
-						cFYI(1,
-						     ("and old usr: %s new: %s",
-						      tcon->treeName, uncName));
-						if (strncmp
-						    (tcon->ses->userName,
-						     userName,
-						     MAX_USERNAME_SIZE) == 0) {
-							read_unlock(&GlobalSMBSeslock);
-							/* matched smb session
-							(user name */
-							return tcon;
-						}
-					}
-				}
-			}
-		}
+		if (!tcon->ses || !tcon->ses->server)
+			continue;
+
+		old_ip = tcon->ses->server->addr.sockAddr.sin_addr.s_addr;
+		cFYI(1, ("old ip addr: %x == new ip %x ?",
+			old_ip, new_target_ip_addr));
+
+		if (old_ip != new_target_ip_addr)
+			continue;
+
+		/* BB lock tcon, server and tcp session and increment use count here? */
+		/* found a match on the TCP session */
+		/* BB check if reconnection needed */
+		cFYI(1, ("IP match, old UNC: %s new: %s",
+			tcon->treeName, uncName));
+
+		if (strncmp(tcon->treeName, uncName, MAX_TREE_SIZE))
+			continue;
+
+		cFYI(1, ("and old usr: %s new: %s",
+			tcon->treeName, uncName));
+
+		if (strncmp(tcon->ses->userName, userName, MAX_USERNAME_SIZE))
+			continue;
+
+		/* matched smb session (user name) */
+		read_unlock(&GlobalSMBSeslock);
+		return tcon;
 	}
+
 	read_unlock(&GlobalSMBSeslock);
 	return NULL;
 }
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
uml-use-page_size-in-linker-scripts.patch
linux-next.patch
git-cifs.patch
cifs-find_unc-cleanup.patch
mips-elf-handling-use-selfmag-instead-of-numeric-constant.patch
module-loading-elf-handling-use-selfmag-instead-of-numeric-constant.patch

