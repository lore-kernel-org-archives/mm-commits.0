From: akpm@linux-foundation.org
Subject: + drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch
 added to -mm tree
Date: Tue, 22 Jul 2014 15:36:01 -0700
Message-ID: <53cee751.gSpg6TIILvlhkpkz%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:37225 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700AbaGVWgC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 22 Jul 2014 18:36:02 -0400
Received: by mail-yh0-f74.google.com with SMTP id 29so70689yhl.5
        for <mm-commits@vger.kernel.org>; Tue, 22 Jul 2014 15:36:02 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, davem@davemloft.net, hariprasad@chelsio.com, swise@opengridcomputing.com, mm-commits@vger.kernel.org


The patch titled
     Subject: drivers/infiniband/hw/cxgb4/device.c: fix 32-bit builds
has been added to the -mm tree.  Its filename is
     drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch

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
Subject: drivers/infiniband/hw/cxgb4/device.c: fix 32-bit builds

ERROR: "__udivdi3" [drivers/infiniband/hw/cxgb4/iw_cxgb4.ko] undefined!

Fixes 7730b4c7e32c0ab4d ("cxgb4/iw_cxgb4: work request logging feature").

Cc: Hariprasad Shenai <hariprasad@chelsio.com>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/infiniband/hw/cxgb4/device.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff -puN drivers/infiniband/hw/cxgb4/device.c~drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds drivers/infiniband/hw/cxgb4/device.c
--- a/drivers/infiniband/hw/cxgb4/device.c~drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds
+++ a/drivers/infiniband/hw/cxgb4/device.c
@@ -33,6 +33,7 @@
 #include <linux/moduleparam.h>
 #include <linux/debugfs.h>
 #include <linux/vmalloc.h>
+#include <linux/math64.h>
 
 #include <rdma/ib_verbs.h>
 
@@ -142,6 +143,11 @@ void c4iw_log_wr_stats(struct t4_wq *wq,
 	wq->rdev->wr_log[idx] = le;
 }
 
+static u64 ts2ns(struct c4iw_dev *dev, u64 ts)
+{
+	return div64_u64(ts * dev->rdev.lldi.cclk_ps, 1000);
+}
+
 static int wr_log_show(struct seq_file *seq, void *v)
 {
 	struct c4iw_dev *dev = seq->private;
@@ -150,8 +156,6 @@ static int wr_log_show(struct seq_file *
 	int prev_ts_set = 0;
 	int idx, end;
 
-#define ts2ns(ts) ((ts) * dev->rdev.lldi.cclk_ps / 1000)
-
 	idx = atomic_read(&dev->rdev.wr_log_idx) &
 		(dev->rdev.wr_log_size - 1);
 	end = idx - 1;
@@ -184,8 +188,10 @@ static int wr_log_show(struct seq_file *
 						lep->post_host_ts).tv_nsec,
 				   lep->post_sge_ts, lep->cqe_sge_ts,
 				   lep->poll_sge_ts,
-				   ts2ns(lep->poll_sge_ts - lep->post_sge_ts),
-				   ts2ns(lep->poll_sge_ts - lep->cqe_sge_ts));
+				   ts2ns(dev, lep->poll_sge_ts -
+						lep->post_sge_ts),
+				   ts2ns(dev, lep->poll_sge_ts -
+						lep->cqe_sge_ts));
 			prev_ts = lep->poll_host_ts;
 		}
 		idx++;
@@ -193,7 +199,6 @@ static int wr_log_show(struct seq_file *
 			idx = 0;
 		lep = &dev->rdev.wr_log[idx];
 	}
-#undef ts2ns
 	return 0;
 }
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
maintainers-akpm-maintenance.patch
revert-fs-seq_file-fallback-to-vmalloc-allocation.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
kbuild-explain-stack-protector-strong-config-logic.patch
ocfs2-free-inode-when-i_count-becomes-zero-checkpatch-fixes.patch
mm.patch
slub-use-new-node-functions-checkpatch-fixes.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2.patch
slab-use-get_node-and-kmem_cache_node-functions-fix-2-fix.patch
slab-change-int-to-size_t-for-representing-allocation-size.patch
mm-page_allocc-unexport-alloc_pages_exact_nid.patch
dma-cma-support-arbitrary-bitmap-granularity-fix.patch
mm-vmallocc-add-a-schedule-point-to-vmalloc-fix.patch
include-linux-mmdebugh-add-vm_warn_once.patch
mm-catch-memory-commitment-underflow-fix.patch
mm-hugetlb-generalize-writes-to-nr_hugepages-fix.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
mm-compactionc-isolate_freepages_block-small-tuneup.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
list-fix-order-of-arguments-for-hlist_add_after_rcu-checkpatch-fixes.patch
add-lib-globc-fix.patch
lib-list_sortc-convert-to-pr_foo.patch
lib-list_sortc-convert-to-pr_foo-fix.patch
checkpatch-add-test-for-commit-id-formatting-style-in-commit-log.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting-fix.patch
rtc-add-pcf85063-support-fix.patch
fs-isofs-logging-clean-up-fix.patch
proc-remove-proc_tty_ldisc-variable-fix.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
drivers-infiniband-hw-cxgb4-devicec-fix-32-bit-builds.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch
mm-replace-remap_file_pages-syscall-with-emulation-fix.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

