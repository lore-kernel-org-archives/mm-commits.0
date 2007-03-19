From: akpm@linux-foundation.org
Subject: + reiserfs-proc-support-requires-proc_fs.patch added to -mm tree
Date: Mon, 19 Mar 2007 15:51:15 -0700
Message-ID: <200703192251.l2JMpGUa019794@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:60454 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965370AbXCSWvg (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 19 Mar 2007 18:51:36 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com


The patch titled
     reiserfs: proc support requires PROC_FS
has been added to the -mm tree.  Its filename is
     reiserfs-proc-support-requires-proc_fs.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: reiserfs: proc support requires PROC_FS
From: Randy Dunlap <randy.dunlap@oracle.com>

REISER_FS /proc option needs to depend on PROC_FS.

fs/reiserfs/procfs.c: In function 'show_super':
fs/reiserfs/procfs.c:134: error: 'reiserfs_proc_info_data_t' has no member named 'max_hash_collisions'
fs/reiserfs/procfs.c:134: error: 'reiserfs_proc_info_data_t' has no member named 'breads'
fs/reiserfs/procfs.c:135: error: 'reiserfs_proc_info_data_t' has no member named 'bread_miss'
fs/reiserfs/procfs.c:135: error: 'reiserfs_proc_info_data_t' has no member named 'search_by_key'
fs/reiserfs/procfs.c:136: error: 'reiserfs_proc_info_data_t' has no member named 'search_by_key_fs_changed'
fs/reiserfs/procfs.c:136: error: 'reiserfs_proc_info_data_t' has no member named 'search_by_key_restarted'
fs/reiserfs/procfs.c:137: error: 'reiserfs_proc_info_data_t' has no member named 'insert_item_restarted'
fs/reiserfs/procfs.c:137: error: 'reiserfs_proc_info_data_t' has no member named 'paste_into_item_restarted'
fs/reiserfs/procfs.c:138: error: 'reiserfs_proc_info_data_t' has no member named 'cut_from_item_restarted'
fs/reiserfs/procfs.c:139: error: 'reiserfs_proc_info_data_t' has no member named 'delete_solid_item_restarted'
fs/reiserfs/procfs.c:139: error: 'reiserfs_proc_info_data_t' has no member named 'delete_item_restarted'
fs/reiserfs/procfs.c:140: error: 'reiserfs_proc_info_data_t' has no member named 'leaked_oid'
fs/reiserfs/procfs.c:140: error: 'reiserfs_proc_info_data_t' has no member named 'leaves_removable'
fs/reiserfs/procfs.c: In function 'show_per_level':
fs/reiserfs/procfs.c:184: error: 'reiserfs_proc_info_data_t' has no member named 'balance_at'
fs/reiserfs/procfs.c:185: error: 'reiserfs_proc_info_data_t' has no member named 'sbk_read_at'
fs/reiserfs/procfs.c:186: error: 'reiserfs_proc_info_data_t' has no member named 'sbk_fs_changed'
fs/reiserfs/procfs.c:187: error: 'reiserfs_proc_info_data_t' has no member named 'sbk_restarted'
fs/reiserfs/procfs.c:188: error: 'reiserfs_proc_info_data_t' has no member named 'free_at'
fs/reiserfs/procfs.c:189: error: 'reiserfs_proc_info_data_t' has no member named 'items_at'
fs/reiserfs/procfs.c:190: error: 'reiserfs_proc_info_data_t' has no member named 'can_node_be_removed'
fs/reiserfs/procfs.c:191: error: 'reiserfs_proc_info_data_t' has no member named 'lnum'
fs/reiserfs/procfs.c:192: error: 'reiserfs_proc_info_data_t' has no member named 'rnum'
fs/reiserfs/procfs.c:193: error: 'reiserfs_proc_info_data_t' has no member named 'lbytes'
fs/reiserfs/procfs.c:194: error: 'reiserfs_proc_info_data_t' has no member named 'rbytes'
fs/reiserfs/procfs.c:195: error: 'reiserfs_proc_info_data_t' has no member named 'get_neighbors'
fs/reiserfs/procfs.c:196: error: 'reiserfs_proc_info_data_t' has no member named 'get_neighbors_restart'
fs/reiserfs/procfs.c:197: error: 'reiserfs_proc_info_data_t' has no member named 'need_l_neighbor'
fs/reiserfs/procfs.c:197: error: 'reiserfs_proc_info_data_t' has no member named 'need_r_neighbor'
fs/reiserfs/procfs.c: In function 'show_bitmap':
fs/reiserfs/procfs.c:224: error: 'reiserfs_proc_info_data_t' has no member named 'free_block'
fs/reiserfs/procfs.c:225: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:226: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:227: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:228: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:229: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:230: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c:230: error: 'reiserfs_proc_info_data_t' has no member named 'scan_bitmap'
fs/reiserfs/procfs.c: In function 'show_journal':
fs/reiserfs/procfs.c:384: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:385: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:386: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:387: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:388: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:389: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:390: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:391: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:392: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:393: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:394: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:395: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:395: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c:395: error: 'reiserfs_proc_info_data_t' has no member named 'journal'
fs/reiserfs/procfs.c: In function 'reiserfs_proc_info_init':
fs/reiserfs/procfs.c:504: warning: implicit declaration of function '__PINFO'
fs/reiserfs/procfs.c:504: error: request for member 'lock' in something not a structure or union
fs/reiserfs/procfs.c: In function 'reiserfs_proc_info_done':
fs/reiserfs/procfs.c:544: error: request for member 'lock' in something not a structure or union
fs/reiserfs/procfs.c:545: error: request for member 'exiting' in something not a structure or union
fs/reiserfs/procfs.c:546: error: request for member 'lock' in something not a structure or union

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/Kconfig~reiserfs-proc-support-requires-proc_fs fs/Kconfig
--- a/fs/Kconfig~reiserfs-proc-support-requires-proc_fs
+++ a/fs/Kconfig
@@ -314,7 +314,7 @@ config REISERFS_CHECK
 
 config REISERFS_PROC_INFO
 	bool "Stats in /proc/fs/reiserfs"
-	depends on REISERFS_FS
+	depends on REISERFS_FS && PROC_FS
 	help
 	  Create under /proc/fs/reiserfs a hierarchy of files, displaying
 	  various ReiserFS statistics and internal data at the expense of
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

romfs-printk-format-warnings.patch
git-drm.patch
git-libata-all.patch
git-netdev-all.patch
fusion-kernel-doc-warning-fixes.patch
unionfs-sioq-not-__exit.patch
i386-fix-gdts-number-of-quadwords-in.patch
scripts-kernel-doc-whitespace-cleanup.patch
reiserfs-proc-support-requires-proc_fs.patch
ptrace-needs-proc_fs.patch
some-grammatical-fixups-and-additions-to-atomich-kernel-doc.patch
profile-likely-unlikely-macros.patch
