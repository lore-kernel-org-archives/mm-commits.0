From: akpm@linux-foundation.org
Subject: [patch 24/84] nilfs2: clean trailing semicolons in macros
Date: Mon, 23 May 2016 16:23:28 -0700
Message-ID: <574390f0./kssZUoQwEnFETNr%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42163 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbcEWXX3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 May 2016 19:23:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, konishi.ryusuke@lab.ntt.co.jp

From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Subject: nilfs2: clean trailing semicolons in macros

Remove trailing semicolons from macros, as suggested by checkpatch.pl.

Link: http://lkml.kernel.org/r/1461935747-10380-12-git-send-email-konishi.ryusuke@lab.ntt.co.jp
[konishi.ryusuke@lab.ntt.co.jp: fix style issues]
  Link: http://lkml.kernel.org/r/20160509.231703.1481729973362188932.konishi.ryusuke@lab.ntt.co.jp
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 fs/nilfs2/sysfs.h |    6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff -puN fs/nilfs2/sysfs.c~nilfs2-clean-trailing-semicolons-in-macros fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-clean-trailing-semicolons-in-macros
+++ a/fs/nilfs2/sysfs.c
@@ -68,7 +68,7 @@ static ssize_t nilfs_##name##_attr_store
 static const struct sysfs_ops nilfs_##name##_attr_ops = { \
 	.show	= nilfs_##name##_attr_show, \
 	.store	= nilfs_##name##_attr_store, \
-};
+}
 
 #define NILFS_DEV_INT_GROUP_TYPE(name, parent_name) \
 static void nilfs_##name##_attr_release(struct kobject *kobj) \
@@ -84,7 +84,7 @@ static struct kobj_type nilfs_##name##_k
 	.default_attrs	= nilfs_##name##_attrs, \
 	.sysfs_ops	= &nilfs_##name##_attr_ops, \
 	.release	= nilfs_##name##_attr_release, \
-};
+}
 
 #define NILFS_DEV_INT_GROUP_FNS(name, parent_name) \
 static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
diff -puN fs/nilfs2/sysfs.h~nilfs2-clean-trailing-semicolons-in-macros fs/nilfs2/sysfs.h
--- a/fs/nilfs2/sysfs.h~nilfs2-clean-trailing-semicolons-in-macros
+++ a/fs/nilfs2/sysfs.h
@@ -66,7 +66,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct kobject *, struct attribute *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_COMMON_ATTR_STRUCT(feature);
 
@@ -77,7 +77,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct the_nilfs *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_DEV_ATTR_STRUCT(dev);
 NILFS_DEV_ATTR_STRUCT(segments);
@@ -93,7 +93,7 @@ struct nilfs_##name##_attr { \
 			char *); \
 	ssize_t (*store)(struct nilfs_##name##_attr *, struct nilfs_root *, \
 			 const char *, size_t); \
-};
+}
 
 NILFS_CP_ATTR_STRUCT(snapshot);
 
_
