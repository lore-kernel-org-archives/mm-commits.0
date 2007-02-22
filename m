From: akpm@linux-foundation.org
Subject: + frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch added to -mm tree
Date: Wed, 21 Feb 2007 16:34:14 -0800
Message-ID: <200702220034.l1M0YET6031386@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:59577 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965100AbXBVAeW (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Wed, 21 Feb 2007 19:34:22 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dhowells@redhat.com


The patch titled
     FRV: Add some missng lazy MMU hooks for NOMMU mode
has been added to the -mm tree.  Its filename is
     frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: FRV: Add some missng lazy MMU hooks for NOMMU mode
From: David Howells <dhowells@redhat.com>

Add some missing lazy MMU hooks for NOMMU mode.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-frv/pgtable.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletion(-)

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

frv-no-zone_dma.patch
frv-add-some-missng-lazy-mmu-hooks-for-nommu-mode.patch
git-cpufreq.patch
drivers-media-video-cpia_ppc-dont-use-_work_nar.patch
git-parisc.patch
frv-missing-error-defs.patch
doc-atomic_add_unless-doesnt-imply-mb-on-failure.patch
kill-net-rxrpc-rxrpc_symsc.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
reiser4-get_sb_dev-fix.patch
mutex-subsystem-synchro-test-module.patch
