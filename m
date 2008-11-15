From: akpm@linux-foundation.org
Subject: - cifs-remove-global_extern-macro.patch removed from -mm tree
Date: Fri, 14 Nov 2008 20:48:50 -0800
Message-ID: <200811150448.mAF4mppr018471@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752041AbYKOEsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 14 Nov 2008 23:48:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, sfrench@us.ibm.com, mm-commits@vger.kernel.org


The patch titled
     cifs: remove GLOBAL_EXTERN macro
has been removed from the -mm tree.  Its filename was
     cifs-remove-global_extern-macro.patch

This patch was dropped because everyone hates me

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: cifs: remove GLOBAL_EXTERN macro
From: Harvey Harrison <harvey.harrison@gmail.com>

Global variables should be defined in C files, not in headers.

1) Comment out unused vars
GlobalDnotifyRsp_Q
GlobalUidList

2) Declare vars in cifsfs.c that need it and change to extern in
cifsglob.h

3) Change to extern in cifsglob.h for vars that were already being
declared in cifsfs.c

4) Remove GLOBAL_EXTERN

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsfs.c   |   31 +++++++++++++++++-
 fs/cifs/cifsglob.h |   73 +++++++++++++++++++------------------------
 2 files changed, 62 insertions(+), 42 deletions(-)

diff -puN fs/cifs/cifsfs.c~cifs-remove-global_extern-macro fs/cifs/cifsfs.c
--- a/fs/cifs/cifsfs.c~cifs-remove-global_extern-macro
+++ a/fs/cifs/cifsfs.c
@@ -37,7 +37,6 @@
 #include <linux/freezer.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
-#define DECLARE_GLOBALS_HERE
 #include "cifsglob.h"
 #include "cifsproto.h"
 #include "cifs_debug.h"
@@ -85,6 +84,34 @@ module_param(cifs_max_pending, int, 0);
 MODULE_PARM_DESC(cifs_max_pending, "Simultaneous requests to server. "
 				   "Default: 50 Range: 2 to 256");
 
+struct list_head GlobalSMBSessionList;
+struct list_head GlobalTreeConnectionList;
+rwlock_t GlobalSMBSeslock;
+
+struct list_head GlobalOplock_Q;
+
+struct list_head GlobalDnotifyReqList;
+
+unsigned int GlobalCurrentXid;
+unsigned int GlobalTotalActiveXid;
+unsigned int GlobalMaxActiveXid;
+spinlock_t GlobalMid_Lock;
+char Local_System_Name[15];
+
+atomic_t sesInfoAllocCount;
+atomic_t tconInfoAllocCount;
+atomic_t tcpSesAllocCount;
+atomic_t tcpSesReconnectCount;
+atomic_t tconInfoReconnectCount;
+
+atomic_t bufAllocCount;    /* current number allocated  */
+#ifdef CONFIG_CIFS_STATS2
+atomic_t totBufAllocCount; /* total allocated over all time */
+atomic_t totSmBufAllocCount;
+#endif
+atomic_t smBufAllocCount;
+atomic_t midCount;
+
 extern mempool_t *cifs_sm_req_poolp;
 extern mempool_t *cifs_req_poolp;
 extern mempool_t *cifs_mid_poolp;
@@ -1065,7 +1092,7 @@ init_cifs(void)
 	INIT_LIST_HEAD(&GlobalOplock_Q);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	INIT_LIST_HEAD(&GlobalDnotifyReqList);
-	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q);
+/*	INIT_LIST_HEAD(&GlobalDnotifyRsp_Q); */
 #endif
 /*
  *  Initialize Global counters
diff -puN fs/cifs/cifsglob.h~cifs-remove-global_extern-macro fs/cifs/cifsglob.h
--- a/fs/cifs/cifsglob.h~cifs-remove-global_extern-macro
+++ a/fs/cifs/cifsglob.h
@@ -586,72 +586,65 @@ require use of the stronger protocol */
  *
  ****************************************************************************/
 
-#ifdef DECLARE_GLOBALS_HERE
-#define GLOBAL_EXTERN
-#else
-#define GLOBAL_EXTERN extern
-#endif
-
-
 /* the list of TCP_Server_Info structures, ie each of the sockets
  * connecting our client to a distinct server (ip address), is
  * chained together by global_cifs_sock_list. The list of all our SMB
  * sessions (and from that the tree connections) can be found
  * by iterating over global_cifs_sock_list */
-GLOBAL_EXTERN struct list_head global_cifs_sock_list;
-GLOBAL_EXTERN struct list_head GlobalSMBSessionList; /* BB to be removed by jl*/
-GLOBAL_EXTERN struct list_head GlobalTreeConnectionList; /* BB to be removed */
-GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
+extern struct list_head global_cifs_sock_list;
+extern struct list_head GlobalSMBSessionList; /* BB to be removed by jl*/
+extern struct list_head GlobalTreeConnectionList; /* BB to be removed */
+extern rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 
-GLOBAL_EXTERN struct list_head GlobalOplock_Q;
+extern struct list_head GlobalOplock_Q;
 
 /* Outstanding dir notify requests */
-GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
+extern struct list_head GlobalDnotifyReqList;
 /* DirNotify response queue */
-GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
+extern struct list_head GlobalDnotifyRsp_Q;
 
 /*
  * Global transaction id (XID) information
  */
-GLOBAL_EXTERN unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
-GLOBAL_EXTERN unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
-GLOBAL_EXTERN spinlock_t GlobalMid_Lock;  /* protects above & list operations */
+extern unsigned int GlobalCurrentXid;	/* protected by GlobalMid_Sem */
+extern unsigned int GlobalTotalActiveXid; /* prot by GlobalMid_Sem */
+extern unsigned int GlobalMaxActiveXid;	/* prot by GlobalMid_Sem */
+extern spinlock_t GlobalMid_Lock;  /* protects above & list operations */
 					  /* on midQ entries */
-GLOBAL_EXTERN char Local_System_Name[15];
+extern char Local_System_Name[15];
 
 /*
  *  Global counters, updated atomically
  */
-GLOBAL_EXTERN atomic_t sesInfoAllocCount;
-GLOBAL_EXTERN atomic_t tconInfoAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesAllocCount;
-GLOBAL_EXTERN atomic_t tcpSesReconnectCount;
-GLOBAL_EXTERN atomic_t tconInfoReconnectCount;
+extern atomic_t sesInfoAllocCount;
+extern atomic_t tconInfoAllocCount;
+extern atomic_t tcpSesAllocCount;
+extern atomic_t tcpSesReconnectCount;
+extern atomic_t tconInfoReconnectCount;
 
 /* Various Debug counters */
-GLOBAL_EXTERN atomic_t bufAllocCount;    /* current number allocated  */
+extern atomic_t bufAllocCount;    /* current number allocated  */
 #ifdef CONFIG_CIFS_STATS2
-GLOBAL_EXTERN atomic_t totBufAllocCount; /* total allocated over all time */
-GLOBAL_EXTERN atomic_t totSmBufAllocCount;
+extern atomic_t totBufAllocCount; /* total allocated over all time */
+extern atomic_t totSmBufAllocCount;
 #endif
-GLOBAL_EXTERN atomic_t smBufAllocCount;
-GLOBAL_EXTERN atomic_t midCount;
+extern atomic_t smBufAllocCount;
+extern atomic_t midCount;
 
 /* Misc globals */
-GLOBAL_EXTERN unsigned int multiuser_mount; /* if enabled allows new sessions
+extern unsigned int multiuser_mount; /* if enabled allows new sessions
 				to be established on existing mount if we
 				have the uid/password or Kerberos credential
 				or equivalent for current user */
-GLOBAL_EXTERN unsigned int oplockEnabled;
-GLOBAL_EXTERN unsigned int experimEnabled;
-GLOBAL_EXTERN unsigned int lookupCacheEnabled;
-GLOBAL_EXTERN unsigned int extended_security;	/* if on, session setup sent
+extern unsigned int oplockEnabled;
+extern unsigned int experimEnabled;
+extern unsigned int lookupCacheEnabled;
+extern unsigned int extended_security;	/* if on, session setup sent
 				with more secure ntlmssp2 challenge/resp */
-GLOBAL_EXTERN unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
-GLOBAL_EXTERN unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
-GLOBAL_EXTERN unsigned int CIFSMaxBufSize;  /* max size not including hdr */
-GLOBAL_EXTERN unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
-GLOBAL_EXTERN unsigned int cifs_min_small;  /* min size of small buf pool */
-GLOBAL_EXTERN unsigned int cifs_max_pending; /* MAX requests at once to server*/
+extern unsigned int sign_CIFS_PDUs;  /* enable smb packet signing */
+extern unsigned int linuxExtEnabled;/*enable Linux/Unix CIFS extensions*/
+extern unsigned int CIFSMaxBufSize;  /* max size not including hdr */
+extern unsigned int cifs_min_rcv;    /* min size of big ntwrk buf pool */
+extern unsigned int cifs_min_small;  /* min size of small buf pool */
+extern unsigned int cifs_max_pending; /* MAX requests at once to server*/
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
linux-next.patch
arm-use-the-new-byteorder-headers.patch
cifs-remove-global_extern-macro.patch
dvb-cinergyt2-annotate-struct-endiannes-remove-unused-variable-add-static.patch
v4l-s2255drv-fix-firmware-test-on-big-endian.patch
dlm-trivial-annotation-of-be16-value.patch
ia64-use-the-new-byteorder-headers.patch
input-ads7846c-sparse-lock-annotation.patch
m32r-use-the-new-byteorder-headers.patch
blackfin-remove-__function__-in-new-serial-driver.patch
blackfin-use-the-new-byteorder-headers.patch
parisc-use-the-new-byteorder-headers.patch
s390-use-the-new-byteorder-headers.patch
scsi-replace-__inline-with-inline.patch
scsi-use-the-common-hex_asc-array-rather-than-a-private-one.patch
scsi-gdthc-use-unaligned-access-helpers.patch
scsi-annotate-gdth_rdcap_data-gdth_rdcap16_data-endianness.patch
frv-use-the-new-byteorder-headers.patch
m68knommu-use-the-new-byteorder-headers.patch
h8300-use-the-new-byteorder-headers.patch
alpha-use-the-new-byteorder-headers.patch
lib-fix-sparse-shadowed-variable-warning.patch
lib-radix_treec-make-percpu-variable-static.patch
lib-proportionsc-trivial-sparse-lock-annotation.patch
ibmpex-add-endian-annotation-to-extract_data-helper.patch
blackfin-remove-__function__-in-video-driver.patch
fb-carminefb-trivial-annotation-packing-color-register.patch
memstick-annotate-endianness-of-attribute-structs.patch

