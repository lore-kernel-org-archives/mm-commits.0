From: akpm@linux-foundation.org
Subject: - use-config_arch_has_ilog2_xxx-in-__get_order-not-arch_has_ilog2_xxx.patch removed from -mm tree
Date: Wed, 07 Mar 2007 00:11:14 -0800
Message-ID: <200703070811.l278BEUE023764@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:55821 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964931AbXCGILX (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 7 Mar 2007 03:11:23 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Use CONFIG_ARCH_HAS_ILOG2_xxx in __get_order() not ARCH_HAS_ILOG2_xxx
has been removed from the -mm tree.  Its filename was
     use-config_arch_has_ilog2_xxx-in-__get_order-not-arch_has_ilog2_xxx.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: Use CONFIG_ARCH_HAS_ILOG2_xxx in __get_order() not ARCH_HAS_ILOG2_xxx
From: David Howells <dhowells@redhat.com>

Use CONFIG_ARCH_HAS_ILOG2_xxx in __get_order() not ARCH_HAS_ILOG2_xxx as
the former is the right thing to use.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-generic/page.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff -puN include/asm-generic/page.h~use-config_arch_has_ilog2_xxx-in-__get_order-not-arch_has_ilog2_xxx include/asm-generic/page.h
--- a/include/asm-generic/page.h~use-config_arch_has_ilog2_xxx-in-__get_order-not-arch_has_ilog2_xxx
+++ a/include/asm-generic/page.h
@@ -16,10 +16,10 @@
 static inline __attribute__((const))
 int __get_order(unsigned long size, int page_shift)
 {
-#if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
+#if BITS_PER_LONG == 32 && defined(CONFIG_ARCH_HAS_ILOG2_U32)
 	int order = __ilog2_u32(size) - page_shift;
 	return order >= 0 ? order : 0;
-#elif BITS_PER_LONG == 64 && defined(ARCH_HAS_ILOG2_U64)
+#elif BITS_PER_LONG == 64 && defined(CONFIG_ARCH_HAS_ILOG2_U64)
 	int order = __ilog2_u64(size) - page_shift;
 	return order >= 0 ? order : 0;
 #else
_

Patches currently in -mm which might be from dhowells@redhat.com are

use-config_arch_has_ilog2_xxx-in-__get_order-not-arch_has_ilog2_xxx.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
nommu-hide-vm_mm-in-nommu-mode.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
use-symbolic-constants-in-generic-lseek-code.patch
use-use-seek_max-to-validate-user-lseek-arguments.patch
kconfig-centralize-the-selection-of-semaphore-debugging.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
workqueue-kill-noautorel-works.patch
mutex-subsystem-synchro-test-module.patch
