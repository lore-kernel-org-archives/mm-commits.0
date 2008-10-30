From: akpm@linux-foundation.org
Subject: + cifs-clean-up-server-protocol-handling-for-tcp_server_info.patch added to -mm tree
Date: Wed, 29 Oct 2008 17:10:23 -0700
Message-ID: <200810300010.m9U0ANQu019271@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755301AbYJ3AKi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Oct 2008 20:10:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com


The patch titled
     cifs: clean up server protocol handling for TCP_Server_Info
has been added to the -mm tree.  Its filename is
     cifs-clean-up-server-protocol-handling-for-tcp_server_info.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: clean up server protocol handling for TCP_Server_Info
From: Jeff Layton <jlayton@redhat.com>

We're currently declaring both a sockaddr_in and sockaddr6_in on the
stack, but we really only need storage for one of them.  Declare a
sockaddr struct and cast it to the proper type.  Also, eliminate the
protocolType field in the TCP_Server_Info struct.  It's redundant since we
have a sin_family field in the sockaddr anyway.

We may need to revisit this if SCTP is ever implemented, but for now this
will simplify the code.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsglob.h |    8 --------
 fs/cifs/connect.c  |   39 +++++++++++++++++++--------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff -puN fs/cifs/cifsglob.h~cifs-clean-up-server-protocol-handling-for-tcp_server_info fs/cifs/cifsglob.h
--- a/fs/cifs/cifsglob.h~cifs-clean-up-server-protocol-handling-for-tcp_server_info
+++ a/fs/cifs/cifsglob.h
@@ -84,13 +84,6 @@ enum securityEnum {
 	MSKerberos,		/* MS Kerberos via SPNEGO */
 };
 
-enum protocolEnum {
-	IPV4 = 0,
-	IPV6,
-	SCTP
-	/* Netbios frames protocol not supported at this time */
-};
-
 struct mac_key {
 	unsigned int len;
 	union {
@@ -137,7 +130,6 @@ struct TCP_Server_Info {
 	void *Server_NlsInfo;	/* BB - placeholder for future NLS info  */
 	unsigned short server_codepage;	/* codepage for the server    */
 	unsigned long ip_address;	/* IP addr for the server if known */
-	enum protocolEnum protocolType;
 	char versionMajor;
 	char versionMinor;
 	bool svlocal:1;			/* local server or remote */
diff -puN fs/cifs/connect.c~cifs-clean-up-server-protocol-handling-for-tcp_server_info fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-clean-up-server-protocol-handling-for-tcp_server_info
+++ a/fs/cifs/connect.c
@@ -189,7 +189,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 	while ((server->tcpStatus != CifsExiting) &&
 	       (server->tcpStatus != CifsGood)) {
 		try_to_freeze();
-		if (server->protocolType == IPV6) {
+		if (server->addr.sockAddr6.sin6_family == AF_INET6) {
 			rc = ipv6_connect(&server->addr.sockAddr6,
 					  &server->ssocket);
 		} else {
@@ -1873,10 +1873,10 @@ cifs_mount(struct super_block *sb, struc
 {
 	int rc = 0;
 	int xid;
-	int address_type = AF_INET;
 	struct socket *csocket = NULL;
-	struct sockaddr_in sin_server;
-	struct sockaddr_in6 sin_server6;
+	struct sockaddr addr;
+	struct sockaddr_in *sin_server = (struct sockaddr_in *) &addr;
+	struct sockaddr_in6 *sin_server6 = (struct sockaddr_in6 *) &addr;
 	struct smb_vol volume_info;
 	struct cifsSesInfo *pSesInfo = NULL;
 	struct cifsSesInfo *existingCifsSes = NULL;
@@ -1909,16 +1909,16 @@ cifs_mount(struct super_block *sb, struc
 
 	if (volume_info.UNCip && volume_info.UNC) {
 		rc = cifs_inet_pton(AF_INET, volume_info.UNCip,
-				    &sin_server.sin_addr.s_addr);
+				    &sin_server->sin_addr.s_addr);
 
 		if (rc <= 0) {
 			/* not ipv4 address, try ipv6 */
 			rc = cifs_inet_pton(AF_INET6, volume_info.UNCip,
-					    &sin_server6.sin6_addr.in6_u);
+					    &sin_server6->sin6_addr.in6_u);
 			if (rc > 0)
-				address_type = AF_INET6;
+				addr.sa_family = AF_INET6;
 		} else {
-			address_type = AF_INET;
+			addr.sa_family = AF_INET;
 		}
 
 		if (rc <= 0) {
@@ -1958,14 +1958,14 @@ cifs_mount(struct super_block *sb, struc
 		}
 	}
 
-	if (address_type == AF_INET)
-		existingCifsSes = cifs_find_tcp_session(&sin_server.sin_addr,
+	if (addr.sa_family == AF_INET)
+		existingCifsSes = cifs_find_tcp_session(&sin_server->sin_addr,
 			NULL /* no ipv6 addr */,
 			volume_info.username, &srvTcp);
-	else if (address_type == AF_INET6) {
+	else if (addr.sa_family == AF_INET6) {
 		cFYI(1, ("looking for ipv6 address"));
 		existingCifsSes = cifs_find_tcp_session(NULL /* no ipv4 addr */,
-			&sin_server6.sin6_addr,
+			&sin_server6->sin6_addr,
 			volume_info.username, &srvTcp);
 	} else {
 		rc = -EINVAL;
@@ -1976,16 +1976,16 @@ cifs_mount(struct super_block *sb, struc
 		cFYI(1, ("Existing tcp session with server found"));
 	} else {	/* create socket */
 		if (volume_info.port)
-			sin_server.sin_port = htons(volume_info.port);
+			sin_server->sin_port = htons(volume_info.port);
 		else
-			sin_server.sin_port = 0;
-		if (address_type == AF_INET6) {
+			sin_server->sin_port = 0;
+		if (addr.sa_family == AF_INET6) {
 			cFYI(1, ("attempting ipv6 connect"));
 			/* BB should we allow ipv6 on port 139? */
 			/* other OS never observed in Wild doing 139 with v6 */
-			rc = ipv6_connect(&sin_server6, &csocket);
+			rc = ipv6_connect(sin_server6, &csocket);
 		} else
-			rc = ipv4_connect(&sin_server, &csocket,
+			rc = ipv4_connect(sin_server, &csocket,
 				  volume_info.source_rfc1001_name,
 				  volume_info.target_rfc1001_name);
 		if (rc < 0) {
@@ -2002,12 +2002,11 @@ cifs_mount(struct super_block *sb, struc
 			sock_release(csocket);
 			goto out;
 		} else {
-			memcpy(&srvTcp->addr.sockAddr, &sin_server,
+			memcpy(&srvTcp->addr.sockAddr, sin_server,
 				sizeof(struct sockaddr_in));
 			atomic_set(&srvTcp->inFlight, 0);
 			/* BB Add code for ipv6 case too */
 			srvTcp->ssocket = csocket;
-			srvTcp->protocolType = IPV4;
 			srvTcp->hostname = extract_hostname(volume_info.UNC);
 			if (IS_ERR(srvTcp->hostname)) {
 				rc = PTR_ERR(srvTcp->hostname);
@@ -2059,7 +2058,7 @@ cifs_mount(struct super_block *sb, struc
 		else {
 			pSesInfo->server = srvTcp;
 			sprintf(pSesInfo->serverName, "%u.%u.%u.%u",
-				NIPQUAD(sin_server.sin_addr.s_addr));
+				NIPQUAD(sin_server->sin_addr.s_addr));
 		}
 
 		if (!rc) {
_

Patches currently in -mm which might be from jlayton@redhat.com are

cifs-clean-up-server-protocol-handling-for-tcp_server_info.patch

