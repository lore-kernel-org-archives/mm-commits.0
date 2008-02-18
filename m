From: akpm@linux-foundation.org
Subject: + cifs-remove-global_extern-macro.patch added to -mm tree
Date: Mon, 18 Feb 2008 01:56:40 -0800
Message-ID: <200802180957.m1I9vcWp018789@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34328 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331AbYBRJ6h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 18 Feb 2008 04:58:37 -0500
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

Just use extern, saves a lot of sparse warnings.
fs/cifs/cifsglob.h:603:33: warning: symbol 'GlobalUidList' was not declared. Should it be static?
fs/cifs/cifsglob.h:606:32: warning: symbol 'GlobalSMBSessionList' was not declared. Should it be static?
fs/cifs/cifsglob.h:607:32: warning: symbol 'GlobalTreeConnectionList' was not declared. Should it be static?
fs/cifs/cifsglob.h:608:24: warning: symbol 'GlobalSMBSeslock' was not declared. Should it be static?
fs/cifs/cifsglob.h:610:32: warning: symbol 'GlobalOplock_Q' was not declared. Should it be static?
fs/cifs/cifsglob.h:613:32: warning: symbol 'GlobalDnotifyReqList' was not declared. Should it be static?
fs/cifs/cifsglob.h:615:32: warning: symbol 'GlobalDnotifyRsp_Q' was not declared. Should it be static?
fs/cifs/cifsglob.h:620:28: warning: symbol 'GlobalCurrentXid' was not declared. Should it be static?
fs/cifs/cifsglob.h:621:28: warning: symbol 'GlobalTotalActiveXid' was not declared. Should it be static?
fs/cifs/cifsglob.h:622:28: warning: symbol 'GlobalMaxActiveXid' was not declared. Should it be static?
fs/cifs/cifsglob.h:623:26: warning: symbol 'GlobalMid_Lock' was not declared. Should it be static?
fs/cifs/cifsglob.h:625:20: warning: symbol 'Local_System_Name' was not declared. Should it be static?
fs/cifs/cifsglob.h:630:24: warning: symbol 'sesInfoAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:631:24: warning: symbol 'tconInfoAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:632:24: warning: symbol 'tcpSesAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:633:24: warning: symbol 'tcpSesReconnectCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:634:24: warning: symbol 'tconInfoReconnectCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:637:24: warning: symbol 'bufAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:639:24: warning: symbol 'totBufAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:640:24: warning: symbol 'totSmBufAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:642:24: warning: symbol 'smBufAllocCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:643:24: warning: symbol 'midCount' was not declared. Should it be static?
fs/cifs/cifsglob.h:646:28: warning: symbol 'multiuser_mount' was not declared. Should it be static?
fs/cifs/cifsglob.h:650:28: warning: symbol 'oplockEnabled' was not declared. Should it be static?
fs/cifs/cifsglob.h:651:28: warning: symbol 'experimEnabled' was not declared. Should it be static?
fs/cifs/cifsglob.h:652:28: warning: symbol 'lookupCacheEnabled' was not declared. Should it be static?
fs/cifs/cifsglob.h:653:28: warning: symbol 'extended_security' was not declared. Should it be static?
fs/cifs/cifsglob.h:655:28: warning: symbol 'sign_CIFS_PDUs' was not declared. Should it be static?
fs/cifs/cifsglob.h:656:28: warning: symbol 'linuxExtEnabled' was not declared. Should it be static?
fs/cifs/cifsglob.h:657:28: warning: symbol 'CIFSMaxBufSize' was not declared. Should it be static?
fs/cifs/cifsglob.h:658:28: warning: symbol 'cifs_min_rcv' was not declared. Should it be static?
fs/cifs/cifsglob.h:659:28: warning: symbol 'cifs_min_small' was not declared. Should it be static?
fs/cifs/cifsglob.h:660:28: warning: symbol 'cifs_max_pending' was not declared. Should it be static?

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Steven French <sfrench@us.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/cifs/cifsglob.h |   76 +++++++++++++++++++------------------------
 1 file changed, 35 insertions(+), 41 deletions(-)

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
+extern struct smbUidInfo *GlobalUidList[UID_HASH];
 
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
acpi-sparse-fix-replace-macro-with-static-function.patch
cifs-remove-global_extern-macro.patch
dlm-match-signedness-between-dlm_config_info-and-cluster_set.patch
ata-fix-sparse-warning-in-libatah.patch
pata_amd-replace-macro-with-static-inline-in-libatah.patch
jffs2-include-function-prototype-for-jffs2_ioctl.patch
jffs2-fix-sparse-warning-in-nodemgmtc.patch
jffs2-fix-sparse-warning-in-writec.patch
jffs2-fix-sparse-warnings-in-gcc.patch
git-ubi.patch
lockd-fix-sparse-warning-in-svcsharec.patch
remove-sparse-warning-for-mmzoneh.patch
remove-sparse-warning-for-mmzoneh-checkpatch-fixes.patch
adfs-work-around-bogus-sparse-warning.patch
debugfs-fix-sparse-warnings.patch
coda-add-static-to-functions-in-dirc.patch
befs-fix-sparse-warning-in-linuxvfsc.patch
autofs4-fix-sparse-warning-in-rootc.patch
ncpfs-add-prototypes-to-ncp_fsh.patch
ncpfs-fix-sparse-warnings-in-ioctlc.patch
ncpfs-fix-sparse-warning-in-ncpsign_kernelc.patch
jbd-sparse-warnings-in-revokec-journalc.patch
udf-fix-sparse-warning-in-nameic.patch
jbd2-sparse-warnings-in-revokec-journalc.patch
