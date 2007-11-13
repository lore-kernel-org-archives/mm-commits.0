From: akpm@linux-foundation.org
Subject: + nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch added to -mm tree
Date: Tue, 13 Nov 2007 11:42:40 -0800
Message-ID: <200711131942.lADJgeY5031219@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59937 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762586AbXKMTnS (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 13 Nov 2007 14:43:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jirislaby@gmail.com, steved@redhat.com


The patch titled
     nfs functions undefined
has been added to the -mm tree.  Its filename is
     nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: nfs functions undefined
From: Randy Dunlap <randy.dunlap@oracle.com>

nfs_put_super() and nfs_sb_deactive() should not be inside an
ifdef CONFIG_NFS_V4 block.

ERROR: "nfs_put_super" [fs/nfs/nfs.ko] undefined!
ERROR: "nfs_sb_deactive" [fs/nfs/nfs.ko] undefined!

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Steve Dickson <steved@redhat.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nfs/super.c |   34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff -puN fs/nfs/super.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix fs/nfs/super.c
--- a/fs/nfs/super.c~nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix
+++ a/fs/nfs/super.c
@@ -1499,6 +1499,23 @@ error_splat_super:
 	return error;
 }
 
+static void nfs_put_super(struct super_block *sb)
+{
+	struct nfs_server *server = NFS_SB(sb);
+	/*
+	 * Make sure there are no outstanding ops to this server.
+	 * If so, wait for them to finish before allowing the
+	 * unmount to continue.
+	 */
+	wait_event(server->active_wq, atomic_read(&server->active) == 0);
+}
+
+void nfs_sb_deactive(struct nfs_server *server)
+{
+	if (atomic_dec_and_test(&server->active))
+		wake_up(&server->active_wq);
+}
+
 #ifdef CONFIG_NFS_V4
 
 /*
@@ -1771,17 +1788,6 @@ static void nfs4_kill_super(struct super
 	nfs_free_server(server);
 }
 
-static void nfs_put_super(struct super_block *sb)
-{
-	struct nfs_server *server = NFS_SB(sb);
-	/*
-	 * Make sure there are no outstanding ops to this server.
-	 * If so, wait for them to finish before allowing the
-	 * unmount to continue.
-	 */
-	wait_event(server->active_wq, atomic_read(&server->active) == 0);
-}
-
 /*
  * Clone an NFS4 server record on xdev traversal (FSID-change)
  */
@@ -1929,10 +1935,4 @@ error_splat_super:
 	return error;
 }
 
-void nfs_sb_deactive(struct nfs_server *server)
-{
-	if (atomic_dec_and_test(&server->active))
-		wake_up(&server->active_wq);
-}
-
 #endif /* CONFIG_NFS_V4 */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
chipsfb-uses-depends-on-pci.patch
git-dvb.patch
git-kbuild.patch
nfs-stop-sillyname-renames-and-unmounts-from-racing-fix-fix-fix.patch
advansys-fix-section-mismatch-warning.patch
aic94-fix-section-mismatches.patch
sym2-fix-section-mismatch-warning.patch
git-unionfs.patch
git-ipwireless_cs.patch
x86-bitops_32h-style-cleanups.patch
sysctl-fix-token-ring-procname.patch
gbefb-fix-section-mismatch-warnings.patch
vmstat-fix-section-mismatch-warning.patch
register_cpu-__devinit-or-__cpuinit.patch
cciss-use-upper_32_bits-macro-to-eliminate-warnings.patch
move-kprobes-examples-to-samples-resend.patch
move-kprobes-examples-to-samples-resend-checkpatch-fixes.patch
fs-menu-small-reorg.patch
profile-likely-unlikely-macros.patch
