From: akpm@osdl.org
Subject: - allow-cifsd-to-suspend-if-connection-is-lost.patch removed from -mm tree
Date: Fri, 08 Dec 2006 03:04:21 -0800
Message-ID: <200612081104.kB8B4LfA018545@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:49562 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1425402AbWLHLLq (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 8 Dec 2006 06:11:46 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rjw@sisk.pl, pavel@ucw.cz, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     Allow cifsd to suspend if connection is lost
has been removed from the -mm tree.  Its filename was
     allow-cifsd-to-suspend-if-connection-is-lost.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Allow cifsd to suspend if connection is lost
From: "Rafael J. Wysocki" <rjw@sisk.pl>

Make cifsd allow us to suspend if it has lost the connection with the server.

Ref. http://bugzilla.kernel.org/show_bug.cgi?id=6811

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Acked-by: Pavel Machek <pavel@ucw.cz>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 fs/cifs/connect.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/cifs/connect.c~allow-cifsd-to-suspend-if-connection-is-lost fs/cifs/connect.c
--- a/fs/cifs/connect.c~allow-cifsd-to-suspend-if-connection-is-lost
+++ a/fs/cifs/connect.c
@@ -182,6 +182,7 @@ cifs_reconnect(struct TCP_Server_Info *s
 
 	while ((server->tcpStatus != CifsExiting) && (server->tcpStatus != CifsGood))
 	{
+		try_to_freeze();
 		if(server->protocolType == IPV6) {
 			rc = ipv6_connect(&server->addr.sockAddr6,&server->ssocket);
 		} else {
_

Patches currently in -mm which might be from rjw@sisk.pl are

origin.patch
git-acpi.patch
md-change-lifetime-rules-for-md-devices.patch

