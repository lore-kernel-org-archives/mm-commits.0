From: akpm@linux-foundation.org
Subject: + cleancache-forbid-overriding-cleancache_ops.patch added to -mm
 tree
Date: Wed, 25 Feb 2015 14:41:20 -0800
Message-ID: <54ee4f90.+8CrpIdMhaUd83oP%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbbBYWlV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Feb 2015 17:41:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: vdavydov@parallels.com, andor.daam@googlemail.com, boris.ostrovsky@oracle.com, dan.magenheimer@oracle.com, david.vrabel@citrix.com, fschmaus@gmail.com, ilendir@googlemail.com, jlbec@evilplan.org, konrad.wilk@oracle.com, lliubbo@gmail.com, mfasheh@suse.com, mm-commits@vger.kernel.org


The patch titled
     Subject: cleancache: forbid overriding cleancache_ops
has been added to the -mm tree.  Its filename is
     cleancache-forbid-overriding-cleancache_ops.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/cleancache-forbid-overriding-cleancache_ops.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/cleancache-forbid-overriding-cleancache_ops.patch

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
Subject: cleancache: forbid overriding cleancache_ops

Currently, cleancache_register_ops returns the previous value of
cleancache_ops to allow chaining.  However, chaining, as it is implemented
now, is extremely dangerous due to possible pool id collisions.  Suppose,
a new cleancache driver is registered after the previous one assigned an
id to a super block.  If the new driver assigns the same id to another
super block, which is perfectly possible, we will have two different
filesystems using the same id.  No matter if the new driver implements
chaining or not, we are likely to get data corruption with such a
configuration eventually.

This patch therefore disables the ability to override cleancache_ops
altogether as potentially dangerous.  If there is already cleancache
driver registered, all further calls to cleancache_register_ops will
return EBUSY.  Since no user of cleancache implements chaining, we only
need to make minor changes to the code outside the cleancache core.

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

 Documentation/vm/cleancache.txt |    4 +---
 drivers/xen/tmem.c              |   16 +++++++++-------
 include/linux/cleancache.h      |    3 +--
 mm/cleancache.c                 |   12 +++++++-----
 4 files changed, 18 insertions(+), 17 deletions(-)

diff -puN Documentation/vm/cleancache.txt~cleancache-forbid-overriding-cleancache_ops Documentation/vm/cleancache.txt
--- a/Documentation/vm/cleancache.txt~cleancache-forbid-overriding-cleancache_ops
+++ a/Documentation/vm/cleancache.txt
@@ -28,9 +28,7 @@ IMPLEMENTATION OVERVIEW
 A cleancache "backend" that provides transcendent memory registers itself
 to the kernel's cleancache "frontend" by calling cleancache_register_ops,
 passing a pointer to a cleancache_ops structure with funcs set appropriately.
-Note that cleancache_register_ops returns the previous settings so that
-chaining can be performed if desired. The functions provided must conform to
-certain semantics as follows:
+The functions provided must conform to certain semantics as follows:
 
 Most important, cleancache is "ephemeral".  Pages which are copied into
 cleancache have an indefinite lifetime which is completely unknowable
diff -puN drivers/xen/tmem.c~cleancache-forbid-overriding-cleancache_ops drivers/xen/tmem.c
--- a/drivers/xen/tmem.c~cleancache-forbid-overriding-cleancache_ops
+++ a/drivers/xen/tmem.c
@@ -397,13 +397,15 @@ static int __init xen_tmem_init(void)
 #ifdef CONFIG_CLEANCACHE
 	BUG_ON(sizeof(struct cleancache_filekey) != sizeof(struct tmem_oid));
 	if (tmem_enabled && cleancache) {
-		char *s = "";
-		struct cleancache_ops *old_ops =
-			cleancache_register_ops(&tmem_cleancache_ops);
-		if (old_ops)
-			s = " (WARNING: cleancache_ops overridden)";
-		pr_info("cleancache enabled, RAM provided by Xen Transcendent Memory%s\n",
-			s);
+		int err;
+
+		err = cleancache_register_ops(&tmem_cleancache_ops);
+		if (err)
+			pr_warn("xen-tmem: failed to enable cleancache: %d\n",
+				err);
+		else
+			pr_info("cleancache enabled, RAM provided by "
+				"Xen Transcendent Memory\n");
 	}
 #endif
 #ifdef CONFIG_XEN_SELFBALLOONING
diff -puN include/linux/cleancache.h~cleancache-forbid-overriding-cleancache_ops include/linux/cleancache.h
--- a/include/linux/cleancache.h~cleancache-forbid-overriding-cleancache_ops
+++ a/include/linux/cleancache.h
@@ -33,8 +33,7 @@ struct cleancache_ops {
 	void (*invalidate_fs)(int);
 };
 
-extern struct cleancache_ops *
-	cleancache_register_ops(struct cleancache_ops *ops);
+extern int cleancache_register_ops(struct cleancache_ops *ops);
 extern void __cleancache_init_fs(struct super_block *);
 extern void __cleancache_init_shared_fs(struct super_block *);
 extern int  __cleancache_get_page(struct page *);
diff -puN mm/cleancache.c~cleancache-forbid-overriding-cleancache_ops mm/cleancache.c
--- a/mm/cleancache.c~cleancache-forbid-overriding-cleancache_ops
+++ a/mm/cleancache.c
@@ -106,15 +106,17 @@ static DEFINE_MUTEX(poolid_mutex);
  */
 
 /*
- * Register operations for cleancache, returning previous thus allowing
- * detection of multiple backends and possible nesting.
+ * Register operations for cleancache. Returns 0 on success.
  */
-struct cleancache_ops *cleancache_register_ops(struct cleancache_ops *ops)
+int cleancache_register_ops(struct cleancache_ops *ops)
 {
-	struct cleancache_ops *old = cleancache_ops;
 	int i;
 
 	mutex_lock(&poolid_mutex);
+	if (cleancache_ops) {
+		mutex_unlock(&poolid_mutex);
+		return -EBUSY;
+	}
 	for (i = 0; i < MAX_INITIALIZABLE_FS; i++) {
 		if (fs_poolid_map[i] == FS_NO_BACKEND)
 			fs_poolid_map[i] = ops->init_fs(PAGE_SIZE);
@@ -130,7 +132,7 @@ struct cleancache_ops *cleancache_regist
 	barrier();
 	cleancache_ops = ops;
 	mutex_unlock(&poolid_mutex);
-	return old;
+	return 0;
 }
 EXPORT_SYMBOL(cleancache_register_ops);
 
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

