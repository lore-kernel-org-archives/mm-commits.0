From: akpm@linux-foundation.org
Subject: + mm-cma-make-kmemleak-ignore-cma-regions-fix.patch added to -mm
 tree
Date: Thu, 23 Oct 2014 13:22:45 -0700
Message-ID: <54496395.wr+ShLuQpZnFsAub%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:46014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932303AbaJWUWq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 23 Oct 2014 16:22:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, aneesh.kumar@linux.vnet.ibm.com, catalin.marinas@arm.com, iamjoonsoo.kim@lge.com, m.szyprowski@samsung.com, mina86@mina86.com, treding@nvidia.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm-cma-make-kmemleak-ignore-cma-regions-fix
has been added to the -mm tree.  Its filename is
     mm-cma-make-kmemleak-ignore-cma-regions-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/mm-cma-make-kmemleak-ignore-cma-regions-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/mm-cma-make-kmemleak-ignore-cma-regions-fix.patch

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
Subject: mm-cma-make-kmemleak-ignore-cma-regions-fix

add comment

Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Michal Nazarewicz <mina86@mina86.com>
Cc: Thierry Reding <treding@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/cma.c |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix mm/cma.c
--- a/mm/cma.c~mm-cma-make-kmemleak-ignore-cma-regions-fix
+++ a/mm/cma.c
@@ -280,6 +280,10 @@ int __init cma_declare_contiguous(phys_a
 			ret = -ENOMEM;
 			goto err;
 		} else {
+			/*
+			 * kmemleak writes metadata to the tracked objects, but
+			 * this address isn't mapped and accessible.
+			 */
 			kmemleak_ignore(phys_to_virt(addr));
 			base = addr;
 		}
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-fix.patch
mm-cma-make-kmemleak-ignore-cma-regions-fix.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-and-remove-inode-in-orphan-dir-in-ocfs2_direct_io-fix.patch
ocfs2-do-not-fallback-to-buffer-i-o-write-if-fill-holes-checkpatch-fixes.patch
mm.patch
mm-memcontrol-lockless-page-counters-fix.patch
mm-memcontrol-lockless-page-counters-fix-fix.patch
kernel-res_counter-remove-the-unused-api-fix.patch
mm-compaction-simplify-deferred-compaction-fix.patch
mm-memcontrol-remove-unnecessary-pcg_used-pc-mem_cgroup-valid-flag-fix.patch
mm-memcontrol-fold-mem_cgroup_start_move-mem_cgroup_end_move-fix.patch
lib-show_mem-this-patch-adds-cma-reserved-infromation-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
fs-proc-use-a-rb-tree-for-the-directory-entries-fix.patch
init-allow-config_init_fallback=n-to-disable-defaults-if-init=-fails-checkpatch-fixes.patch
sysctl-terminate-strings-also-on-r-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix.patch
ipc-semc-chance-memory-barrier-in-sem_lock-to-smp_rmb-fix-fix.patch
ipc-msg-increase-msgmni-remove-scaling-checkpatch-fixes.patch
linux-next.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

