From: akpm@linux-foundation.org
Subject: [merged] ocfs2-set-append-dio-as-a-ro-compat-feature.patch
 removed from -mm tree
Date: Tue, 17 Feb 2015 12:06:33 -0800
Message-ID: <54e39f49.ep2zSnhpaacuYtyg%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35363 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbbBQUGe (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 17 Feb 2015 15:06:34 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: joseph.qi@huawei.com, alex.chen@huawei.com, jlbec@evilplan.org, junxiao.bi@oracle.com, mfasheh@suse.com, wangww631@huawei.com, xuejiufei@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: set append dio as a ro compat feature
has been removed from the -mm tree.  Its filename was
     ocfs2-set-append-dio-as-a-ro-compat-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Joseph Qi <joseph.qi@huawei.com>
Subject: ocfs2: set append dio as a ro compat feature

Intruduce a bit OCFS2_FEATURE_RO_COMPAT_APPEND_DIO and check it in
write flow. If the bit is not set, fall back to the old way.

Signed-off-by: Joseph Qi <joseph.qi@huawei.com>
Cc: Weiwei Wang <wangww631@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Junxiao Bi <junxiao.bi@oracle.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Xuejiufei <xuejiufei@huawei.com>
Cc: alex chen <alex.chen@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/file.c     |   17 ++++++++++++++++-
 fs/ocfs2/ocfs2.h    |    8 ++++++++
 fs/ocfs2/ocfs2_fs.h |    8 +++++++-
 3 files changed, 31 insertions(+), 2 deletions(-)

diff -puN fs/ocfs2/file.c~ocfs2-set-append-dio-as-a-ro-compat-feature fs/ocfs2/file.c
--- a/fs/ocfs2/file.c~ocfs2-set-append-dio-as-a-ro-compat-feature
+++ a/fs/ocfs2/file.c
@@ -2213,6 +2213,15 @@ static int ocfs2_prepare_inode_for_write
 		}
 
 		/*
+		 * Fallback to old way if the feature bit is not set.
+		 */
+		if (end > i_size_read(inode) &&
+				!ocfs2_supports_append_dio(osb)) {
+			*direct_io = 0;
+			break;
+		}
+
+		/*
 		 * We don't fill holes during direct io, so
 		 * check for them here. If any are found, the
 		 * caller will have to retake some cluster
@@ -2220,7 +2229,13 @@ static int ocfs2_prepare_inode_for_write
 		 */
 		ret = ocfs2_check_range_for_holes(inode, saved_pos, count);
 		if (ret == 1) {
-			*direct_io = 0;
+			/*
+			 * Fallback to old way if the feature bit is not set.
+			 * Otherwise try dio first and then complete the rest
+			 * request through buffer io.
+			 */
+			if (!ocfs2_supports_append_dio(osb))
+				*direct_io = 0;
 			ret = 0;
 		} else if (ret < 0)
 			mlog_errno(ret);
diff -puN fs/ocfs2/ocfs2.h~ocfs2-set-append-dio-as-a-ro-compat-feature fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-set-append-dio-as-a-ro-compat-feature
+++ a/fs/ocfs2/ocfs2.h
@@ -500,6 +500,14 @@ static inline int ocfs2_writes_unwritten
 	return 0;
 }
 
+static inline int ocfs2_supports_append_dio(struct ocfs2_super *osb)
+{
+	if (osb->s_feature_ro_compat & OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+		return 1;
+	return 0;
+}
+
+
 static inline int ocfs2_supports_inline_data(struct ocfs2_super *osb)
 {
 	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_INLINE_DATA)
diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-set-append-dio-as-a-ro-compat-feature fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-set-append-dio-as-a-ro-compat-feature
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -105,7 +105,8 @@
 					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA \
+					 | OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -199,6 +200,11 @@
 #define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
 #define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004
 
+/*
+ * Append Direct IO support
+ */
+#define OCFS2_FEATURE_RO_COMPAT_APPEND_DIO	0x0008
+
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
  */
_

Patches currently in -mm which might be from joseph.qi@huawei.com are

origin.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages.patch
ocfs2-avoid-access-invalid-address-when-read-o2dlm-debug-messages-v3.patch

