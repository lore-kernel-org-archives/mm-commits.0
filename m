From: akpm@linux-foundation.org
Subject: - linux-atm_tcph-linux-atmh-cleanup-for-userspace.patch removed from -mm tree
Date: Fri, 16 May 2008 15:53:57 -0700
Message-ID: <200805162253.m4GMrvGG003185@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757282AbYEPWyA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 16 May 2008 18:54:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vapier@gentoo.org, mm-commits@vger.kernel.org


The patch titled
     linux/atm_tcp.h linux/atm.h: cleanup for userspace
has been removed from the -mm tree.  Its filename was
     linux-atm_tcph-linux-atmh-cleanup-for-userspace.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: linux/atm_tcp.h linux/atm.h: cleanup for userspace
From: Mike Frysinger <vapier@gentoo.org>

The atm_tcp.h uses types from linux/atm.h, but does not include it.  It
should also use the standard __u## types from linux/types.h rather than
the uint##_t types since the former can be found with the kernel already.

Same goes for linux/atm.h.  The linux/socket.h include there also gets
dropped as atm.h does not actually use anything from socket.h.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/atm.h     |    7 ++-----
 include/linux/atm_tcp.h |   12 +++++-------
 2 files changed, 7 insertions(+), 12 deletions(-)

diff -puN include/linux/atm.h~linux-atm_tcph-linux-atmh-cleanup-for-userspace include/linux/atm.h
--- a/include/linux/atm.h~linux-atm_tcph-linux-atmh-cleanup-for-userspace
+++ a/include/linux/atm.h
@@ -16,14 +16,11 @@
  * documentation. Do not change them.
  */
 
-#ifdef __KERNEL__
-#include <linux/socket.h>
-#include <linux/types.h>
-#endif
 #include <linux/compiler.h>
 #include <linux/atmapi.h>
 #include <linux/atmsap.h>
 #include <linux/atmioc.h>
+#include <linux/types.h>
 
 
 /* general ATM constants */
@@ -212,7 +209,7 @@ struct sockaddr_atmsvc {
         char		pub[ATM_E164_LEN+1]; /* public address (E.164) */
     					/* unused addresses must be bzero'ed */
 	char		lij_type;	/* role in LIJ call; one of ATM_LIJ* */
-	uint32_t	lij_id;		/* LIJ call identifier */
+	__u32	lij_id;		/* LIJ call identifier */
     } sas_addr __ATM_API_ALIGN;		/* SVC address */
 };
 
diff -puN include/linux/atm_tcp.h~linux-atm_tcph-linux-atmh-cleanup-for-userspace include/linux/atm_tcp.h
--- a/include/linux/atm_tcp.h~linux-atm_tcph-linux-atmh-cleanup-for-userspace
+++ a/include/linux/atm_tcp.h
@@ -8,11 +8,9 @@
 #define LINUX_ATM_TCP_H
 
 #include <linux/atmapi.h>
-
-#ifdef __KERNEL__
-#include <linux/types.h>
-#endif
+#include <linux/atm.h>
 #include <linux/atmioc.h>
+#include <linux/types.h>
 
 
 /*
@@ -20,9 +18,9 @@
  */
 
 struct atmtcp_hdr {
-	uint16_t	vpi;
-	uint16_t	vci;
-	uint32_t	length;		/* ... of data part */
+	__u16	vpi;
+	__u16	vci;
+	__u32	length;		/* ... of data part */
 };
 
 /*
_

Patches currently in -mm which might be from vapier@gentoo.org are

origin.patch
linux-next.patch

