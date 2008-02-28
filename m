From: akpm@linux-foundation.org
Subject: + cifs-remove-global_extern-macro.patch added to -mm tree
Date: Wed, 27 Feb 2008 21:18:59 -0800
Message-ID: <200802280518.m1S5Ix8c017116@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:56904 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751209AbYB1FTW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Feb 2008 00:19:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: harvey.harrison@gmail.com, sfrench@us.ibm.com


The patch titled
     cifs: remove GLOBAL_EXTERN macro
has been added to the -mm tree.  Its filename is
     cifs-remove-global_extern-macro.patch

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

 fs/cifs/cifsfs.c   |   31 ++++++++++++++++-
 fs/cifs/cifsglob.h |   76 +++++++++++++++++++------------------------
 2 files changed, 64 insertions(+), 43 deletions(-)

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
@@ -996,7 +1023,7 @@ init_cifs(void)
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
@@ -583,79 +583,73 @@ require use of the stronger protocol */
  *
  ****************************************************************************/
 
-#ifdef DECLARE_GLOBALS_HERE
-#define GLOBAL_EXTERN
-#else
-#define GLOBAL_EXTERN extern
-#endif
-
 /*
  * The list of servers that did not respond with NT LM 0.12.
  * This list helps improve performance and eliminate the messages indicating
  * that we had a communications error talking to the server in this list.
  */
 /* Feature not supported */
-/* GLOBAL_EXTERN struct servers_not_supported *NotSuppList; */
+/* extern struct servers_not_supported *NotSuppList; */
 
 /*
  * The following is a hash table of all the users we know about.
  */
-GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
+/* extern struct smbUidInfo *GlobalUidList[UID_HASH]; */
 
-/* GLOBAL_EXTERN struct list_head GlobalServerList; BB not implemented yet */
-GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
-GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
-GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
+/* extern struct list_head GlobalServerList; BB not implemented yet */
+extern struct list_head GlobalSMBSessionList;
+extern struct list_head GlobalTreeConnectionList;
+extern rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 
-GLOBAL_EXTERN struct list_head GlobalOplock_Q;
+extern struct list_head GlobalOplock_Q;
 
 /* Outstanding dir notify requests */
-GLOBAL_EXTERN struct list_head GlobalDnotifyReqList;
+extern struct list_head GlobalDnotifyReqList;
 /* DirNotify response queue */
-GLOBAL_EXTERN struct list_head GlobalDnotifyRsp_Q;
+/* extern struct list_head GlobalDnotifyRsp_Q; */
 
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
 
 /* Various Debug counters to remove someday (BB) */
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
specialixc-fix-possible-double-unlock.patch
video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs.patch
video-add-a-clamp-macro-to-kernelh-and-replace-two-existing-defs-checkpatch-fixes.patch
git-x86.patch
agp-fix-shadowed-variable-warning-in-amd-k7-agpc.patch
cifs-remove-global_extern-macro.patch
radeon-fix-integer-as-null-pointer-warnings-in-radeon_memc.patch
git-dvb.patch
git-dlm.patch
git-kvm.patch
pata_amd-fix-sparse-warning.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
git-net.patch
git-nfsd.patch
block-fix-shadowed-variable-warning-in-blk-mapc.patch
block-remove-extern-on-function-definition.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
smack-fix-integer-as-null-pointer-warning-in-smack_lsmc.patch
adfs-work-around-bogus-sparse-warning.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
serial-remove-double-initializer.patch
char-make-functions-static-in-synclinkmpc.patch
kprobes-introduce-kprobe_handle_fault.patch
kprobes-remove-preempt_enable-disable-from-kprobe_handle_fault.patch
capi-fix-sparse-warnings-using-integer-as-null-pointer.patch
avm-fix-sparse-warning-using-integer-as-null-pointer.patch
eicon-fix-sparse-integer-as-null-pointer-warnings.patch
xen-make-blkif_getgeo-static.patch
fbcon-replace-mono_col-macro-with-static-inline.patch
md-fix-integer-as-null-pointer-warnings-in-mdc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-fix_nodec.patch
reiserfs-fix-sparse-warnings-in-do_balanc.patch
reiserfs-fix-sparse-warning-in-nameic.patch
reiserfs-fix-sparse-warnings-in-lbalancec.patch
reiserfs-fix-sparse-warning-in-journalc.patch
reiserfs-fix-more-sparse-warnings-in-do_balanc.patch
cgroup-fix-sparse-warning-of-shadow-symbol-in-cgroupc.patch
char-fix-sparse-shadowed-variable-warnings-in-espc.patch
char-espc-fix-possible-double-unlock.patch
char-rocketc-fix-sparse-variable-shadowing-and-int-as-null-pointer.patch
cycladesc-fix-sparse-shadowed-variable-warnings.patch
epcac-static-functions-and-integer-as-null-pointer-fixes.patch
epcac-static-functions-and-integer-as-null-pointer-fixes-checkpatch-fixes.patch
