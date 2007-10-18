From: akpm@linux-foundation.org
Subject: - menuconfig-transform-network-filesystems-menu.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:01:19 -0700
Message-ID: <200710180701.l9I71JbU031167@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40969 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932563AbXJRHsP (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:48:15 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jengelh@computergmbh.de, bfields@fieldses.org, dhowells@redhat.com, ericvh@hera.kernel.org, jengelh@gmx.de, neilb@suse.de, sfrench@us.ibm.com, trond.myklebust@fys.uio.no, mm-commits@v


The patch titled
     menuconfig: transform Network Filesystems menu
has been removed from the -mm tree.  Its filename was
     menuconfig-transform-network-filesystems-menu.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: menuconfig: transform Network Filesystems menu
From: Jan Engelhardt <jengelh@computergmbh.de>

Turn Network File Systems into a menuconfig so that it can be disabled at
once.

(Note: I added a "default y". If you do not like that, speak up.)

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Steven French <sfrench@us.ibm.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Eric Van Hensbergen <ericvh@hera.kernel.org>
Cc: Neil Brown <neilb@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff -puN fs/Kconfig~menuconfig-transform-network-filesystems-menu fs/Kconfig
--- a/fs/Kconfig~menuconfig-transform-network-filesystems-menu
+++ a/fs/Kconfig
@@ -1547,8 +1547,20 @@ config UFS_DEBUG
 
 endmenu
 
-menu "Network File Systems"
+menuconfig NETWORK_FILESYSTEMS
+	bool "Network File Systems"
+	default y
 	depends on NET
+	---help---
+	  Say Y here to get to see options for network filesystems and
+	  filesystem-related networking code, such as NFS daemon and
+	  RPCSEC security modules.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled; if unsure, say Y here.
+
+if NETWORK_FILESYSTEMS
 
 config NFS_FS
 	tristate "NFS file system support"
@@ -2094,7 +2106,7 @@ config 9P_FS
 
 	  If unsure, say N.
 
-endmenu
+endif # NETWORK_FILESYSTEMS
 
 if BLOCK
 menu "Partition Types"
_

Patches currently in -mm which might be from jengelh@computergmbh.de are

origin.patch
remove-config_vt_unicode.patch
intel-iommu-iommu-gfx-workaround-kconfig-fix.patch
intel-iommu-iommu-floppy-workaround-kconfig-fix.patch
