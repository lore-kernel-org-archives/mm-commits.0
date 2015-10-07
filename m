From: akpm@linux-foundation.org
Subject: +
 panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch added to -mm tree
Date: Wed, 07 Oct 2015 15:34:29 -0700
Message-ID: <56159df5.+9i701LQqNlC7Dk+%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:42674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752770AbbJGWea (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 7 Oct 2015 18:34:30 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, bhe@redhat.com, d.hatayama@jp.fujitsu.com, jack@suse.cz, jkosina@suse.cz, kys@microsoft.com, masami.hiramatsu.pt@hitachi.com, prarit@redhat.com, sjenning@redhat.com, vkuznets@redhat.com, xiexiuqi@huawei.com, mm-commits@vger.kernel.org


The patch titled
     Subject: panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix
has been added to the -mm tree.  Its filename is
     panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch

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
Subject: panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix

tweak comment text

Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Cc: Seth Jennings <sjenning@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Xie XiuQi <xiexiuqi@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/panic.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix kernel/panic.c
--- a/kernel/panic.c~panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix
+++ a/kernel/panic.c
@@ -149,10 +149,10 @@ void panic(const char *fmt, ...)
 	bust_spinlocks(0);
 
 	/*
-	 * We may have ended up killing the CPU holding the lock and still have
-	 * some valuable data in console buffer. Try to acquire the lock and
-	 * release it regardless of the result. The release will also print the
-	 * buffers out.
+	 * We may have ended up stopping the CPU holding the lock (in
+	 * smp_send_stop()) while still having some valuable data in the console
+	 * buffer.  Try to acquire the lock then release it regardless of the
+	 * result.  The release will also print the buffers out.
 	 */
 	console_trylock();
 	console_unlock();
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
drivers-gpu-drm-i915-intel_spritec-fix-build.patch
drivers-gpu-drm-i915-intel_tvc-fix-build.patch
mm.patch
slub-optimize-bulk-slowpath-free-by-detached-freelist-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix.patch
uaccess-reimplement-probe_kernel_address-using-probe_kernel_read-fix-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-fix.patch
mm-page_alloc-rename-__gfp_wait-to-__gfp_reclaim-checkpatch-fixes.patch
mm-page_alloc-only-enforce-watermarks-for-order-0-allocations-fix-fix.patch
mm-fix-declarations-of-nr-delta-and-nr_pagecache_reclaimable-fix.patch
mm-oom_kill-fix-the-wrong-task-mm-==-mm-checks-in-oom_kill_process-fix.patch
include-linux-mmzoneh-reflow-comment.patch
mm-fs-introduce-mapping_gfp_constraint-checkpatch-fixes.patch
mm-vmstatc-uninline-node_page_state.patch
mm-vmstatc-uninline-node_page_state-fix.patch
kasan-various-fixes-in-documentation-checkpatch-fixes.patch
zsmalloc-add-comments-for-inuse-to-zspage-v2-fix.patch
page-flags-define-pg_locked-behavior-on-compound-pages-fix.patch
x86-add-pmd_-for-thp-fix.patch
sparc-add-pmd_-for-thp-fix.patch
mm-support-madvisemadv_free-fix-2.patch
mm-dont-split-thp-page-when-syscall-is-called-fix-3.patch
mm-move-lazy-free-pages-to-inactive-list-fix-fix.patch
include-linux-compiler-gcch-improve-__visible-documentation.patch
fs-jffs2-wbufc-remove-stray-semicolon.patch
lib-documentation-synchronize-%p-formatting-documentation-fix-fix.patch
rbtree-clarify-documentation-of-rbtree_postorder_for_each_entry_safe-fix.patch
dma-mapping-tidy-up-dma_parms-default-handling-fix.patch
panic-release-stale-console-lock-to-always-get-the-logbuf-printed-out-fix.patch
linux-next-rejects.patch
linux-next-git-rejects.patch
net-ipv4-routec-prevent-oops.patch
remove-abs64.patch
remove-abs64-fix.patch
remove-abs64-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
kernel-forkc-export-kernel_thread-to-modules.patch
slab-leaks3-default-y.patch

