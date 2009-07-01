From: akpm@linux-foundation.org
Subject: [obsolete] kprobes-fix-kprobe-selftest-configuration-dependency.patch removed from -mm tree
Date: Tue, 30 Jun 2009 17:20:25 -0700
Message-ID: <200907010020.n610KPKQ015438@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56010 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbZGAAUo (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Jun 2009 20:20:44 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mhiramat@redhat.com, ananth@in.ibm.com, mm-commits@vger.kernel.org


The patch titled
     kprobes: fix kprobe selftest configuration dependency
has been removed from the -mm tree.  Its filename was
     kprobes-fix-kprobe-selftest-configuration-dependency.patch

This patch was dropped because it is obsolete

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kprobes: fix kprobe selftest configuration dependency
From: Masami Hiramatsu <mhiramat@redhat.com>

Select CONFIG_KALLSYMS_ALL when CONFIG_KPROBES_SANITY_TEST=y.  Kprobe
selftest always fail without CONFIG_KALLSYMS_ALL=y, because kallsyms
doesn't list up the target functions which are probed in this test.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~kprobes-fix-kprobe-selftest-configuration-dependency lib/Kconfig.debug
--- a/lib/Kconfig.debug~kprobes-fix-kprobe-selftest-configuration-dependency
+++ a/lib/Kconfig.debug
@@ -748,6 +748,7 @@ config KPROBES_SANITY_TEST
 	bool "Kprobes sanity tests"
 	depends on DEBUG_KERNEL
 	depends on KPROBES
+	select KALLSYMS_ALL
 	default n
 	help
 	  This option provides for testing basic kprobes functionality on
_

Patches currently in -mm which might be from mhiramat@redhat.com are

kprobes-fix-kprobe-selftest-configuration-dependency.patch

