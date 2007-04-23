From: akpm@linux-foundation.org
Subject: + fault-injection-disable-stacktrace-filter-for-x86-64.patch added to -mm tree
Date: Sun, 22 Apr 2007 17:34:25 -0700
Message-ID: <200704230034.l3N0YPCp004183@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:41511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030307AbXDWAee (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 22 Apr 2007 20:34:34 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault injection: disable stacktrace filter for x86-64
has been added to the -mm tree.  Its filename is
     fault-injection-disable-stacktrace-filter-for-x86-64.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault injection: disable stacktrace filter for x86-64
From: Akinobu Mita <akinobu.mita@gmail.com>

Disable stacktrace filter support for x86-64 for now.  Will be enable when we
can get the dwarf2 unwinder back.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~fault-injection-disable-stacktrace-filter-for-x86-64 lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-disable-stacktrace-filter-for-x86-64
+++ a/lib/Kconfig.debug
@@ -463,6 +463,7 @@ config FAULT_INJECTION_DEBUG_FS
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
+	depends on !X86_64
 	select STACKTRACE
 	select FRAME_POINTER
 	help
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

fault-injection-add-entry-to-maintainers.patch
mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-ieee1394.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
