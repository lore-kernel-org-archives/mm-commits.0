From: akpm@linux-foundation.org
Subject: [folded-merged]
 support-resetting-warn_once-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 17 Nov 2017 15:11:50 -0800
Message-ID: <5a0f6cb6.5AZCZ+njy9j+H7cI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53572 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966856AbdKQXLw (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 17 Nov 2017 18:11:52 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ak@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: support-resetting-warn_once-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     support-resetting-warn_once-checkpatch-fixes.patch

This patch was dropped because it was folded into support-resetting-warn_once.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: support-resetting-warn_once-checkpatch-fixes

ERROR: code indent should use tabs where possible
#124: FILE: kernel/panic.c:604:
+                        clear_warn_once_set,$

WARNING: please, no spaces at the start of a line
#124: FILE: kernel/panic.c:604:
+                        clear_warn_once_set,$

ERROR: code indent should use tabs where possible
#125: FILE: kernel/panic.c:605:
+^I^I        "%lld\n");$

WARNING: please use device_initcall() or more appropriate function instead of __initcall() (see include/linux/init.h)
#135: FILE: kernel/panic.c:615:
+__initcall(register_warn_debugfs);

total: 2 errors, 2 warnings, 87 lines checked

NOTE: For some of the reported defects, checkpatch may be able to
      mechanically convert to the typical style using --fix or --fix-inplace.

NOTE: Whitespace errors detected.
      You may wish to use scripts/cleanpatch or scripts/cleanfile

./patches/support-resetting-warn_once.patch has style problems, please review.

NOTE: If any of the errors are false positives, please report
      them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN kernel/panic.c~support-resetting-warn_once-checkpatch-fixes kernel/panic.c
--- a/kernel/panic.c~support-resetting-warn_once-checkpatch-fixes
+++ a/kernel/panic.c
@@ -601,8 +601,8 @@ static int clear_warn_once_set(void *dat
 
 DEFINE_SIMPLE_ATTRIBUTE(clear_warn_once_fops,
 			NULL,
-                        clear_warn_once_set,
-		        "%lld\n");
+			clear_warn_once_set,
+			"%lld\n");
 
 static __init int register_warn_debugfs(void)
 {
@@ -612,7 +612,7 @@ static __init int register_warn_debugfs(
 	return 0;
 }
 
-__initcall(register_warn_debugfs);
+device_initcall(register_warn_debugfs);
 #endif
 
 #ifdef CONFIG_CC_STACKPROTECTOR
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

support-resetting-warn_once.patch
support-resetting-warn_once-for-all-architectures-v2-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix.patch
support-resetting-warn_once-for-all-architectures-v2-fix-fix-fix.patch
kernel-reboot-add-devm_register_reboot_notifier-fix.patch
watchdog-core-make-use-of-devm_register_reboot_notifier-fix.patch
sysvipc-unteach-ids-next_id-for-checkpoint_restore-checkpatch-fixes.patch
sysvipc-make-get_maxid-o1-again-checkpatch-fixes.patch

