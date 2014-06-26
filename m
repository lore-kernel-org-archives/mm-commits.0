From: akpm@linux-foundation.org
Subject: + nilfs2-integrate-sysfs-support-into-driver-fix.patch added to
 -mm tree
Date: Thu, 26 Jun 2014 12:34:11 -0700
Message-ID: <53ac75b3.QpAiAq7e9Swfv4XV%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbaFZTeM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 26 Jun 2014 15:34:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: fengguang.wu@intel.com, Vyacheslav.Dubeyko@hgst.com, hannes@cmpxchg.org, mm-commits@vger.kernel.org


The patch titled
     Subject: nilfs2: nilfs_sysfs_create_mounted_snapshots_group can be static
has been added to the -mm tree.  Its filename is
     nilfs2-integrate-sysfs-support-into-driver-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/nilfs2-integrate-sysfs-support-into-driver-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/nilfs2-integrate-sysfs-support-into-driver-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
slab-common-add-functions-for-kmem_cache_node-access-fix.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
mm-readaheadc-remove-unused-file_ra_state-from-count_history_pages.patch
ppc-kvm-cma-use-general-cma-reserved-area-management-framework-fix.patch
mm-memcontrol-rewrite-uncharge-api-fix-2.patch
mm-zpool-update-zswap-to-use-zpool-fix.patch
include-kernelh-rewrite-min3-max3-and-clamp-using-min-and-max-fix.patch
add-lib-globc-fix.patch
nilfs2-integrate-sysfs-support-into-driver-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
linux-next.patch
drivers-staging-emxx_udc-emxx_udcc-replace-strict_strto-with-kstrto.patch
mm-add-strictlimit-knob-v2.patch
debugging-keep-track-of-page-owners.patch

