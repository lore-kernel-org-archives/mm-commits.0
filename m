From: akpm@linux-foundation.org
Subject: + openrisc-fix-config_uid16-setting.patch added to -mm tree
Date: Mon, 06 Jul 2015 15:00:47 -0700
Message-ID: <559afa8f.fR64UTH2yrzDHttJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbGFWAs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:00:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, iulia.manda21@gmail.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: openrisc: fix CONFIG_UID16 setting
has been added to the -mm tree.  Its filename is
     openrisc-fix-config_uid16-setting.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/openrisc-fix-config_uid16-setting.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/openrisc-fix-config_uid16-setting.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
openrisc-fix-config_uid16-setting.patch
mm.patch
slab-infrastructure-for-bulk-object-allocation-and-freeing-v3-fix.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2.patch
userfaultfd-change-the-read-api-to-return-a-uffd_msg-fix-2-fix.patch
userfaultfd-avoid-mmap_sem-read-recursion-in-mcopy_atomic-fix.patch
fs-userfaultfdc-work-around-i386-build-error.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
linux-next.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
net-netfilter-ipset-work-around-gcc-444-initializer-bug.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

