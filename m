From: akpm@linux-foundation.org
Subject: [merged] ocfs2-make-append_dio-an-incompat-feature.patch removed
 from -mm tree
Date: Mon, 16 Mar 2015 11:02:30 -0700
Message-ID: <55071ab6.Yy6eEKN3vQLgEx1t%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33513 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944AbbCPSCb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 16 Mar 2015 14:02:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mfasheh@suse.de, jlbec@evilplan.org, joseph.qi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ocfs2: make append_dio an incompat feature
has been removed from the -mm tree.  Its filename was
     ocfs2-make-append_dio-an-incompat-feature.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mark Fasheh <mfasheh@suse.de>
Subject: ocfs2: make append_dio an incompat feature

It turns out that making this feature ro_compat isn't quite enough to
prevent accidental corruption on mount from older kernels.  Ocfs2 (like
other file systems) will process orphaned inodes even when the user mounts
in 'ro' mode.  So for the case of a filesystem not knowing the append_dio
feature, mounting the filesystem could result in orphaned-for-dio files
being deleted, which we clearly don't want.

So instead, turn this into an incompat flag.

Btw, this is kind of my fault - initially I asked that we add a flag to
cover the feature and even suggested that we use an ro flag.  It wasn't
until I was looking through our commits for v4.0-rc1 that I realized we
actually want this to be incompat.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
Cc: Joseph Qi <joseph.qi@huawei.com>
Cc: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/ocfs2.h    |    2 +-
 fs/ocfs2/ocfs2_fs.h |   15 ++++++++-------
 2 files changed, 9 insertions(+), 8 deletions(-)

diff -puN fs/ocfs2/ocfs2.h~ocfs2-make-append_dio-an-incompat-feature fs/ocfs2/ocfs2.h
--- a/fs/ocfs2/ocfs2.h~ocfs2-make-append_dio-an-incompat-feature
+++ a/fs/ocfs2/ocfs2.h
@@ -502,7 +502,7 @@ static inline int ocfs2_writes_unwritten
 
 static inline int ocfs2_supports_append_dio(struct ocfs2_super *osb)
 {
-	if (osb->s_feature_ro_compat & OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+	if (osb->s_feature_incompat & OCFS2_FEATURE_INCOMPAT_APPEND_DIO)
 		return 1;
 	return 0;
 }
diff -puN fs/ocfs2/ocfs2_fs.h~ocfs2-make-append_dio-an-incompat-feature fs/ocfs2/ocfs2_fs.h
--- a/fs/ocfs2/ocfs2_fs.h~ocfs2-make-append_dio-an-incompat-feature
+++ a/fs/ocfs2/ocfs2_fs.h
@@ -102,11 +102,11 @@
 					 | OCFS2_FEATURE_INCOMPAT_INDEXED_DIRS \
 					 | OCFS2_FEATURE_INCOMPAT_REFCOUNT_TREE \
 					 | OCFS2_FEATURE_INCOMPAT_DISCONTIG_BG	\
-					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO)
+					 | OCFS2_FEATURE_INCOMPAT_CLUSTERINFO \
+					 | OCFS2_FEATURE_INCOMPAT_APPEND_DIO)
 #define OCFS2_FEATURE_RO_COMPAT_SUPP	(OCFS2_FEATURE_RO_COMPAT_UNWRITTEN \
 					 | OCFS2_FEATURE_RO_COMPAT_USRQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA \
-					 | OCFS2_FEATURE_RO_COMPAT_APPEND_DIO)
+					 | OCFS2_FEATURE_RO_COMPAT_GRPQUOTA)
 
 /*
  * Heartbeat-only devices are missing journals and other files.  The
@@ -179,6 +179,11 @@
 #define OCFS2_FEATURE_INCOMPAT_CLUSTERINFO	0x4000
 
 /*
+ * Append Direct IO support
+ */
+#define OCFS2_FEATURE_INCOMPAT_APPEND_DIO	0x8000
+
+/*
  * backup superblock flag is used to indicate that this volume
  * has backup superblocks.
  */
@@ -200,10 +205,6 @@
 #define OCFS2_FEATURE_RO_COMPAT_USRQUOTA	0x0002
 #define OCFS2_FEATURE_RO_COMPAT_GRPQUOTA	0x0004
 
-/*
- * Append Direct IO support
- */
-#define OCFS2_FEATURE_RO_COMPAT_APPEND_DIO	0x0008
 
 /* The byte offset of the first backup block will be 1G.
  * The following will be 4G, 16G, 64G, 256G and 1T.
_

Patches currently in -mm which might be from mfasheh@suse.de are

ocfs2-dereferencing-freed-pointers-in-ocfs2_reflink.patch

