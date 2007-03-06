From: akpm@linux-foundation.org
Subject: - linux-kernel-markers-kconfig-menus-fix-5.patch removed from -mm tree
Date: Mon, 05 Mar 2007 17:33:49 -0800
Message-ID: <200703060133.l261XnDI007845@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:45576 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933793AbXCFBeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Mon, 5 Mar 2007 20:34:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mathieu.desnoyers@polymtl.ca, mm-commits@vger.kernel.org


The patch titled
     linux-kernel-markers-kconfig-menus-fix-5
has been removed from the -mm tree.  Its filename was
     linux-kernel-markers-kconfig-menus-fix-5.patch

This patch was dropped because it was folded into linux-kernel-markers-kconfig-menus.patch

------------------------------------------------------
Subject: linux-kernel-markers-kconfig-menus-fix-5
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>

linux-kernel-markers-kconfig-menus-fix-5

- Change CONFIG_MARKERS_ENABLE_OPTIMIZATION for
  CONFIG_MARKERS_DISABLE_OPTIMIZATION.
- Have CONFIG_MARKERS_DISABLE_OPTIMIZATION depend on EMBEDDED.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/Kconfig.marker |   12 ++++++++----
 1 files changed, 8 insertions(+), 4 deletions(-)

diff -puN kernel/Kconfig.marker~linux-kernel-markers-kconfig-menus-fix-5 kernel/Kconfig.marker
--- a/kernel/Kconfig.marker~linux-kernel-markers-kconfig-menus-fix-5
+++ a/kernel/Kconfig.marker
@@ -7,10 +7,14 @@ config MARKERS
 	  Place an empty function call at each marker site. Can be
 	  dynamically changed for a probe function.
 
-config MARKERS_ENABLE_OPTIMIZATION
-	bool "Enable marker optimization"
-	depends on MARKERS
-	default y
+config MARKERS_DISABLE_OPTIMIZATION
+	bool "Disable marker optimization"
+	depends on MARKERS && EMBEDDED
+	default n
 	help
 	  Disable code replacement jump optimisations. Especially useful if your
 	  code is in a read-only rom/flash.
+
+config MARKERS_ENABLE_OPTIMIZATION
+	def_bool y
+	depends on MARKERS && !MARKERS_DISABLE_OPTIMIZATION
_

Patches currently in -mm which might be from mathieu.desnoyers@polymtl.ca are

atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-alpha.patch
atomich-complete-atomic_long-operations-in-asm-generic.patch
atomich-i386-type-safety-fix.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-ia64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-mips.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-parisc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-powerpc.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-sparc64.patch
atomich-add-atomic64-cmpxchg-xchg-and-add_unless-to-x86_64.patch
atomich-atomic_add_unless-as-inline-remove-systemh-atomich-circular-dependency.patch
local_t-architecture-independant-extension.patch
local_t-alpha-extension.patch
local_t-i386-extension.patch
local_t-ia64-extension.patch
local_t-mips-extension.patch
local_t-parisc-cleanup.patch
local_t-powerpc-extension.patch
local_t-sparc64-cleanup.patch
local_t-x86_64-extension.patch
linux-kernel-markers-kconfig-menus.patch
linux-kernel-markers-kconfig-menus-fix-5.patch
linux-kernel-markers-architecture-independant-code.patch
linux-kernel-markers-architecture-independant-code-license-fix.patch
linux-kernel-markers-architecture-independant-code-flags.patch
linux-kernel-markers-powerpc-optimization.patch
linux-kernel-markers-powerpc-optimization-flags.patch
linux-kernel-markers-i386-optimization.patch
linux-kernel-markers-i386-optimization-fix.patch
linux-kernel-markers-i386-optimization-export-fix.patch
linux-kernel-markers-i386-optimization-flags.patch
linux-kernel-markers-non-optimized-architectures.patch
linux-kernel-markers-non-optimized-architures-fallback-flags.patch
linux-kernel-markers-documentation.patch
linux-kernel-markers-documentation-fix.patch
linux-kernel-markers-documentation-update-adds-context.patch
linux-kernel-markers-documentation-update-markerh.patch
linux-kernel-markers-documentation-update-flags.patch
