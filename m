From: akpm@linux-foundation.org
Subject: - net-uninline-skb_put.patch removed from -mm tree
Date: Thu, 22 Mar 2007 15:35:11 -0800
Message-ID: <200703222335.l2MNZBT8000980@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:57104 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbXCVXfx (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 22 Mar 2007 19:35:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, acme@conectiva.com.br, mm-commits@vger.kernel.org


The patch titled
     net: uninline skb_put()
has been removed from the -mm tree.  Its filename was
     net-uninline-skb_put.patch

This patch was dropped because it is obsolete

------------------------------------------------------
Subject: net: uninline skb_put()
From: Andrew Morton <akpm@osdl.org>

It has many callsites.

Cc: Arnaldo Carvalho de Melo <acme@conectiva.com.br>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/skbuff.h |   20 +-------------------
 net/core/skbuff.c      |   21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 19 deletions(-)

diff -puN include/linux/skbuff.h~net-uninline-skb_put include/linux/skbuff.h
--- a/include/linux/skbuff.h~net-uninline-skb_put
+++ a/include/linux/skbuff.h
@@ -829,25 +829,7 @@ static inline unsigned char *__skb_put(s
 	return tmp;
 }
 
-/**
- *	skb_put - add data to a buffer
- *	@skb: buffer to use
- *	@len: amount of data to add
- *
- *	This function extends the used data area of the buffer. If this would
- *	exceed the total buffer size the kernel will panic. A pointer to the
- *	first byte of the extra data is returned.
- */
-static inline unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
-{
-	unsigned char *tmp = skb->tail;
-	SKB_LINEAR_ASSERT(skb);
-	skb->tail += len;
-	skb->len  += len;
-	if (unlikely(skb->tail>skb->end))
-		skb_over_panic(skb, len, current_text_addr());
-	return tmp;
-}
+unsigned char *skb_put(struct sk_buff *skb, unsigned int len);
 
 static inline unsigned char *__skb_push(struct sk_buff *skb, unsigned int len)
 {
diff -puN net/core/skbuff.c~net-uninline-skb_put net/core/skbuff.c
--- a/net/core/skbuff.c~net-uninline-skb_put
+++ a/net/core/skbuff.c
@@ -119,6 +119,27 @@ void skb_truesize_bug(struct sk_buff *sk
 }
 EXPORT_SYMBOL(skb_truesize_bug);
 
+/**
+ *	skb_put - add data to a buffer
+ *	@skb: buffer to use
+ *	@len: amount of data to add
+ *
+ *	This function extends the used data area of the buffer. If this would
+ *	exceed the total buffer size the kernel will panic. A pointer to the
+ *	first byte of the extra data is returned.
+ */
+unsigned char *skb_put(struct sk_buff *skb, unsigned int len)
+{
+	unsigned char *tmp = skb->tail;
+	SKB_LINEAR_ASSERT(skb);
+	skb->tail += len;
+	skb->len  += len;
+	if (unlikely(skb->tail>skb->end))
+		skb_over_panic(skb, len, current_text_addr());
+	return tmp;
+}
+EXPORT_SYMBOL(skb_put);
+
 /* 	Allocate a new skbuff. We do this ourselves so we can fill in a few
  *	'private' fields and also do memory statistics to find all the
  *	[BEEP] leaks.
_

Patches currently in -mm which might be from akpm@osdl.org are

git-powerpc.patch
git-ia64.patch
git-ieee1394.patch
sata_nv-add-back-some-verbosity-into-adma-error_handler.patch
git-ubi.patch
git-netdev-all.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
net-uninline-skb_put.patch
git-ioat-vs-git-md-accel.patch
ioat-warning-fix.patch
drivers-scsi-mca_53c9xc-save_flags-cli-removal.patch
scsi-cover-up-bugs-fix-up-compiler-warnings-in-megaraid-driver.patch
git-ipwireless_cs.patch
arch-i386-kernel-alternativec-dont-include-bugsh.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
block_write_full_page-handle-enospc.patch
filesystem-disk-errors-at-boot-time-caused-by-probe.patch
merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
epoll-optimizations-and-cleanups-tidy.patch
sync_sb_inodes-propagate-errors.patch
mips-convert-to-use-shared-apm-emulation-fix.patch
schedule_on_each_cpu-use-preempt_disable.patch
implement-flush_work-sanity.patch
implement-flush_work_keventd.patch
flush_workqueue-use-preempt_disable-to-hold-off-cpu-hotplug.patch
aio-use-flush_work.patch
kblockd-use-flush_work.patch
relayfs-use-flush_keventd_work.patch
tg3-use-flush_keventd_work.patch
e1000-use-flush_keventd_work.patch
libata-use-flush_work.patch
phy-use-flush_work.patch
extend-notifier_call_chain-to-count-nr_calls-made.patch
eliminate-lock_cpu_hotplug-in-kernel-schedc.patch
move-page-writeback-acounting-out-of-macros.patch
per-backing_dev-dirty-and-writeback-page-accounting.patch
ext2-reservations.patch
edac-new-opteron-athlon64-memory-controller-driver.patch
aio-is-unlikely.patch
mm-implement-swap-prefetching.patch
readahead-kconfig-options.patch
readahead-minmax_ra_pages.patch
readahead-sysctl-parameters.patch
readahead-context-based-method.patch
readahead-call-scheme.patch
readahead-nfsd-case.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
vdso-print-fatal-signals-use-ctl_unnumbered.patch
restore-rogue-readahead-printk.patch
put_bh-debug.patch
e1000-printk-warning-fixes.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
