From: akpm@linux-foundation.org
Subject: + gfs2-use-unified-uuid-guid-code.patch added to -mm tree
Date: Thu, 15 Oct 2009 20:45:56 -0700
Message-ID: <200910160345.n9G3juDj028370@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33171 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750805AbZJPDqz (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 15 Oct 2009 23:46:55 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: ying.huang@intel.com, joe@perches.com, laurent.pinchart@ideasonboard.com, swhiteho@redhat.com


The patch titled
     gfs2: use unified UUID/GUID code
has been added to the -mm tree.  Its filename is
     gfs2-use-unified-uuid-guid-code.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: gfs2: use unified UUID/GUID code
From: Huang Ying <ying.huang@intel.com>

Replace u8[16] UUID definition in gfs2.

Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Joe Perches <joe@perches.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/gfs2/incore.h            |    3 ++-
 fs/gfs2/ops_fstype.c        |    2 +-
 fs/gfs2/sys.c               |   14 ++++----------
 include/linux/gfs2_ondisk.h |    3 ++-
 4 files changed, 9 insertions(+), 13 deletions(-)

diff -puN fs/gfs2/incore.h~gfs2-use-unified-uuid-guid-code fs/gfs2/incore.h
--- a/fs/gfs2/incore.h~gfs2-use-unified-uuid-guid-code
+++ a/fs/gfs2/incore.h
@@ -15,6 +15,7 @@
 #include <linux/slow-work.h>
 #include <linux/dlm.h>
 #include <linux/buffer_head.h>
+#include <linux/uuid.h>
 
 #define DIO_WAIT	0x00000010
 #define DIO_METADATA	0x00000020
@@ -483,7 +484,7 @@ struct gfs2_sb_host {
 
 	char sb_lockproto[GFS2_LOCKNAME_LEN];
 	char sb_locktable[GFS2_LOCKNAME_LEN];
-	u8 sb_uuid[16];
+	uuid_be sb_uuid;
 };
 
 /*
diff -puN fs/gfs2/ops_fstype.c~gfs2-use-unified-uuid-guid-code fs/gfs2/ops_fstype.c
--- a/fs/gfs2/ops_fstype.c~gfs2-use-unified-uuid-guid-code
+++ a/fs/gfs2/ops_fstype.c
@@ -234,7 +234,7 @@ static void gfs2_sb_in(struct gfs2_sb_ho
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
-	memcpy(sb->sb_uuid, str->sb_uuid, 16);
+	sb->sb_uuid = str->sb_uuid;
 }
 
 /**
diff -puN fs/gfs2/sys.c~gfs2-use-unified-uuid-guid-code fs/gfs2/sys.c
--- a/fs/gfs2/sys.c~gfs2-use-unified-uuid-guid-code
+++ a/fs/gfs2/sys.c
@@ -68,20 +68,14 @@ static ssize_t fsname_show(struct gfs2_s
 	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_fsname);
 }
 
-static int gfs2_uuid_valid(const u8 *uuid)
+static int gfs2_uuid_valid(const uuid_be *uuid)
 {
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		if (uuid[i])
-			return 1;
-	}
-	return 0;
+	return uuid_be_cmp(*uuid, NULL_UUID_BE);
 }
 
 static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 {
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	const uuid_be *uuid = &sdp->sd_sb.sb_uuid;
 	buf[0] = '\0';
 	if (!gfs2_uuid_valid(uuid))
 		return 0;
@@ -565,7 +559,7 @@ static int gfs2_uevent(struct kset *kset
 		       struct kobj_uevent_env *env)
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
-	const u8 *uuid = sdp->sd_sb.sb_uuid;
+	const uuid_be *uuid = &sdp->sd_sb.sb_uuid;
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
diff -puN include/linux/gfs2_ondisk.h~gfs2-use-unified-uuid-guid-code include/linux/gfs2_ondisk.h
--- a/include/linux/gfs2_ondisk.h~gfs2-use-unified-uuid-guid-code
+++ a/include/linux/gfs2_ondisk.h
@@ -11,6 +11,7 @@
 #define __GFS2_ONDISK_DOT_H__
 
 #include <linux/types.h>
+#include <linux/uuid.h>
 
 #define GFS2_MAGIC		0x01161970
 #define GFS2_BASIC_BLOCK	512
@@ -124,7 +125,7 @@ struct gfs2_sb {
 	struct gfs2_inum __pad3; /* Was quota inode in gfs1 */
 	struct gfs2_inum __pad4; /* Was licence inode in gfs1 */
 #define GFS2_HAS_UUID 1
-	__u8 sb_uuid[16]; /* The UUID, maybe 0 for backwards compat */
+	uuid_be sb_uuid; /* The UUID, maybe 0 for backwards compat */
 };
 
 /*
_

Patches currently in -mm which might be from ying.huang@intel.com are

linux-next.patch
lib-unified-uuid-guid-definition.patch
gfs2-use-unified-uuid-guid-code.patch

