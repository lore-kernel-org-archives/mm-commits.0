From: akpm@linux-foundation.org
Subject: [patch 097/114] lustre: replace CURRENT_TIME macro
Date: Mon, 08 May 2017 15:59:28 -0700
Message-ID: <20170508225928.uTwc02GbB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47498 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbdEHW73 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 8 May 2017 18:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, andreas.dilger@intel.com, deepa.kernel@gmail.com, jsimmons@infradead.org, mm-commits@vger.kernel.org, oleg.drokin@intel.com, torvalds@linux-foundation.org

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
@@ -1454,17 +1454,17 @@ int ll_setattr_raw(struct dentry *dentry
 
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
