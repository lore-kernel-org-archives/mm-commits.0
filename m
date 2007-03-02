From: akpm@linux-foundation.org
Subject: - frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch removed from -mm tree
Date: Thu, 01 Mar 2007 21:06:12 -0800
Message-ID: <200703020506.l2256CHV000774@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:42258 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422676AbXCBFGU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Fri, 2 Mar 2007 00:06:20 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, mm-commits@vger.kernel.org


The patch titled
     FRV: Add some missng lazy MMU hooks for NOMMU mode
has been removed from the -mm tree.  Its filename was
     frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: FRV: Add some missng lazy MMU hooks for NOMMU mode
From: David Howells <dhowells@redhat.com>

Add some missing lazy MMU hooks for NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -puN include/asm-frv/pgtable.h~frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode include/asm-frv/pgtable.h
--- a/include/asm-frv/pgtable.h~frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode
+++ a/include/asm-frv/pgtable.h
@@ -70,7 +70,11 @@ static inline int pte_file(pte_t pte) { 
 
 #define swapper_pg_dir		((pgd_t *) NULL)
 
-#define pgtable_cache_init()	do {} while(0)
+#define pgtable_cache_init()		do {} while (0)
+#define arch_enter_lazy_mmu_mode()	do {} while (0)
+#define arch_leave_lazy_mmu_mode()	do {} while (0)
+#define arch_enter_lazy_cpu_mode()	do {} while (0)
+#define arch_leave_lazy_cpu_mode()	do {} while (0)
 
 #else /* !CONFIG_MMU */
 /*****************************************************************************/
_

Patches currently in -mm which might be from dhowells@redhat.com are

origin.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
nommu-present-backing-device-capabilities-for-mtd.patch
nommu-present-backing-device-capabilities-for-mtd-fix.patch
nommu-add-support-for-direct-mapping-through-mtdconcat.patch
nommu-generalise-the-handling-of-mtd-specific-superblocks.patch
nommu-make-it-possible-for-romfs-to-use-mtd-devices.patch
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
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
