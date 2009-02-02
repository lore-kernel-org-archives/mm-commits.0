From: akpm@linux-foundation.org
Subject: [merged] cifs-use-ipv6_addr_equal-for-address-comparison.patch removed from -mm tree
Date: Mon, 02 Feb 2009 11:36:58 -0800
Message-ID: <200902021936.n12Jaweu013573@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752919AbZBBThP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 2 Feb 2009 14:37:15 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jlayton@redhat.com, smfrench@gmail.com, mm-commits@vger.kernel.org


The patch titled
     cifs: use ipv6_addr_equal for address comparison
has been removed from the -mm tree.  Its filename was
     cifs-use-ipv6_addr_equal-for-address-comparison.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: use ipv6_addr_equal for address comparison
From: Jeff Layton <jlayton@redhat.com>

Signed-off-by: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <smfrench@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/connect.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN fs/cifs/connect.c~cifs-use-ipv6_addr_equal-for-address-comparison fs/cifs/connect.c
--- a/fs/cifs/connect.c~cifs-use-ipv6_addr_equal-for-address-comparison
+++ a/fs/cifs/connect.c
@@ -23,7 +23,6 @@
 #include <linux/string.h>
 #include <linux/list.h>
 #include <linux/wait.h>
-#include <linux/ipv6.h>
 #include <linux/pagemap.h>
 #include <linux/ctype.h>
 #include <linux/utsname.h>
@@ -35,6 +34,7 @@
 #include <linux/freezer.h>
 #include <asm/uaccess.h>
 #include <asm/processor.h>
+#include <net/ipv6.h>
 #include "cifspdu.h"
 #include "cifsglob.h"
 #include "cifsproto.h"
@@ -1379,8 +1379,8 @@ cifs_find_tcp_session(struct sockaddr_st
 		     server->addr.sockAddr.sin_addr.s_addr))
 			continue;
 		else if (addr->ss_family == AF_INET6 &&
-			 memcmp(&server->addr.sockAddr6.sin6_addr,
-				&addr6->sin6_addr, sizeof(addr6->sin6_addr)))
+			 !ipv6_addr_equal(&server->addr.sockAddr6.sin6_addr,
+					  &addr6->sin6_addr))
 			continue;
 
 		++server->srv_count;
_

Patches currently in -mm which might be from jlayton@redhat.com are

origin.patch
linux-next.patch

