From: akpm@linux-foundation.org
Subject: + kptr_restrict-fix-build-when-printk-not-enabled.patch added to -mm tree
Date: Tue, 28 Dec 2010 13:12:39 -0800
Message-ID: <201012282112.oBSLCd1O017799@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47479 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751744Ab0L1VMo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 28 Dec 2010 16:12:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, drosenberg@vsecurity.com


The patch titled
     kptr_restrict: fix build when PRINTK not enabled
has been added to the -mm tree.  Its filename is
     kptr_restrict-fix-build-when-printk-not-enabled.patch

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
Subject: kptr_restrict: fix build when PRINTK not enabled
From: Randy Dunlap <randy.dunlap@oracle.com>

#include <linux/printk.h> since that is where kptr_restrict is externed.

Put kptr_restrict inside #ifdef CONFIG_PRINTK block to fix build error
when CONFIG_PRINTK is not enabled:

kernel/sysctl.c:712: error: 'kptr_restrict' undeclared here (not in a function)

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/sysctl.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN kernel/sysctl.c~kptr_restrict-fix-build-when-printk-not-enabled kernel/sysctl.c
--- a/kernel/sysctl.c~kptr_restrict-fix-build-when-printk-not-enabled
+++ a/kernel/sysctl.c
@@ -24,6 +24,7 @@
 #include <linux/slab.h>
 #include <linux/sysctl.h>
 #include <linux/signal.h>
+#include <linux/printk.h>
 #include <linux/proc_fs.h>
 #include <linux/security.h>
 #include <linux/ctype.h>
@@ -710,7 +711,6 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
-#endif
 	{
 		.procname	= "kptr_restrict",
 		.data		= &kptr_restrict,
@@ -720,6 +720,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &two,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
kptr_restrict-fix-build-when-printk-not-enabled.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

