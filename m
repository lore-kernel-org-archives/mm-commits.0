From: akpm@linux-foundation.org
Subject: - xfs-fix-disabled-xfs-posix-acl-handling.patch removed from -mm tree
Date: Sun, 13 Jul 2008 21:35:53 -0700
Message-ID: <200807140435.m6E4Zrmn022440@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57550 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036AbYGNEgd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 14 Jul 2008 00:36:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, david@fromorbit.com, hch@lst.de, lachlan@sgi.com, tes@sgi.com, mm-commits@vger.kernel.org


The patch titled
     xfs: fix disabled XFS POSIX ACL handling
has been removed from the -mm tree.  Its filename was
     xfs-fix-disabled-xfs-posix-acl-handling.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: xfs: fix disabled XFS POSIX ACL handling
From: David Howells <dhowells@redhat.com>

Fix XFS POSIX ACL handling when it's not enabled.  xfs_decode_acl() refers to
return types that aren't defined under those circumstances.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Timothy Shimmin <tes@sgi.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/xfs/linux-2.6/xfs_xattr.c |   14 --------------
 fs/xfs/xfs_acl.c             |   13 +++++++++++++
 fs/xfs/xfs_acl.h             |    2 ++
 3 files changed, 15 insertions(+), 14 deletions(-)

diff -puN fs/xfs/linux-2.6/xfs_xattr.c~xfs-fix-disabled-xfs-posix-acl-handling fs/xfs/linux-2.6/xfs_xattr.c
--- a/fs/xfs/linux-2.6/xfs_xattr.c~xfs-fix-disabled-xfs-posix-acl-handling
+++ a/fs/xfs/linux-2.6/xfs_xattr.c
@@ -30,20 +30,6 @@
 
 
 /*
- * ACL handling.  Should eventually be moved into xfs_acl.c
- */
-
-static int
-xfs_decode_acl(const char *name)
-{
-	if (strcmp(name, "posix_acl_access") == 0)
-		return _ACL_TYPE_ACCESS;
-	else if (strcmp(name, "posix_acl_default") == 0)
-		return _ACL_TYPE_DEFAULT;
-	return -EINVAL;
-}
-
-/*
  * Get system extended attributes which at the moment only
  * includes Posix ACLs.
  */
diff -puN fs/xfs/xfs_acl.c~xfs-fix-disabled-xfs-posix-acl-handling fs/xfs/xfs_acl.c
--- a/fs/xfs/xfs_acl.c~xfs-fix-disabled-xfs-posix-acl-handling
+++ a/fs/xfs/xfs_acl.c
@@ -51,6 +51,19 @@ kmem_zone_t *xfs_acl_zone;
 
 
 /*
+ * ACL handling.
+ */
+int
+xfs_decode_acl(const char *name)
+{
+	if (strcmp(name, "posix_acl_access") == 0)
+		return _ACL_TYPE_ACCESS;
+	else if (strcmp(name, "posix_acl_default") == 0)
+		return _ACL_TYPE_DEFAULT;
+	return -EINVAL;
+}
+
+/*
  * Test for existence of access ACL attribute as efficiently as possible.
  */
 int
diff -puN fs/xfs/xfs_acl.h~xfs-fix-disabled-xfs-posix-acl-handling fs/xfs/xfs_acl.h
--- a/fs/xfs/xfs_acl.h~xfs-fix-disabled-xfs-posix-acl-handling
+++ a/fs/xfs/xfs_acl.h
@@ -59,6 +59,7 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
+extern int xfs_decode_acl(const char *);
 extern int xfs_acl_inherit(bhv_vnode_t *, mode_t mode, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
 extern int xfs_acl_vtoacl(bhv_vnode_t *, xfs_acl_t *, xfs_acl_t *);
@@ -80,6 +81,7 @@ extern int xfs_acl_vremove(bhv_vnode_t *
 #define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
 
 #else
+#define xfs_decode_acl(name)	(-EINVAL)
 #define xfs_acl_zone_init(zone,name)
 #define xfs_acl_zone_destroy(zone)
 #define xfs_acl_vset(v,p,sz,t)	(-EOPNOTSUPP)
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
linux-next.patch
acpi-fix-a-cast-of-a-32-bit-int-to-a-pointer.patch
calgary-fix-a-comparison-warning-the-pci-calgary-64-driver.patch
cifs-fix-range-check.patch
sis-drm-fix-the-memory-allocator-if-the-sis-fb-is-built-as-a-module.patch
sis-drm-fix-a-pointer-cast-warning.patch
ivtv-framebuffer-driver-fix-pointer-cast-warnings.patch
drx397xd-demodulator-driver-fix-a-const-pointer-assignment.patch
mtd-fix-const-assignment-in-the-command-line-partitioning-driver.patch
netfilter-fix-xt_times-time_mts-use-of-do_div.patch
atm-fix-const-assignment-discard-warnings-in-the-atm-networking-driver.patch
atm-fix-direct-casts-of-pointers-to-u32-in-the-interphase-driver.patch
hysdn-remove-the-packed-attribute-from-poftimstamp_tag.patch
sched-fix-inc_rt_tasks-to-not-declare-variable-rq-if-its-not-needed.patch
git-unionfs.patch
xfs-fix-disabled-xfs-posix-acl-handling.patch
clocksource-fix-a-print-format-error-in-the-acpi-pm-clocksource-driver-and-check-range.patch
x86-pci-fix-pci_subsys_init-to-have-a-return-value.patch
pm-fix-try_to_freeze_taskss-use-of-do_div.patch
mn10300-move-sg_dma_addresslen-to-asm-scatterlisth.patch
inflate-refactor-inflate-malloc-code.patch
inflate-refactor-inflate-malloc-code-checkpatch-fixes.patch
pnpacpi-fix-pnpacpi_parse_irq_options-test-against-pnp_irq_nr.patch
pnp-fix-the-fcpnp_driver-declaration-to-only-exist-if-config_pnp=y.patch
include-asm-ptraceh-userspace-headers-cleanup.patch
sdio-fix-break-control-to-now-return-success-or-an-error.patch
mn10300-fix-mn10300s-serial-port-driver-to-get-at-its-tty_struct.patch
ip2-fix-iielliscleanup-as-it-is-static-but-not-always-used.patch
stallion-fix-the-istallion-drivers-putchar-and-break_ctl-ops.patch
tsacct-fix-bacct_add_tsks-use-of-do_div.patch
frv-use-the-common-ascii-hex-helpers.patch
mn10300-use-the-common-ascii-hex-helpers.patch
mutex-subsystem-synchro-test-module.patch

