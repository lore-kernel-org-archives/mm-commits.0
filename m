From: akpm@linux-foundation.org
Subject: + lustre-replace-current_time-macro.patch added to -mm tree
Date: Mon, 10 Apr 2017 15:34:33 -0700
Message-ID: <58ec0879.afC9AxxE/SLE7SOh%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60526 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752369AbdDJWee (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 10 Apr 2017 18:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: deepa.kernel@gmail.com, andreas.dilger@intel.com, jsimmons@infradead.org, oleg.drokin@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: lustre: replace CURRENT_TIME macro
has been added to the -mm tree.  Its filename is
     lustre-replace-current_time-macro.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/lustre-replace-current_time-macro.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/lustre-replace-current_time-macro.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Deepa Dinamani <deepa.kernel@gmail.com>
Subject: lustre: replace CURRENT_TIME macro

CURRENT_TIME macro is not y2038 safe on 32 bit systems.

The patch replaces all the uses of CURRENT_TIME by current_time() for
filesystem times, and ktime_get_* functions for others.

struct timespec is also not y2038 safe.  Retain timespec for timestamp
representation here as lustre uses it internally everywhere.  These
references will be changed to use struct timespec64 in a separate patch.

This is also in preparation for the patch that transitions vfs timestamps
to use 64 bit time and hence make them y2038 safe.  current_time() is also
planned to be transitioned to y2038 safe behavior along with this change.

CURRENT_TIME macro will be deleted before merging the
aforementioned change.

Link: http://lkml.kernel.org/r/1491613030-11599-10-git-send-email-deepa.kernel@gmail.com
Signed-off-by: Deepa Dinamani <deepa.kernel@gmail.com>
Cc: Oleg Drokin <oleg.drokin@intel.com>
Cc: Andreas Dilger <andreas.dilger@intel.com>
Cc: James Simmons <jsimmons@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/staging/lustre/lustre/llite/llite_lib.c |    6 +++---
 drivers/staging/lustre/lustre/osc/osc_io.c      |    4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN drivers/staging/lustre/lustre/llite/llite_lib.c~lustre-replace-current_time-macro drivers/staging/lustre/lustre/llite/llite_lib.c
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c~lustre-replace-current_time-macro
+++ a/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -1472,17 +1472,17 @@ int ll_setattr_raw(struct dentry *dentry
 
 	/* We mark all of the fields "set" so MDS/OST does not re-set them */
 	if (attr->ia_valid & ATTR_CTIME) {
-		attr->ia_ctime = CURRENT_TIME;
+		attr->ia_ctime = current_time(inode);
 		attr->ia_valid |= ATTR_CTIME_SET;
 	}
 	if (!(attr->ia_valid & ATTR_ATIME_SET) &&
 	    (attr->ia_valid & ATTR_ATIME)) {
-		attr->ia_atime = CURRENT_TIME;
+		attr->ia_atime = current_time(inode);
 		attr->ia_valid |= ATTR_ATIME_SET;
 	}
 	if (!(attr->ia_valid & ATTR_MTIME_SET) &&
 	    (attr->ia_valid & ATTR_MTIME)) {
-		attr->ia_mtime = CURRENT_TIME;
+		attr->ia_mtime = current_time(inode);
 		attr->ia_valid |= ATTR_MTIME_SET;
 	}
 
diff -puN drivers/staging/lustre/lustre/osc/osc_io.c~lustre-replace-current_time-macro drivers/staging/lustre/lustre/osc/osc_io.c
--- a/drivers/staging/lustre/lustre/osc/osc_io.c~lustre-replace-current_time-macro
+++ a/drivers/staging/lustre/lustre/osc/osc_io.c
@@ -216,7 +216,7 @@ static int osc_io_submit(const struct lu
 		struct cl_object *obj = ios->cis_obj;
 
 		cl_object_attr_lock(obj);
-		attr->cat_mtime = LTIME_S(CURRENT_TIME);
+		attr->cat_mtime = ktime_get_real_seconds();
 		attr->cat_ctime = attr->cat_mtime;
 		cl_object_attr_update(env, obj, attr, CAT_MTIME | CAT_CTIME);
 		cl_object_attr_unlock(obj);
@@ -256,7 +256,7 @@ static void osc_page_touch_at(const stru
 	       kms > loi->loi_kms ? "" : "not ", loi->loi_kms, kms,
 	       loi->loi_lvb.lvb_size);
 
-	attr->cat_ctime = LTIME_S(CURRENT_TIME);
+	attr->cat_ctime = ktime_get_real_seconds();
 	attr->cat_mtime = attr->cat_ctime;
 	valid = CAT_MTIME | CAT_CTIME;
 	if (kms > loi->loi_kms) {
_

Patches currently in -mm which might be from deepa.kernel@gmail.com are

fs-f2fs-use-ktime_get_real_seconds-for-sit_info-times.patch
trace-make-trace_hwlat-timestamp-y2038-safe.patch
fs-cifs-replace-current_time-by-other-appropriate-apis.patch
fs-ceph-current_time-with-ktime_get_real_ts.patch
fs-ufs-use-ktime_get_real_ts64-for-birthtime.patch
audit-use-timespec64-to-represent-audit-timestamps.patch
fs-btrfs-use-ktime_get_real_ts-for-root-ctime.patch
fs-ubifs-replace-current_time_sec-with-current_time.patch
lustre-replace-current_time-macro.patch
apparmorfs-replace-current_time-with-current_time.patch
time-delete-current_time_sec-and-current_time.patch
time-delete-current_fs_time-function.patch

