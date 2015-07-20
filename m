From: akpm@linux-foundation.org
Subject: [merged] openrisc-fix-config_uid16-setting.patch removed from -mm tree
Date: Mon, 20 Jul 2015 11:49:56 -0700
Message-ID: <55ad42d4.Kyre4HHwRvb2OvCW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34475 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbbGTSt5 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 20 Jul 2015 14:49:57 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, iulia.manda21@gmail.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: fix CONFIG_UID16 setting
has been removed from the -mm tree.  Its filename was
     openrisc-fix-config_uid16-setting.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: openrisc: fix CONFIG_UID16 setting

openrisc-allnoconfig:

kernel/uid16.c: In function 'SYSC_setgroups16':
kernel/uid16.c:184:2: error: implicit declaration of function 'groups_alloc'
kernel/uid16.c:184:13: warning: assignment makes pointer from integer without a cast

openrisc shouldn't be setting CONFIG_UID16 when CONFIG_MULTIUSER=n.

Fixes: 2813893f8b197a1 ("kernel: conditionally support non-root users, groups and capabilities")
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Iulia Manda <iulia.manda21@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/openrisc/Kconfig |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN arch/openrisc/Kconfig~openrisc-fix-config_uid16-setting arch/openrisc/Kconfig
--- a/arch/openrisc/Kconfig~openrisc-fix-config_uid16-setting
+++ a/arch/openrisc/Kconfig
@@ -17,6 +17,7 @@ config OPENRISC
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
 	select GENERIC_CPU_DEVICES
+	select HAVE_UID16
 	select GENERIC_ATOMIC64
 	select GENERIC_CLOCKEVENTS
 	select GENERIC_STRNCPY_FROM_USER
@@ -31,9 +32,6 @@ config MMU
 config HAVE_DMA_ATTRS
 	def_bool y
 
-config UID16
-	def_bool y
-
 config RWSEM_GENERIC_SPINLOCK
 	def_bool y
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-kthreadc-kthread_create_on_node-clarify-documentation.patch
scripts-spellingtxt-adding-misspelled-word-for-check-fix.patch
mm.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
genalloc-add-name-arg-to-gen_pool_get-and-devm_gen_pool_create-fix.patch
genalloc-add-support-of-multiple-gen_pools-per-device-fix.patch
mm-make-gup-handle-pfn-mapping-unless-foll_get-is-requested-fix.patch
dax-revert-userfaultfd-change.patch
thp-prepare-for-dax-huge-pages-fix.patch
pagemap-add-mmap-exclusive-bit-for-marking-pages-mapped-only-here-fix.patch
mm-show-proportional-swap-share-of-the-mapping-fix.patch
mm-improve-__gfp_noretry-comment-based-on-implementation-fix.patch
memcg-export-struct-mem_cgroup-fix.patch
memcg-export-struct-mem_cgroup-fix-2.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix.patch
procfs-always-expose-proc-pid-map_files-and-make-it-readable-fix-fix.patch
define-kallsyms_cmp_symbol_t-as-function-type-to-simplify-the-code-fix.patch
linux-next.patch
linux-next-rejects.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
sound-soc-codecs-cs4349c-include-gpio-consumerh.patch
fs-seq_file-convert-int-seq_vprint-seq_printf-etc-returns-to-void-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

