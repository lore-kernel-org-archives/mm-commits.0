From: akpm@linux-foundation.org
Subject: - ioat-warning-fix.patch removed from -mm tree
Date: Fri, 13 Jul 2007 15:33:04 -0700
Message-ID: <200707132233.l6DMX4Lm025049@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:34465 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937329AbXGMWpC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 13 Jul 2007 18:45:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, christopher.leech@intel.com, shannon.nelson@intel.com, mm-commits@vger.kernel.org


The patch titled
     ioat warning fix
has been removed from the -mm tree.  Its filename was
     ioat-warning-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: ioat warning fix
From: Andrew Morton <akpm@osdl.org>

net/ipv4/tcp.c: In function 'tcp_recvmsg':
net/ipv4/tcp.c:1111: warning: unused variable 'available'

Cc: Chris Leech <christopher.leech@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 net/ipv4/tcp.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff -puN net/ipv4/tcp.c~ioat-warning-fix net/ipv4/tcp.c
--- a/net/ipv4/tcp.c~ioat-warning-fix
+++ a/net/ipv4/tcp.c
@@ -1116,7 +1116,6 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	long timeo;
 	struct task_struct *user_recv = NULL;
 	int copied_early = 0;
-	int available = 0;
 	struct sk_buff *skb;
 
 	lock_sock(sk);
@@ -1145,15 +1144,22 @@ int tcp_recvmsg(struct kiocb *iocb, stru
 	tp->ucopy.dma_chan = NULL;
 	preempt_disable();
 	skb = skb_peek_tail(&sk->sk_receive_queue);
-	if (skb)
-		available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
-	if ((available < target) &&
-	    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
-	    !sysctl_tcp_low_latency && __get_cpu_var(softnet_data).net_dma) {
-		preempt_enable_no_resched();
-		tp->ucopy.pinned_list = dma_pin_iovec_pages(msg->msg_iov, len);
-	} else
-		preempt_enable_no_resched();
+	{
+		int available = 0;
+
+		if (skb)
+			available = TCP_SKB_CB(skb)->seq + skb->len - (*seq);
+		if ((available < target) &&
+		    (len > sysctl_tcp_dma_copybreak) && !(flags & MSG_PEEK) &&
+		    !sysctl_tcp_low_latency &&
+		    __get_cpu_var(softnet_data).net_dma) {
+			preempt_enable_no_resched();
+			tp->ucopy.pinned_list =
+					dma_pin_iovec_pages(msg->msg_iov, len);
+		} else {
+			preempt_enable_no_resched();
+		}
+	}
 #endif
 
 	do {
_

Patches currently in -mm which might be from akpm@osdl.org are

origin.patch
git-md-accel.patch
drivers-net-ns83820c-add-paramter-to-disable-auto.patch
update-smc91x-driver-with-arm-versatile-board-info.patch
git-ipwireless_cs.patch
revert-81b0c8713385ce1b1b9058e916edcf9561ad76d6.patch
revert-6527c2bdf1f833cc18e8f42bd97973d583e4aa83.patch
mm-clean-up-buffered-write-code.patch
lumpy-reclaim-v4.patch
deprecate-smbfs-in-favour-of-cifs.patch
sync_sb_inodes-propagate-errors.patch
move-page-writeback-acounting-out-of-macros.patch
ext2-reservations.patch
mm-implement-swap-prefetching.patch
make-copy_from_user_inatomic-not-zero-the-tail-on-i386-vs-reiser4.patch
reiser4.patch
nr_blockdev_pages-in_interrupt-warning.patch
device-suspend-debug.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
acpi_format_exception-debug.patch
kmap_atomic-debugging.patch
shrink_slab-handle-bad-shrinkers.patch
squash-ipc-warnings.patch
