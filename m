From: akpm@linux-foundation.org
Subject: + fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch added to -mm tree
Date: Sat, 28 Apr 2007 00:37:58 -0700
Message-ID: <200704280737.l3S7bwFn017321@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60287 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965461AbXD1HiA (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 28 Apr 2007 03:38:00 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akinobu.mita@gmail.com


The patch titled
     fault injection: enable stacktrace with dwarf2 unwinder
has been added to the -mm tree.  Its filename is
     fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: fault injection: enable stacktrace with dwarf2 unwinder
From: Akinobu Mita <akinobu.mita@gmail.com>

We can enable stacktrace filter with dwarf2 unwinder on x86-64.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~fault-injection-enable-stacktrace-with-dwarf2-unwinder lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-enable-stacktrace-with-dwarf2-unwinder
+++ a/lib/Kconfig.debug
@@ -463,7 +463,8 @@ config FAULT_INJECTION_DEBUG_FS
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
-	depends on !X86_64
+	select UNWIND_INFO if X86
+	select STACK_UNWIND if X86
 	select STACKTRACE
 	select FRAME_POINTER
 	help
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-alsa.patch
mod_sysfs_setup-doesnt-return-errno-when-kobject_add_dir-failure-occurs.patch
git-dvb.patch
git-ieee1394.patch
git-net.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
fault-injection-disable-stacktrace-filter-for-x86-64.patch
fault-injection-enable-stacktrace-with-dwarf2-unwinder.patch
slob-handle-slab_panic-flag.patch
use-slab_panic-flag-cleanup.patch
fault-injection-fix-failslab-with-config_numa.patch
simplify-the-stacktrace-code.patch
dtlk-fix-error-checks-in-module_init.patch
dtlk-fix-error-checks-in-module_init-fix.patch
