From: akpm@linux-foundation.org
Subject: - afs-replace-remaining-__function__-occurrences.patch removed from -mm tree
Date: Thu, 01 May 2008 02:33:13 -0700
Message-ID: <200805010933.m419XD9a031121@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46176 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758078AbYEAJdR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 1 May 2008 05:33:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: harvey.harrison@gmail.com, mm-commits@vger.kernel.org


The patch titled
     afs: replace remaining __FUNCTION__ occurrences
has been removed from the -mm tree.  Its filename was
     afs-replace-remaining-__function__-occurrences.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: afs: replace remaining __FUNCTION__ occurrences
From: Harvey Harrison <harvey.harrison@gmail.com>

__FUNCTION__ is gcc-specific, use __func__

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/afs/dir.c      |    4 ++--
 fs/afs/internal.h |    8 ++++----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff -puN fs/afs/dir.c~afs-replace-remaining-__function__-occurrences fs/afs/dir.c
--- a/fs/afs/dir.c~afs-replace-remaining-__function__-occurrences
+++ a/fs/afs/dir.c
@@ -140,7 +140,7 @@ static inline void afs_dir_check_page(st
 
 	if (page->index == 0 && qty != ntohs(dbuf->blocks[0].pagehdr.npages)) {
 		printk("kAFS: %s(%lu): wrong number of dir blocks %d!=%hu\n",
-		       __FUNCTION__, dir->i_ino, qty,
+		       __func__, dir->i_ino, qty,
 		       ntohs(dbuf->blocks[0].pagehdr.npages));
 		goto error;
 	}
@@ -159,7 +159,7 @@ static inline void afs_dir_check_page(st
 	for (tmp = 0; tmp < qty; tmp++) {
 		if (dbuf->blocks[tmp].pagehdr.magic != AFS_DIR_MAGIC) {
 			printk("kAFS: %s(%lu): bad magic %d/%d is %04hx\n",
-			       __FUNCTION__, dir->i_ino, tmp, qty,
+			       __func__, dir->i_ino, tmp, qty,
 			       ntohs(dbuf->blocks[tmp].pagehdr.magic));
 			goto error;
 		}
diff -puN fs/afs/internal.h~afs-replace-remaining-__function__-occurrences fs/afs/internal.h
--- a/fs/afs/internal.h~afs-replace-remaining-__function__-occurrences
+++ a/fs/afs/internal.h
@@ -757,8 +757,8 @@ void _dbprintk(const char *fmt, ...)
 {
 }
 
-#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define kenter(FMT,...)	dbgprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define kleave(FMT,...)	dbgprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define kdebug(FMT,...)	dbgprintk("    "FMT ,##__VA_ARGS__)
 
 
@@ -791,8 +791,8 @@ do {							\
 } while (0)
 
 #else
-#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__FUNCTION__ ,##__VA_ARGS__)
-#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__FUNCTION__ ,##__VA_ARGS__)
+#define _enter(FMT,...)	_dbprintk("==> %s("FMT")",__func__ ,##__VA_ARGS__)
+#define _leave(FMT,...)	_dbprintk("<== %s()"FMT"",__func__ ,##__VA_ARGS__)
 #define _debug(FMT,...)	_dbprintk("    "FMT ,##__VA_ARGS__)
 #endif
 
_

Patches currently in -mm which might be from harvey.harrison@gmail.com are

origin.patch
frv-unbreak-misalignment-handling-changes.patch
git-acpi.patch
cifs-remove-global_extern-macro.patch
input-replace-remaining-__function__-occurrences.patch
input-make-one-bit-signed-bitfields-unsigned.patch
git-kvm.patch
git-mips.patch
mmc-make-one-bit-signed-bitfields-unsigned.patch
nfs-replace-remaining-__function__-occurrences.patch
parisc-replace-remaining-__function__-occurences.patch
drivers-parisc-replace-remaining-__function__-occurrences.patch
git-sched.patch
scsi-replace-remaining-__function__-occurrences.patch
fusion-replace-remaining-__function__-occurrences.patch
scsi-replace-__inline-with-inline.patch
git-watchdog.patch
mac80211-michaelc-use-kernel-provided-infrastructure.patch
mac80211-introduce-struct-michael_mic_ctx-and-static-helpers.patch
mac80211-tkipc-use-kernel-provided-infrastructure.patch
mac80211-add-const-remove-unused-function-make-one-function-static.patch
mac80211-add-a-struct-to-hold-tkip-context.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-1-key-mixing.patch
mac80211-tkipc-use-struct-tkip_ctx-in-phase-2-key-mixing.patch
git-xfs.patch
xtensa-replace-remaining-__function__-occurences.patch
pcmcia-replace-remaining-__function__-occurrences.patch
autofs4-fix-sparse-warning-in-waitqc-autofs4_expire_indirect.patch
ide-eliminate-fit-macro.patch
ata-remove-fit-macro.patch
b43-replace-limit_value-macro-with-clamp_val.patch
b43legacy-replace-limit_value-macro-with-clamp_val.patch
fuse-use-clamp-rather-than-nested-min-max.patch
ide-tape-use-clamp_t-rather-than-nested-min_t-max_t.patch
input-ff-memlessc-use-clamp_val-macro.patch
dccp-ccid2c-ccid3c-use-clamp-clamp_t.patch
block-remove-remaining-__function__-occurances.patch

