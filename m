From: akpm@linux-foundation.org
Subject: [merged] lib-turn-config_stacktrace-into-an-actual-option.patch
 removed from -mm tree
Date: Wed, 03 Sep 2014 10:57:25 -0700
Message-ID: <54075685.yEwCmxUZoXc8oH5l%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42835 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaICR50 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Sep 2014 13:57:26 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: davej@redhat.com, mingo@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: lib: turn CONFIG_STACKTRACE into an actual option.
has been removed from the -mm tree.  Its filename was
     lib-turn-config_stacktrace-into-an-actual-option.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Dave Jones <davej@redhat.com>
Subject: lib: turn CONFIG_STACKTRACE into an actual option.

I was puzzled why /proc/$$/stack had disappeared, until I figured out I
had disabled the last debug option that did a 'select STACKTRACE'.  This
patch makes the option show up at config time, so it can be enabled
without enabling any of the more heavyweight debug options.

Signed-off-by: Dave Jones <davej@redhat.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN lib/Kconfig.debug~lib-turn-config_stacktrace-into-an-actual-option lib/Kconfig.debug
--- a/lib/Kconfig.debug~lib-turn-config_stacktrace-into-an-actual-option
+++ a/lib/Kconfig.debug
@@ -1036,8 +1036,13 @@ config TRACE_IRQFLAGS
 	  either tracing or lock debugging.
 
 config STACKTRACE
-	bool
+	bool "Stack backtrace support"
 	depends on STACKTRACE_SUPPORT
+	help
+	  This option causes the kernel to create a /proc/pid/stack for
+	  every process, showing its current stack trace.
+	  It is also used by various kernel debugging features that require
+	  stack trace generation.
 
 config DEBUG_KOBJECT
 	bool "kobject debugging"
_

Patches currently in -mm which might be from davej@redhat.com are

mem-hotplug-fix-boot-failed-in-case-all-the-nodes-are-hotpluggable.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch

