From: akpm@linux-foundation.org
Subject: [withdrawn] kernel-uid16c-needs-credh.patch removed from -mm tree
Date: Mon, 06 Jul 2015 15:00:38 -0700
Message-ID: <559afa86.xxrwbpKq6Xkkzne8%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33278 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752695AbbGFWAj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 6 Jul 2015 18:00:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fengguang.wu@gmail.com, iulia.manda21@gmail.com, josh@joshtriplett.org, mm-commits@vger.kernel.org


The patch titled
     Subject: kernel/uid16.c needs cred.h
has been removed from the -mm tree.  Its filename was
     kernel-uid16c-needs-credh.patch

This patch was dropped because it was withdrawn

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kernel/uid16.c needs cred.h

openrisc-allnoconfig:

kernel/uid16.c: In function 'SYSC_setgroups16':
kernel/uid16.c:184:2: error: implicit declaration of function 'groups_alloc'
kernel/uid16.c:184:13: warning: assignment makes pointer from integer without a cast

Fixes: 2813893f8b197a1 ("kernel: conditionally support non-root users, groups and capabilities")
Reported-by: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Iulia Manda <iulia.manda21@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/cred.h |    9 +++++++--
 kernel/uid16.c       |    1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff -puN kernel/uid16.c~kernel-uid16c-needs-credh kernel/uid16.c
--- a/kernel/uid16.c~kernel-uid16c-needs-credh
+++ a/kernel/uid16.c
@@ -9,6 +9,7 @@
 #include <linux/reboot.h>
 #include <linux/prctl.h>
 #include <linux/capability.h>
+#include <linux/cred.h>
 #include <linux/init.h>
 #include <linux/highuid.h>
 #include <linux/security.h>
diff -puN include/linux/cred.h~kernel-uid16c-needs-credh include/linux/cred.h
--- a/include/linux/cred.h~kernel-uid16c-needs-credh
+++ a/include/linux/cred.h
@@ -64,12 +64,17 @@ do {							\
 
 extern struct group_info init_groups;
 #ifdef CONFIG_MULTIUSER
-extern struct group_info *groups_alloc(int);
-extern void groups_free(struct group_info *);
+extern struct group_info *groups_alloc(int gidsetsize);
+extern void groups_free(struct group_info *group_info);
 
 extern int in_group_p(kgid_t);
 extern int in_egroup_p(kgid_t);
 #else
+extern struct group_info *groups_alloc(int gidsetsize)
+{
+	return NULL;
+}
+
 static inline void groups_free(struct group_info *group_info)
 {
 }
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
a.patch
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

