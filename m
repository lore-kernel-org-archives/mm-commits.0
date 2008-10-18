From: akpm@linux-foundation.org
Subject: - ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:51:26 -0700
Message-ID: <200810182351.m9INpQSx001752@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34129 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751735AbYJRXwV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:52:21 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, eugene@ibrix.com, msnitzer@ibrix.com, tytso@mit.edu, mm-commits@vger.kernel.org


The patch titled
     ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch

This patch was dropped because it was folded into ext3-fix-ext3_dx_readdir-hash-collision-handling.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: code indent should use tabs where possible
#37: FILE: fs/ext3/dir.c:453:
+                if (call_filldir(filp, dirent, filldir, info->extra_fname))$

ERROR: code indent should use tabs where possible
#38: FILE: fs/ext3/dir.c:454:
+                        goto finished;$

ERROR: code indent should use tabs where possible
#40: FILE: fs/ext3/dir.c:456:
+                info->extra_fname = NULL;$

ERROR: code indent should use tabs where possible
#41: FILE: fs/ext3/dir.c:457:
+                info->curr_node = rb_next(info->curr_node);$

ERROR: code indent should use tabs where possible
#42: FILE: fs/ext3/dir.c:458:
+                if (!info->curr_node) {$

ERROR: code indent should use tabs where possible
#43: FILE: fs/ext3/dir.c:459:
+                        if (info->next_hash == ~0) {$

ERROR: code indent should use tabs where possible
#44: FILE: fs/ext3/dir.c:460:
+                                filp->f_pos = EXT3_HTREE_EOF;$

ERROR: code indent should use tabs where possible
#45: FILE: fs/ext3/dir.c:461:
+                                goto finished;$

ERROR: code indent should use tabs where possible
#46: FILE: fs/ext3/dir.c:462:
+                        }$

ERROR: code indent should use tabs where possible
#47: FILE: fs/ext3/dir.c:463:
+                        info->curr_hash = info->next_hash;$

ERROR: code indent should use tabs where possible
#48: FILE: fs/ext3/dir.c:464:
+                        info->curr_minor_hash = 0;$

ERROR: code indent should use tabs where possible
#49: FILE: fs/ext3/dir.c:465:
+                }$

ERROR: code indent should use tabs where possible
#50: FILE: fs/ext3/dir.c:466:
+        } else if (!info->curr_node)$

total: 13 errors, 0 warnings, 34 lines checked

./patches/ext3-fix-ext3_dx_readdir-hash-collision-handling.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eugene Dashevsky <eugene@ibrix.com>
Cc: Mike Snitzer <msnitzer@ibrix.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ext3/dir.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff -puN fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes fs/ext3/dir.c
--- a/fs/ext3/dir.c~ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes
+++ a/fs/ext3/dir.c
@@ -450,20 +450,20 @@ static int ext3_dx_readdir(struct file *
 	 * chain, return them first.
 	 */
 	if (info->extra_fname) {
-                if (call_filldir(filp, dirent, filldir, info->extra_fname))
-                        goto finished;
+		if (call_filldir(filp, dirent, filldir, info->extra_fname))
+			goto finished;
 
-                info->extra_fname = NULL;
-                info->curr_node = rb_next(info->curr_node);
-                if (!info->curr_node) {
-                        if (info->next_hash == ~0) {
-                                filp->f_pos = EXT3_HTREE_EOF;
-                                goto finished;
-                        }
-                        info->curr_hash = info->next_hash;
-                        info->curr_minor_hash = 0;
-                }
-        } else if (!info->curr_node)
+		info->extra_fname = NULL;
+		info->curr_node = rb_next(info->curr_node);
+		if (!info->curr_node) {
+			if (info->next_hash == ~0) {
+				filp->f_pos = EXT3_HTREE_EOF;
+				goto finished;
+			}
+			info->curr_hash = info->next_hash;
+			info->curr_minor_hash = 0;
+		}
+	} else if (!info->curr_node)
 		info->curr_node = rb_first(&info->root);
 
 	while (1) {
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-cleanup-to-make-remove_memory-arch-neutral.patch
vmscan-move-isolate_lru_page-to-vmscanc.patch
define-page_file_cache-function.patch
vmscan-split-lru-lists-into-anon-file-sets.patch
unevictable-lru-infrastructure.patch
unevictable-lru-page-statistics.patch
mlock-mlocked-pages-are-unevictable.patch
mmap-handle-mlocked-pages-during-map-remap-unmap.patch
vmscan-unevictable-lru-scan-sysctl.patch
mlock-make-mlock-error-return-posixly-correct.patch
mm-rewrite-vmap-layer.patch
memory_probe-fix-wrong-sysfs-file-attribute.patch
container-freezer-add-tif_freeze-flag-to-all-architectures.patch
container-freezer-implement-freezer-cgroup-subsystem.patch
hwmon-pc87360-separate-alarm-files-add-in-min-max-alarms.patch
hwmon-pc87360-separate-alarm-files-add-temp-min-max-crit-fault-alarms.patch
hwmon-pc87360-separate-alarm-files-add-therm-min-max-crit-alarms.patch
drivers-hwmon-applesmcc-remove-unneeded-casts.patch
fb-push-down-the-bkl-in-the-ioctl-handler.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling.patch
ext3-fix-ext3_dx_readdir-hash-collision-handling-checkpatch-fixes.patch
cgroups-fix-probable-race-with-put_css_set-and-find_css_set-fix.patch
message-queues-increase-range-limits-checkpatch-fixes.patch
drivers-rtc-rtc-bq4802c-dont-use-bin_2_bcd-and-bcd_2_bin.patch
x86-sysfs-kill-owner-field-from-attribute-fix.patch
x86-sysfs-kill-owner-field-from-attribute-fix-3.patch

