From: akpm@linux-foundation.org
Subject: - bsg-fix-build-for-config_block=n.patch removed from -mm tree
Date: Sat, 28 Jul 2007 23:13:02 -0700
Message-ID: <200707290613.l6T6D2WE011169@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37472 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757570AbXG2GXl (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 29 Jul 2007 02:23:41 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: lethal@linux-sh.org, jens.axboe@oracle.com, mm-commits@vger.kernel.org


The patch titled
     bsg: fix build for CONFIG_BLOCK=n
has been removed from the -mm tree.  Its filename was
     bsg-fix-build-for-config_block=n.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: bsg: fix build for CONFIG_BLOCK=n
From: Paul Mundt <lethal@linux-sh.org>

BLK_DEV_BSG was added outside of the if BLOCK check, which allows it to be
enabled when CONFIG_BLOCK=n.  This leads to many screenlengths of errors,
starting with a parse error on the request_queue_t definition.  Obviously
this wasn't intended for CONFIG_BLOCK=n usage, so just move the option back
in to the block.

Caught with a randconfig on sh.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 block/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN block/Kconfig~bsg-fix-build-for-config_block=n block/Kconfig
--- a/block/Kconfig~bsg-fix-build-for-config_block=n
+++ a/block/Kconfig
@@ -49,8 +49,6 @@ config LSF
 
 	  If unsure, say Y.
 
-endif # BLOCK
-
 config BLK_DEV_BSG
 	bool "Block layer SG support v4 (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -64,4 +62,6 @@ config BLK_DEV_BSG
 	protocols (e.g. Task Management Functions and SMP in Serial
 	Attached SCSI).
 
+endif # BLOCK
+
 source block/Kconfig.iosched
_

Patches currently in -mm which might be from lethal@linux-sh.org are

origin.patch
git-sh.patch
git-scsi-rc-fixes.patch
nohz-fix-nohz-x86-dyntick-idle-handling.patch
serial-sh-sci-fix-build-failure-from-kgdb-fallout.patch
during-vm-oom-condition-kill-all-threads-in-process-group.patch
clean-up-duplicate-includes-in-mm.patch
