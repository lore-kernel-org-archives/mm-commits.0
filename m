From: akpm@linux-foundation.org
Subject: + cifs-use-ipv6_addr_equal-for-address-comparison.patch added to -mm tree
Date: Fri, 30 Jan 2009 12:07:19 -0800
Message-ID: <200901302007.n0UK7JPu028404@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60085 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754107AbZA3UIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 30 Jan 2009 15:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jlayton@redhat.com, smfrench@gmail.com


The patch titled
     cifs: use ipv6_addr_equal for address comparison
has been added to the -mm tree.  Its filename is
     cifs-use-ipv6_addr_equal-for-address-comparison.patch

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
cifs-use-ipv6_addr_equal-for-address-comparison.patch

