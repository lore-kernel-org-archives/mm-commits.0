From: akpm@linux-foundation.org
Subject: - reiserfs-proc-support-requires-proc_fs.patch removed from -mm tree
Date: Tue, 08 May 2007 19:47:18 -0700
Message-ID: <200705090247.l492lILT008957@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36025 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031797AbXEICrX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 8 May 2007 22:47:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     reiserfs: proc support requires PROC_FS
has been removed from the -mm tree.  Its filename was
     reiserfs-proc-support-requires-proc_fs.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
 1 file changed, 1 insertion(+), 1 deletion(-)

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

origin.patch
krealloc-fix-kerneldoc-comments.patch
git-acpi.patch
git-ieee1394.patch
romfs-printk-format-warnings.patch
add-pci_try_set_mwi.patch
git-unionfs.patch
git-ipwireless_cs.patch
mm-merge-populate-and-nopage-into-fault-fixes-nonlinear-doc-fix.patch
doc-kernel-parameters-use-x86-32-tag-instead-of-ia-32.patch
lib-hexdump.patch
lib-hexdump-fix.patch
lib-hexdump-update-on-feedback.patch
doc-what-a-patch-series-is.patch
kernel-doc-small-kernel-doc-optimization.patch
profile-likely-unlikely-macros.patch
