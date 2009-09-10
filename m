From: akpm@linux-foundation.org
Subject: + thermal-add-missing-kconfig-dependency.patch added to -mm tree
Date: Thu, 10 Sep 2009 13:44:52 -0700
Message-ID: <200909102044.n8AKiqxB004314@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728AbZIJUqh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 10 Sep 2009 16:46:37 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: JBeulich@novell.com, jbeulich@novell.com, lenb@kernel.org, mjg@redhat.com, rui.zhang@intel.com


The patch titled
     thermal: add missing Kconfig dependency
has been added to the -mm tree.  Its filename is
     thermal-add-missing-kconfig-dependency.patch

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

linux-next.patch
thermal-add-missing-kconfig-dependency.patch
kbuild-generate-modulesbuiltin.patch
kbuild-rebuild-fix-for-makefilemodbuiltin.patch
memory-hotplug-fix-updating-of-num_physpages-for-hot-plugged-memory.patch
mm-replace-various-uses-of-num_physpages-by-totalram_pages.patch
mm-dont-use-alloc_bootmem_low-where-not-strictly-needed.patch
mm-also-use-alloc_large_system_hash-for-the-pid-hash-table.patch
build_bug_on-fix-it-and-a-couple-of-bogus-uses-of-it.patch

