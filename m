From: akpm@linux-foundation.org
Subject: + aha152x-in-debug-mode.patch added to -mm tree
Date: Wed, 18 Jul 2007 15:32:09 -0700
Message-ID: <200707182232.l6IMW9ER032337@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53229 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756580AbXGRWdB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 18 Jul 2007 18:33:01 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     aha152x in debug mode
has been added to the -mm tree.  Its filename is
     aha152x-in-debug-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: aha152x in debug mode
From: Randy Dunlap <randy.dunlap@oracle.com>

The symbol <debug_locks> conflicts with the rather global one in
include/linux/locks.h.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aha152x.c |   10 +++++-----
 drivers/scsi/aha152x.h |    2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/scsi/aha152x.c~aha152x-in-debug-mode drivers/scsi/aha152x.c
--- a/drivers/scsi/aha152x.c~aha152x-in-debug-mode
+++ a/drivers/scsi/aha152x.c
@@ -289,18 +289,18 @@ static LIST_HEAD(aha152x_host_list);
 		if(spin_is_locked(&QLOCK)) { \
 			DPRINTK(debug_intr, DEBUG_LEAD "(%s:%d) already locked at %s:%d\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
 		} \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locking\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		spin_lock_irqsave(&QLOCK,flags); \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) locked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		QLOCKER=__FUNCTION__; \
 		QLOCKERL=__LINE__; \
 	} while(0)
 
 #define DO_UNLOCK(flags)	\
 	do { \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocking (locked at %s:%d)\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__, QLOCKER, QLOCKERL); \
 		spin_unlock_irqrestore(&QLOCK,flags); \
-		DPRINTK(debug_locks, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
+		DPRINTK(debug_locking, DEBUG_LEAD "(%s:%d) unlocked\n", CMDINFO(CURRENT_SC), __FUNCTION__, __LINE__); \
 		QLOCKER="(not locked)"; \
 		QLOCKERL=0; \
 	} while(0)
@@ -3395,7 +3395,7 @@ static int aha152x_proc_info(struct Scsi
 	PDEBUG(debug_datai, "data in");
 	PDEBUG(debug_datao, "data out");
 	PDEBUG(debug_eh, "eh");
-	PDEBUG(debug_locks, "locks");
+	PDEBUG(debug_locking, "locks");
 	PDEBUG(debug_phases, "phases");
 
 	SPRINTF("\n");
diff -puN drivers/scsi/aha152x.h~aha152x-in-debug-mode drivers/scsi/aha152x.h
--- a/drivers/scsi/aha152x.h~aha152x-in-debug-mode
+++ a/drivers/scsi/aha152x.h
@@ -298,7 +298,7 @@ typedef union {
 enum {
   debug_procinfo  = 0x0001,
   debug_queue     = 0x0002,
-  debug_locks     = 0x0004,
+  debug_locking   = 0x0004,
   debug_intr      = 0x0008,
   debug_selection = 0x0010,
   debug_msgo      = 0x0020,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear.patch
kernel-doc-add-tools-doc-in-makefile.patch
kernel-doc-fix-unnamed-struct-union-warning.patch
kernel-doc-strip-c99-comments.patch
kernel-doc-fix-leading-dot-in-man-mode-output.patch
docbook-dont-reference-file-without-kernel-doc.patch
git-acpi.patch
git-alsa.patch
git-mtd.patch
aha152x-in-debug-mode.patch
git-unionfs.patch
git-ipwireless_cs.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
profile-likely-unlikely-macros.patch
