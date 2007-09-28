From: akpm@linux-foundation.org
Subject: + add-samples-subdir.patch added to -mm tree
Date: Fri, 28 Sep 2007 15:41:24 -0700
Message-ID: <200709282241.l8SMfOfB020925@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60801 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755193AbXI1WmU (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 28 Sep 2007 18:42:20 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mathieu.desnoyers@polymtl.ca, randy.dunlap@oracle.com


The patch titled
     markers: Add samples subdir
has been added to the -mm tree.  Its filename is
     add-samples-subdir.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: markers: Add samples subdir
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

Begin infrastructure for kernel code samples in the samples/ directory.
Add its Kconfig and Kbuild files.
Source its Kconfig file in all arch/ Kconfigs.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


diff -puN Makefile~add-samples-subdir Makefile
--- a/Makefile~add-samples-subdir
+++ a/Makefile
@@ -772,6 +772,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
 ifdef CONFIG_HEADERS_CHECK
 	$(Q)$(MAKE) -f $(srctree)/Makefile headers_check
 endif
+ifdef CONFIG_SAMPLES
+	$(Q)$(MAKE) $(build)=samples
+endif
 	$(call vmlinux-modpost)
 	$(call if_changed_rule,vmlinux__)
 	$(Q)rm -f .old_version
diff -puN lib/Kconfig.debug~add-samples-subdir lib/Kconfig.debug
--- a/lib/Kconfig.debug~add-samples-subdir
+++ a/lib/Kconfig.debug
@@ -521,3 +521,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	  Provide stacktrace filter for fault-injection capabilities
 
 source "lib/Kconfig.kgdb"
+
+source "samples/Kconfig"
diff -puN /dev/null samples/Kconfig
--- /dev/null
+++ a/samples/Kconfig
@@ -0,0 +1,11 @@
+# samples/Kconfig
+
+menuconfig SAMPLES
+	bool "Sample kernel code"
+	help
+	  You can build and test sample kernel code here.
+
+if SAMPLES
+
+
+endif # SAMPLES
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

powerpc-include-pagemaph-in-asm-powerpc-tlbh.patch
fix-f_version-type-should-be-u64-instead-of-unsigned-long.patch
local_t-documentation-update-2.patch
local_t-update-documentation.patch
combine-instrumentation-menus-in-kernel-kconfiginstrumentation.patch
linux-kernel-markers.patch
linux-kernel-markers-checkpatch-fixes.patch
add-samples-subdir.patch
linux-kernel-markers-samples.patch
linux-kernel-markers-samples-checkpatch-fixes.patch
linux-kernel-markers-documentation.patch
