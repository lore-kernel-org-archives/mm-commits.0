From: akpm@linux-foundation.org
Subject: [obsolete]
 net-switchdev-switchdevc-work-around-gcc-444-initializer-bug.patch removed
 from -mm tree
Date: Thu, 14 May 2015 11:09:09 -0700
Message-ID: <5554e4c5.zQ0r3KJ5mJotxc1u%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44275 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbbENSJL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 14 May 2015 14:09:11 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, jiri@resnulli.us, sfeldma@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Subject: net/switchdev/switchdev.c: work around gcc-4.4.4 initializer bug
has been removed from the -mm tree.  Its filename was
     net-switchdev-switchdevc-work-around-gcc-444-initializer-bug.patch

This patch was dropped because it is obsolete

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: net/switchdev/switchdev.c: work around gcc-4.4.4 initializer bug

gcc-4.4.4 (at least) doesn't like mixing anonymous unions with initializers.

This workaround is pretty lame and maybe there's a better way, but it
doesn't increase net/switchdev/switchdev.o's object size with gcc-4.8.2.

Cc: Scott Feldman <sfeldma@gmail.com>
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: David S. Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/switchdev/switchdev.c |   40 +++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 18 deletions(-)

diff -puN net/switchdev/switchdev.c~net-switchdev-switchdevc-work-around-gcc-444-initializer-bug net/switchdev/switchdev.c
--- a/net/switchdev/switchdev.c~net-switchdev-switchdevc-work-around-gcc-444-initializer-bug
+++ a/net/switchdev/switchdev.c
@@ -641,21 +641,23 @@ static struct net_device *switchdev_get_
 int switchdev_fib_ipv4_add(u32 dst, int dst_len, struct fib_info *fi,
 			   u8 tos, u8 type, u32 nlflags, u32 tb_id)
 {
+	struct switchdev_obj_ipv4_fib ipv4_fib = {
+		.dst = htonl(dst),
+		.dst_len = dst_len,
+		.fi = fi,
+		.tos = tos,
+		.type = type,
+		.nlflags = nlflags,
+		.tb_id = tb_id,
+	};
 	struct switchdev_obj fib_obj = {
 		.id = SWITCHDEV_OBJ_IPV4_FIB,
-		.ipv4_fib = {
-			.dst = htonl(dst),
-			.dst_len = dst_len,
-			.fi = fi,
-			.tos = tos,
-			.type = type,
-			.nlflags = nlflags,
-			.tb_id = tb_id,
-		},
 	};
 	struct net_device *dev;
 	int err = 0;
 
+	fib_obj.ipv4_fib = ipv4_fib;
+
 	/* Don't offload route if using custom ip rules or if
 	 * IPv4 FIB offloading has been disabled completely.
 	 */
@@ -695,21 +697,23 @@ EXPORT_SYMBOL_GPL(switchdev_fib_ipv4_add
 int switchdev_fib_ipv4_del(u32 dst, int dst_len, struct fib_info *fi,
 			   u8 tos, u8 type, u32 tb_id)
 {
+	struct switchdev_obj_ipv4_fib ipv4_fib = {
+		.dst = htonl(dst),
+		.dst_len = dst_len,
+		.fi = fi,
+		.tos = tos,
+		.type = type,
+		.nlflags = 0,
+		.tb_id = tb_id,
+	};
 	struct switchdev_obj fib_obj = {
 		.id = SWITCHDEV_OBJ_IPV4_FIB,
-		.ipv4_fib = {
-			.dst = htonl(dst),
-			.dst_len = dst_len,
-			.fi = fi,
-			.tos = tos,
-			.type = type,
-			.nlflags = 0,
-			.tb_id = tb_id,
-		},
 	};
 	struct net_device *dev;
 	int err = 0;
 
+	fib_obj.ipv4_fib = ipv4_fib;
+
 	if (!(fi->fib_flags & RTNH_F_EXTERNAL))
 		return 0;
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-rtc-rtc-armada38xc-remove-unused-local-flags.patch
gfp-add-__gfp_noaccount-v2-fix.patch
cma-page_isolation-check-buddy-before-access-it-fix.patch
ocfs2-reduce-object-size-of-mlog-uses-fix.patch
ocfs2-remove-__mlog_cpu_guess.patch
ocfs2-remove-__mlog_cpu_guess-fix.patch
mm.patch
mm-slab_common-support-the-slub_debug-boot-option-on-specific-object-size-fix.patch
slub-bulk-allocation-from-per-cpu-partial-pages-fix.patch
mm-fix-mprotect-behaviour-on-vm_locked-vmas-fix.patch
mm-new-mm-hook-framework.patch
mm-meminit-inline-some-helper-functions-fix.patch
mm-meminit-finish-initialisation-of-struct-pages-before-basic-setup-fix.patch
mm-memory-failure-introduce-get_hwpoison_page-for-consistent-refcount-handling-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix.patch
rmap-fix-theoretical-race-between-do_wp_page-and-shrink_active_list-fix-fix.patch
mm-thp-split-out-pmd-collpase-flush-into-a-separate-functions-fix.patch
mm-clarify-that-the-function-operateds-on-hugepage-pte-fix.patch
include-linux-page-flagsh-rename-macros-to-avoid-collisions.patch
mm-vmscan-fix-the-page-state-calculation-in-too_many_isolated.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix-fix.patch
proc-fix-page_size-limit-of-proc-pid-cmdline-fix.patch
bitmap-remove-explicit-newline-handling-using-scnprintf-format-string-fix.patch
radix-tree-replace-preallocated-node-array-with-linked-list-fix.patch
rtc-omap-add-external-32k-clock-feature-fix.patch
devpts-if-initialization-failed-dont-crash-when-opening-dev-ptmx-fix.patch
linux-next.patch
linux-next-rejects.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

