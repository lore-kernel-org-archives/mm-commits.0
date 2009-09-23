From: akpm@linux-foundation.org
Subject: [merged] thermal-add-missing-kconfig-dependency.patch removed from -mm tree
Date: Wed, 23 Sep 2009 13:03:53 -0700
Message-ID: <200909232003.n8NK3r5Q020104@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52405 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753688AbZIWUF3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 23 Sep 2009 16:05:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: JBeulich@novell.com, jbeulich@novell.com, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com, mm-commits@vger.kernel.org


The patch titled
     thermal: add missing Kconfig dependency
has been removed from the -mm tree.  Its filename was
     thermal-add-missing-kconfig-dependency.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: thermal: add missing Kconfig dependency
From: "Jan Beulich" <JBeulich@novell.com>

Otherwise THERMAL_HWMON can be selected when HWMON=n and THERMAL=n, which
fails to build.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/thermal/Kconfig |    1 +
 1 file changed, 1 insertion(+)

diff -puN drivers/thermal/Kconfig~thermal-add-missing-kconfig-dependency drivers/thermal/Kconfig
--- a/drivers/thermal/Kconfig~thermal-add-missing-kconfig-dependency
+++ a/drivers/thermal/Kconfig
@@ -15,6 +15,7 @@ menuconfig THERMAL
 
 config THERMAL_HWMON
 	bool "Hardware monitoring support"
+	depends on THERMAL
 	depends on HWMON=y || HWMON=THERMAL
 	help
 	  The generic thermal sysfs driver's hardware monitoring support
_

Patches currently in -mm which might be from JBeulich@novell.com are

origin.patch
linux-next.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch

