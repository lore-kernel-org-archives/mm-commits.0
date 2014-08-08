From: akpm@linux-foundation.org
Subject: [folded-merged]
 nilfs2-integrate-sysfs-support-into-driver-fix.patch removed from -mm tree
Date: Fri, 08 Aug 2014 13:57:06 -0700
Message-ID: <53e539a2.D5hxWdf2k3kkWtmT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ie0-f202.google.com ([209.85.223.202]:51008 "EHLO
	mail-ie0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347AbaHHU5H (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:57:07 -0400
Received: by mail-ie0-f202.google.com with SMTP id rl12so1101934iec.3
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:57:06 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, Vyacheslav.Dubeyko@hgst.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: nilfs_sysfs_create_mounted_snapshots_group can be static
has been removed from the -mm tree.  Its filename was
     nilfs2-integrate-sysfs-support-into-driver-fix.patch

This patch was dropped because it was folded into nilfs2-integrate-sysfs-support-into-driver.patch

------------------------------------------------------
From: Fengguang Wu <fengguang.wu@intel.com>
Subject: nilfs2: nilfs_sysfs_create_mounted_snapshots_group can be static

Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Cc: Vyacheslav Dubeyko <Vyacheslav.Dubeyko@hgst.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/nilfs2/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN fs/nilfs2/sysfs.c~nilfs2-integrate-sysfs-support-into-driver-fix fs/nilfs2/sysfs.c
--- a/fs/nilfs2/sysfs.c~nilfs2-integrate-sysfs-support-into-driver-fix
+++ a/fs/nilfs2/sysfs.c
@@ -87,7 +87,7 @@ static struct kobj_type nilfs_##name##_k
 };
 
 #define NILFS_DEV_INT_GROUP_FNS(name, parent_name) \
-int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
+static int nilfs_sysfs_create_##name##_group(struct the_nilfs *nilfs) \
 { \
 	struct kobject *parent; \
 	struct kobject *kobj; \
@@ -106,7 +106,7 @@ int nilfs_sysfs_create_##name##_group(st
 		return err; \
 	return 0; \
 } \
-void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
+static void nilfs_sysfs_delete_##name##_group(struct the_nilfs *nilfs) \
 { \
 	kobject_del(&nilfs->ns_##parent_name##_subgroups->sg_##name##_kobj); \
 }
_

Patches currently in -mm which might be from fengguang.wu@intel.com are

origin.patch
fs-befs-linuxvfsc-check-superblock-before-dump-operation.patch
nilfs2-integrate-sysfs-support-into-driver.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch

