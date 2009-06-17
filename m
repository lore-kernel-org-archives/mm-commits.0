From: akpm@linux-foundation.org
Subject: [merged] config_file_locking-should-not-depend-on-config_block.patch removed from -mm tree
Date: Wed, 17 Jun 2009 11:37:58 -0700
Message-ID: <200906171837.n5HIbwCE003965@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53447 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760702AbZFQSkA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 17 Jun 2009 14:40:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: szepe@pinerecords.com, stable@kernel.org, mm-commits@vger.kernel.org


The patch titled
     CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
has been removed from the -mm tree.  Its filename was
     config_file_locking-should-not-depend-on-config_block.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK
From: Tomas Szepe <szepe@pinerecords.com>

CONFIG_FILE_LOCKING should not depend on CONFIG_BLOCK.

This makes it possible to run complete systems out of a CONFIG_BLOCK=n
initramfs on current kernels again (this last worked on 2.6.27.*).

Cc: <stable@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/Kconfig |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff -puN fs/Kconfig~config_file_locking-should-not-depend-on-config_block fs/Kconfig
--- a/fs/Kconfig~config_file_locking-should-not-depend-on-config_block
+++ a/fs/Kconfig
@@ -39,6 +39,13 @@ config FS_POSIX_ACL
 	bool
 	default n
 
+source "fs/xfs/Kconfig"
+source "fs/gfs2/Kconfig"
+source "fs/ocfs2/Kconfig"
+source "fs/btrfs/Kconfig"
+
+endif # BLOCK
+
 config FILE_LOCKING
 	bool "Enable POSIX file locking API" if EMBEDDED
 	default y
@@ -47,13 +54,6 @@ config FILE_LOCKING
           for filesystems like NFS and for the flock() system
           call. Disabling this option saves about 11k.
 
-source "fs/xfs/Kconfig"
-source "fs/gfs2/Kconfig"
-source "fs/ocfs2/Kconfig"
-source "fs/btrfs/Kconfig"
-
-endif # BLOCK
