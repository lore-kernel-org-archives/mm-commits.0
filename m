From: akpm@linux-foundation.org
Subject: - add-samples-subdir.patch removed from -mm tree
Date: Fri, 19 Oct 2007 15:54:26 -0700
Message-ID: <200710192254.l9JMsQaJ024528@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37929 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935173AbXJSXFt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 19 Oct 2007 19:05:49 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, randy.dunlap@oracle.com, mm-commits@vger.kernel.org


The patch titled
     markers: Add samples subdir
has been removed from the -mm tree.  Its filename was
     add-samples-subdir.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

 Makefile          |    3 +++
 lib/Kconfig.debug |    2 ++
 samples/Kconfig   |   11 +++++++++++
 3 files changed, 16 insertions(+)

diff -puN Makefile~add-samples-subdir Makefile
--- a/Makefile~add-samples-subdir
+++ a/Makefile
@@ -774,6 +774,9 @@ vmlinux: $(vmlinux-lds) $(vmlinux-init) 
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
@@ -498,3 +498,5 @@ config FAULT_INJECTION_STACKTRACE_FILTER
 	select FRAME_POINTER
 	help
 	  Provide stacktrace filter for fault-injection capabilities
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

origin.patch
