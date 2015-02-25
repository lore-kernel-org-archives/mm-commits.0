From: akpm@linux-foundation.org
Subject: + cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
 added to -mm tree
Date: Wed, 25 Feb 2015 14:41:18 -0800
Message-ID: <54ee4f8e.+7BEiGj8lZsEh4XO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbbBYWlU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:41:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cleancache: zap uuid arg of cleancache_init_shared_fs
has been added to the -mm tree.  Its filename is
     cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Vladimir Davydov <vdavydov@parallels.com>
Subject: cleancache: zap uuid arg of cleancache_init_shared_fs

Use super_block->s_uuid instead.  Every shared filesystem using cleancache
must now initialize super_block->s_uuid before calling
cleancache_init_shared_fs.  The only one on the tree, ocfs2, already meets
this requirement.

Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: David Vrabel <david.vrabel@citrix.com>
Cc: Mark Fasheh <mfasheh@suse.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Stefan Hengelein <ilendir@googlemail.com>
Cc: Florian Schmaus <fschmaus@gmail.com>
Cc: Andor Daam <andor.daam@googlemail.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Bob Liu <lliubbo@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ocfs2/super.c           |    2 +-
 include/linux/cleancache.h |    6 +++---
 mm/cleancache.c            |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/ocfs2/super.c~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs fs/ocfs2/super.c
--- a/fs/ocfs2/super.c~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs
+++ a/fs/ocfs2/super.c
@@ -2335,7 +2335,7 @@ static int ocfs2_initialize_super(struct
 		mlog_errno(status);
 		goto bail;
 	}
-	cleancache_init_shared_fs((char *)&di->id2.i_super.s_uuid, sb);
+	cleancache_init_shared_fs(sb);
 
 bail:
 	return status;
diff -puN include/linux/cleancache.h~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs include/linux/cleancache.h
--- a/include/linux/cleancache.h~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs
+++ a/include/linux/cleancache.h
@@ -36,7 +36,7 @@ struct cleancache_ops {
 extern struct cleancache_ops *
 	cleancache_register_ops(struct cleancache_ops *ops);
 extern void __cleancache_init_fs(struct super_block *);
-extern void __cleancache_init_shared_fs(char *, struct super_block *);
+extern void __cleancache_init_shared_fs(struct super_block *);
 extern int  __cleancache_get_page(struct page *);
 extern void __cleancache_put_page(struct page *);
 extern void __cleancache_invalidate_page(struct address_space *, struct page *);
@@ -78,10 +78,10 @@ static inline void cleancache_init_fs(st
 		__cleancache_init_fs(sb);
 }
 
-static inline void cleancache_init_shared_fs(char *uuid, struct super_block *sb)
+static inline void cleancache_init_shared_fs(struct super_block *sb)
 {
 	if (cleancache_enabled)
-		__cleancache_init_shared_fs(uuid, sb);
+		__cleancache_init_shared_fs(sb);
 }
 
 static inline int cleancache_get_page(struct page *page)
diff -puN mm/cleancache.c~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs mm/cleancache.c
--- a/mm/cleancache.c~cleancache-zap-uuid-arg-of-cleancache_init_shared_fs
+++ a/mm/cleancache.c
@@ -155,7 +155,7 @@ void __cleancache_init_fs(struct super_b
 EXPORT_SYMBOL(__cleancache_init_fs);
 
 /* Called by a cleancache-enabled clustered filesystem at time of mount */
-void __cleancache_init_shared_fs(char *uuid, struct super_block *sb)
+void __cleancache_init_shared_fs(struct super_block *sb)
 {
 	int i;
 
@@ -163,10 +163,10 @@ void __cleancache_init_shared_fs(char *u
 	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
 		if (shared_fs_poolid_map[i] == FS_UNKNOWN) {
 			sb->cleancache_poolid = i + FAKE_SHARED_FS_POOLID_OFFSET;
-			uuids[i] = uuid;
+			uuids[i] = sb->s_uuid;
 			if (cleancache_ops)
 				shared_fs_poolid_map[i] = cleancache_ops->init_shared_fs
-						(uuid, PAGE_SIZE);
+						(sb->s_uuid, PAGE_SIZE);
 			else
 				shared_fs_poolid_map[i] = FS_NO_BACKEND;
 			break;
_

Patches currently in -mm which might be from vdavydov@parallels.com are

mm-memcontrol-use-max-instead-of-infinity-in-control-knobs.patch
mm-hotplug-fix-concurrent-memory-hot-add-deadlock.patch
ocfs2-copy-fs-uuid-to-superblock.patch
cleancache-zap-uuid-arg-of-cleancache_init_shared_fs.patch
cleancache-forbid-overriding-cleancache_ops.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems.patch
cleancache-remove-limit-on-the-number-of-cleancache-enabled-filesystems-fix.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch

