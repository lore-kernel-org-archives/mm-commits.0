From: akpm@linux-foundation.org
Subject: [folded] kptr_restrict-fix-build-when-printk-not-enabled.patch removed from -mm tree
Date: Wed, 12 Jan 2011 16:20:23 -0800
Message-ID: <201101130020.p0D0KN5E012173@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44325 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755542Ab1AMAU1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 12 Jan 2011 19:20:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, drosenberg@vsecurity.com, mm-commits@vger.kernel.org


The patch titled
     kptr_restrict: fix build when PRINTK not enabled
has been removed from the -mm tree.  Its filename was
     kptr_restrict-fix-build-when-printk-not-enabled.patch

This patch was dropped because it was folded into kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch

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

origin.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
kptr_restrict-for-hiding-kernel-pointers-from-unprivileged-users.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
update-thunderbird-docs-with-wordwrap-plugin.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
w1-ds2423-counter-driver-and-documentation-fix.patch

