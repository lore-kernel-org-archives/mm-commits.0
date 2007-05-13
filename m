From: akpm@linux-foundation.org
Subject: - fault-injection-disable-stacktrace-filter-for-x86-64.patch removed from -mm tree
Date: Sat, 12 May 2007 22:14:16 -0700
Message-ID: <200705130514.l4D5EGH2022707@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:54980 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752306AbXEMFOX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 13 May 2007 01:14:23 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akinobu.mita@gmail.com, ak@suse.de, mm-commits@vger.kernel.org


The patch titled
     fault injection: disable stacktrace filter for x86-64
has been removed from the -mm tree.  Its filename was
     fault-injection-disable-stacktrace-filter-for-x86-64.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: fault injection: disable stacktrace filter for x86-64
From: Akinobu Mita <akinobu.mita@gmail.com>

Disable stacktrace filter support for x86-64 for now.  Will be enable when we
can get the dwarf2 unwinder back.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Andi Kleen <ak@suse.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/Kconfig.debug |    1 +
 1 file changed, 1 insertion(+)

diff -puN lib/Kconfig.debug~fault-injection-disable-stacktrace-filter-for-x86-64 lib/Kconfig.debug
--- a/lib/Kconfig.debug~fault-injection-disable-stacktrace-filter-for-x86-64
+++ a/lib/Kconfig.debug
@@ -438,6 +438,7 @@ config FAULT_INJECTION_DEBUG_FS
 config FAULT_INJECTION_STACKTRACE_FILTER
 	bool "stacktrace filter for fault-injection capabilities"
 	depends on FAULT_INJECTION_DEBUG_FS && STACKTRACE_SUPPORT
+	depends on !X86_64
 	select STACKTRACE
 	select FRAME_POINTER
 	help
_

Patches currently in -mm which might be from akinobu.mita@gmail.com are

git-alsa.patch
auth_gss-unregister-gss_domain-when-unloading-module.patch
add-kstrndup.patch
