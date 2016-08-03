From: akpm@linux-foundation.org
Subject: [patch 10/18] block: remove BLK_DEV_DAX config option
Date: Wed, 03 Aug 2016 13:46:15 -0700
Message-ID: <57a25817.dRHPWU6T/lSW+lzO%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39867 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758329AbcHCUqi (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Aug 2016 16:46:38 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: torvalds@linux-foundation.org, mm-commits@vger.kernel.org, akpm@linux-foundation.org, ross.zwisler@linux.intel.com, axboe@kernel.dk, dan.j.williams@intel.com, dave.hansen@linux.intel.com

From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: block: remove BLK_DEV_DAX config option

The functionality for block device DAX was already removed with this
commit:

commit acc93d30d7d4 ("Revert "block: enable dax for raw block devices"")

However, we still had a config option hanging around that was always
disabled because it depended on CONFIG_BROKEN.  This config option was
introduced in this commit:

commit 03cdadb04077 ("block: disable block device DAX by default")

This change reverts that commit, removing the dead config option.

Link: http://lkml.kernel.org/r/20160729182314.6368-1-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig  |   13 -------------
 fs/block_dev.c |    6 +-----
 2 files changed, 1 insertion(+), 18 deletions(-)

diff -puN block/Kconfig~block-remove-blk_dev_dax-config-option block/Kconfig
--- a/block/Kconfig~block-remove-blk_dev_dax-config-option
+++ a/block/Kconfig
@@ -88,19 +88,6 @@ config BLK_DEV_INTEGRITY
 	T10/SCSI Data Integrity Field or the T13/ATA External Path
 	Protection.  If in doubt, say N.
 
-config BLK_DEV_DAX
-	bool "Block device DAX support"
-	depends on FS_DAX
-	depends on BROKEN
-	help
-	  When DAX support is available (CONFIG_FS_DAX) raw block
-	  devices can also support direct userspace access to the
-	  storage capacity via MMAP(2) similar to a file on a
-	  DAX-enabled filesystem.  However, the DAX I/O-path disables
-	  some standard I/O-statistics, and the MMAP(2) path has some
-	  operational differences due to bypassing the page
-	  cache.  If in doubt, say N.
