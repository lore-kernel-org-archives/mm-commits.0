From: akpm@linux-foundation.org
Subject: [merged] lockd-fix-file_locking=n-build-error.patch removed from -mm tree
Date: Wed, 27 May 2009 13:55:48 -0700
Message-ID: <200905272055.n4RKtmCc026037@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48787 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755424AbZE0VDQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 May 2009 17:03:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, bfields@fieldses.org, trond.myklebust@fys.uio.no, mm-commits@vger.kernel.org


The patch titled
     lockd: fix FILE_LOCKING=n build error
has been removed from the -mm tree.  Its filename was
     lockd-fix-file_locking=n-build-error.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: lockd: fix FILE_LOCKING=n build error
From: Randy Dunlap <randy.dunlap@oracle.com>

lockd/svclock.c is missing a header file <linux/fs.h>.

<linux/fs.h> is missing a definition of locks_release_private()
for the config case of FILE_LOCKING=n, causing a build error:

fs/lockd/svclock.c:330: error: implicit declaration of function 'locks_release_private'

lockd without FILE_LOCKING doesn't make sense, so make LOCKD and LOCKD_V4
depend on FILE_LOCKING, and make NFS depend on FILE_LOCKING.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bruce Fields <bfields@fieldses.org>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig     |    2 ++
 fs/nfs/Kconfig |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff -puN fs/Kconfig~lockd-fix-file_locking=n-build-error fs/Kconfig
--- a/fs/Kconfig~lockd-fix-file_locking=n-build-error
+++ a/fs/Kconfig
@@ -236,10 +236,12 @@ source "fs/nfsd/Kconfig"
 
 config LOCKD
 	tristate
+	depends on FILE_LOCKING
 
 config LOCKD_V4
 	bool
 	depends on NFSD_V3 || NFS_V3
+	depends on FILE_LOCKING
 	default y
 
 config EXPORTFS
diff -puN fs/nfs/Kconfig~lockd-fix-file_locking=n-build-error fs/nfs/Kconfig
--- a/fs/nfs/Kconfig~lockd-fix-file_locking=n-build-error
+++ a/fs/nfs/Kconfig
@@ -1,6 +1,6 @@
 config NFS_FS
 	tristate "NFS client support"
-	depends on INET
+	depends on INET && FILE_LOCKING
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
x86-platform-oqo-select-input_polldev.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
hexdump-remove-the-trailing-space.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch

