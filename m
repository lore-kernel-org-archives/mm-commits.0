From: akpm@linux-foundation.org
Subject: + power-fix-kernel-doc-notation.patch added to -mm tree
Date: Thu, 07 Jan 2010 14:38:47 -0800
Message-ID: <201001072238.o07Mcl2H021781@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752531Ab0AGWjB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 7 Jan 2010 17:39:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, rjw@sisk.pl


The patch titled
     power: fix kernel-doc notation
has been added to the -mm tree.  Its filename is
     power-fix-kernel-doc-notation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: power: fix kernel-doc notation
From: Randy Dunlap <randy.dunlap@oracle.com>

Warning(drivers/base/power/main.c:453): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:453): No description found for parameter 'cb'
Warning(drivers/base/power/main.c:719): No description found for parameter 'dev'
Warning(drivers/base/power/main.c:719): No description found for parameter 'state'
Warning(drivers/base/power/main.c:719): No description found for parameter 'cb'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/base/power/main.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff -puN drivers/base/power/main.c~power-fix-kernel-doc-notation drivers/base/power/main.c
--- a/drivers/base/power/main.c~power-fix-kernel-doc-notation
+++ a/drivers/base/power/main.c
@@ -446,8 +446,8 @@ EXPORT_SYMBOL_GPL(dpm_resume_noirq);
 
 /**
  * legacy_resume - Execute a legacy (bus or class) resume callback for device.
- * dev: Device to resume.
- * cb: Resume callback to execute.
+ * @dev: Device to resume.
+ * @cb: Resume callback to execute.
  */
 static int legacy_resume(struct device *dev, int (*cb)(struct device *dev))
 {
@@ -711,8 +711,9 @@ EXPORT_SYMBOL_GPL(dpm_suspend_noirq);
 
 /**
  * legacy_suspend - Execute a legacy (bus or class) suspend callback for device.
- * dev: Device to suspend.
- * cb: Suspend callback to execute.
+ * @dev: Device to suspend.
+ * @state: PM transition of the system being carried out.
+ * @cb: Suspend callback to execute.
  */
 static int legacy_suspend(struct device *dev, pm_message_t state,
 			  int (*cb)(struct device *dev, pm_message_t state))
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

docs-large-update-to-ioctl-numbertxt.patch
proc-revert-procfs-provide-stack-information-for-threads.patch
power-fix-kernel-doc-notation.patch
linux-next.patch
documentation-update-ring-buffer-designtxt.patch
documentation-update-kernel-doc-nano-howto-information.patch
mfgpt-move-clocksource-menu.patch
xen-add-kconfig-menu.patch
gpio-add-driver-for-max7300-i2c-gpio-extender.patch
reiser4-export-remove_from_page_cache-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

