From: akpm@linux-foundation.org
Subject: + kernel-api-docbook-fix-content-problems.patch added to -mm tree
Date: Thu, 18 Oct 2007 14:48:51 -0700
Message-ID: <200710182148.l9ILmpx1032728@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45694 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754699AbXJRVtq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 17:49:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, jens.axboe@oracle.com, wfg@mail.ustc.edu.cn


The patch titled
     kernel-api docbook: fix content problems
has been added to the -mm tree.  Its filename is
     kernel-api-docbook-fix-content-problems.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kernel-api docbook: fix content problems
From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-api docbook contents problems.

docproc: linux-2.6.23-git13/include/asm-x86/unaligned_32.h: No such file or directory
Warning(linux-2.6.23-git13//include/linux/list.h:482): bad line: 			of list entry
Warning(linux-2.6.23-git13//mm/filemap.c:864): No description found for parameter 'ra'
Warning(linux-2.6.23-git13//block/ll_rw_blk.c:3760): No description found for parameter 'req'
Warning(linux-2.6.23-git13//include/linux/input.h:1077): No description found for parameter 'private'
Warning(linux-2.6.23-git13//include/linux/input.h:1077): No description found for parameter 'cdev'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: WU Fengguang <wfg@mail.ustc.edu.cn>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-api.tmpl |    2 +-
 block/ll_rw_blk.c                     |    2 +-
 include/linux/input.h                 |    4 +++-
 include/linux/list.h                  |    3 +--
 mm/filemap.c                          |    2 +-
 5 files changed, 7 insertions(+), 6 deletions(-)

diff -puN Documentation/DocBook/kernel-api.tmpl~kernel-api-docbook-fix-content-problems Documentation/DocBook/kernel-api.tmpl
--- a/Documentation/DocBook/kernel-api.tmpl~kernel-api-docbook-fix-content-problems
+++ a/Documentation/DocBook/kernel-api.tmpl
@@ -46,7 +46,7 @@
 
      <sect1><title>Atomic and pointer manipulation</title>
 !Iinclude/asm-x86/atomic_32.h
-!Iinclude/asm-x86/unaligned_32.h
+!Iinclude/asm-x86/unaligned.h
      </sect1>
 
      <sect1><title>Delaying, scheduling, and timer routines</title>
diff -puN block/ll_rw_blk.c~kernel-api-docbook-fix-content-problems block/ll_rw_blk.c
--- a/block/ll_rw_blk.c~kernel-api-docbook-fix-content-problems
+++ a/block/ll_rw_blk.c
@@ -3739,7 +3739,7 @@ EXPORT_SYMBOL(end_dequeued_request);
 
 /**
  * end_request - end I/O on the current segment of the request
- * @rq:		the request being processed
+ * @req:	the request being processed
  * @uptodate:	error value or 0/1 uptodate flag
  *
  * Description:
diff -puN include/linux/input.h~kernel-api-docbook-fix-content-problems include/linux/input.h
--- a/include/linux/input.h~kernel-api-docbook-fix-content-problems
+++ a/include/linux/input.h
@@ -1005,13 +1005,15 @@ struct ff_effect {
  * @going_away: marks devices that are in a middle of unregistering and
  *	causes input_open_device*() fail with -ENODEV.
  * @dev: driver model's view of this device
+ * @cdev: union for struct device pointer
  * @h_list: list of input handles associated with the device. When
  *	accessing the list dev->mutex must be held
  * @node: used to place the device onto input_dev_list
  */
 struct input_dev {
-
+	/* private: */
 	void *private;	/* do not use */
+	/* public: */
 
 	const char *name;
 	const char *phys;
diff -puN include/linux/list.h~kernel-api-docbook-fix-content-problems include/linux/list.h
--- a/include/linux/list.h~kernel-api-docbook-fix-content-problems
+++ a/include/linux/list.h
@@ -478,8 +478,7 @@ static inline void list_splice_init_rcu(
 		pos = n, n = pos->next)
 
 /**
- * list_for_each_prev_safe - iterate over a list backwards safe against removal
-			of list entry
+ * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
  * @pos:	the &struct list_head to use as a loop cursor.
  * @n:		another &struct list_head to use as temporary storage
  * @head:	the head for your list.
diff -puN mm/filemap.c~kernel-api-docbook-fix-content-problems mm/filemap.c
--- a/mm/filemap.c~kernel-api-docbook-fix-content-problems
+++ a/mm/filemap.c
@@ -840,7 +840,7 @@ static void shrink_readahead_size_eio(st
 /**
  * do_generic_mapping_read - generic file read routine
  * @mapping:	address_space to be read
- * @_ra:	file's readahead state
+ * @ra:		file's readahead state
  * @filp:	the file to read
  * @ppos:	current file position
  * @desc:	read_descriptor
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
i-oat-cleanup-pci-issues.patch
git-acpi.patch
fix-auditscc-kernel-doc.patch
comment-typo-in-scripts-kconfig-makefile.patch
onenand-sim-fix-kernel-doc-and-typos.patch
git-net.patch
git-unionfs.patch
git-watchdog.patch
git-ipwireless_cs.patch
kernel-api-docbook-fix-content-problems.patch
hook-up-group-scheduler-with-control-groups.patch
hook-up-group-scheduler-with-control-groups-fix.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
add-samples-subdir.patch
profile-likely-unlikely-macros.patch
