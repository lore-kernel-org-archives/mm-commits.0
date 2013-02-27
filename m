From: akpm@linux-foundation.org
Subject: [merged] block-fix-part_pack_uuid-build-error.patch removed from -mm tree
Date: Wed, 27 Feb 2013 12:50:42 -0800
Message-ID: <20130227205042.CBA665A41BD@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f201.google.com ([209.85.220.201]:62428 "EHLO
	mail-vc0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767Ab3B0Uuo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Feb 2013 15:50:44 -0500
Received: by mail-vc0-f201.google.com with SMTP id n11so111312vch.4
        for <mm-commits@vger.kernel.org>; Wed, 27 Feb 2013 12:50:43 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: zohar@linux.vnet.ibm.com, axboe@kernel.dk, jmorris@namei.org, rdunlap@infradead.org, rientjes@google.com, mm-commits@vger.kernel.org


The patch titled
     Subject: block: fix part_pack_uuid() build error
has been removed from the -mm tree.  Its filename was
     block-fix-part_pack_uuid-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: block: fix part_pack_uuid() build error

Fix a build error when CONFIG_BLOCK is not enabled, by defining a wrapper
called blk_part_pack_uuid().  The wrapper returns -EINVAL, when
CONFIG_BLOCK is not defined.

security/integrity/ima/ima_policy.c:538:4: error: implicit declaration
of function 'part_pack_uuid' [-Werror=implicit-function-declaration]

Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: David Rientjes <rientjes@google.com>
Acked-by: David Rientjes <rientjes@google.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Cc: James Morris <jmorris@namei.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/genhd.h               |   10 ++++++++++
 security/integrity/ima/ima_policy.c |   11 ++++++-----
 2 files changed, 16 insertions(+), 5 deletions(-)

diff -puN include/linux/genhd.h~block-fix-part_pack_uuid-build-error include/linux/genhd.h
--- a/include/linux/genhd.h~block-fix-part_pack_uuid-build-error
+++ a/include/linux/genhd.h
@@ -231,6 +231,12 @@ static inline void part_pack_uuid(const 
 	}
 }
 
+static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
+{
+	part_pack_uuid(uuid_str, to);
+	return 0;
+}
+
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
@@ -718,6 +724,10 @@ static inline dev_t blk_lookup_devt(cons
 	return devt;
 }
 
+static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_BLOCK */
 
 #endif /* _LINUX_GENHD_H */
diff -puN security/integrity/ima/ima_policy.c~block-fix-part_pack_uuid-build-error security/integrity/ima/ima_policy.c
--- a/security/integrity/ima/ima_policy.c~block-fix-part_pack_uuid-build-error
+++ a/security/integrity/ima/ima_policy.c
@@ -176,7 +176,7 @@ static bool ima_match_rules(struct ima_r
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
 	if ((rule->flags & IMA_FSUUID) &&
-		memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
+	    memcmp(rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
 		return false;
 	if ((rule->flags & IMA_UID) && !uid_eq(rule->uid, cred->uid))
 		return false;
@@ -530,14 +530,15 @@ static int ima_parse_rule(char *rule, st
 			ima_log_string(ab, "fsuuid", args[0].from);
 
 			if (memchr_inv(entry->fsuuid, 0x00,
-			    sizeof(entry->fsuuid))) {
+				       sizeof(entry->fsuuid))) {
 				result = -EINVAL;
 				break;
 			}
 
-			part_pack_uuid(args[0].from, entry->fsuuid);
-			entry->flags |= IMA_FSUUID;
-			result = 0;
+			result = blk_part_pack_uuid(args[0].from,
+						    entry->fsuuid);
+			if (!result)
+				entry->flags |= IMA_FSUUID;
 			break;
 		case Opt_uid:
 			ima_log_string(ab, "uid", args[0].from);
_

Patches currently in -mm which might be from zohar@linux.vnet.ibm.com are

origin.patch
ocfs2-fix-ocfs2_init_security_and_acl-to-initialize-acl-correctly.patch

