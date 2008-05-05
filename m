From: akpm@linux-foundation.org
Subject: + cifs-cifs_find_tcp_session-cleanup.patch added to -mm tree
Date: Mon, 05 May 2008 12:56:10 -0700
Message-ID: <200805051956.m45JuAD4002039@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35673 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753186AbYEET4O (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 5 May 2008 15:56:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: gorcunov@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: cifs_find_tcp_session() cleanup
has been added to the -mm tree.  Its filename is
     cifs-cifs_find_tcp_session-cleanup.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: cifs_find_tcp_session() cleanup
From: Cyrill Gorcunov <gorcunov@gmail.com>

Remove over-indented code in cifs_find_tcp_session.

Also memcmp was used wrongly - we would have found the session which IP6
addresses didn't match.

Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/connect.c |   56 ++++++++++++++++++++++----------------------
 1 file changed, 29 insertions(+), 27 deletions(-)

diff -puN fs/cifs/connect.c~cifs-cifs_find_tcp_session-cleanup fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-cifs_find_tcp_session-cleanup
+++ a/fs/cifs/connect.c
@@ -1318,42 +1318,44 @@ cifs_parse_mount_options(char *options, 
 
 static struct cifsSesInfo *
 cifs_find_tcp_session(struct in_addr *target_ip_addr,
-		struct in6_addr *target_ip6_addr,
-		 char *userName, struct TCP_Server_Info **psrvTcp)
+		      struct in6_addr *target_ip6_addr,
+		      char *userName, struct TCP_Server_Info **psrvTcp)
 {
 	struct list_head *tmp;
 	struct cifsSesInfo *ses;
+
 	*psrvTcp = NULL;
-	read_lock(&GlobalSMBSeslock);
 
+	if (!target_ip_addr)
+		return NULL;
+
+	read_lock(&GlobalSMBSeslock);
 	list_for_each(tmp, &GlobalSMBSessionList) {
 		ses = list_entry(tmp, struct cifsSesInfo, cifsSessionList);
-		if (ses->server) {
-			if ((target_ip_addr &&
-				(ses->server->addr.sockAddr.sin_addr.s_addr
-				  == target_ip_addr->s_addr)) || (target_ip6_addr
-				&& memcmp(&ses->server->addr.sockAddr6.sin6_addr,
-					target_ip6_addr, sizeof(*target_ip6_addr)))) {
-				/* BB lock server and tcp session and increment
-				      use count here?? */
-
-				/* found a match on the TCP session */
-				*psrvTcp = ses->server;
-
-				/* BB check if reconnection needed */
-				if (strncmp
-				    (ses->userName, userName,
-				     MAX_USERNAME_SIZE) == 0){
-					read_unlock(&GlobalSMBSeslock);
-					/* Found exact match on both TCP and
-					   SMB sessions */
-					return ses;
-				}
-			}
-		}
-		/* else tcp and smb sessions need reconnection */
+		if (!ses->server)
+			continue;
+
+		if (ses->server->addr.sockAddr.sin_addr.s_addr != target_ip_addr->s_addr ||
+		    memcmp(&ses->server->addr.sockAddr6.sin6_addr,
+			   target_ip6_addr, sizeof(*target_ip6_addr)))
+			continue;
+
+		/* BB lock server and tcp session and increment
+		   use count here?? */
+
+		/* found a match on the TCP session */
+		*psrvTcp = ses->server;
+
+		/* BB check if reconnection needed */
+		if (strncmp(ses->userName, userName, MAX_USERNAME_SIZE))
+			continue;
+
+		/* Found exact match on both TCP and SMB sessions */
+		read_unlock(&GlobalSMBSeslock);
+		return ses;
 	}
 	read_unlock(&GlobalSMBSeslock);
+
 	return NULL;
 }
 
_

Patches currently in -mm which might be from gorcunov@gmail.com are

origin.patch
linux-next.patch
cifs-find_unc-cleanup.patch
cifs-cifs_find_tcp_session-cleanup.patch

